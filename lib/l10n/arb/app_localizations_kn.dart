// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get pomodoroTimer => 'ಪೋಮೋಜೆನ್';

  @override
  String get home => 'ಮುಖಪುಟ';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get statistics => 'ಅಂಕಿಅಂಶಗಳು';

  @override
  String get about => 'ಬಗ್ಗೆ';

  @override
  String get focusDuration => 'ಗಮನ';

  @override
  String get shortBreak => 'ಸಣ್ಣ ವಿರಾಮ';

  @override
  String get longBreak => 'ದೀರ್ಘ ವಿರಾಮ';

  @override
  String get sessions => 'ಸೆಷನ್‌ಗಳು';

  @override
  String sessionOfSessions(Object current, Object total) {
    return '$total ರಲ್ಲಿ $current ಸೆಷನ್';
  }

  @override
  String get start => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get pause => 'ವಿರಾಮ';

  @override
  String get skip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡು';

  @override
  String get save => 'ಉಳಿಸು';

  @override
  String get reminders => 'ಜ್ಞಾಪನೆಗಳು';

  @override
  String get notification => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get alarm => 'ಅಲಾರಾಂ ಧ್ವನಿ';

  @override
  String get autoPlay => 'ಸ್ವಯಂ-ಮುಂದುವರಿಕೆ';

  @override
  String get torchAlerts => 'ಫ್ಲ್ಯಾಶ್ ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get persistentAlerts => 'ನಿರಂತರ ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get dailyReminder => 'ದೈನಂದಿನ ಜ್ಞಾಪನೆ';

  @override
  String dailyReminderSet(Object time) {
    return 'ದೈನಂದಿನ ಜ್ಞಾಪನೆ $time ಕ್ಕೆ ಹೊಂದಿಸಲಾಗಿದೆ. 🔔';
  }

  @override
  String get dailyReminderCancelled => 'ದೈನಂದಿನ ಜ್ಞಾಪನೆ ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ. ⏸️';

  @override
  String get notificationsAndAlerts => 'ಅಧಿಸೂಚನೆಗಳು ಮತ್ತು ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get focusSessionCompletedNotificationTitle => 'ಗಮನ ಪೂರ್ಣಗೊಂಡಿದೆ 🧘‍♀️';

  @override
  String focusSessionCompletedNotificationBody(Object nextMode) {
    return 'ರೀಚಾರ್ಜ್ ಮಾಡಲು ಸಮಯ. ಮುಂದೆ: $nextMode';
  }

  @override
  String get shortBreakCompletedNotificationTitle =>
      'ಸಣ್ಣ ವಿರಾಮ ಪೂರ್ಣಗೊಂಡಿದೆ 🌸';

  @override
  String shortBreakCompletedNotificationBody(Object nextMode) {
    return 'ಮನಸ್ಸು ರಿಫ್ರೆಶ್ ಆಗಿದೆ. ಮುಂದೆ: $nextMode';
  }

  @override
  String get longBreakCompletedNotificationTitle =>
      'ದೀರ್ಘ ವಿರಾಮ ಪೂರ್ಣಗೊಂಡಿದೆ 🌺';

  @override
  String longBreakCompletedNotificationBody(Object nextMode) {
    return 'ಚೆನ್ನಾಗಿ ಮಾಡಿದ್ದೀರಿ. ಮುಂದೆ: $nextMode';
  }

  @override
  String get ongoingTimerNotification => 'ಪೋಮೋಜೆನ್ ಟೈಮರ್ ಚಾಲನೆಯಲ್ಲಿದೆ';

  @override
  String get alarmTitle => 'ಪೋಮೋಜೆನ್ ಎಚ್ಚರಿಕೆ 🔔';

  @override
  String get alarmBody => 'ಸೆಷನ್ ಪೂರ್ಣಗೊಂಡಿದೆ. ಮುಂದುವರಿಯಲು ನಿಲ್ಲಿಸಿ. 🌟';

  @override
  String get dailyReminderNotificationTitle => 'ಗಮನಹರಿಸಲು ಸಮಯ. 🌅';

  @override
  String get dailyReminderNotificationBody =>
      'ನಿಮ್ಮ ದೈನಂದಿನ ಅಭ್ಯಾಸ ಕಾಯುತ್ತಿದೆ. ನಿಮ್ಮ ಸೆಷನ್ ಪ್ರಾರಂಭಿಸಿ. 🧘‍♂️';

  @override
  String get permissionRequired => 'ಅನುಮತಿ ಅಗತ್ಯವಿದೆ';

  @override
  String get permissionDenied => 'ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get reminderPermissionDenied =>
      'ಜ್ಞಾಪನೆಗಳನ್ನು ಪಡೆಯಲು ಮತ್ತು ಗಮನದಲ್ಲಿರಲು ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಅಧಿಸೂಚನೆಗಳನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ. ✨';

  @override
  String get notificationPermissionDenied =>
      'ಸಂಪರ್ಕದಲ್ಲಿರಲು ಅಧಿಸೂಚನೆಗಳನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ. 🔔';

  @override
  String get notificationPermissionDeniedAndGoToSettings =>
      'ಅಧಿಸೂಚನೆ ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ. ಜ್ಞಾಪನೆಗಳನ್ನು ಪಡೆಯಲು ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಸಕ್ರಿಯಗೊಳಿಸಿ. 🔔';

  @override
  String get notificationPermissionRequiredForDailyReminder =>
      'ದೈನಂದಿನ ಜ್ಞಾಪನೆ ಹೊಂದಿಸಲು ಅಧಿಸೂಚನೆ ಅನುಮತಿ ಅಗತ್ಯವಿದೆ. ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಸಕ್ರಿಯಗೊಳಿಸಿ. 🔔';

  @override
  String get storagePermissionDenied =>
      'ಡೇಟಾ ನಿರ್ವಹಿಸಲು ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ \'ಫೈಲ್‌ಗಳು ಮತ್ತು ಮಾಧ್ಯಮ\' ಅನುಮತಿ ಸಕ್ರಿಯಗೊಳಿಸಿ. 🔒';

  @override
  String get importPermissionRationale =>
      'ನಿಮ್ಮ ಡೇಟಾವನ್ನು ಆಮದು ಮಾಡಲು ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ \'ಫೈಲ್‌ಗಳು ಮತ್ತು ಮಾಧ್ಯಮ\' ಅನುಮತಿ ನೀಡಿ. 🔒';

  @override
  String get openSettings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ತೆರೆಯಿರಿ';

  @override
  String get error => 'ದೋಷ';

  @override
  String get failedToPickFile => 'ಫೈಲ್ ಆಯ್ಕೆ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ.';

  @override
  String get general => 'ಸಾಮಾನ್ಯ';

  @override
  String get keepScreenOn => 'ಸ್ಕ್ರೀನ್ ಆನ್ ಇರಿಸಿ';

  @override
  String get soundEffects => 'ಧ್ವನಿ ಪರಿಣಾಮಗಳು';

  @override
  String get vibration => 'ಕಂಪನ';

  @override
  String get dndToggle => 'ತೊಂದರೆ ನೀಡಬೇಡಿ';

  @override
  String get lockScreenDisplay => 'ಲಾಕ್ ಸ್ಕ್ರೀನ್ ಮೇಲೆ ತೋರಿಸು';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get timerSize => 'ಟೈಮರ್ ಗಾತ್ರ';

  @override
  String get ringThickness => 'ರಿಂಗ್ ದಪ್ಪ';

  @override
  String get immersiveMode => 'ತಲ್ಲೀನಗೊಳಿಸುವ ಮೋಡ್';

  @override
  String get hideSeconds => 'ಸೆಕೆಂಡುಗಳನ್ನು ಮರೆಮಾಡಿ';

  @override
  String get startOfDay => 'ದಿನದ ಪ್ರಾರಂಭ';

  @override
  String get startOfWeek => 'ವಾರದ ಪ್ರಾರಂಭ';

  @override
  String get theme => 'ಥೀಮ್';

  @override
  String get light => 'ಹಗುರ';

  @override
  String get dark => 'ಗಾಢ';

  @override
  String get system => 'ಸಿಸ್ಟಮ್';

  @override
  String get systemTheme => 'ಸಿಸ್ಟಮ್ ಥೀಮ್';

  @override
  String get lightTheme => 'ಲೈಟ್ ಥೀಮ್';

  @override
  String get darkTheme => 'ಡಾರ್ಕ್ ಥೀಮ್';

  @override
  String get appColors => 'ಅಪ್ಲಿಕೇಶನ್ ಬಣ್ಣಗಳು';

  @override
  String get primaryColor => 'ಗಮನ ಬಣ್ಣ';

  @override
  String get secondaryColor => 'ಸಣ್ಣ ವಿರಾಮ ಬಣ್ಣ';

  @override
  String get tertiaryColor => 'ದೀರ್ಘ ವಿರಾಮ ಬಣ್ಣ';

  @override
  String get glyphProgress => 'ಗ್ಲಿಫ್ ಪ್ರಗತಿ';

  @override
  String get enableGlyphProgress => 'ಗ್ಲಿಫ್ ಪ್ರಗತಿಯನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ';

  @override
  String get addLabel => 'ಲೇಬಲ್ ಸೇರಿಸಿ';

  @override
  String get addCustomLabel => 'ಹೊಸ ಲೇಬಲ್';

  @override
  String get editLabel => 'ಲೇಬಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get deleteLabel => 'ಲೇಬಲ್ ತೆಗೆದುಹಾಕು';

  @override
  String deleteLabelConfirmation(Object labelName) {
    return '\'$labelName\' ಅಳಿಸುವುದೇ? ಈ ಕ್ರಿಯೆ ರದ್ದುಗೊಳಿಸಲಾಗದು. ⚠️';
  }

  @override
  String get labelColor => 'ಲೇಬಲ್ ಬಣ್ಣ';

  @override
  String get labelName => 'ಲೇಬಲ್ ಹೆಸರು';

  @override
  String get labelNameCannotBeEmpty => 'ಲೇಬಲ್ ಹೆಸರು ಖಾಲಿಯಾಗಿರಬಾರದು.';

  @override
  String get labelAlreadyExists => 'ಈ ಲೇಬಲ್ ಹೆಸರು ಈಗಾಗಲೇ ಅಸ್ತಿತ್ವದಲ್ಲಿದೆ.';

  @override
  String get addNewLabel => 'ಹೊಸ ಲೇಬಲ್ ಸೇರಿಸಿ';

  @override
  String get unlabeled => 'ಲೇಬಲ್ ಮಾಡದ';

  @override
  String get orange => 'ಕಿತ್ತಳೆ';

  @override
  String get teal => 'ಟೀಲ್';

  @override
  String get blue => 'ನೀಲಿ';

  @override
  String get red => 'ಕೆಂಪು';

  @override
  String get green => 'ಹಸಿರು';

  @override
  String get purple => 'ನೇರಳೆ';

  @override
  String get indigo => 'ಇಂಡಿಗೋ';

  @override
  String get pink => 'ಪಿಂಕ್';

  @override
  String get brown => 'ಕಂದು';

  @override
  String get cyan => 'ಸಯಾನ್';

  @override
  String get amber => 'ಅಂಬರ್';

  @override
  String get sessionHistory => 'ಸೆಷನ್ ಇತಿಹಾಸ';

  @override
  String get time => 'ಸಮಯ';

  @override
  String get label => 'ಲೇಬಲ್';

  @override
  String get note => 'ಟಿಪ್ಪಣಿ';

  @override
  String get editSession => 'ಸೆಷನ್ ಸಂಪಾದಿಸಿ';

  @override
  String get deleteSession => 'ಸೆಷನ್ ಅಳಿಸಿ';

  @override
  String get deleteSessionConfirmation =>
      'ಈ ಸೆಷನ್ ಅಳಿಸುವುದೇ? ಈ ಕ್ರಿಯೆ ರದ್ದುಗೊಳಿಸಲಾಗದು. 🗑️';

  @override
  String get today => 'ಇಂದು';

  @override
  String get yesterday => 'ನಿನ್ನೆ';

  @override
  String get minutesShort => 'ನಿಮಿಷ';

  @override
  String get minutes => 'ನಿಮಿಷಗಳು';

  @override
  String get focusMinutes => 'ಗಮನದ ನಿಮಿಷಗಳು';

  @override
  String get sessionNote => 'ಸೆಷನ್ ಟಿಪ್ಪಣಿ';

  @override
  String get sessionUpdatedSuccessfully =>
      'ಸೆಷನ್ ನವೀಕರಿಸಲಾಗಿದೆ. ಪ್ರಗತಿ ದಾಖಲಾಗಿದೆ. ✨';

  @override
  String get sessionDeletedSuccessfully => 'ಸೆಷನ್ ಅಳಿಸಲಾಗಿದೆ. 🗑️';

  @override
  String get filterByLabel => 'ಲೇಬಲ್ ಮೂಲಕ ಫಿಲ್ಟರ್ ಮಾಡಿ';

  @override
  String get allSessions => 'ಎಲ್ಲಾ ಸೆಷನ್‌ಗಳು';

  @override
  String get viewAll => 'ಎಲ್ಲವನ್ನೂ ವೀಕ್ಷಿಸಿ';

  @override
  String get viewLess => 'ಕಡಿಮೆ ವೀಕ್ಷಿಸಿ';

  @override
  String get focusMinutesZeroNotCompleted =>
      'ಪೂರ್ಣಗೊಳಿಸಲು ಒಂದು ಗಮನದ ಸೆಷನ್ ಪೂರ್ಣಗೊಳಿಸಿ.';

  @override
  String get dateNewestFirst => 'ಹೊಸದು ಮೊದಲು';

  @override
  String get focusMoreToLess => 'ಗಮನ: ಹೆಚ್ಚು ದಿಂದ ಕಡಿಮೆ';

  @override
  String get focusLessToMore => 'ಗಮನ: ಕಡಿಮೆ ದಿಂದ ಹೆಚ್ಚು';

  @override
  String get completedFirst => 'ಮೊದಲು ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get notePresentFirst => 'ಟಿಪ್ಪಣಿಗಳು ಮೊದಲು';

  @override
  String get labelAscending => 'ಲೇಬಲ್ A-Z';

  @override
  String get completed => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get yes => 'ಹೌದು';

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get data => 'ಡೇಟಾ';

  @override
  String get exportData => 'ಡೇಟಾ ರಫ್ತು ಮಾಡಿ';

  @override
  String get importData => 'ಡೇಟಾ ಆಮದು ಮಾಡಿ';

  @override
  String get pomodoroData => 'ಪೋಮೋಡೋರೋ ಡೇಟಾ';

  @override
  String get dataExportedSuccessfully =>
      'ಡೇಟಾ ಯಶಸ್ವಿಯಾಗಿ ರಫ್ತು ಮಾಡಲಾಗಿದೆ. ನಿಮ್ಮ ಗಮನದ ಪ್ರಯಾಣ ಈಗ ಬ್ಯಾಕಪ್ ಆಗಿದೆ. 📊';

  @override
  String get dataExportFailed =>
      'ರಫ್ತು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ. ❌';

  @override
  String get exportCanceled => 'ರಫ್ತು ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ. ⏸️';

  @override
  String get importCanceled =>
      'ಆಮದು ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ. ಯಾವುದೇ ಬದಲಾವಣೆಗಳಿಲ್ಲ. ⏸️';

  @override
  String get importDataConfirmation =>
      'ಆಮದು ಅಸ್ತಿತ್ವದಲ್ಲಿರುವ ಡೇಟಾವನ್ನು ಅತಿಕ್ರಮಿಸುತ್ತದೆ. ಮುಂದುವರಿಯುವುದೇ? ⚠️';

  @override
  String get dataImportFailed =>
      'ಡೇಟಾ ಆಮದು ವಿಫಲವಾಗಿದೆ. ಫೈಲ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ. ❌';

  @override
  String dataImportedSuccessfully(Object count) {
    return '$count ಸೆಷನ್‌ಗಳು ಆಮದು ಮಾಡಲಾಗಿದೆ. ನಿಮ್ಮ ಗಮನದ ಇತಿಹಾಸ ಈಗ ಪೂರ್ಣಗೊಂಡಿದೆ. 🎉';
  }

  @override
  String get noValidFilesSelected =>
      'ಯಾವುದೇ ಮಾನ್ಯ ಫೈಲ್‌ಗಳನ್ನು ಆಯ್ಕೆ ಮಾಡಲಾಗಿಲ್ಲ.';

  @override
  String get emptyCsvFile => 'ಖಾಲಿ CSV ಫೈಲ್.';

  @override
  String get emptyJsonFile => 'ಖಾಲಿ JSON ಫೈಲ್.';

  @override
  String get invalidCsvHeader => 'ಅಮಾನ್ಯ CSV ಹೆಡರ್. ಸ್ವರೂಪ ಪರಿಶೀಲಿಸಿ. 📄';

  @override
  String get invalidColumnCount => 'ಸಾಲಿನಲ್ಲಿ ಅಮಾನ್ಯ ಕಾಲಮ್ ಎಣಿಕೆ.';

  @override
  String get invalidRowData => 'ಕೆಲವು ಸಾಲುಗಳು ಅಮಾನ್ಯ ಡೇಟಾವನ್ನು ಹೊಂದಿವೆ.';

  @override
  String get invalidDateFormat => 'CSV ನಲ್ಲಿ ಅಮಾನ್ಯ ದಿನಾಂಕ ಸ್ವರೂಪ.';

  @override
  String get invalidFocusMinutes => 'CSV ನಲ್ಲಿ ಅಮಾನ್ಯ ಗಮನದ ನಿಮಿಷಗಳು.';

  @override
  String get invalidIsCompleted =>
      'CSV ನಲ್ಲಿ \'ಪೂರ್ಣಗೊಂಡಿದೆ\' ಮೌಲ್ಯ ಅಮಾನ್ಯವಾಗಿದೆ.';

  @override
  String get importErrors => 'ಆಮದು ದೋಷಗಳು';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get invalidSettingValue => 'ಅಮಾನ್ಯ ಸೆಟ್ಟಿಂಗ್ ಮೌಲ್ಯ.';

  @override
  String get invalidLabelFormat => 'ಸಾಲಿನಲ್ಲಿ ಅಮಾನ್ಯ ಲೇಬಲ್ ಸ್ವರೂಪ.';

  @override
  String get invalidLabelValue => 'ಸಾಲಿನಲ್ಲಿ ಅಮಾನ್ಯ ಲೇಬಲ್ ಮೌಲ್ಯ.';

  @override
  String get invalidSettingFormat => 'ಸಾಲಿನಲ್ಲಿ ಅಮಾನ್ಯ ಸೆಟ್ಟಿಂಗ್ ಸ್ವರೂಪ.';

  @override
  String get reset => 'ಮರುಹೊಂದಿಸಿ';

  @override
  String get resetSettings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ಮರುಹೊಂದಿಸಿ';

  @override
  String get resetAllData => 'ಎಲ್ಲಾ ಡೇಟಾವನ್ನು ಮರುಹೊಂದಿಸಿ';

  @override
  String get resetSettingsConfirmation =>
      'ಎಲ್ಲಾ ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ಡೀಫಾಲ್ಟ್ ಮೌಲ್ಯಗಳಿಗೆ ಮರುಹೊಂದಿಸುವುದೇ? 🔄';

  @override
  String get resetAllDataConfirmation =>
      'ಎಲ್ಲಾ ಸೆಷನ್ ಇತಿಹಾಸ ಮತ್ತು ಲೇಬಲ್‌ಗಳನ್ನು ಅಳಿಸುವುದೇ? ಈ ಕ್ರಿಯೆ ರದ್ದುಗೊಳಿಸಲಾಗದು. 🗑️';

  @override
  String get allDataResetSuccessfully =>
      'ಎಲ್ಲಾ ಡೇಟಾ ಮರುಹೊಂದಿಸಲಾಗಿದೆ. ಹೊಸ ಪ್ರಾರಂಭಕ್ಕೆ ಸಿದ್ಧ. 🌱';

  @override
  String get settingsResetSuccessfully =>
      'ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ಡೀಫಾಲ್ಟ್‌ಗೆ ಮರುಸ್ಥಾಪಿಸಲಾಗಿದೆ. 🔄';

  @override
  String get noData => 'ಡೇಟಾ ಇಲ್ಲ';

  @override
  String get noLabelsAvailable => 'ಇನ್ನೂ ಯಾವುದೇ ಲೇಬಲ್‌ಗಳನ್ನು ರಚಿಸಲಾಗಿಲ್ಲ. 🏷️';

  @override
  String get noSessionsAvailable =>
      'ಇನ್ನೂ ಯಾವುದೇ ಸೆಷನ್‌ಗಳನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಲಾಗಿಲ್ಲ. 🧘‍♀️';

  @override
  String get noLabelsYet =>
      'ಇನ್ನೂ ಯಾವುದೇ ಲೇಬಲ್‌ಗಳಿಲ್ಲ. ನಿಮ್ಮ ಗಮನದ ಪ್ರಯಾಣವನ್ನು ಸಂಘಟಿಸಲು ಒಂದನ್ನು ರಚಿಸಿ. ✨';

  @override
  String get noSessionsYet =>
      'ನಿಮ್ಮ ಗಮನದ ಪ್ರಯಾಣ ಇಲ್ಲಿಂದ ಪ್ರಾರಂಭವಾಗುತ್ತದೆ. ನಿಮ್ಮ ಮೊದಲ ಸೆಷನ್ ಅನ್ನು ಪ್ರಾರಂಭಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಉತ್ಪಾದಕತೆಯನ್ನು ಅರಳಿಸಿ. 🌸';

  @override
  String get weeklySummary => 'ವಾರದ ಸಾರಾಂಶ';

  @override
  String get overview => 'ಅವಲೋಕನ';

  @override
  String get totalFocusTime => 'ಒಟ್ಟು ಗಮನದ ಸಮಯ';

  @override
  String get totalSessions => 'ಒಟ್ಟು ಸೆಷನ್‌ಗಳು';

  @override
  String get successRate => 'ಯಶಸ್ಸಿನ ದರ';

  @override
  String get labelBreakdown => 'ಲೇಬಲ್ ವಿಭಜನೆ';

  @override
  String get noLabeledSessionsYet =>
      'ಇನ್ನೂ ಯಾವುದೇ ಲೇಬಲ್ ಮಾಡಿದ ಸೆಷನ್‌ಗಳಿಲ್ಲ. 🏷️';

  @override
  String get focusTime => 'ಗಮನದ ಸಮಯ';

  @override
  String get dailyFocusTrends => 'ದೈನಂದಿನ ಗಮನದ ಪ್ರವೃತ್ತಿಗಳು';

  @override
  String get dailySuccessRateTrends => 'ದೈನಂದಿನ ಯಶಸ್ಸಿನ ದರ';

  @override
  String get trends => 'ಪ್ರವೃತ್ತಿಗಳು';

  @override
  String get totalTime => 'ಒಟ್ಟು ಸಮಯ';

  @override
  String get dailyTrends => 'ದೈನಂದಿನ ಪ್ರವೃತ್ತಿಗಳು';

  @override
  String get weeklyTrends => 'ವಾರದ ಪ್ರವೃತ್ತಿಗಳು';

  @override
  String get averageFocusTimePerSession => 'ಸರಾಸರಿ ಗಮನದ ಸಮಯ';

  @override
  String get currentStreak => 'ಪ್ರಸ್ತುತ ಸ್ಟ್ರೀಕ್';

  @override
  String get days => 'ದಿನಗಳು';

  @override
  String get bestFocusDay => 'ಅತ್ಯುತ್ತಮ ಗಮನದ ದಿನ';

  @override
  String get notAvailable =>
      'ಇನ್ನೂ ಯಾವುದೇ ಡೇಟಾ ಇಲ್ಲ. ನಿಮ್ಮ ಗಮನದ ಪ್ರಯಾಣವನ್ನು ಪ್ರಾರಂಭಿಸಿ. 🌱';

  @override
  String get goalProgress => 'ಗುರಿ ಪ್ರಗತಿ';

  @override
  String get featureComingSoon => 'ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ';

  @override
  String get trendsAndProgress => 'ಪ್ರವೃತ್ತಿಗಳು ಮತ್ತು ಪ್ರಗತಿ';

  @override
  String get visualInsights => 'ದೃಶ್ಯ ಒಳನೋಟಗಳು';

  @override
  String get weekOf => 'ವಾರದ';

  @override
  String get skippedSessions => 'ಬಿಟ್ಟುಬಿಟ್ಟ ಸೆಷನ್‌ಗಳು';

  @override
  String get mostFocusedTimeOfDay => 'ಅತ್ಯಂತ ಗಮನಹರಿಸಿದ ಸಮಯ';

  @override
  String get calendarHeatmap => 'ಕ್ಯಾಲೆಂಡರ್ ಹೀಟ್‌ಮ್ಯಾಪ್';

  @override
  String get focusIntensity => 'ಗಮನದ ತೀವ್ರತೆ';

  @override
  String get startSessionPrompt =>
      'ಗಮನದೊಂದಿಗೆ ಉತ್ಪಾದಕತೆಯನ್ನು ಬೆಳೆಸಿಕೊಳ್ಳಿ. ಪ್ರತಿ ಸೆಷನ್ ನಿಮ್ಮ ಗುರಿಗಳಿಗೆ ಹತ್ತಿರ ತರುತ್ತದೆ. 🧘‍♀️';

  @override
  String get startNow => 'ಈಗ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get date => 'ದಿನಾಂಕ';

  @override
  String get monthNames => 'ತಿಂಗಳ ಹೆಸರುಗಳು';

  @override
  String get weekdaysShort => 'ಸಣ್ಣ ವಾರದ ದಿನಗಳು';

  @override
  String get mondayShort => 'ಸೋಮ';

  @override
  String get tuesdayShort => 'ಮಂಗಳ';

  @override
  String get wednesdayShort => 'ಬುಧ';

  @override
  String get thursdayShort => 'ಗುರು';

  @override
  String get fridayShort => 'ಶುಕ್ರ';

  @override
  String get saturdayShort => 'ಶನಿ';

  @override
  String get sundayShort => 'ಭಾನು';

  @override
  String get add => 'ಸೇರಿಸಿ';

  @override
  String get done => 'ಮುಗಿದಿದೆ';

  @override
  String get edit => 'ಸಂಪಾದಿಸಿ';

  @override
  String get focus => 'ಗಮನ';

  @override
  String get delete => 'ಅಳಿಸು';

  @override
  String get reminder => 'ಜ್ಞಾಪನೆ';

  @override
  String get aboutAndLegal => 'ಬಗ್ಗೆ ಮತ್ತು ಕಾನೂನು';

  @override
  String get aboutApp => 'ಪೋಮೋಜೆನ್ ಬಗ್ಗೆ';

  @override
  String get appDescription =>
      'ಮಿನಿಮಲ್ ಡಿಸೈನ್, ಆಫ್‌ಲೈನ್ ಬೆಂಬಲ ಮತ್ತು ನಿಮ್ಮ ಗಮನವನ್ನು ಹೆಚ್ಚಿಸಲು ಗ್ರಾಹಕೀಯಗೊಳಿಸಬಹುದಾದ ಸೆಟ್ಟಿಂಗ್‌ಗಳೊಂದಿಗೆ ಮೈಂಡ್‌ಫುಲ್ ಪೋಮೋಡೋರೋ ಟೈಮರ್ ಅಪ್ಲಿಕೇಶನ್. 🧘‍♀️';

  @override
  String get featuresTitle => 'ಪ್ರಮುಖ ವೈಶಿಷ್ಟ್ಯಗಳು';

  @override
  String get featureStatistics =>
      '• ನಿಮ್ಮ ಪ್ರಗತಿಯ ವಿವರವಾದ ಟ್ರ್ಯಾಕಿಂಗ್‌ನೊಂದಿಗೆ ಸಮಗ್ರ ಅಂಕಿಅಂಶಗಳು. 📊';

  @override
  String get featureReminders =>
      '• ಗಮನಕ್ಕೆ ನಿಮ್ಮನ್ನು ಮರಳಿ ಮಾರ್ಗದರ್ಶನ ನೀಡಲು ಗ್ರಾಹಕೀಯಗೊಳಿಸಬಹುದಾದ ಜ್ಞಾಪನೆಗಳು. ⏰';

  @override
  String get featureGlyphProgress =>
      '• ನಥಿಂಗ್ ಫೋನ್ ಬಳಕೆದಾರರಿಗಾಗಿ ಗ್ಲಿಫ್ ಪ್ರಗತಿ ಏಕೀಕರಣ. ✨';

  @override
  String get featureHydrationReminder =>
      '• ದಿನವಿಡೀ ಹೈಡ್ರೇಟೆಡ್ ಆಗಿರಲು ನಿಮಗೆ ಸಹಾಯ ಮಾಡುವ ಹೈಡ್ರೇಶನ್ ಜ್ಞಾಪನೆ. 💧';

  @override
  String get thankYouMessage =>
      'ನಿಮ್ಮ ಉತ್ಪಾದಕತೆ ಮತ್ತು ಮೈಂಡ್‌ಫುಲ್‌ನೆಸ್ ಹೆಚ್ಚಿಸಲು ಪೋಮೋಜೆನ್ ಆಯ್ಕೆ ಮಾಡಿದ್ದಕ್ಕೆ ಧನ್ಯವಾದಗಳು. ನಿಮ್ಮ ಗಮನ ಆಳವಾಗಿರಲಿ, ವಿರಾಮಗಳು ಶಾಂತಿಯುತವಾಗಿರಲಿ. 💖';

  @override
  String get appVersion => 'ಆವೃತ್ತಿ';

  @override
  String get version => 'ಆವೃತ್ತಿ';

  @override
  String get privacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get termsOfService => 'ಸೇವಾ ನಿಯಮಗಳು';

  @override
  String get termsAndConditions => 'ಸೇವಾ ನಿಯಮಗಳು';

  @override
  String get termsAndConditionsIntro =>
      'ಪೋಮೋಜೆನ್‌ಗೆ ಸ್ವಾಗತ. ಈ ನಿಯಮಗಳು ನಮ್ಮ ಮೈಂಡ್‌ಫುಲ್ ಉತ್ಪಾದಕತೆ ಅಪ್ಲಿಕೇಶನ್‌ನ ನಿಮ್ಮ ಬಳಕೆಯನ್ನು ನಿಯಂತ್ರಿಸುತ್ತವೆ. 🙏';

  @override
  String get openSourceTitle => 'ಓಪನ್ ಸೋರ್ಸ್';

  @override
  String get openSourceContent =>
      'ಪೋಮೋಜೆನ್ ಪಾರದರ್ಶಕತೆಯೊಂದಿಗೆ ನಿರ್ಮಿಸಲಾದ ಓಪನ್ ಸೋರ್ಸ್ ಅಪ್ಲಿಕೇಶನ್ ಆಗಿದೆ. ಇದರ ಕೋಡ್ ಪರಿಶೀಲನೆ, ಮಾರ್ಪಾಡು ಮತ್ತು ವಿತರಣೆಗೆ ಸಾರ್ವಜನಿಕವಾಗಿದೆ. ಉತ್ತಮ ಸಾಧನಗಳಿಗಾಗಿ ಸಮುದಾಯ ಮತ್ತು ಹಂಚಿಕೆಯ ಜ್ಞಾನದಲ್ಲಿ ನಾವು ನಂಬುತ್ತೇವೆ. 🌟';

  @override
  String get dataCollectionTitle => 'ಡೇಟಾ ಗೌಪ್ಯತೆ';

  @override
  String get dataCollectionContent =>
      'ನಿಮ್ಮ ಗೌಪ್ಯತೆ ಮುಖ್ಯ. ಪೋಮೋಜೆನ್ ಯಾವುದೇ ವೈಯಕ್ತಿಕ ಡೇಟಾ ಅಥವಾ ಬಳಕೆಯ ಅಂಕಿಅಂಶಗಳನ್ನು ಸಂಗ್ರಹಿಸುವುದಿಲ್ಲ. ಎಲ್ಲಾ ಡೇಟಾ ಮತ್ತು ಸೆಟ್ಟಿಂಗ್‌ಗಳು ನಿಮ್ಮ ಸಾಧನದಲ್ಲಿ ಸ್ಥಳೀಯವಾಗಿ ಸಂಗ್ರಹವಾಗುತ್ತವೆ, ಹೊರಗಡೆ ರವಾನೆಯಾಗುವುದಿಲ್ಲ. ನಿಮ್ಮ ಗಮನದ ಪ್ರಯಾಣ ಖಾಸಗಿಯಾಗಿ ಉಳಿಯುತ್ತದೆ. 🔒';

  @override
  String get disclaimerTitle => 'ಹಕ್ಕುತ್ಯಾಗ';

  @override
  String get disclaimerContent =>
      'ಪೋಮೋಜೆನ್ \'ಇರುವಂತೆ\' ಒದಗಿಸಲಾಗಿದೆ, ಯಾವುದೇ ವಾರಂಟಿಗಳಿಲ್ಲದೆ. ಇದರ ಬಳಕೆಯಿಂದ ಉಂಟಾಗುವ ಯಾವುದೇ ಹಾನಿಗಳಿಗೆ ನಾವು ಜವಾಬ್ದಾರರಾಗಿರುವುದಿಲ್ಲ. ನಾವು ನಿಖರತೆಗಾಗಿ ಶ್ರಮಿಸುತ್ತಿದ್ದರೂ, ಅಪ್ಲಿಕೇಶನ್ ದೋಷ-ಮುಕ್ತ ಅಥವಾ ನಿರಂತರವಾಗಿರುತ್ತದೆ ಎಂದು ಖಾತರಿಪಡಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ. ⚖️';

  @override
  String get thirdPartyLibrariesTitle => 'ಮೂರನೇ-ಪಕ್ಷದ ಲೈಬ್ರರಿಗಳು';

  @override
  String get thirdPartyLibrariesIntro =>
      'ಈ ಅಪ್ಲಿಕೇಶನ್ ಮೂರನೇ-ಪಕ್ಷದ ಲೈಬ್ರರಿಗಳನ್ನು ಬಳಸುತ್ತದೆ, ಪ್ರತಿಯೊಂದೂ ತನ್ನದೇ ಆದ ಪರವಾನಗಿಯಿಂದ ನಿಯಂತ್ರಿಸಲ್ಪಡುತ್ತದೆ. ಓಪನ್ ಸೋರ್ಸ್ ಸಮುದಾಯಕ್ಕೆ ನಾವು ಧನ್ಯವಾದಗಳು. 🛠️';

  @override
  String get termsAndConditionsEnd =>
      'ಪೋಮೋಜೆನ್ ಬಳಸುವುದರಿಂದ, ನೀವು ಈ ನಿಯಮಗಳಿಗೆ ಒಪ್ಪುತ್ತೀರಿ. ನೀವು ಒಪ್ಪದಿದ್ದರೆ, ದಯವಿಟ್ಟು ಅಪ್ಲಿಕೇಶನ್ ಬಳಸಬೇಡಿ. ಮೈಂಡ್‌ಫುಲ್ ಉತ್ಪಾದಕತೆಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿದ್ದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು! ✨';

  @override
  String get linksTitle => 'ಲಿಂಕ್‌ಗಳು';

  @override
  String get sourceCodeLink => 'ಮೂಲ ಕೋಡ್';

  @override
  String get sendFeedbackLink => 'ಪ್ರತಿಕ್ರಿಯೆ ಕಳುಹಿಸಿ';

  @override
  String get fdroidLink => 'ಎಫ್-ಡ್ರಾಯ್ಡ್ ಲಿಂಕ್';

  @override
  String get privacyPolicyLink => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get waterReminder => 'ಜಲಸಂಚಯ ಜ್ಞಾಪನೆ';

  @override
  String get interval => 'ನನಗೆ ಪ್ರತಿ ನೆನಪಿಸಿ';

  @override
  String get addCustom => 'ಕಸ್ಟಮ್';

  @override
  String get customIntervalTitle => 'ಕಸ್ಟಮ್ ರಿಮೈಂಡರ್';

  @override
  String get invalidInterval => '5 ರಿಂದ 480 ನಿಮಿಷಗಳ ನಡುವೆ ಸಮಯ ನಮೂದಿಸಿ';

  @override
  String waterReminderIntervalSet(Object minutes) {
    return 'ನಿಮಗೆ ಪ್ರತಿ $minutes ನಿಮಿಷಗಳಿಗೆ ನೆನಪಿಸಲಾಗುತ್ತದೆ';
  }

  @override
  String get waterReminderNotificationTitle => '💧 ನೀರು ಕುಡಿಯುವ ಸಮಯ';

  @override
  String get waterReminderNotificationBody =>
      'ಒಂದು ಸಣ್ಣ ಗುಟುಕು ನಿಮ್ಮನ್ನು ಉತ್ತಮವಾಗಿ ಇರಿಸುತ್ತದೆ';

  @override
  String get waterReminderAlarmTitle => '💙 ಜಲಸಂಚಯದಲ್ಲಿ ಇರಿ';

  @override
  String get waterReminderAlarmBody => 'ನಿಮ್ಮ ದೇಹ ನಿಮಗೆ ಧನ್ಯವಾದ ಹೇಳುತ್ತದೆ';

  @override
  String get wellness => 'ಕ್ಷೇಮ';

  @override
  String get customIntervalRemoved => 'ಕಸ್ಟಮ್ ಇಂಟರ್ವಲ್ ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get waterReminderEnabled => 'Water reminder enabled.';

  @override
  String get waterReminderCancelled => 'Water reminder cancelled.';
}
