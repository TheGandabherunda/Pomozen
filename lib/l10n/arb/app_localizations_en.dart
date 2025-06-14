// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pomodoroTimer => 'Pomozen';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get statistics => 'Statistics';

  @override
  String get about => 'About';

  @override
  String get focusDuration => 'Focus';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get sessions => 'Sessions';

  @override
  String sessionOfSessions(Object current, Object total) {
    return 'Session $current of $total';
  }

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get skip => 'Skip';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get reminders => 'Reminders';

  @override
  String get notification => 'Notifications';

  @override
  String get alarm => 'Alarm Sound';

  @override
  String get autoPlay => 'Auto-Continue';

  @override
  String get torchAlerts => 'Flash Alerts';

  @override
  String get persistentAlerts => 'Persistent Alerts';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String dailyReminderSet(Object time) {
    return 'Daily reminder set for $time. 🔔';
  }

  @override
  String get dailyReminderCancelled => 'Daily reminder cancelled. ⏸️';

  @override
  String get notificationsAndAlerts => 'Notifications & Alerts';

  @override
  String get focusSessionCompletedNotificationTitle => 'Focus Complete 🧘‍♀️';

  @override
  String focusSessionCompletedNotificationBody(Object nextMode) {
    return 'Time to recharge. Up next: $nextMode';
  }

  @override
  String get shortBreakCompletedNotificationTitle => 'Short Break Complete 🌸';

  @override
  String shortBreakCompletedNotificationBody(Object nextMode) {
    return 'Mind refreshed. Up next: $nextMode';
  }

  @override
  String get longBreakCompletedNotificationTitle => 'Long Break Complete 🌺';

  @override
  String longBreakCompletedNotificationBody(Object nextMode) {
    return 'Well done. Up next: $nextMode';
  }

  @override
  String get ongoingTimerNotification => 'Pomozen Timer Running';

  @override
  String get alarmTitle => 'Pomozen Alert 🔔';

  @override
  String get alarmBody => 'Session complete. Tap Stop to continue. 🌟';

  @override
  String get dailyReminderNotificationTitle => 'Time to Focus. 🌅';

  @override
  String get dailyReminderNotificationBody =>
      'Your daily practice awaits. Start your session. 🧘‍♂️';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get permissionDenied => 'Permission Denied';

  @override
  String get reminderPermissionDenied =>
      'Enable notifications in Settings to receive reminders and stay focused. ✨';

  @override
  String get notificationPermissionDenied =>
      'Enable notifications to stay connected. 🔔';

  @override
  String get notificationPermissionDeniedAndGoToSettings =>
      'Notification permission denied. Enable in Settings to receive reminders. 🔔';

  @override
  String get notificationPermissionRequiredForDailyReminder =>
      'Enable notifications in Settings to set a daily reminder. �';

  @override
  String get storagePermissionDenied =>
      'Enable \'Files and Media\' permission in Settings to manage data. 🔒';

  @override
  String get importPermissionRationale =>
      'Grant \'Files and Media\' permission in Settings to import your data. 🔒';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get error => 'Error';

  @override
  String get failedToPickFile => 'Failed to select file.';

  @override
  String get general => 'General';

  @override
  String get keepScreenOn => 'Keep Screen On';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get vibration => 'Vibration';

  @override
  String get dndToggle => 'Do Not Disturb';

  @override
  String get lockScreenDisplay => 'Show on Lock Screen';

  @override
  String get language => 'Language';

  @override
  String get timerSize => 'Timer Size';

  @override
  String get ringThickness => 'Ring Thickness';

  @override
  String get immersiveMode => 'Immersive Mode';

  @override
  String get hideSeconds => 'Hide Seconds';

  @override
  String get startOfDay => 'Start of Day';

  @override
  String get startOfWeek => 'Start of Week';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get appColors => 'App Colors';

  @override
  String get primaryColor => 'Focus Color';

  @override
  String get secondaryColor => 'Short Break Color';

  @override
  String get tertiaryColor => 'Long Break Color';

  @override
  String get glyphProgress => 'Glyph Progress';

  @override
  String get enableGlyphProgress => 'Enable Glyph Progress';

  @override
  String get addLabel => 'Add Label';

  @override
  String get addCustomLabel => 'New Label';

  @override
  String get editLabel => 'Edit Label';

  @override
  String get deleteLabel => 'Delete Label';

  @override
  String deleteLabelConfirmation(Object labelName) {
    return 'Delete \'$labelName\'? This action cannot be undone. ⚠️';
  }

  @override
  String get labelColor => 'Label Color';

  @override
  String get labelName => 'Label Name';

  @override
  String get labelNameCannotBeEmpty => 'Label name cannot be empty.';

  @override
  String get labelAlreadyExists => 'Label name already exists.';

  @override
  String get addNewLabel => 'Add New Label';

  @override
  String get unlabeled => 'Unlabeled';

  @override
  String get orange => 'Orange';

  @override
  String get teal => 'Teal';

  @override
  String get blue => 'Blue';

  @override
  String get red => 'Red';

  @override
  String get green => 'Green';

  @override
  String get purple => 'Purple';

  @override
  String get indigo => 'Indigo';

  @override
  String get pink => 'Pink';

  @override
  String get brown => 'Brown';

  @override
  String get cyan => 'Cyan';

  @override
  String get amber => 'Amber';

  @override
  String get sessionHistory => 'Session History';

  @override
  String get time => 'Time';

  @override
  String get label => 'Label';

  @override
  String get note => 'Note';

  @override
  String get editSession => 'Edit Session';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get deleteSessionConfirmation =>
      'Delete this session? This action cannot be undone. 🗑️';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get minutesShort => 'min';

  @override
  String get minutes => 'minutes';

  @override
  String get focusMinutes => 'Focus Minutes';

  @override
  String get sessionNote => 'Session Note';

  @override
  String get sessionUpdatedSuccessfully =>
      'Session updated. Progress recorded. ✨';

  @override
  String get sessionDeletedSuccessfully => 'Session deleted. 🗑️';

  @override
  String get filterByLabel => 'Filter by Label';

  @override
  String get allSessions => 'All Sessions';

  @override
  String get viewAll => 'View All';

  @override
  String get viewLess => 'View Less';

  @override
  String get focusMinutesZeroNotCompleted =>
      'Complete a focus session to mark as done.';

  @override
  String get dateNewestFirst => 'Newest First';

  @override
  String get focusMoreToLess => 'Focus: More to Less';

  @override
  String get focusLessToMore => 'Focus: Less to More';

  @override
  String get completedFirst => 'Completed First';

  @override
  String get notePresentFirst => 'Notes First';

  @override
  String get labelAscending => 'Label A-Z';

  @override
  String get completed => 'Completed';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get data => 'Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get pomodoroData => 'Pomodoro Data';

  @override
  String get dataExportedSuccessfully =>
      'Data exported successfully. Your focus journey is now backed up. 📊';

  @override
  String get dataExportFailed => 'Export failed. Please try again. ❌';

  @override
  String get exportCanceled => 'Export canceled. ⏸️';

  @override
  String get importCanceled => 'Import canceled. No changes made. ⏸️';

  @override
  String get importDataConfirmation =>
      'Importing will overwrite existing data. Proceed? ⚠️';

  @override
  String get dataImportFailed =>
      'Data import failed. Check file and try again. ❌';

  @override
  String dataImportedSuccessfully(Object count) {
    return '$count sessions imported. Your focus history is now complete. 🎉';
  }

  @override
  String get noValidFilesSelected => 'No valid files selected.';

  @override
  String get emptyCsvFile => 'Empty CSV file.';

  @override
  String get emptyJsonFile => 'Empty JSON file.';

  @override
  String get invalidCsvHeader => 'Invalid CSV header. Check format. 📄';

  @override
  String get invalidColumnCount => 'Invalid column count in row.';

  @override
  String get invalidRowData => 'Some rows have invalid data.';

  @override
  String get invalidDateFormat => 'Invalid date format in CSV.';

  @override
  String get invalidFocusMinutes => 'Invalid focus minutes in CSV.';

  @override
  String get invalidIsCompleted => 'Invalid \'Is Completed\' value in CSV.';

  @override
  String get importErrors => 'Import Errors';

  @override
  String get ok => 'OK';

  @override
  String get invalidSettingValue => 'Invalid setting value.';

  @override
  String get invalidLabelFormat => 'Invalid label format in row.';

  @override
  String get invalidLabelValue => 'Invalid label value in row.';

  @override
  String get invalidSettingFormat => 'Invalid setting format in row.';

  @override
  String get reset => 'Reset';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetAllData => 'Reset All Data';

  @override
  String get resetSettingsConfirmation =>
      'Reset all settings to default values? 🔄';

  @override
  String get resetAllDataConfirmation =>
      'Delete all session history and labels? This action cannot be undone. 🗑️';

  @override
  String get allDataResetSuccessfully =>
      'All data reset. Ready for a fresh start. 🌱';

  @override
  String get settingsResetSuccessfully => 'Settings restored to default. 🔄';

  @override
  String get noData => 'No Data';

  @override
  String get noLabelsAvailable => 'No labels created yet. 🏷️';

  @override
  String get noSessionsAvailable => 'No sessions recorded yet. 🧘‍♀️';

  @override
  String get noLabelsYet =>
      'No labels yet. Create one to organize your focus journey. ✨';

  @override
  String get noSessionsYet =>
      'Your focus journey begins here. Start your first session and watch your productivity bloom. 🌸';

  @override
  String get weeklySummary => 'Weekly Summary';

  @override
  String get overview => 'Overview';

  @override
  String get totalFocusTime => 'Total Focus Time';

  @override
  String get totalSessions => 'Total Sessions';

  @override
  String get successRate => 'Success Rate';

  @override
  String get labelBreakdown => 'Label Breakdown';

  @override
  String get noLabeledSessionsYet => 'No labeled sessions yet. 🏷️';

  @override
  String get focusTime => 'Focus Time';

  @override
  String get dailyFocusTrends => 'Daily Focus Trends';

  @override
  String get dailySuccessRateTrends => 'Daily Success Rate';

  @override
  String get trends => 'Trends';

  @override
  String get totalTime => 'Total Time';

  @override
  String get dailyTrends => 'Daily Trends';

  @override
  String get weeklyTrends => 'Weekly Trends';

  @override
  String get averageFocusTimePerSession => 'Average Focus Time';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get days => 'days';

  @override
  String get bestFocusDay => 'Best Focus Day';

  @override
  String get notAvailable => 'No data yet. Begin your mindful journey. 🌱';

  @override
  String get goalProgress => 'Goal Progress';

  @override
  String get featureComingSoon => 'Coming Soon';

  @override
  String get trendsAndProgress => 'Trends & Progress';

  @override
  String get visualInsights => 'Visual Insights';

  @override
  String get weekOf => 'Week of';

  @override
  String get skippedSessions => 'Skipped Sessions';

  @override
  String get mostFocusedTimeOfDay => 'Most Focused Time';

  @override
  String get calendarHeatmap => 'Calendar Heatmap';

  @override
  String get focusIntensity => 'Focus Intensity';

  @override
  String get startSessionPrompt =>
      'Cultivate mindful focus. Each session brings you closer to your goals. 🧘‍♀️';

  @override
  String get startNow => 'Start Now';

  @override
  String get date => 'Date';

  @override
  String get monthNames => 'Month Names';

  @override
  String get weekdaysShort => 'Short Weekdays';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get add => 'Add';

  @override
  String get done => 'Done';

  @override
  String get edit => 'Edit';

  @override
  String get focus => 'Focus';

  @override
  String get delete => 'Delete';

  @override
  String get reminder => 'Reminder';

  @override
  String get aboutAndLegal => 'About & Legal';

  @override
  String get aboutApp => 'About Pomozen';

  @override
  String get appDescription =>
      'A mindful Pomodoro timer app with Minimal Design, offline support, and customizable settings to enhance your focus. 🧘‍♀️';

  @override
  String get featuresTitle => 'Key Features';

  @override
  String get featureStatistics =>
      '• Comprehensive Statistics with detailed tracking of your progress. 📊';

  @override
  String get featureReminders =>
      '• Customizable Reminders to guide you back to focus. ⏰';

  @override
  String get featureGlyphProgress =>
      '• Glyph Progress integration for Nothing Phone users. ✨';

  @override
  String get featureHydrationReminder =>
      '• Hydration Reminder to help you stay hydrated throughout the day. 💧';

  @override
  String get thankYouMessage =>
      'Thank you for choosing Pomozen to enhance your productivity and mindfulness. May your focus be deep, and your breaks peaceful. 💖';

  @override
  String get appVersion => 'Version';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsAndConditions => 'Terms of Service';

  @override
  String get termsAndConditionsIntro =>
      'Welcome to Pomozen. These terms govern your use of our mindful productivity app. 🙏';

  @override
  String get openSourceTitle => 'Open Source';

  @override
  String get openSourceContent =>
      'Pomozen is open-source, built with transparency. Its code is public for inspection, modification, and distribution. We believe in community and shared knowledge for better tools. 🌟';

  @override
  String get dataCollectionTitle => 'Data Privacy';

  @override
  String get dataCollectionContent =>
      'Your privacy is paramount. Pomozen collects no personal data or usage statistics. All data and settings are stored locally on your device, never transmitted externally. Your focus journey remains private. 🔒';

  @override
  String get disclaimerTitle => 'Disclaimer';

  @override
  String get disclaimerContent =>
      'Pomozen is provided \'as is,\' without warranties. We are not liable for any damages arising from its use. While we strive for accuracy, we cannot guarantee error-free or uninterrupted service. ⚖️';

  @override
  String get thirdPartyLibrariesTitle => 'Third-Party Libraries';

  @override
  String get thirdPartyLibrariesIntro =>
      'This app uses third-party libraries, each under its own license. We thank the open-source community. 🛠️';

  @override
  String get termsAndConditionsEnd =>
      'By using Pomozen, you agree to these terms. If you disagree, please do not use the app. Thank you for choosing mindful productivity! ✨';

  @override
  String get linksTitle => 'Links';

  @override
  String get sourceCodeLink => 'Source Code';

  @override
  String get sendFeedbackLink => 'Send Feedback';

  @override
  String get fdroidLink => 'Fdroid Link';

  @override
  String get privacyPolicyLink => 'Privacy Policy';

  @override
  String get waterReminder => 'Hydration Reminder';

  @override
  String get interval => 'Remind me every';

  @override
  String get addCustom => 'Custom';

  @override
  String get customIntervalTitle => 'Custom Reminder';

  @override
  String get invalidInterval => 'Enter a time between 5 and 480 minutes';

  @override
  String waterReminderIntervalSet(Object minutes) {
    return 'You\'ll be reminded every $minutes minutes';
  }

  @override
  String get waterReminderNotificationTitle => '💧 Time for water';

  @override
  String get waterReminderNotificationBody =>
      'A quick sip keeps you at your best';

  @override
  String get waterReminderAlarmTitle => '💙 Stay hydrated';

  @override
  String get waterReminderAlarmBody => 'Your body will thank you';

  @override
  String get wellness => 'Wellness';

  @override
  String get customIntervalRemoved => 'Custom interval removed';

  @override
  String get waterReminderEnabled => 'Water reminder enabled.';

  @override
  String get waterReminderCancelled => 'Water reminder cancelled.';
}
