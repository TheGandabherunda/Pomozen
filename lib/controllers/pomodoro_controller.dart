import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:torch_light/torch_light.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../l10n/arb/app_localizations.dart';
import '../services/settings_service.dart';
import '../ui/screens/statistics_screen.dart';

/// Defines the different modes of the Pomodoro timer.
enum PomodoroMode { focus, shortBreak, longBreak }

/// Manages the state and logic for the Pomodoro timer,
/// including notifications, DND, and device-specific integrations.
class PomodoroController extends GetxController with WidgetsBindingObserver {
  // Service and Plugin Instances
  final SettingsService settingsService;
  final DoNotDisturbPlugin _dndPlugin = DoNotDisturbPlugin();

  // Constructor
  PomodoroController(this.settingsService);

  // Observable State Variables
  final isRunning = false.obs;
  final currentTime = 0.0.obs;
  final totalTime = 0.0.obs;
  final progress = 0.0.obs;
  final currentMode = PomodoroMode.focus.obs;
  final currentSession = 1.obs;
  final totalSessions = 4.obs;
  final completedMode = Rxn<PomodoroMode>();
  final currentLabel = Rxn<Map<String, dynamic>>();
  final RxBool triggerRippleAnimation = false.obs;
  final RxBool triggerAppStartAnimation = false.obs;

  // Timers
  Timer? _timer;
  Timer? _saveTimerDebounceTimer;
  Timer? _foregroundReminderTimer;

  // Internal Flags
  bool _isPermissionRequestInProgress = false;
  bool _wasPaused = false; // Added to track if the app was previously paused

  // Notification IDs
  static const int _waterReminderNotificationId = 4;
  static const int _waterReminderAlarmId = 5;

  /// Initializes the controller, sets up observers, notifications,
  /// and listens to settings changes.
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _initializeNotifications().then((_) async {
      final areEnabled = await areNotificationsEnabled();
      if (!areEnabled) {
        await requestNotificationPermissions();
      }
      if (settingsService.dailyReminderTimeHour.value != null &&
          settingsService.dailyReminderTimeMinute.value != null) {
        scheduleDailyReminder();
      }
      // Initialize water reminder state based on settings
      _updateWaterReminderState();
    });

    _setInitialTimer();

    totalSessions.value = settingsService.totalSessions.value;

    _setupSettingsListeners();
    _restoreTimerState();

    if (settingsService.keepScreenOn.value) {
      WakelockPlus.enable();
    }

