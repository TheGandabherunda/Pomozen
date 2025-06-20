import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomozen/ui/screens/statistics_screen.dart';

class SettingsService extends GetxService {
  // Hive Box Names
  static const String _settingsBoxName = 'pomodoroSettings';
  static const String _sessionsBoxName = 'sessions';
  late Box _settingsBox;
  late Box<SessionData> _sessionsBox;

  Box<SessionData> get sessionsBox => _sessionsBox;

  // Keys for Settings
  static const String _focusDurationKey = 'focusDuration';
  static const String _shortBreakDurationKey = 'shortBreakDuration';
  static const String _longBreakDurationKey = 'longBreakDuration';
  static const String _totalSessionsKey = 'totalSessions';
  static const String _reminderKey = 'reminder';
  static const String _isAlarmKey = 'isAlarm';
  static const String _autoPlayKey = 'autoPlay';
  static const String _torchAlertsKey = 'torchAlerts';
  static const String _keepScreenOnKey = 'keepScreenOn';
  static const String _dndToggleKey = 'dndToggle';
  static const String _languageKey = 'language';
  static const String _labelsKey = 'labels';
  static const String _dailyReminderTimeHourKey = 'dailyReminderTimeHour';
  static const String _dailyReminderTimeMinuteKey = 'dailyReminderTimeMinute';
  static const String _startOfDayKey = 'startOfDay';
  static const String _startOfWeekKey = 'startOfWeek';
  static const String _themeModeKey = 'themeMode';
  static const String _selectedStatsLabelKey = 'selectedStatsLabel';
  static const String _enableGlyphProgressKey = 'enableGlyphProgress';
  static const String _notificationPermissionAskedKey =
      'notificationPermissionAsked';

  // NEW: Keys for Water Reminder Settings
  static const String _waterReminderEnabledKey = 'waterReminderEnabled';
  static const String _waterReminderIntervalMinutesKey = 'waterReminderIntervalMinutes';
  static const String _waterReminderTypeKey = 'waterReminderType'; // 'notification' or 'alarm'

  // Keys for Selected Theme Colors
  static const String _selectedPrimaryColorNameKey = 'selectedPrimaryColorName';
  static const String _selectedSecondaryColorNameKey =
      'selectedSecondaryColorName';
  static const String _selectedTertiaryColorNameKey =
      'selectedTertiaryColorName';

  // Reactive Properties for Settings
  final focusDuration = 25.obs;
  final shortBreakDuration = 5.obs;
  final longBreakDuration = 20.obs;
  final totalSessions = 4.obs;
  final reminder = true.obs;
  final isAlarm = false.obs;
  final autoPlay = false.obs;
  final torchAlerts = false.obs;
  final keepScreenOn = true.obs;
  final dndToggle = false.obs;
  final language = 'en'.obs;
  final labels = <Map<String, dynamic>>[].obs;
  final dailyReminderTimeHour = Rxn<int>();
  final dailyReminderTimeMinute = Rxn<int>();
  final startOfDay = 0.obs;
  final startOfWeek = 1.obs;
  final themeMode = ThemeMode.system.obs;
  final selectedStatsLabel = Rxn<Map<String, dynamic>>();
  final enableGlyphProgress = false.obs;
  final notificationPermissionAsked = false.obs;

  // NEW: Reactive Properties for Water Reminder Settings
  final waterReminderEnabled = false.obs;
  final waterReminderIntervalMinutes = 30.obs; // Default to 30 minutes
  final waterReminderType = 'notification'.obs; // Default to notification ('notification' or 'alarm')

  // Reactive Properties for Selected Theme Colors
  final selectedPrimaryColorName = 'Blue'.obs;
  final selectedSecondaryColorName = 'Yellow'.obs;
  final selectedTertiaryColorName = 'Green'.obs;

  // Initialization
  Future<void> init() async {
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _sessionsBox = await Hive.openBox<SessionData>(_sessionsBoxName);
    await _loadSettings();
    print('SettingsService initialized successfully');
  }

