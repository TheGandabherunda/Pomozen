import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
  ];

  /// No description provided for @pomodoroTimer.
  ///
  /// In en, this message translates to:
  /// **'Pomozen'**
  String get pomodoroTimer;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @focusDuration.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusDuration;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @sessionOfSessions.
  ///
  /// In en, this message translates to:
  /// **'Session {current} of {total}'**
  String sessionOfSessions(Object current, Object total);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// No description provided for @alarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm Sound'**
  String get alarm;

  /// No description provided for @autoPlay.
  ///
  /// In en, this message translates to:
  /// **'Auto-Continue'**
  String get autoPlay;

  /// No description provided for @torchAlerts.
  ///
  /// In en, this message translates to:
  /// **'Flash Alerts'**
  String get torchAlerts;

  /// No description provided for @persistentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Persistent Alerts'**
  String get persistentAlerts;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder set for {time}. 🔔'**
  String dailyReminderSet(Object time);

  /// No description provided for @dailyReminderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder cancelled. ⏸️'**
  String get dailyReminderCancelled;

  /// No description provided for @notificationsAndAlerts.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Alerts'**
  String get notificationsAndAlerts;

  /// No description provided for @focusSessionCompletedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Complete 🧘‍♀️'**
  String get focusSessionCompletedNotificationTitle;

  /// No description provided for @focusSessionCompletedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time to recharge. Up next: {nextMode}'**
  String focusSessionCompletedNotificationBody(Object nextMode);

  /// No description provided for @shortBreakCompletedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Short Break Complete 🌸'**
  String get shortBreakCompletedNotificationTitle;

  /// No description provided for @shortBreakCompletedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Mind refreshed. Up next: {nextMode}'**
  String shortBreakCompletedNotificationBody(Object nextMode);

  /// No description provided for @longBreakCompletedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Long Break Complete 🌺'**
  String get longBreakCompletedNotificationTitle;

  /// No description provided for @longBreakCompletedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Well done. Up next: {nextMode}'**
  String longBreakCompletedNotificationBody(Object nextMode);

  /// No description provided for @ongoingTimerNotification.
  ///
  /// In en, this message translates to:
  /// **'Pomozen Timer Running'**
  String get ongoingTimerNotification;

  /// No description provided for @alarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Pomozen Alert 🔔'**
  String get alarmTitle;

  /// No description provided for @alarmBody.
  ///
  /// In en, this message translates to:
  /// **'Session complete. Tap Stop to continue. 🌟'**
  String get alarmBody;

  /// No description provided for @dailyReminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to Focus. 🌅'**
  String get dailyReminderNotificationTitle;

  /// No description provided for @dailyReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Your daily practice awaits. Start your session. 🧘‍♂️'**
  String get dailyReminderNotificationBody;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionDenied;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications in Settings to receive reminders and stay focused. ✨'**
  String get reminderPermissionDenied;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to stay connected. 🔔'**
  String get notificationPermissionDenied;

  /// No description provided for @notificationPermissionDeniedAndGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. Enable in Settings to receive reminders. 🔔'**
  String get notificationPermissionDeniedAndGoToSettings;

  /// No description provided for @notificationPermissionRequiredForDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications in Settings to set a daily reminder. �'**
  String get notificationPermissionRequiredForDailyReminder;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Enable \'Files and Media\' permission in Settings to manage data. 🔒'**
  String get storagePermissionDenied;

  /// No description provided for @importPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'Grant \'Files and Media\' permission in Settings to import your data. 🔒'**
  String get importPermissionRationale;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failedToPickFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to select file.'**
  String get failedToPickFile;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get keepScreenOn;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @dndToggle.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get dndToggle;

  /// No description provided for @lockScreenDisplay.
  ///
  /// In en, this message translates to:
  /// **'Show on Lock Screen'**
  String get lockScreenDisplay;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @timerSize.
  ///
  /// In en, this message translates to:
  /// **'Timer Size'**
  String get timerSize;

  /// No description provided for @ringThickness.
  ///
  /// In en, this message translates to:
  /// **'Ring Thickness'**
  String get ringThickness;

  /// No description provided for @immersiveMode.
  ///
  /// In en, this message translates to:
  /// **'Immersive Mode'**
  String get immersiveMode;

  /// No description provided for @hideSeconds.
  ///
  /// In en, this message translates to:
  /// **'Hide Seconds'**
  String get hideSeconds;

  /// No description provided for @startOfDay.
  ///
  /// In en, this message translates to:
  /// **'Start of Day'**
  String get startOfDay;

  /// No description provided for @startOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Start of Week'**
  String get startOfWeek;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @appColors.
  ///
  /// In en, this message translates to:
  /// **'App Colors'**
  String get appColors;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Focus Color'**
  String get primaryColor;

  /// No description provided for @secondaryColor.
  ///
  /// In en, this message translates to:
  /// **'Short Break Color'**
  String get secondaryColor;

  /// No description provided for @tertiaryColor.
  ///
  /// In en, this message translates to:
  /// **'Long Break Color'**
  String get tertiaryColor;

  /// No description provided for @glyphProgress.
  ///
  /// In en, this message translates to:
  /// **'Glyph Progress'**
  String get glyphProgress;

  /// No description provided for @enableGlyphProgress.
  ///
  /// In en, this message translates to:
  /// **'Enable Glyph Progress'**
  String get enableGlyphProgress;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Label'**
  String get addLabel;

  /// No description provided for @addCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'New Label'**
  String get addCustomLabel;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Label'**
  String get editLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete Label'**
  String get deleteLabel;

  /// No description provided for @deleteLabelConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete \'{labelName}\'? This action cannot be undone. ⚠️'**
  String deleteLabelConfirmation(Object labelName);

  /// No description provided for @labelColor.
  ///
  /// In en, this message translates to:
  /// **'Label Color'**
  String get labelColor;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Label Name'**
  String get labelName;

  /// No description provided for @labelNameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Label name cannot be empty.'**
  String get labelNameCannotBeEmpty;

  /// No description provided for @labelAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Label name already exists.'**
  String get labelAlreadyExists;

  /// No description provided for @addNewLabel.
  ///
  /// In en, this message translates to:
  /// **'Add New Label'**
  String get addNewLabel;

  /// No description provided for @unlabeled.
  ///
  /// In en, this message translates to:
  /// **'Unlabeled'**
  String get unlabeled;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @teal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get teal;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @indigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get indigo;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @brown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get brown;

  /// No description provided for @cyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get cyan;

  /// No description provided for @amber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get amber;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistory;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @editSession.
  ///
  /// In en, this message translates to:
  /// **'Edit Session'**
  String get editSession;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @deleteSessionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this session? This action cannot be undone. 🗑️'**
  String get deleteSessionConfirmation;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @focusMinutes.
  ///
  /// In en, this message translates to:
  /// **'Focus Minutes'**
  String get focusMinutes;

  /// No description provided for @sessionNote.
  ///
  /// In en, this message translates to:
  /// **'Session Note'**
  String get sessionNote;

  /// No description provided for @sessionUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Session updated. Progress recorded. ✨'**
  String get sessionUpdatedSuccessfully;

  /// No description provided for @sessionDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Session deleted. 🗑️'**
  String get sessionDeletedSuccessfully;

  /// No description provided for @filterByLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by Label'**
  String get filterByLabel;

  /// No description provided for @allSessions.
  ///
  /// In en, this message translates to:
  /// **'All Sessions'**
  String get allSessions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewLess.
  ///
  /// In en, this message translates to:
  /// **'View Less'**
  String get viewLess;

  /// No description provided for @focusMinutesZeroNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Complete a focus session to mark as done.'**
  String get focusMinutesZeroNotCompleted;

  /// No description provided for @dateNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get dateNewestFirst;

  /// No description provided for @focusMoreToLess.
  ///
  /// In en, this message translates to:
  /// **'Focus: More to Less'**
  String get focusMoreToLess;

  /// No description provided for @focusLessToMore.
  ///
  /// In en, this message translates to:
  /// **'Focus: Less to More'**
  String get focusLessToMore;

  /// No description provided for @completedFirst.
  ///
  /// In en, this message translates to:
  /// **'Completed First'**
  String get completedFirst;

  /// No description provided for @notePresentFirst.
  ///
  /// In en, this message translates to:
  /// **'Notes First'**
  String get notePresentFirst;

  /// No description provided for @labelAscending.
  ///
  /// In en, this message translates to:
  /// **'Label A-Z'**
  String get labelAscending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @pomodoroData.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Data'**
  String get pomodoroData;

  /// No description provided for @dataExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully. Your focus journey is now backed up. 📊'**
  String get dataExportedSuccessfully;

  /// No description provided for @dataExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again. ❌'**
  String get dataExportFailed;

  /// No description provided for @exportCanceled.
  ///
  /// In en, this message translates to:
  /// **'Export canceled. ⏸️'**
  String get exportCanceled;

  /// No description provided for @importCanceled.
  ///
  /// In en, this message translates to:
  /// **'Import canceled. No changes made. ⏸️'**
  String get importCanceled;

  /// No description provided for @importDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Importing will overwrite existing data. Proceed? ⚠️'**
  String get importDataConfirmation;

  /// No description provided for @dataImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Data import failed. Check file and try again. ❌'**
  String get dataImportFailed;

  /// No description provided for @dataImportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions imported. Your focus history is now complete. 🎉'**
  String dataImportedSuccessfully(Object count);

  /// No description provided for @noValidFilesSelected.
  ///
  /// In en, this message translates to:
  /// **'No valid files selected.'**
  String get noValidFilesSelected;

  /// No description provided for @emptyCsvFile.
  ///
  /// In en, this message translates to:
  /// **'Empty CSV file.'**
  String get emptyCsvFile;

  /// No description provided for @emptyJsonFile.
  ///
  /// In en, this message translates to:
  /// **'Empty JSON file.'**
  String get emptyJsonFile;

  /// No description provided for @invalidCsvHeader.
  ///
  /// In en, this message translates to:
  /// **'Invalid CSV header. Check format. 📄'**
  String get invalidCsvHeader;

  /// No description provided for @invalidColumnCount.
  ///
  /// In en, this message translates to:
  /// **'Invalid column count in row.'**
  String get invalidColumnCount;

  /// No description provided for @invalidRowData.
  ///
  /// In en, this message translates to:
  /// **'Some rows have invalid data.'**
  String get invalidRowData;

  /// No description provided for @invalidDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid date format in CSV.'**
  String get invalidDateFormat;

  /// No description provided for @invalidFocusMinutes.
  ///
  /// In en, this message translates to:
  /// **'Invalid focus minutes in CSV.'**
  String get invalidFocusMinutes;

  /// No description provided for @invalidIsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Invalid \'Is Completed\' value in CSV.'**
  String get invalidIsCompleted;

  /// No description provided for @importErrors.
  ///
  /// In en, this message translates to:
  /// **'Import Errors'**
  String get importErrors;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @invalidSettingValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid setting value.'**
  String get invalidSettingValue;

  /// No description provided for @invalidLabelFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid label format in row.'**
  String get invalidLabelFormat;

  /// No description provided for @invalidLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid label value in row.'**
  String get invalidLabelValue;

  /// No description provided for @invalidSettingFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid setting format in row.'**
  String get invalidSettingFormat;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetAllData;

  /// No description provided for @resetSettingsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Reset all settings to default values? 🔄'**
  String get resetSettingsConfirmation;

  /// No description provided for @resetAllDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete all session history and labels? This action cannot be undone. 🗑️'**
  String get resetAllDataConfirmation;

  /// No description provided for @allDataResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'All data reset. Ready for a fresh start. 🌱'**
  String get allDataResetSuccessfully;

  /// No description provided for @settingsResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings restored to default. 🔄'**
  String get settingsResetSuccessfully;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @noLabelsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No labels created yet. 🏷️'**
  String get noLabelsAvailable;

  /// No description provided for @noSessionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded yet. 🧘‍♀️'**
  String get noSessionsAvailable;

  /// No description provided for @noLabelsYet.
  ///
  /// In en, this message translates to:
  /// **'No labels yet. Create one to organize your focus journey. ✨'**
  String get noLabelsYet;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'Your focus journey begins here. Start your first session and watch your productivity bloom. 🌸'**
  String get noSessionsYet;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummary;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @totalFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Total Focus Time'**
  String get totalFocusTime;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @labelBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Label Breakdown'**
  String get labelBreakdown;

  /// No description provided for @noLabeledSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No labeled sessions yet. 🏷️'**
  String get noLabeledSessionsYet;

  /// No description provided for @focusTime.
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get focusTime;

  /// No description provided for @dailyFocusTrends.
  ///
  /// In en, this message translates to:
  /// **'Daily Focus Trends'**
  String get dailyFocusTrends;

  /// No description provided for @dailySuccessRateTrends.
  ///
  /// In en, this message translates to:
  /// **'Daily Success Rate'**
  String get dailySuccessRateTrends;

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @dailyTrends.
  ///
  /// In en, this message translates to:
  /// **'Daily Trends'**
  String get dailyTrends;

  /// No description provided for @weeklyTrends.
  ///
  /// In en, this message translates to:
  /// **'Weekly Trends'**
  String get weeklyTrends;

  /// No description provided for @averageFocusTimePerSession.
  ///
  /// In en, this message translates to:
  /// **'Average Focus Time'**
  String get averageFocusTimePerSession;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @bestFocusDay.
  ///
  /// In en, this message translates to:
  /// **'Best Focus Day'**
  String get bestFocusDay;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data yet. Begin your mindful journey. 🌱'**
  String get notAvailable;

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'Goal Progress'**
  String get goalProgress;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get featureComingSoon;

  /// No description provided for @trendsAndProgress.
  ///
  /// In en, this message translates to:
  /// **'Trends & Progress'**
  String get trendsAndProgress;

  /// No description provided for @visualInsights.
  ///
  /// In en, this message translates to:
  /// **'Visual Insights'**
  String get visualInsights;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of'**
  String get weekOf;

  /// No description provided for @skippedSessions.
  ///
  /// In en, this message translates to:
  /// **'Skipped Sessions'**
  String get skippedSessions;

  /// No description provided for @mostFocusedTimeOfDay.
  ///
  /// In en, this message translates to:
  /// **'Most Focused Time'**
  String get mostFocusedTimeOfDay;

  /// No description provided for @calendarHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Calendar Heatmap'**
  String get calendarHeatmap;

  /// No description provided for @focusIntensity.
  ///
  /// In en, this message translates to:
  /// **'Focus Intensity'**
  String get focusIntensity;

  /// No description provided for @startSessionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Cultivate mindful focus. Each session brings you closer to your goals. 🧘‍♀️'**
  String get startSessionPrompt;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @monthNames.
  ///
  /// In en, this message translates to:
  /// **'Month Names'**
  String get monthNames;

  /// No description provided for @weekdaysShort.
  ///
  /// In en, this message translates to:
  /// **'Short Weekdays'**
  String get weekdaysShort;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @aboutAndLegal.
  ///
  /// In en, this message translates to:
  /// **'About & Legal'**
  String get aboutAndLegal;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Pomozen'**
  String get aboutApp;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A mindful Pomodoro timer app with Minimal Design, offline support, and customizable settings to enhance your focus. 🧘‍♀️'**
  String get appDescription;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get featuresTitle;

  /// No description provided for @featureStatistics.
  ///
  /// In en, this message translates to:
  /// **'• Comprehensive Statistics with detailed tracking of your progress. 📊'**
  String get featureStatistics;

  /// No description provided for @featureReminders.
  ///
  /// In en, this message translates to:
  /// **'• Customizable Reminders to guide you back to focus. ⏰'**
  String get featureReminders;

  /// No description provided for @featureGlyphProgress.
  ///
  /// In en, this message translates to:
  /// **'• Glyph Progress integration for Nothing Phone users. ✨'**
  String get featureGlyphProgress;

  /// No description provided for @featureHydrationReminder.
  ///
  /// In en, this message translates to:
  /// **'• Hydration Reminder to help you stay hydrated throughout the day. 💧'**
  String get featureHydrationReminder;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for choosing Pomozen to enhance your productivity and mindfulness. May your focus be deep, and your breaks peaceful. 💖'**
  String get thankYouMessage;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsAndConditions;

  /// No description provided for @termsAndConditionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pomozen. These terms govern your use of our mindful productivity app. 🙏'**
  String get termsAndConditionsIntro;

  /// No description provided for @openSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSourceTitle;

  /// No description provided for @openSourceContent.
  ///
  /// In en, this message translates to:
  /// **'Pomozen is open-source, built with transparency. Its code is public for inspection, modification, and distribution. We believe in community and shared knowledge for better tools. 🌟'**
  String get openSourceContent;

  /// No description provided for @dataCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Privacy'**
  String get dataCollectionTitle;

  /// No description provided for @dataCollectionContent.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is paramount. Pomozen collects no personal data or usage statistics. All data and settings are stored locally on your device, never transmitted externally. Your focus journey remains private. 🔒'**
  String get dataCollectionContent;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerContent.
  ///
  /// In en, this message translates to:
  /// **'Pomozen is provided \'as is,\' without warranties. We are not liable for any damages arising from its use. While we strive for accuracy, we cannot guarantee error-free or uninterrupted service. ⚖️'**
  String get disclaimerContent;

  /// No description provided for @thirdPartyLibrariesTitle.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Libraries'**
  String get thirdPartyLibrariesTitle;

  /// No description provided for @thirdPartyLibrariesIntro.
  ///
  /// In en, this message translates to:
  /// **'This app uses third-party libraries, each under its own license. We thank the open-source community. 🛠️'**
  String get thirdPartyLibrariesIntro;

  /// No description provided for @termsAndConditionsEnd.
  ///
  /// In en, this message translates to:
  /// **'By using Pomozen, you agree to these terms. If you disagree, please do not use the app. Thank you for choosing mindful productivity! ✨'**
  String get termsAndConditionsEnd;

  /// No description provided for @linksTitle.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get linksTitle;

  /// No description provided for @sourceCodeLink.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCodeLink;

  /// No description provided for @sendFeedbackLink.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedbackLink;

  /// No description provided for @fdroidLink.
  ///
  /// In en, this message translates to:
  /// **'Fdroid Link'**
  String get fdroidLink;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLink;

  /// No description provided for @waterReminder.
  ///
  /// In en, this message translates to:
  /// **'Hydration Reminder'**
  String get waterReminder;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Remind me every'**
  String get interval;

  /// No description provided for @addCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get addCustom;

  /// No description provided for @customIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Reminder'**
  String get customIntervalTitle;

  /// No description provided for @invalidInterval.
  ///
  /// In en, this message translates to:
  /// **'Enter a time between 5 and 480 minutes'**
  String get invalidInterval;

  /// No description provided for @waterReminderIntervalSet.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be reminded every {minutes} minutes'**
  String waterReminderIntervalSet(Object minutes);

  /// No description provided for @waterReminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'💧 Time for water'**
  String get waterReminderNotificationTitle;

  /// No description provided for @waterReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'A quick sip keeps you at your best'**
  String get waterReminderNotificationBody;

  /// No description provided for @waterReminderAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'💙 Stay hydrated'**
  String get waterReminderAlarmTitle;

  /// No description provided for @waterReminderAlarmBody.
  ///
  /// In en, this message translates to:
  /// **'Your body will thank you'**
  String get waterReminderAlarmBody;

  /// No description provided for @wellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get wellness;

  /// No description provided for @customIntervalRemoved.
  ///
  /// In en, this message translates to:
  /// **'Custom interval removed'**
  String get customIntervalRemoved;

  /// No description provided for @waterReminderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Water reminder enabled.'**
  String get waterReminderEnabled;

  /// No description provided for @waterReminderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Water reminder cancelled.'**
  String get waterReminderCancelled;

  /// No description provided for @pomodoroTimerInfo.
  ///
  /// In en, this message translates to:
  /// **'Configure the durations for your focus sessions, short breaks, and long breaks, as well as the number of sessions before a long break.'**
  String get pomodoroTimerInfo;

  /// No description provided for @notificationsAndAlertsInfo.
  ///
  /// In en, this message translates to:
  /// **'Manage how Pomozen notifies you about session changes and other reminders. You can enable or disable various alerts.'**
  String get notificationsAndAlertsInfo;

  /// No description provided for @generalInfo.
  ///
  /// In en, this message translates to:
  /// **'General application settings, including language preferences.'**
  String get generalInfo;

  /// No description provided for @wellnessInfo.
  ///
  /// In en, this message translates to:
  /// **'Settings related to your well-being, such as water reminders to help you stay hydrated.'**
  String get wellnessInfo;

  /// No description provided for @appColorsInfo.
  ///
  /// In en, this message translates to:
  /// **'Customize the look and feel of the app by selecting different color themes and primary, secondary, and tertiary colors.'**
  String get appColorsInfo;

  /// No description provided for @dataInfo.
  ///
  /// In en, this message translates to:
  /// **'Manage your Pomozen data. You can export your session history and settings for backup, or import data from a previous backup. You can also reset all data.'**
  String get dataInfo;

  /// No description provided for @focusDurationSlider.
  ///
  /// In en, this message translates to:
  /// **'Focus Duration'**
  String get focusDurationSlider;

  /// No description provided for @shortBreakSlider.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreakSlider;

  /// No description provided for @longBreakSlider.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreakSlider;

  /// No description provided for @sessionsSlider.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsSlider;

  /// No description provided for @aboutAndLegalInfo.
  ///
  /// In en, this message translates to:
  /// **'Information about the application, including version details, terms and conditions, and privacy policy.'**
  String get aboutAndLegalInfo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