    startForegroundReminderCheck();
    // This line triggers the animation on initial cold launch
    triggerAppStartAnimation.value = true;
  }

  /// Handles the disposal of resources when the controller is closed.
  @override
  void onClose() {
    _timer?.cancel();
    _saveTimerDebounceTimer?.cancel();
    _foregroundReminderTimer?.cancel();
    AwesomeNotifications().cancelAll();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    if (settingsService.dndToggle.value) {
      _setDndInterruptionFilter(InterruptionFilter.all);
    }
    super.onClose();
  }

  /// Acknowledges the app start animation to reset its trigger.
  void acknowledgeAppStartAnimation() {
    triggerAppStartAnimation.value = false;
  }

  /// Sets up listeners for various settings changes to update timer and notification states.
  void _setupSettingsListeners() {
    settingsService.totalSessions.listen((value) {
      totalSessions.value = value;
      if (currentSession.value > totalSessions.value) {
        currentSession.value = 1;
      }
      _setInitialTimer();
    });

    settingsService.focusDuration.listen((newDurationMinutes) =>
        _updateTimerDuration(newDurationMinutes, PomodoroMode.focus));
    settingsService.shortBreakDuration.listen((newDurationMinutes) =>
        _updateTimerDuration(newDurationMinutes, PomodoroMode.shortBreak));
    settingsService.longBreakDuration.listen((newDurationMinutes) =>
        _updateTimerDuration(newDurationMinutes, PomodoroMode.longBreak));

    ever(settingsService.labels, (_) {
      if (currentLabel.value != null &&
          !settingsService.labels.any((label) =>
              label['name'].toString() ==
                  currentLabel.value!['name'].toString() &&
              label['color'] == currentLabel.value!['color'])) {
        currentLabel.value = null;
      }
    });

    ever(settingsService.dailyReminderTimeHour, (_) => scheduleDailyReminder());
    ever(settingsService.dailyReminderTimeMinute,
        (_) => scheduleDailyReminder());

    // Consolidate water reminder setting listeners
    settingsService.waterReminderEnabled
        .listen((_) => _updateWaterReminderState());
    settingsService.waterReminderIntervalMinutes
        .listen((_) => _updateWaterReminderState());
    settingsService.waterReminderType
        .listen((_) => _updateWaterReminderState());
  }

  /// Updates the timer duration when settings change, adjusting `currentTime` if running.
  Future<void> _updateTimerDuration(
      int newDurationMinutes, PomodoroMode mode) async {
    final newTotalSeconds = newDurationMinutes * 60.0;
    if (isRunning.value && currentMode.value == mode) {
      final double elapsedSeconds = totalTime.value - currentTime.value;
      totalTime.value = newTotalSeconds;
      currentTime.value = newTotalSeconds - elapsedSeconds;
      if (currentTime.value < 0) currentTime.value = 0.0;
      if (currentTime.value > totalTime.value) {
        currentTime.value = totalTime.value;
      }
      progress.value = 1.0 - (currentTime.value / totalTime.value);
    } else {
      _setInitialTimer();
    }
  }

  // Timer Control Methods
  /// Sets the initial time for the current Pomodoro mode.
  void _setInitialTimer() {
    switch (currentMode.value) {
      case PomodoroMode.focus:
        totalTime.value = settingsService.focusDuration.value * 60.0;
        break;
      case PomodoroMode.shortBreak:
        totalTime.value = settingsService.shortBreakDuration.value * 60.0;
        break;
      case PomodoroMode.longBreak:
        totalTime.value = settingsService.longBreakDuration.value * 60.0;
        break;
    }
    currentTime.value = totalTime.value;
    progress.value = 0.0;
    _saveTimerState(immediate: true);
  }

  /// Starts the Pomodoro timer.
  void startTimer() async {
    if (isRunning.value) return;
    isRunning.value = true;
    completedMode.value = null;
    HapticFeedback.lightImpact();

    if (settingsService.dndToggle.value) {
      await _setDndInterruptionFilter(InterruptionFilter.alarms);
    }

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (currentTime.value > 0) {
        currentTime.value -= 0.1;
        progress.value = 1.0 - (currentTime.value / totalTime.value);
        _saveTimerState();

        _showOngoingNotification();
      } else {
        _timer?.cancel();
        isRunning.value = false;
        _handleModeCompletion();
      }
    });
  }

  /// Pauses the Pomodoro timer.
  void pauseTimer() async {
    _timer?.cancel();
    isRunning.value = false;
    _cancelOngoingNotification();
    HapticFeedback.lightImpact();
    _saveTimerState(immediate: true);
    if (settingsService.dndToggle.value) {
      await _setDndInterruptionFilter(InterruptionFilter.all);
    }
  }

  /// Resets the Pomodoro timer to its initial state.
  void resetTimer() async {
    pauseTimer();
    currentSession.value = 1;
    currentMode.value = PomodoroMode.focus;
    _setInitialTimer();
    completedMode.value = null;
    _stopSystemAlarm();
    HapticFeedback.lightImpact();
    _saveTimerState(immediate: true);
    if (settingsService.dndToggle.value) {
      await _setDndInterruptionFilter(InterruptionFilter.all);
    }
  }

  /// Skips to the next Pomodoro mode.
  void skipToNextMode() {
    pauseTimer();
    _handleModeCompletion(skipped: true);
  }

  /// Handles actions to be performed upon completion or skipping of a Pomodoro mode.
  void _handleModeCompletion({bool skipped = false}) async {
    final prevMode = currentMode.value;
    completedMode.value = prevMode;
    _logSession(prevMode, !skipped);
    _saveTimerState(immediate: true);
    switch (prevMode) {
      case PomodoroMode.focus:
        if (currentSession.value % totalSessions.value == 0) {
          currentMode.value = PomodoroMode.longBreak;
        } else {
          currentMode.value = PomodoroMode.shortBreak;
        }
        break;
      case PomodoroMode.shortBreak:
        currentSession.value++;
        currentMode.value = PomodoroMode.focus;
        break;
      case PomodoroMode.longBreak:
        if (currentSession.value % totalSessions.value == 0) {
          triggerRippleAnimation.value = false;
          await Future.microtask(() => triggerRippleAnimation.value = true);
        }
        currentSession.value = 1;
        currentMode.value = PomodoroMode.focus;
        break;
    }
    _setInitialTimer();

    if (!triggerRippleAnimation.value && settingsService.autoPlay.value) {
      Future.delayed(const Duration(seconds: 1), () {
        startTimer();
      });
    }

    if (Get.context != null && settingsService.reminder.value) {
      if (!settingsService.isAlarm.value) {
        _sendCompletionNotification(prevMode, currentMode.value, Get.context!);
      } else {
        _playSystemAlarm(prevMode, Get.context!);
      }
    }
    if (settingsService.torchAlerts.value) {
      try {
        await TorchLight.enableTorch();
        await Future.delayed(const Duration(milliseconds: 500));
        await TorchLight.disableTorch();
      } catch (e) {
        Fluttertoast.showToast(msg: 'Torch failed: $e');
      }
    }
    HapticFeedback.heavyImpact();
  }

  /// Acknowledges the ripple animation to reset its trigger and potentially auto-start the timer.
  void acknowledgeRippleAnimation() {
    if (triggerRippleAnimation.value) {
      triggerRippleAnimation.value = false;
      if (settingsService.autoPlay.value) {
        Future.delayed(const Duration(milliseconds: 200), () {
          startTimer();
        });
      }
    }
  }

  // Session Logging
  /// Logs the completed or skipped Pomodoro session.
  void _logSession(PomodoroMode mode, bool isCompleted) async {
    if (mode == PomodoroMode.focus) {
      final elapsedSeconds = totalTime.value - currentTime.value;
      final actualFocusMinutes = (elapsedSeconds / 60).round();
      final session = SessionData(
        DateTime.now().subtract(Duration(seconds: actualFocusMinutes * 60)),
        DateTime.now(),
        actualFocusMinutes,
        labelName: currentLabel.value?['name'],
        isCompleted: isCompleted,
      );
      await settingsService.sessionsBox.add(session);
    }
  }

  // Notification Methods
  /// Initializes the timezone for notifications.
  Future<void> _initializeNotificationsTimezone() async {
    tz.initializeTimeZones();
    try {
      String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      if (currentTimeZone == 'Asia/Calcutta') {
        currentTimeZone = 'Asia/Kolkata';
      }
      try {
        final location = tz.getLocation(currentTimeZone);
        tz.setLocalLocation(location);
      } catch (e) {
        final fallbacks = _getTimezoneFallbacks(currentTimeZone);
        for (final fallback in fallbacks) {
          try {
            final location = tz.getLocation(fallback);
            tz.setLocalLocation(location);
            break;
          } catch (e) {}
        }
      }
    } catch (e) {}
  }

  /// Provides fallback timezones for notification scheduling.
  List<String> _getTimezoneFallbacks(String originalTimezone) {
    final fallbacks = <String>[];
    if (originalTimezone.startsWith('Asia/')) {
      fallbacks.addAll(
          ['Asia/Kolkata', 'Asia/Calcutta', 'Asia/Dubai', 'Asia/Shanghai']);
    } else if (originalTimezone.startsWith('America/')) {
      fallbacks.addAll([
        'America/New_York',
        'America/Chicago',
        'America/Denver',
        'America/Los_Angeles'
      ]);
    } else if (originalTimezone.startsWith('Europe/')) {
      fallbacks.addAll(
          ['Europe/London', 'Europe/Berlin', 'Europe/Paris', 'Europe/Rome']);
    }
    fallbacks.addAll(['UTC', 'GMT']);
    fallbacks.remove(originalTimezone);
    return fallbacks;
  }

  /// Initializes Awesome Notifications with channels and groups.
  Future<void> _initializeNotifications() async {
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );

    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_notification',
      [
        NotificationChannel(
          channelGroupKey: 'pomodoro_channel_group',
          channelKey: 'pomodoro_timer_channel',
          channelName: 'Pomodoro Timer Notifications',
          channelDescription: 'Notifications for Pomodoro timer events',
          importance: NotificationImportance.Max,
          playSound: true,
          enableVibration: true,
          soundSource: null,
        ),
        NotificationChannel(
          channelGroupKey: 'pomodoro_channel_group',
          channelKey: 'pomodoro_ongoing_channel',
          channelName: 'Pomodoro Ongoing Timer',
          channelDescription: 'Shows ongoing timer notification',
          importance: NotificationImportance.High,
          playSound: false,
          enableVibration: false,
          onlyAlertOnce: true,
          channelShowBadge: false,
          soundSource: null,
        ),
        NotificationChannel(
          channelGroupKey: 'pomodoro_channel_group',
          channelKey: 'pomodoro_alarm_channel',
          channelName: 'Pomodoro Alarm',
          channelDescription: 'Alarm for Pomodoro completion',
          importance: NotificationImportance.Max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          channelShowBadge: true,
          soundSource: null,
          criticalAlerts: true,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
        ),
        NotificationChannel(
          channelGroupKey: 'pomodoro_channel_group',
          channelKey: 'daily_reminder_channel',
          channelName: 'Daily Reminder',
          channelDescription: 'Daily reminder to focus',
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          soundSource: null,
        ),
        NotificationChannel(
          channelGroupKey: 'pomodoro_channel_group',
          channelKey: 'water_reminder_channel',
          channelName: 'Water Reminder Notifications',
          channelDescription: 'Notifications for water reminders',
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          soundSource: null,
        ),
        NotificationChannel(
          channelGroupKey: 'pomodoro_channel_group',
          channelKey: 'water_reminder_alarm_channel',
          channelName: 'Water Reminder Alarm',
          channelDescription: 'Alarm for water reminders',
          importance: NotificationImportance.Max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          channelShowBadge: true,
          soundSource: null,
          criticalAlerts: true,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'pomodoro_channel_group',
          channelGroupName: 'Pomodoro Notifications Group',
        ),
      ],
    );

    await _initializeNotificationsTimezone();
  }

  /// Requests permission to send notifications.
  Future<bool> requestNotificationPermissions() async {
    if (_isPermissionRequestInProgress) return false;
    _isPermissionRequestInProgress = true;
    try {
      bool granted =
          await AwesomeNotifications().requestPermissionToSendNotifications();
      return granted;
    } finally {
      _isPermissionRequestInProgress = false;
    }
  }

  /// Checks if notifications are currently enabled.
  Future<bool> areNotificationsEnabled() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  /// Cancels all active and scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
    _stopSystemAlarm();
    _stopWaterReminderAlarm();
    // No toast here; toast is handled in the UI layer.
  }

  /// Schedules the daily reminder notification.
  Future<void> scheduleDailyReminder() async {
    await AwesomeNotifications().cancel(3);

    final hour = settingsService.dailyReminderTimeHour.value;
    final minute = settingsService.dailyReminderTimeMinute.value;

    if (hour == null || minute == null) {
      return;
    }

    final notificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();

    if (!notificationsAllowed) {
      Fluttertoast.showToast(
          msg:
              'Notification permission denied. Please enable notifications in app settings to receive daily reminders.');
      return;
    }

    final String reminderTitle = Get.context != null
        ? AppLocalizations.of(Get.context!)?.dailyReminderNotificationTitle ??
            'Time to Focus!'
        : 'Time to Focus!';
    final String reminderBody = Get.context != null
        ? AppLocalizations.of(Get.context!)?.dailyReminderNotificationBody ??
            "Don't forget to start your Pomodoro session."
        : "Don't forget to start your Pomodoro session.";

    try {
      final now = tz.TZDateTime.now(tz.local);

      var scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

      if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      if (tz.local.name == 'UTC') {
        try {
          String deviceTimeZone = await FlutterTimezone.getLocalTimezone();
          if (deviceTimeZone == 'Asia/Calcutta') {
            deviceTimeZone = 'Asia/Kolkata';
          }
          final deviceLocation = tz.getLocation(deviceTimeZone);
          final deviceNow = tz.TZDateTime.now(deviceLocation);
          scheduledDate = tz.TZDateTime(deviceLocation, deviceNow.year,
              deviceNow.month, deviceNow.day, hour, minute);
          if (scheduledDate.isBefore(deviceNow) ||
              scheduledDate.isAtSameMomentAs(deviceNow)) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
          }
        } catch (e) {
          print('Error getting device timezone for UTC adjustment: $e');
        }
      }

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 3,
          channelKey: 'daily_reminder_channel',
          title: reminderTitle,
          body: reminderBody,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          autoDismissible: true,
        ),
        schedule: NotificationCalendar(
          hour: scheduledDate.hour,
          minute: scheduledDate.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          allowWhileIdle: true,
        ),
      );

      final pending = await AwesomeNotifications().listScheduledNotifications();
      final dailyReminderPending =
          pending.where((n) => n.content?.id == 3).toList();

      if (dailyReminderPending.isEmpty) {
        await _scheduleDailyReminderFallback(
            hour, minute, reminderTitle, reminderBody);
      }
    } catch (e, stackTrace) {
      print('Error scheduling daily reminder: $e, $stackTrace');
      try {
        await _scheduleDailyReminderFallback(
            hour, minute, reminderTitle, reminderBody);
      } catch (fallbackError) {
        print('Error in daily reminder fallback: $fallbackError');
      }
    }
  }

  /// Schedules the water reminder notification.
  Future<void> _scheduleWaterReminderNotification() async {
    // Always cancel existing reminders before attempting to schedule new ones
    await AwesomeNotifications().cancel(_waterReminderNotificationId);
    await AwesomeNotifications().cancel(_waterReminderAlarmId);

    if (!settingsService.waterReminderEnabled.value) {
      // If reminder is not enabled in settings, ensure it's cancelled and do nothing more.
      return;
    }

    final notificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    if (!notificationsAllowed) {
      // If notifications are not allowed, do not schedule.
      // The UI layer or _updateWaterReminderState should handle showing toasts.
      print('Water reminder: Notifications not allowed, skipping schedule.');
      return;
    }

    final intervalMinutes = settingsService.waterReminderIntervalMinutes.value;
    final reminderType = settingsService.waterReminderType.value;
    final localizations = AppLocalizations.of(Get.context!)!;

    if (intervalMinutes <= 0) {
      Fluttertoast.showToast(
          msg:
              'Water reminder interval must be greater than 0 minutes. Please set a valid interval.');
      return;
    }

    final String title = reminderType == 'notification'
        ? localizations.waterReminderNotificationTitle ?? 'Time to Drink Water!'
        : localizations.waterReminderAlarmTitle ?? 'Drink Water!';
    final String body = reminderType == 'notification'
        ? localizations.waterReminderNotificationBody ??
            'Stay hydrated for better focus.'
        : localizations.waterReminderAlarmBody ?? 'It\'s time to hydrate.';

    final String channelKey = reminderType == 'notification'
        ? 'water_reminder_channel'
        : 'water_reminder_alarm_channel';
    final int notificationId = reminderType == 'notification'
        ? _waterReminderNotificationId
        : _waterReminderAlarmId;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: reminderType == 'notification',
        wakeUpScreen: true,
        category: reminderType == 'alarm'
            ? NotificationCategory.Alarm
            : NotificationCategory.Reminder,
        locked: reminderType == 'alarm',
      ),
      schedule: NotificationInterval(
        interval: Duration(seconds: intervalMinutes * 60),
        repeats: true,
        allowWhileIdle: true,
      ),
      actionButtons: reminderType == 'alarm'
          ? [
              NotificationActionButton(
                actionType: ActionType.SilentBackgroundAction,
                key: 'stop_water_alarm',
                label: 'Stop',
                autoDismissible: true,
              ),
            ]
          : null,
    );

    final pending = await AwesomeNotifications().listScheduledNotifications();
    final waterReminderPending =
        pending.where((n) => n.content?.id == notificationId).toList();

    if (waterReminderPending.isEmpty) {
      print(
          'WARNING: Water reminder not scheduled by AwesomeNotifications directly. Fallback might be needed.');
    }
  }

  /// Consolidates logic for scheduling/cancelling water reminders based on current settings and permissions.
  Future<void> _updateWaterReminderState() async {
    if (settingsService.waterReminderEnabled.value) {
      // If water reminder is enabled in settings, attempt to schedule
      final bool notificationsAllowed = await areNotificationsEnabled();
      if (notificationsAllowed) {
        _scheduleWaterReminderNotification();
      } else {
        // If not enabled, but notifications are not allowed, ensure it's cancelled
        // and potentially prompt user or correct setting state.
        print(
            'Water reminder enabled in settings but notifications not allowed. Cancelling reminder.');
        await AwesomeNotifications().cancel(_waterReminderNotificationId);
        await AwesomeNotifications().cancel(_waterReminderAlarmId);
        // It might be good to revert the settingsService.waterReminderEnabled.value to false here
        // if permissions are definitively denied and the app cannot function as expected.
        // However, for now, we just ensure no notification is scheduled.
      }
    } else {
      // If water reminder is disabled in settings, always cancel any active reminders.
      cancelWaterReminder();
    }
  }

  /// Cancels the water reminder notifications.
  Future<void> cancelWaterReminder() async {
    await AwesomeNotifications().cancel(_waterReminderNotificationId);
    await AwesomeNotifications().cancel(_waterReminderAlarmId);
    // No toast here; toast is handled in the UI layer.
  }

  /// Opens the battery optimization settings on Android.
  void openBatteryOptimizationSettings() {
    final intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
    );
    intent.launch();
  }

  /// Cancels the daily reminder notification.
  Future<void> cancelDailyReminder() async {
    await AwesomeNotifications().cancel(3);
  }

  /// Provides a fallback mechanism for scheduling daily reminders if the primary method fails.
  Future<void> _scheduleDailyReminderFallback(
      int hour, int minute, String title, String body) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'daily_reminder_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        autoDismissible: true,
      ),
      schedule: NotificationCalendar(
        hour: tzScheduledDate.hour,
        minute: tzScheduledDate.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  /// Starts a periodic check to show the daily reminder if the app is in the foreground.
  void startForegroundReminderCheck() {
    _foregroundReminderTimer?.cancel();
    _foregroundReminderTimer =
        Timer.periodic(const Duration(seconds: 10), (_) async {
      final hour = settingsService.dailyReminderTimeHour.value;
      final minute = settingsService.dailyReminderTimeMinute.value;
      if (hour != null && minute != null) {
        final now = DateTime.now();
        if (now.hour == hour && now.minute == minute && now.second < 10) {
          showDailyReminderNow();
        }
      }
    });
  }

  /// Displays the daily reminder notification immediately.
  void showDailyReminderNow() {
    final String reminderTitle = Get.context != null
        ? AppLocalizations.of(Get.context!)?.dailyReminderNotificationTitle ??
            'Time to Focus!'
        : 'Time to Focus!';
    final String reminderBody = Get.context != null
        ? AppLocalizations.of(Get.context!)?.dailyReminderNotificationBody ??
            "Don't forget to start your Pomodoro session."
        : "Don't forget to start your Pomodoro session.";

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'daily_reminder_channel',
        title: reminderTitle,
        body: reminderBody,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        autoDismissible: true,
      ),
    );
  }

  /// Sends a completion notification when a Pomodoro mode finishes.
  void _sendCompletionNotification(PomodoroMode completedMode,
      PomodoroMode nextMode, BuildContext context) async {
    if (!settingsService.reminder.value || settingsService.isAlarm.value) {
      return;
    }
    final localizations = AppLocalizations.of(context)!;
    String title;
    String body;
    String nextModeText;

    switch (nextMode) {
      case PomodoroMode.focus:
        nextModeText = localizations.focus;
        break;
      case PomodoroMode.shortBreak:
        nextModeText = localizations.shortBreak;
        break;
      case PomodoroMode.longBreak:
        nextModeText = localizations.longBreak;
        break;
    }

    switch (completedMode) {
      case PomodoroMode.focus:
        title = localizations.focusSessionCompletedNotificationTitle;
        body =
            localizations.focusSessionCompletedNotificationBody(nextModeText);
        break;
      case PomodoroMode.shortBreak:
        title = localizations.shortBreakCompletedNotificationTitle;
        body = localizations.shortBreakCompletedNotificationBody(nextModeText);
        break;
      case PomodoroMode.longBreak:
        title = localizations.longBreakCompletedNotificationTitle;
        body = localizations.longBreakCompletedNotificationBody(nextModeText);
        break;
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'pomodoro_timer_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: true,
      ),
    );
  }

  /// Plays a system alarm when a Pomodoro mode finishes.
  void _playSystemAlarm(
      PomodoroMode completedMode, BuildContext context) async {
    if (!settingsService.reminder.value || !settingsService.isAlarm.value) {
      return;
    }
    final localizations = AppLocalizations.of(context)!;
    String title = localizations.alarmTitle;
    String body = localizations.alarmBody;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'pomodoro_alarm_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: false,
        wakeUpScreen: true,
        fullScreenIntent: true,
        category: NotificationCategory.Alarm,
        locked: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'stop_alarm',
          label: 'Stop',
          autoDismissible: true,
        ),
      ],
    );
  }

  /// Stops the main Pomodoro system alarm.
  void _stopSystemAlarm() async {
    await AwesomeNotifications().cancel(2);

    if (settingsService.dndToggle.value) {
      await _setDndInterruptionFilter(InterruptionFilter.alarms);
    }
  }

  /// Stops the water reminder alarm.
  void _stopWaterReminderAlarm() async {
    await AwesomeNotifications().cancel(_waterReminderAlarmId);
  }

  /// Cancels the ongoing timer notification.
  void _cancelOngoingNotification() async {
    await AwesomeNotifications().cancel(0);
  }

  // Do Not Disturb Control
  /// Handles the DND toggle switch, requesting permissions if necessary.
  Future<void> handleDndToggle(bool value) async {
    if (value) {
      final bool hasAccess =
          await _dndPlugin.isNotificationPolicyAccessGranted();
      if (!hasAccess) {
        Fluttertoast.showToast(
            msg:
                'Please grant Notification Policy Access to enable DND control.');
        settingsService.setDndToggle(false);
        await _dndPlugin.openNotificationPolicyAccessSettings();
      } else {
        await _setDndInterruptionFilter(InterruptionFilter.alarms);
        settingsService.setDndToggle(true);
      }
    } else {
      await _setDndInterruptionFilter(InterruptionFilter.all);
      settingsService.setDndToggle(false);
    }
  }

  /// Sets the Android Do Not Disturb interruption filter.
  Future<void> _setDndInterruptionFilter(InterruptionFilter filter) async {
    try {
      await _dndPlugin.setInterruptionFilter(filter);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to set DND mode: $e');
    }
  }

  // Label Management Methods
  /// Adds a new label to the list of labels.
  void addLabel(String name, Color color) {
    final newLabel = {
      'name': name,
      'color': color.value,
    };
    final currentLabels =
        List<Map<String, dynamic>>.from(settingsService.labels);
    if (currentLabels.any((label) =>
        label['name'].toString().toLowerCase() == name.toLowerCase())) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(Get.context!)!.labelAlreadyExists);
      return;
    }
    currentLabels.add(newLabel);
    settingsService.setLabels(currentLabels);
  }

  /// Updates an existing label.
  void updateLabel(
      Map<String, dynamic> oldLabel, Map<String, dynamic> newLabel) {
    final labels = settingsService.labels.value;
    final index = labels.indexWhere((l) =>
        l['name'] == oldLabel['name'] && l['color'] == oldLabel['color']);
    if (index != -1) {
      labels[index] = {
        'name': newLabel['name'],
        'color': newLabel['color'],
      };
      settingsService.labels.refresh();
      if (currentLabel.value != null &&
          currentLabel.value!['name'] == oldLabel['name'] &&
          currentLabel.value!['color'] == oldLabel['color']) {
        currentLabel.value = labels[index];
      }
    }
  }

  /// Deletes a label from the list.
  void deleteLabel(Map<String, dynamic> label) {
    final currentLabels =
        List<Map<String, dynamic>>.from(settingsService.labels);
    currentLabels.removeWhere(
        (l) => l['name'] == label['name'] && l['color'] == label['color']);
    settingsService.setLabels(currentLabels);
    if (currentLabel.value?['name'] == label['name'] &&
        currentLabel.value?['color'] == label['color']) {
      currentLabel.value = null;
    }
    HapticFeedback.mediumImpact();
  }

  /// Selects a label and resets the timer.
  void selectLabel(Map<String, dynamic>? label) {
    resetTimer();
    currentLabel.value = label;
    HapticFeedback.lightImpact();
  }

  // Time Formatting
  /// Formats a given number of seconds into a "MM:SS" string.
  String _formatTime(double seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60).ceil();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // State Persistence
  /// Saves the current timer state to local storage with a debounce mechanism.
  void _saveTimerState({bool immediate = false}) {
    _saveTimerDebounceTimer?.cancel();

    if (immediate) {
      _performSaveTimerState();
    } else {
      _saveTimerDebounceTimer =
          Timer(const Duration(milliseconds: 500), _performSaveTimerState);
    }
  }

  /// Performs the actual saving of the timer state to Hive box.
  Future<void> _performSaveTimerState() async {
    final box = await Hive.openBox('app_settings');
    await box.put('timer_state', {
      'isRunning': isRunning.value,
      'currentTime': currentTime.value,
      'totalTime': totalTime.value,
      'progress': progress.value,
      'currentMode': currentMode.value.toString(),
      'currentSession': currentSession.value,
      'currentLabelName': currentLabel.value?['name'],
      'currentLabelColor': currentLabel.value?['color'] as int?,
    });
  }

  /// Restores the timer state from local storage.
  void _restoreTimerState() async {
    final box = await Hive.openBox('app_settings');
    final state = box.get('timer_state');
    if (state != null) {
      isRunning.value = state['isRunning'] ?? false;
      currentTime.value = state['currentTime'] ?? 0.0;
      totalTime.value = state['totalTime'] ?? 0.0;
      progress.value = state['progress'] ?? 0.0;
      currentSession.value = state['currentSession'] ?? 1;
      currentMode.value =
          _parsePomodoroMode(state['currentMode'] ?? 'PomodoroMode.focus');
      final String? labelName = state['currentLabelName'];
      final dynamic storedColor = state['currentLabelColor'];
      final int? labelColor =
          storedColor is double? ? (storedColor)?.toInt() : storedColor as int?;

      if (labelName != null && labelColor != null) {
        currentLabel.value = {
          'name': labelName,
          'color': labelColor,
        };
      } else {
        currentLabel.value = null;
      }
      if (isRunning.value) {
        startTimer();
      }
    }
  }

  /// Parses a string representation of `PomodoroMode` into its enum value.
  PomodoroMode _parsePomodoroMode(String modeString) {
    switch (modeString) {
      case 'PomodoroMode.shortBreak':
        return PomodoroMode.shortBreak;
      case 'PomodoroMode.longBreak':
        return PomodoroMode.longBreak;
      default:
        return PomodoroMode.focus;
    }
  }

  /// Shows an ongoing notification when the timer is running and the app is in the background.
  void _showOngoingNotification() async {
    if (!isRunning.value || Get.context == null) {
      _cancelOngoingNotification();
      return;
    }

    final localizations = AppLocalizations.of(Get.context!);
    String title = localizations.ongoingTimerNotification;
    String body = _formatTime(currentTime.value);

    final bool isAppInBackground =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.paused;

    if (isAppInBackground) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'pomodoro_ongoing_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: (progress.value * 100).toDouble(),
          locked: true,
          autoDismissible: false,
          wakeUpScreen: true,
          showWhen: true,
          displayOnBackground: true,
          displayOnForeground: false,
          ticker: body,
          category: NotificationCategory.Progress,
        ),
      );
    } else {
      _cancelOngoingNotification();
    }
  }

  /// Handles app lifecycle state changes to manage ongoing notifications.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && isRunning.value) {
      _showOngoingNotification();
      _saveTimerState(immediate: true);
      _wasPaused = true; // Mark that the app went into the background
    } else if (state == AppLifecycleState.resumed) {
      _cancelOngoingNotification();
      // Trigger the app start animation only if the app was previously paused
      if (_wasPaused) {
        triggerAppStartAnimation.value = true;
        _wasPaused = false; // Reset the flag
      }
    }
  }
}

