import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomozen/services/timer_preset.dart';
import 'package:pomozen/ui/screens/statistics_screen.dart';

class SettingsService extends GetxService {
  // Hive Box Names
  static const String _settingsBoxName = 'pomodoroSettings';
  static const String _sessionsBoxName = 'sessions';
  static const String _presetsBoxName = 'timerPresets'; // New box for presets
  late Box _settingsBox;
  late Box<SessionData> _sessionsBox;
  late Box<TimerPreset> _presetsBox; // New box instance

  Box<SessionData> get sessionsBox => _sessionsBox;
  Box<TimerPreset> get presetsBox => _presetsBox; // Getter for presets box

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
  static const String _notificationPermissionAskedKey =
      'notificationPermissionAsked';

  // NEW: Keys for Water Reminder Settings
  static const String _waterReminderEnabledKey = 'waterReminderEnabled';
  static const String _waterReminderIntervalMinutesKey =
      'waterReminderIntervalMinutes';
  static const String _waterReminderTypeKey =
      'waterReminderType'; // 'notification' or 'alarm'

  // Keys for Selected Theme Colors
  static const String _selectedPrimaryColorNameKey = 'selectedPrimaryColorName';
  static const String _selectedSecondaryColorNameKey =
      'selectedSecondaryColorName';
  static const String _selectedTertiaryColorNameKey =
      'selectedTertiaryColorName';

  // New key for selected timer preset
  static const String _selectedTimerPresetNameKey = 'selectedTimerPresetName';

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
  final notificationPermissionAsked = false.obs;

  // NEW: Reactive Properties for Water Reminder Settings
  final waterReminderEnabled = false.obs;
  final waterReminderIntervalMinutes = 30.obs; // Default to 30 minutes
  final waterReminderType =
      'notification'.obs; // Default to notification ('notification' or 'alarm')

  // Reactive Properties for Selected Theme Colors
  final selectedPrimaryColorName = 'Blue'.obs;
  final selectedSecondaryColorName = 'Yellow'.obs;
  final selectedTertiaryColorName = 'Green'.obs;

  // New reactive properties for Timer Presets
  final timerPresets = <TimerPreset>[].obs;
  final selectedTimerPresetName = Rxn<String>();

  // Initialization
  Future<void> init() async {
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _sessionsBox = await Hive.openBox<SessionData>(_sessionsBoxName);
    _presetsBox = await Hive.openBox<TimerPreset>(_presetsBoxName);
    await _loadSettings();
    _loadPresets();
    print('SettingsService initialized successfully');
  }

  void _loadPresets() {
    if (_presetsBox.isEmpty) {
      _createDefaultPresets();
    }
    timerPresets.assignAll(_presetsBox.values.toList());
    selectedTimerPresetName.value =
        _settingsBox.get(_selectedTimerPresetNameKey);
  }

  void _createDefaultPresets() {
    final defaultPresets = [
      TimerPreset(
          name: 'Pomodoro',
          focusDuration: 25,
          shortBreakDuration: 5,
          longBreakDuration: 20,
          totalSessions: 4),
      TimerPreset(
          name: 'Lazy day',
          focusDuration: 30,
          shortBreakDuration: 3,
          longBreakDuration: 5,
          totalSessions: 3),
      TimerPreset(
          name: 'Tired day',
          focusDuration: 15,
          shortBreakDuration: 7,
          longBreakDuration: 20,
          totalSessions: 7),
    ];
    for (var preset in defaultPresets) {
      _presetsBox.add(preset);
    }
  }