  // Load Settings from Hive
  Future<void> _loadSettings() async {
    focusDuration.value = _settingsBox.get(_focusDurationKey, defaultValue: 25);
    print('Loaded focusDuration: ${focusDuration.value}');
    shortBreakDuration.value =
        _settingsBox.get(_shortBreakDurationKey, defaultValue: 5);
    print('Loaded shortBreakDuration: ${shortBreakDuration.value}');
    longBreakDuration.value =
        _settingsBox.get(_longBreakDurationKey, defaultValue: 20);
    print('Loaded longBreakDuration: ${longBreakDuration.value}');
    totalSessions.value = _settingsBox.get(_totalSessionsKey, defaultValue: 4);
    print('Loaded totalSessions: ${totalSessions.value}');
    reminder.value = _settingsBox.get(_reminderKey, defaultValue: true);
    print('Loaded reminder: ${reminder.value}');
    isAlarm.value = _settingsBox.get(_isAlarmKey, defaultValue: false);
    print('Loaded isAlarm: ${isAlarm.value}');
    autoPlay.value = _settingsBox.get(_autoPlayKey, defaultValue: false);
    print('Loaded autoPlay: ${autoPlay.value}');
    torchAlerts.value = _settingsBox.get(_torchAlertsKey, defaultValue: false);
    print('Loaded torchAlerts: ${torchAlerts.value}');
    keepScreenOn.value = _settingsBox.get(_keepScreenOnKey, defaultValue: true);
    print('Loaded keepScreenOn: ${keepScreenOn.value}');
    dndToggle.value = _settingsBox.get(_dndToggleKey, defaultValue: false);
    print('Loaded dndToggle: ${dndToggle.value}');
    language.value = _settingsBox.get(_languageKey, defaultValue: 'en');
    print('Loaded language: ${language.value}');

    final List<dynamic> loadedLabels =
    _settingsBox.get(_labelsKey, defaultValue: []);
    labels.value =
        loadedLabels.map((e) => Map<String, dynamic>.from(e)).toList();
    print('Loaded active labels: ${labels.value}');

    dailyReminderTimeHour.value =
        _settingsBox.get(_dailyReminderTimeHourKey, defaultValue: null);
    print('Loaded dailyReminderTimeHour: ${dailyReminderTimeHour.value}');
    dailyReminderTimeMinute.value =
        _settingsBox.get(_dailyReminderTimeMinuteKey, defaultValue: null);
    print('Loaded dailyReminderTimeMinute: ${dailyReminderTimeMinute.value}');

    startOfDay.value = _settingsBox.get(_startOfDayKey, defaultValue: 0);
    print('Loaded startOfDay: ${startOfDay.value}');
    startOfWeek.value = _settingsBox.get(_startOfWeekKey, defaultValue: 1);
    print('Loaded startOfWeek: ${startOfWeek.value}');

    final String? themeModeString = _settingsBox.get(_themeModeKey);
    if (themeModeString != null) {
      themeMode.value = ThemeMode.values.firstWhere(
            (e) => e.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    } else {
      themeMode.value = ThemeMode.system;
    }
    print('Loaded themeMode: ${themeMode.value}');

    final Map<dynamic, dynamic>? loadedSelectedStatsLabel =
    _settingsBox.get(_selectedStatsLabelKey);
    selectedStatsLabel.value = loadedSelectedStatsLabel != null
        ? Map<String, dynamic>.from(loadedSelectedStatsLabel)
        : null;
    print('Loaded selectedStatsLabel: ${selectedStatsLabel.value}');

    enableGlyphProgress.value =
        _settingsBox.get(_enableGlyphProgressKey, defaultValue: false);
    print('Loaded enableGlyphProgress: ${enableGlyphProgress.value}');

    notificationPermissionAsked.value =
        _settingsBox.get(_notificationPermissionAskedKey, defaultValue: false);
    print(
        'Loaded notificationPermissionAsked: ${notificationPermissionAsked.value}');

    selectedPrimaryColorName.value =
        _settingsBox.get(_selectedPrimaryColorNameKey, defaultValue: 'Blue');
    print('Loaded selectedPrimaryColorName: ${selectedPrimaryColorName.value}');
    selectedSecondaryColorName.value =
        _settingsBox.get(_selectedSecondaryColorNameKey, defaultValue: 'Yellow');
    print(
        'Loaded selectedSecondaryColorName: ${selectedSecondaryColorName.value}');
    selectedTertiaryColorName.value =
        _settingsBox.get(_selectedTertiaryColorNameKey, defaultValue: 'Green');
    print(
        'Loaded selectedTertiaryColorName: ${selectedTertiaryColorName.value}');

    // NEW: Load Water Reminder Settings
    waterReminderEnabled.value = _settingsBox.get(_waterReminderEnabledKey, defaultValue: false);
    print('Loaded waterReminderEnabled: ${waterReminderEnabled.value}');
    waterReminderIntervalMinutes.value = _settingsBox.get(_waterReminderIntervalMinutesKey, defaultValue: 30);
    print('Loaded waterReminderIntervalMinutes: ${waterReminderIntervalMinutes.value}');
    waterReminderType.value = _settingsBox.get(_waterReminderTypeKey, defaultValue: 'notification');
    print('Loaded waterReminderType: ${waterReminderType.value}');
  }

  // Setting Methods
  Future<void> setFocusDuration(int value) async {
    focusDuration.value = value;
    await _settingsBox.put(_focusDurationKey, value);
    print('Set focusDuration to: $value (persisted)');
  }

  Future<void> setShortBreakDuration(int value) async {
    shortBreakDuration.value = value;
    await _settingsBox.put(_shortBreakDurationKey, value);
    print('Set shortBreakDuration to: $value (persisted)');
  }

  Future<void> setLongBreakDuration(int value) async {
    longBreakDuration.value = value;
    await _settingsBox.put(_longBreakDurationKey, value);
    print('Set longBreakDuration to: $value (persisted)');
  }

  Future<void> setTotalSessions(int value) async {
    totalSessions.value = value;
    await _settingsBox.put(_totalSessionsKey, value);
    print('Set totalSessions to: $value (persisted)');
  }

  Future<void> setReminder(bool value) async {
    reminder.value = value;
    await _settingsBox.put(_reminderKey, value);
    print('Set reminder to: $value (persisted)');
  }

  Future<void> setIsAlarm(bool value) async {
    isAlarm.value = value;
    await _settingsBox.put(_isAlarmKey, value);
    print('Set isAlarm to: $value (persisted)');
  }

  Future<void> setAutoPlay(bool value) async {
    autoPlay.value = value;
    await _settingsBox.put(_autoPlayKey, value);
    print('Set autoPlay to: $value (persisted)');
  }

  Future<void> setTorchAlerts(bool value) async {
    torchAlerts.value = value;
    await _settingsBox.put(_torchAlertsKey, value);
    print('Set torchAlerts to: $value (persisted)');
  }

  Future<void> setKeepScreenOn(bool value) async {
    keepScreenOn.value = value;
    await _settingsBox.put(_keepScreenOnKey, value);
    print('Set keepScreenOn to: $value (persisted)');
  }

  Future<void> setDndToggle(bool value) async {
    dndToggle.value = value;
    await _settingsBox.put(_dndToggleKey, value);
    print('Set dndToggle to: $value (persisted)');
  }

  Future<void> setLanguage(String value) async {
    language.value = value;
    await _settingsBox.put(_languageKey, value);
    print('Set language to: $value (persisted)');
  }

  Future<void> setLabels(List<Map<String, dynamic>> value) async {
    labels.value = value;
    await _settingsBox.put(_labelsKey, value);
    print('Set labels to: $value (persisted)');
  }

  Future<void> setDailyReminderTime(TimeOfDay? value) async {
    dailyReminderTimeHour.value = value?.hour;
    dailyReminderTimeMinute.value = value?.minute;
    if (value != null) {
      await _settingsBox.put(_dailyReminderTimeHourKey, value.hour);
      await _settingsBox.put(_dailyReminderTimeMinuteKey, value.minute);
      print('Set dailyReminderTime to: $value (persisted)');
    } else {
      await _settingsBox.delete(_dailyReminderTimeHourKey);
      await _settingsBox.delete(_dailyReminderTimeMinuteKey);
      print('Cleared dailyReminderTime (persisted)');
    }
  }

  Future<void> setStartOfDay(int value) async {
    startOfDay.value = value;
    await _settingsBox.put(_startOfDayKey, value);
    print('Set startOfDay to: $value (persisted)');
  }

  Future<void> setStartOfWeek(int value) async {
    startOfWeek.value = value;
    await _settingsBox.put(_startOfWeekKey, value);
    print('Set startOfWeek to: $value (persisted)');
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode.value = value;
    await _settingsBox.put(_themeModeKey, value.toString());
    Get.changeThemeMode(value);
    print('Set themeMode to: $value (persisted)');
  }

  Future<void> setSelectedStatsLabel(Map<String, dynamic>? value) async {
    selectedStatsLabel.value = value;
    await _settingsBox.put(_selectedStatsLabelKey, value);
    print('Set selectedStatsLabel to: $value (persisted)');
  }

  Future<void> setEnableGlyphProgress(bool value) async {
    enableGlyphProgress.value = value;
    await _settingsBox.put(_enableGlyphProgressKey, value);
    print('Set enableGlyphProgress to: $value (persisted)');
  }

  Future<void> setNotificationPermissionAsked(bool value) async {
    notificationPermissionAsked.value = value;
    await _settingsBox.put(_notificationPermissionAskedKey, value);
    print('Set notificationPermissionAsked: $value (persisted)');
  }

  // NEW: Water Reminder Setting Methods
  Future<void> setWaterReminderEnabled(bool value) async {
    waterReminderEnabled.value = value;
    await _settingsBox.put(_waterReminderEnabledKey, value);
    print('Set waterReminderEnabled to: $value (persisted)');
  }

  Future<void> setWaterReminderIntervalMinutes(int value) async {
    waterReminderIntervalMinutes.value = value;
    await _settingsBox.put(_waterReminderIntervalMinutesKey, value);
    print('Set waterReminderIntervalMinutes to: $value (persisted)');
  }

  Future<void> setWaterReminderType(String value) async {
    waterReminderType.value = value;
    await _settingsBox.put(_waterReminderTypeKey, value);
    print('Set waterReminderType to: $value (persisted)');
  }

  // Theme Color Setting Methods
  Future<void> setSelectedPrimaryColorName(String value) async {
    selectedPrimaryColorName.value = value;
    await _settingsBox.put(_selectedPrimaryColorNameKey, value);
    print('Set selectedPrimaryColorName to: $value (persisted)');
  }

  Future<void> setSelectedSecondaryColorName(String value) async {
    selectedSecondaryColorName.value = value;
    await _settingsBox.put(_selectedSecondaryColorNameKey, value);
    print('Set selectedSecondaryColorName to: $value (persisted)');
  }

  Future<void> setSelectedTertiaryColorName(String value) async {
    selectedTertiaryColorName.value = value;
    await _settingsBox.put(_selectedTertiaryColorNameKey, value);
    print('Set selectedTertiaryColorName to: $value (persisted)');
  }

  // Utility Methods
  Future<void> resetToDefaults() async {
    await setFocusDuration(25);
    await setShortBreakDuration(5);
    await setLongBreakDuration(20);
    await setTotalSessions(4);
    await setReminder(true);
    await setIsAlarm(false);
    await setAutoPlay(false);
    await setTorchAlerts(false);
    await setKeepScreenOn(true);
    await setDndToggle(false);
    await setLanguage('en');
    // The line 'await setLabels([]);' was intentionally removed from here
    // as per previous discussion, to preserve labels when only settings are reset.
    await setDailyReminderTime(null);
    await setStartOfDay(0);
    await setStartOfWeek(1);
    await setThemeMode(ThemeMode.system);
    await setSelectedStatsLabel(null);
    await setEnableGlyphProgress(false);
    await setNotificationPermissionAsked(false);
    await setSelectedPrimaryColorName('Blue');
    await setSelectedSecondaryColorName('Yellow');
    await setSelectedTertiaryColorName('Green');
    // NEW: Reset Water Reminder settings
    await setWaterReminderEnabled(false);
    await setWaterReminderIntervalMinutes(30);
    await setWaterReminderType('notification');
    print('All settings reset to defaults (persisted)');
  }

  Future<void> clearAllData() async {
    await _settingsBox.clear();
    await _sessionsBox.clear();
    // Explicitly clear labels after clearing the settings box
    await setLabels([]);
    print('All data (settings and sessions) cleared');
  }
}