/// A static class to handle Awesome Notifications callbacks.
@pragma('vm:entry-point')
class NotificationController {
  /// Callback method when a notification is created.
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print('Notification created: ${receivedNotification.id}');
  }

  /// Callback method when a notification is displayed.
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print('Notification displayed: ${receivedNotification.id}');
  }

  /// Callback method when an action button on a notification is pressed.
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('Action received: ${receivedAction.id}');
    if (receivedAction.channelKey == 'pomodoro_alarm_channel' &&
        receivedAction.buttonKeyPressed == 'stop_alarm') {
      if (Get.isRegistered<PomodoroController>()) {
        final controller = Get.find<PomodoroController>();
        controller._stopSystemAlarm();
        AwesomeNotifications().dismiss(receivedAction.id!);
      }
    } else if (receivedAction.channelKey == 'water_reminder_alarm_channel' &&
        receivedAction.buttonKeyPressed == 'stop_water_alarm') {
      if (Get.isRegistered<PomodoroController>()) {
        final controller = Get.find<PomodoroController>();
        controller._stopWaterReminderAlarm();
        AwesomeNotifications().dismiss(receivedAction.id!);
      }
    }
  }

  /// Callback method when a notification is dismissed.
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('Notification dismissed: ${receivedAction.id}');
    if (receivedAction.channelKey == 'pomodoro_alarm_channel') {
      if (Get.isRegistered<PomodoroController>()) {
        final controller = Get.find<PomodoroController>();
        controller._stopSystemAlarm();
      }
    } else if (receivedAction.channelKey == 'water_reminder_alarm_channel') {
      if (Get.isRegistered<PomodoroController>()) {
        final controller = Get.find<PomodoroController>();
        controller._stopWaterReminderAlarm();
      }
    }
  }
}