  // Load Settings from Hive
  Future<void> _loadSettings() async {
    focusDuration.value = _settingsBox.get(_focusDurationKey, defaultValue: 25);
    shortBreakDuration.value =
        _settingsBox.get(_shortBreakDurationKey, defaultValue: 5);
    longBreakDuration.value =
        _settingsBox.get(_longBreakDurationKey, defaultValue: 20);
    totalSessions.value = _settingsBox.get(_totalSessionsKey, defaultValue: 4);
    reminder.value = _settingsBox.get(_reminderKey, defaultValue: true);
    isAlarm.value = _settingsBox.get(_isAlarmKey, defaultValue: false);
    autoPlay.value = _settingsBox.get(_autoPlayKey, defaultValue: false);
    torchAlerts.value = _settingsBox.get(_torchAlertsKey, defaultValue: false);
    keepScreenOn.value = _settingsBox.get(_keepScreenOnKey, defaultValue: true);
    dndToggle.value = _settingsBox.get(_dndToggleKey, defaultValue: false);
    language.value = _settingsBox.get(_languageKey, defaultValue: 'en');

    final List<dynamic> loadedLabels =
    _settingsBox.get(_labelsKey, defaultValue: []);
    labels.value =
        loadedLabels.map((e) => Map<String, dynamic>.from(e)).toList();

    dailyReminderTimeHour.value =
        _settingsBox.get(_dailyReminderTimeHourKey, defaultValue: null);
    dailyReminderTimeMinute.value =
        _settingsBox.get(_dailyReminderTimeMinuteKey, defaultValue: null);

    startOfDay.value = _settingsBox.get(_startOfDayKey, defaultValue: 0);
    startOfWeek.value = _settingsBox.get(_startOfWeekKey, defaultValue: 1);

    final String? themeModeString = _settingsBox.get(_themeModeKey);
    if (themeModeString != null) {
      themeMode.value = ThemeMode.values.firstWhere(
            (e) => e.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    } else {
      themeMode.value = ThemeMode.system;
    }

    final Map<dynamic, dynamic>? loadedSelectedStatsLabel =
    _settingsBox.get(_selectedStatsLabelKey);
    selectedStatsLabel.value = loadedSelectedStatsLabel != null
        ? Map<String, dynamic>.from(loadedSelectedStatsLabel)
        : null;

    notificationPermissionAsked.value =
        _settingsBox.get(_notificationPermissionAskedKey, defaultValue: false);

    selectedPrimaryColorName.value =
        _settingsBox.get(_selectedPrimaryColorNameKey, defaultValue: 'Blue');
    selectedSecondaryColorName.value =
        _settingsBox.get(_selectedSecondaryColorNameKey, defaultValue: 'Yellow');
    selectedTertiaryColorName.value =
        _settingsBox.get(_selectedTertiaryColorNameKey, defaultValue: 'Green');

    // NEW: Load Water Reminder Settings
    waterReminderEnabled.value =
        _settingsBox.get(_waterReminderEnabledKey, defaultValue: false);
    waterReminderIntervalMinutes.value =
        _settingsBox.get(_waterReminderIntervalMinutesKey, defaultValue: 30);
    waterReminderType.value =
        _settingsBox.get(_waterReminderTypeKey, defaultValue: 'notification');
  }

  // Setting Methods
  Future<void> setFocusDuration(int value) async {
    focusDuration.value = value;
    await _settingsBox.put(_focusDurationKey, value);
    _unselectPresetIfModified();
  }

  Future<void> setShortBreakDuration(int value) async {
    shortBreakDuration.value = value;
    await _settingsBox.put(_shortBreakDurationKey, value);
    _unselectPresetIfModified();
  }

  Future<void> setLongBreakDuration(int value) async {
    longBreakDuration.value = value;
    await _settingsBox.put(_longBreakDurationKey, value);
    _unselectPresetIfModified();
  }

  Future<void> setTotalSessions(int value) async {
    totalSessions.value = value;
    await _settingsBox.put(_totalSessionsKey, value);
    _unselectPresetIfModified();
  }

  Future<void> setReminder(bool value) async {
    reminder.value = value;
    await _settingsBox.put(_reminderKey, value);
  }

  Future<void> setIsAlarm(bool value) async {
    isAlarm.value = value;
    await _settingsBox.put(_isAlarmKey, value);
  }

  Future<void> setAutoPlay(bool value) async {
    autoPlay.value = value;
    await _settingsBox.put(_autoPlayKey, value);
  }

  Future<void> setTorchAlerts(bool value) async {
    torchAlerts.value = value;
    await _settingsBox.put(_torchAlertsKey, value);
  }

  Future<void> setKeepScreenOn(bool value) async {
    keepScreenOn.value = value;
    await _settingsBox.put(_keepScreenOnKey, value);
  }

  Future<void> setDndToggle(bool value) async {
    dndToggle.value = value;
    await _settingsBox.put(_dndToggleKey, value);
  }

  Future<void> setLanguage(String value) async {
    language.value = value;
    await _settingsBox.put(_languageKey, value);
  }

  Future<void> setLabels(List<Map<String, dynamic>> value) async {
    labels.value = value;
    await _settingsBox.put(_labelsKey, value);
  }

  Future<void> setDailyReminderTime(TimeOfDay? value) async {
    dailyReminderTimeHour.value = value?.hour;
    dailyReminderTimeMinute.value = value?.minute;
    if (value != null) {
      await _settingsBox.put(_dailyReminderTimeHourKey, value.hour);
      await _settingsBox.put(_dailyReminderTimeMinuteKey, value.minute);
    } else {
      await _settingsBox.delete(_dailyReminderTimeHourKey);
      await _settingsBox.delete(_dailyReminderTimeMinuteKey);
    }
  }

  Future<void> setStartOfDay(int value) async {
    startOfDay.value = value;
    await _settingsBox.put(_startOfDayKey, value);
  }

  Future<void> setStartOfWeek(int value) async {
    startOfWeek.value = value;
    await _settingsBox.put(_startOfWeekKey, value);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode.value = value;
    await _settingsBox.put(_themeModeKey, value.toString());
    Get.changeThemeMode(value);
  }

  Future<void> setSelectedStatsLabel(Map<String, dynamic>? value) async {
    selectedStatsLabel.value = value;
    await _settingsBox.put(_selectedStatsLabelKey, value);
  }

  Future<void> setNotificationPermissionAsked(bool value) async {
    notificationPermissionAsked.value = value;
    await _settingsBox.put(_notificationPermissionAskedKey, value);
  }

  // NEW: Water Reminder Setting Methods
  Future<void> setWaterReminderEnabled(bool value) async {
    waterReminderEnabled.value = value;
    await _settingsBox.put(_waterReminderEnabledKey, value);
  }

  Future<void> setWaterReminderIntervalMinutes(int value) async {
    waterReminderIntervalMinutes.value = value;
    await _settingsBox.put(_waterReminderIntervalMinutesKey, value);
  }

  Future<void> setWaterReminderType(String value) async {
    waterReminderType.value = value;
    await _settingsBox.put(_waterReminderTypeKey, value);
  }

  // Theme Color Setting Methods
  Future<void> setSelectedPrimaryColorName(String value) async {
    selectedPrimaryColorName.value = value;
    await _settingsBox.put(_selectedPrimaryColorNameKey, value);
  }

  Future<void> setSelectedSecondaryColorName(String value) async {
    selectedSecondaryColorName.value = value;
    await _settingsBox.put(_selectedSecondaryColorNameKey, value);
  }

  Future<void> setSelectedTertiaryColorName(String value) async {
    selectedTertiaryColorName.value = value;
    await _settingsBox.put(_selectedTertiaryColorNameKey, value);
  }

  // Timer Preset Methods
  Future<void> addTimerPreset(TimerPreset preset) async {
    await _presetsBox.add(preset);
    _loadPresets();
  }

  Future<void> updateTimerPreset(dynamic key, TimerPreset preset) async {
    await _presetsBox.put(key, preset);
    if (selectedTimerPresetName.value == preset.name) {
      selectTimerPreset(preset.name); // Re-apply settings if selected preset is updated
    }
    _loadPresets();
  }

  Future<void> deleteTimerPreset(dynamic key) async {
    final preset = _presetsBox.get(key);
    if (preset?.name == selectedTimerPresetName.value) {
      await setSelectedTimerPresetName(null);
    }
    await _presetsBox.delete(key);
    _loadPresets();
  }

  Future<void> selectTimerPreset(String? presetName) async {
    if (presetName == null) {
      await setSelectedTimerPresetName(null);
      return;
    }

    final preset =
    timerPresets.firstWhereOrNull((p) => p.name == presetName);
    if (preset != null) {
      await setFocusDuration(preset.focusDuration);
      await setShortBreakDuration(preset.shortBreakDuration);
      await setLongBreakDuration(preset.longBreakDuration);
      await setTotalSessions(preset.totalSessions);
      await setSelectedTimerPresetName(preset.name);
    }
  }

  Future<void> setSelectedTimerPresetName(String? name) async {
    selectedTimerPresetName.value = name;
    if (name != null) {
      await _settingsBox.put(_selectedTimerPresetNameKey, name);
    } else {
      await _settingsBox.delete(_selectedTimerPresetNameKey);
    }
  }

  void _unselectPresetIfModified() {
    if (selectedTimerPresetName.value == null) return;
    final preset = timerPresets
        .firstWhereOrNull((p) => p.name == selectedTimerPresetName.value);
    if (preset != null) {
      if (preset.focusDuration != focusDuration.value ||
          preset.shortBreakDuration != shortBreakDuration.value ||
          preset.longBreakDuration != longBreakDuration.value ||
          preset.totalSessions != totalSessions.value) {
        setSelectedTimerPresetName(null);
      }
    } else {
      setSelectedTimerPresetName(null);
    }
  }

  List<Map<String, dynamic>> getPresetsAsMaps() {
    return _presetsBox.values.map((p) => p.toMap()).toList();
  }

  Future<void> setPresetsFromMaps(List<Map<String, dynamic>> presetMaps) async {
    await _presetsBox.clear();
    for (var map in presetMaps) {
      await _presetsBox.add(TimerPreset.fromMap(map));
    }
    _loadPresets();
  }

  // Utility Methods
  Future<void> resetToDefaults() async {
    await _presetsBox.clear();
    _createDefaultPresets();
    _loadPresets();
    await setSelectedTimerPresetName(null);

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
    await setDailyReminderTime(null);
    await setStartOfDay(0);
    await setStartOfWeek(1);
    await setThemeMode(ThemeMode.system);
    await setSelectedStatsLabel(null);
    await setNotificationPermissionAsked(false);
    await setSelectedPrimaryColorName('Blue');
    await setSelectedSecondaryColorName('Yellow');
    await setSelectedTertiaryColorName('Green');
    await setWaterReminderEnabled(false);
    await setWaterReminderIntervalMinutes(30);
    await setWaterReminderType('notification');
    print('All settings reset to defaults (persisted)');
  }

  Future<void> clearAllData() async {
    await _settingsBox.clear();
    await _sessionsBox.clear();
    await _presetsBox.clear();
    await setLabels([]);
    print('All data (settings, sessions, presets) cleared');
    _loadPresets();
    await _loadSettings();
  }
}
