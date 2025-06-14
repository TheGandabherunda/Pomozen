// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get pomodoroTimer => 'पोमोज़ेन';

  @override
  String get home => 'होम';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get statistics => 'आँकड़े';

  @override
  String get about => 'के बारे में';

  @override
  String get focusDuration => 'फोकस';

  @override
  String get shortBreak => 'छोटा ब्रेक';

  @override
  String get longBreak => 'लंबा ब्रेक';

  @override
  String get sessions => 'सत्र';

  @override
  String sessionOfSessions(Object current, Object total) {
    return 'सत्र $current कुल $total में से';
  }

  @override
  String get start => 'शुरू करें';

  @override
  String get pause => 'रोकें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get reminders => 'अनुस्मारक';

  @override
  String get notification => 'सूचनाएं';

  @override
  String get alarm => 'अलार्म ध्वनि';

  @override
  String get autoPlay => 'स्वतः जारी रखें';

  @override
  String get torchAlerts => 'फ्लैश अलर्ट';

  @override
  String get persistentAlerts => 'लगातार अलर्ट';

  @override
  String get dailyReminder => 'दैनिक अनुस्मारक';

  @override
  String dailyReminderSet(Object time) {
    return 'दैनिक अनुस्मारक $time के लिए सेट किया गया। 🔔';
  }

  @override
  String get dailyReminderCancelled => 'दैनिक अनुस्मारक रद्द। ⏸️';

  @override
  String get notificationsAndAlerts => 'सूचनाएं और अलर्ट';

  @override
  String get focusSessionCompletedNotificationTitle => 'फोकस पूरा हुआ 🧘‍♀️';

  @override
  String focusSessionCompletedNotificationBody(Object nextMode) {
    return 'रिचार्ज करने का समय। अगला: $nextMode';
  }

  @override
  String get shortBreakCompletedNotificationTitle => 'छोटा ब्रेक पूरा हुआ 🌸';

  @override
  String shortBreakCompletedNotificationBody(Object nextMode) {
    return 'मन ताज़ा। अगला: $nextMode';
  }

  @override
  String get longBreakCompletedNotificationTitle => 'लंबा ब्रेक पूरा हुआ 🌺';

  @override
  String longBreakCompletedNotificationBody(Object nextMode) {
    return 'बहुत अच्छा। अगला: $nextMode';
  }

  @override
  String get ongoingTimerNotification => 'पोमोज़ेन टाइमर चल रहा है';

  @override
  String get alarmTitle => 'पोमोज़ेन अलर्ट 🔔';

  @override
  String get alarmBody =>
      'सत्र पूरा हुआ। जारी रखने के लिए रोकें पर टैप करें। 🌟';

  @override
  String get dailyReminderNotificationTitle => 'फोकस करने का समय। 🌅';

  @override
  String get dailyReminderNotificationBody =>
      'आपका दैनिक अभ्यास प्रतीक्षा कर रहा है। अपना सत्र शुरू करें। 🧘‍♂️';

  @override
  String get permissionRequired => 'अनुमति आवश्यक';

  @override
  String get permissionDenied => 'अनुमति अस्वीकृत';

  @override
  String get reminderPermissionDenied =>
      'रिमाइंडर प्राप्त करने और केंद्रित रहने के लिए सेटिंग्स में सूचनाएं सक्षम करें। ✨';

  @override
  String get notificationPermissionDenied =>
      'जुड़े रहने के लिए सूचनाएं सक्षम करें। 🔔';

  @override
  String get notificationPermissionDeniedAndGoToSettings =>
      'सूचना अनुमति अस्वीकार। रिमाइंडर प्राप्त करने के लिए सेटिंग्स में सक्षम करें। 🔔';

  @override
  String get notificationPermissionRequiredForDailyReminder =>
      'दैनिक रिमाइंडर सेट करने के लिए सेटिंग्स में सूचनाएं सक्षम करें। 🔔';

  @override
  String get storagePermissionDenied =>
      'डेटा प्रबंधित करने के लिए सेटिंग्स में \'फाइलें और मीडिया\' अनुमति सक्षम करें। 🔒';

  @override
  String get importPermissionRationale =>
      'अपना डेटा आयात करने के लिए सेटिंग्स में \'फाइलें और मीडिया\' अनुमति दें। 🔒';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get error => 'त्रुटि';

  @override
  String get failedToPickFile => 'फ़ाइल चुनने में विफल।';

  @override
  String get general => 'सामान्य';

  @override
  String get keepScreenOn => 'स्क्रीन चालू रखें';

  @override
  String get soundEffects => 'ध्वनि प्रभाव';

  @override
  String get vibration => 'कंपन';

  @override
  String get dndToggle => 'परेशान न करें';

  @override
  String get lockScreenDisplay => 'लॉक स्क्रीन पर दिखाएं';

  @override
  String get language => 'भाषा';

  @override
  String get timerSize => 'टाइमर का आकार';

  @override
  String get ringThickness => 'रिंग की मोटाई';

  @override
  String get immersiveMode => 'इमर्सिव मोड';

  @override
  String get hideSeconds => 'सेकंड छुपाएं';

  @override
  String get startOfDay => 'दिन की शुरुआत';

  @override
  String get startOfWeek => 'सप्ताह की शुरुआत';

  @override
  String get theme => 'थीम';

  @override
  String get light => 'हल्का';

  @override
  String get dark => 'गहरा';

  @override
  String get system => 'सिस्टम';

  @override
  String get systemTheme => 'सिस्टम थीम';

  @override
  String get lightTheme => 'लाइट थीम';

  @override
  String get darkTheme => 'डार्क थीम';

  @override
  String get appColors => 'ऐप रंग';

  @override
  String get primaryColor => 'फोकस रंग';

  @override
  String get secondaryColor => 'छोटा ब्रेक रंग';

  @override
  String get tertiaryColor => 'लंबा ब्रेक रंग';

  @override
  String get glyphProgress => 'ग्लिफ़ प्रगति';

  @override
  String get enableGlyphProgress => 'ग्लिफ़ प्रगति सक्षम करें';

  @override
  String get addLabel => 'लेबल जोड़ें';

  @override
  String get addCustomLabel => 'नया लेबल';

  @override
  String get editLabel => 'लेबल संपादित करें';

  @override
  String get deleteLabel => 'लेबल हटाएं';

  @override
  String deleteLabelConfirmation(Object labelName) {
    return 'लेबल \'$labelName\' हटाएं? यह अपरिवर्तनीय है। ⚠️';
  }

  @override
  String get labelColor => 'लेबल रंग';

  @override
  String get labelName => 'लेबल नाम';

  @override
  String get labelNameCannotBeEmpty => 'लेबल नाम खाली नहीं हो सकता।';

  @override
  String get labelAlreadyExists => 'यह लेबल नाम पहले से मौजूद है।';

  @override
  String get addNewLabel => 'नया लेबल जोड़ें';

  @override
  String get unlabeled => 'अनलेबल';

  @override
  String get orange => 'नारंगी';

  @override
  String get teal => 'टील';

  @override
  String get blue => 'नीला';

  @override
  String get red => 'लाल';

  @override
  String get green => 'हरा';

  @override
  String get purple => 'बैंगनी';

  @override
  String get indigo => 'इंडिगो';

  @override
  String get pink => 'गुलाबी';

  @override
  String get brown => 'भूरा';

  @override
  String get cyan => 'सियान';

  @override
  String get amber => 'एम्बर';

  @override
  String get sessionHistory => 'सत्र इतिहास';

  @override
  String get time => 'समय';

  @override
  String get label => 'लेबल';

  @override
  String get note => 'नोट';

  @override
  String get editSession => 'सत्र संपादित करें';

  @override
  String get deleteSession => 'सत्र हटाएं';

  @override
  String get deleteSessionConfirmation =>
      'यह सत्र हटाएं? यह अपरिवर्तनीय है। 🗑️';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get minutesShort => 'मिनट';

  @override
  String get minutes => 'मिनट';

  @override
  String get focusMinutes => 'फोकस मिनट';

  @override
  String get sessionNote => 'सत्र नोट';

  @override
  String get sessionUpdatedSuccessfully =>
      'सत्र अपडेट किया गया। प्रगति रिकॉर्ड की गई। ✨';

  @override
  String get sessionDeletedSuccessfully => 'सत्र हटाया गया। 🗑️';

  @override
  String get filterByLabel => 'लेबल द्वारा फ़िल्टर करें';

  @override
  String get allSessions => 'सभी सत्र';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get viewLess => 'कम देखें';

  @override
  String get focusMinutesZeroNotCompleted =>
      'पूरा करने के लिए एक फोकस सत्र पूरा करें।';

  @override
  String get dateNewestFirst => 'सबसे नया पहले';

  @override
  String get focusMoreToLess => 'फोकस: अधिक से कम';

  @override
  String get focusLessToMore => 'फोकस: कम से अधिक';

  @override
  String get completedFirst => 'पूरा हुआ पहले';

  @override
  String get notePresentFirst => 'नोट्स पहले';

  @override
  String get labelAscending => 'लेबल A-Z';

  @override
  String get completed => 'पूरा हुआ';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get data => 'डेटा';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get importData => 'डेटा आयात करें';

  @override
  String get pomodoroData => 'पोमोडोरो डेटा';

  @override
  String get dataExportedSuccessfully =>
      'डेटा सफलतापूर्वक निर्यात किया गया। आपकी फोकस यात्रा अब बैकअप हो गई है। 📊';

  @override
  String get dataExportFailed => 'निर्यात विफल रहा। कृपया पुनः प्रयास करें। ❌';

  @override
  String get exportCanceled => 'निर्यात रद्द। ⏸️';

  @override
  String get importCanceled => 'आयात रद्द। कोई बदलाव नहीं। ⏸️';

  @override
  String get importDataConfirmation =>
      'आयात करने से मौजूदा डेटा अधिलेखित होगा। आगे बढ़ें? ⚠️';

  @override
  String get dataImportFailed =>
      'डेटा आयात विफल रहा। फाइल जांचें और पुनः प्रयास करें। ❌';

  @override
  String dataImportedSuccessfully(Object count) {
    return '$count सत्र आयात किए गए। आपका फोकस इतिहास अब पूरा हो गया है। 🎉';
  }

  @override
  String get noValidFilesSelected => 'कोई वैध फाइलें नहीं चुनी गईं।';

  @override
  String get emptyCsvFile => 'CSV फ़ाइल खाली है।';

  @override
  String get emptyJsonFile => 'JSON फ़ाइल खाली है।';

  @override
  String get invalidCsvHeader => 'अमान्य CSV हेडर। प्रारूप जांचें। 📄';

  @override
  String get invalidColumnCount => 'पंक्ति में अमान्य कॉलम गणना।';

  @override
  String get invalidRowData => 'कुछ पंक्तियों में अमान्य डेटा है।';

  @override
  String get invalidDateFormat => 'CSV में अमान्य दिनांक प्रारूप।';

  @override
  String get invalidFocusMinutes => 'CSV में अमान्य फोकस मिनट।';

  @override
  String get invalidIsCompleted => 'CSV में \'पूरा हुआ\' मान अमान्य है।';

  @override
  String get importErrors => 'आयात त्रुटियाँ';

  @override
  String get ok => 'ठीक है';

  @override
  String get invalidSettingValue => 'अमान्य सेटिंग मान।';

  @override
  String get invalidLabelFormat => 'पंक्ति में अमान्य लेबल प्रारूप।';

  @override
  String get invalidLabelValue => 'पंक्ति में अमान्य लेबल मान।';

  @override
  String get invalidSettingFormat => 'पंक्ति में अमान्य सेटिंग प्रारूप।';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get resetSettings => 'सेटिंग्स रीसेट करें';

  @override
  String get resetAllData => 'सभी डेटा रीसेट करें';

  @override
  String get resetSettingsConfirmation =>
      'सभी सेटिंग्स डिफ़ॉल्ट पर रीसेट करें? 🔄';

  @override
  String get resetAllDataConfirmation =>
      'सभी सत्र इतिहास और लेबल हटाएं? यह अपरिवर्तनीय है। 🗑️';

  @override
  String get allDataResetSuccessfully =>
      'सभी डेटा रीसेट। एक नई शुरुआत के लिए तैयार। 🌱';

  @override
  String get settingsResetSuccessfully => 'सेटिंग्स डिफ़ॉल्ट पर बहाल। 🔄';

  @override
  String get noData => 'कोई डेटा नहीं';

  @override
  String get noLabelsAvailable => 'अभी कोई लेबल नहीं बना है। 🏷️';

  @override
  String get noSessionsAvailable => 'अभी कोई सत्र रिकॉर्ड नहीं हुआ है। 🧘‍♀️';

  @override
  String get noLabelsYet =>
      'अभी कोई लेबल नहीं। अपनी फोकस यात्रा को व्यवस्थित करने के लिए एक बनाएं। ✨';

  @override
  String get noSessionsYet =>
      'आपकी फोकस यात्रा यहीं से शुरू होती है। अपना पहला सत्र शुरू करें और अपनी उत्पादकता को फलते-फूलते देखें। 🌸';

  @override
  String get weeklySummary => 'साप्ताहिक सारांश';

  @override
  String get overview => 'अवलोकन';

  @override
  String get totalFocusTime => 'कुल फोकस समय';

  @override
  String get totalSessions => 'कुल सत्र';

  @override
  String get successRate => 'सफलता दर';

  @override
  String get labelBreakdown => 'लेबल ब्रेकडाउन';

  @override
  String get noLabeledSessionsYet => 'अभी तक कोई लेबल वाले सत्र नहीं हैं। 🏷️';

  @override
  String get focusTime => 'फोकस समय';

  @override
  String get dailyFocusTrends => 'दैनिक फोकस रुझान';

  @override
  String get dailySuccessRateTrends => 'दैनिक सफलता दर';

  @override
  String get trends => 'रुझान';

  @override
  String get totalTime => 'कुल समय';

  @override
  String get dailyTrends => 'दैनिक रुझान';

  @override
  String get weeklyTrends => 'साप्ताहिक रुझान';

  @override
  String get averageFocusTimePerSession => 'औसत फोकस समय';

  @override
  String get currentStreak => 'वर्तमान स्ट्रीक';

  @override
  String get days => 'दिन';

  @override
  String get bestFocusDay => 'सर्वश्रेष्ठ फोकस दिवस';

  @override
  String get notAvailable =>
      'अभी कोई डेटा नहीं। अपनी माइंडफुल यात्रा शुरू करें। 🌱';

  @override
  String get goalProgress => 'लक्ष्य प्रगति';

  @override
  String get featureComingSoon => 'जल्द आ रहा है';

  @override
  String get trendsAndProgress => 'रुझान और प्रगति';

  @override
  String get visualInsights => 'दृश्य अंतर्दृष्टि';

  @override
  String get weekOf => 'सप्ताह का';

  @override
  String get skippedSessions => 'छोड़े गए सत्र';

  @override
  String get mostFocusedTimeOfDay => 'सबसे केंद्रित समय';

  @override
  String get calendarHeatmap => 'कैलेंडर हीटमैप';

  @override
  String get focusIntensity => 'फोकस तीव्रता';

  @override
  String get startSessionPrompt =>
      'माइंडफुल फोकस विकसित करें। प्रत्येक सत्र आपको अपने लक्ष्यों के करीब लाता है। 🧘‍♀️';

  @override
  String get startNow => 'अभी शुरू करें';

  @override
  String get date => 'दिनांक';

  @override
  String get monthNames => 'महीने के नाम';

  @override
  String get weekdaysShort => 'छोटे सप्ताह के दिन';

  @override
  String get mondayShort => 'सोम';

  @override
  String get tuesdayShort => 'मंगल';

  @override
  String get wednesdayShort => 'बुध';

  @override
  String get thursdayShort => 'गुरु';

  @override
  String get fridayShort => 'शुक्र';

  @override
  String get saturdayShort => 'शनि';

  @override
  String get sundayShort => 'रवि';

  @override
  String get add => 'जोड़ें';

  @override
  String get done => 'हो गया';

  @override
  String get edit => 'संपादित करें';

  @override
  String get focus => 'फोकस';

  @override
  String get delete => 'हटाएं';

  @override
  String get reminder => 'अनुस्मारक';

  @override
  String get aboutAndLegal => 'के बारे में और कानूनी';

  @override
  String get aboutApp => 'पोमोज़ेन के बारे में';

  @override
  String get appDescription =>
      'मिनिमल डिज़ाइन, ऑफ़लाइन समर्थन, और आपके फोकस को बढ़ाने के लिए अनुकूलन योग्य सेटिंग्स के साथ एक माइंडफुल पोमोडोरो टाइमर ऐप। 🧘‍♀️';

  @override
  String get featuresTitle => 'मुख्य विशेषताएं';

  @override
  String get featureStatistics =>
      '• आपकी प्रगति की विस्तृत ट्रैकिंग के साथ व्यापक आँकड़े। 📊';

  @override
  String get featureReminders =>
      '• फोकस पर वापस मार्गदर्शन के लिए अनुकूलन योग्य अनुस्मारक। ⏰';

  @override
  String get featureGlyphProgress =>
      '• नथिंग फोन उपयोगकर्ताओं के लिए ग्लिफ़ प्रगति एकीकरण। ✨';

  @override
  String get featureHydrationReminder =>
      '• पूरे दिन हाइड्रेटेड रहने में आपकी मदद करने के लिए हाइड्रेशन रिमाइंडर। 💧';

  @override
  String get thankYouMessage =>
      'अपनी उत्पादकता और माइंडफुलनेस बढ़ाने के लिए पोमोज़ेन चुनने के लिए धन्यवाद। आपका फोकस गहरा और ब्रेक शांतिपूर्ण हों।💖';

  @override
  String get appVersion => 'संस्करण';

  @override
  String get version => 'संस्करण';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get termsAndConditions => 'सेवा की शर्तें';

  @override
  String get termsAndConditionsIntro =>
      'पोमोज़ेन में आपका स्वागत है। ये शर्तें हमारे माइंडफुल उत्पादकता ऐप के आपके उपयोग को नियंत्रित करती हैं। 🙏';

  @override
  String get openSourceTitle => 'ओपन सोर्स';

  @override
  String get openSourceContent =>
      'पोमोज़ेन पारदर्शिता के साथ बनाया गया एक ओपन-सोर्स ऐप है। इसका कोड निरीक्षण, संशोधन और वितरण के लिए सार्वजनिक है। हम बेहतर टूल के लिए समुदाय और साझा ज्ञान में विश्वास करते हैं। 🌟';

  @override
  String get dataCollectionTitle => 'डेटा गोपनीयता';

  @override
  String get dataCollectionContent =>
      'आपकी गोपनीयता सर्वोपरि है। पोमोज़ेन कोई व्यक्तिगत डेटा या उपयोग के आँकड़े एकत्र नहीं करता है। सभी डेटा और सेटिंग्स आपके डिवाइस पर स्थानीय रूप से संग्रहीत होते हैं, कभी बाहरी रूप से प्रसारित नहीं होते। आपकी फोकस यात्रा निजी रहती है। 🔒';

  @override
  String get disclaimerTitle => 'अस्वीकरण';

  @override
  String get disclaimerContent =>
      'पोमोज़ेन \'जैसा है\' प्रदान किया जाता है, बिना वारंटी के। इसके उपयोग से होने वाले किसी भी नुकसान के लिए हम उत्तरदायी नहीं हैं। हालांकि हम सटीकता का प्रयास करते हैं, ऐप त्रुटि-मुक्त या निर्बाध होगा इसकी गारंटी नहीं। ⚖️';

  @override
  String get thirdPartyLibrariesTitle => 'तीसरे पक्ष की लाइब्रेरीज़';

  @override
  String get thirdPartyLibrariesIntro =>
      'यह ऐप तीसरे पक्ष की लाइब्रेरीज़ का उपयोग करता है, प्रत्येक अपने लाइसेंस के तहत। हम ओपन-सोर्स समुदाय को धन्यवाद देते हैं। 🛠️';

  @override
  String get termsAndConditionsEnd =>
      'पोमोज़ेन का उपयोग करके, आप इन शर्तों से सहमत होते हैं। यदि आप असहमत हैं, तो कृपया ऐप का उपयोग न करें। माइंडफुल उत्पादकता चुनने के लिए धन्यवाद! ✨';

  @override
  String get linksTitle => 'लिंक';

  @override
  String get sourceCodeLink => 'स्रोत कोड';

  @override
  String get sendFeedbackLink => 'प्रतिक्रिया भेजें';

  @override
  String get fdroidLink => 'एफ-ड्रॉइड लिंक';

  @override
  String get privacyPolicyLink => 'गोपनीयता नीति';

  @override
  String get waterReminder => 'हाइड्रेशन रिमाइंडर';

  @override
  String get interval => 'मुझे हर याद दिलाएं';

  @override
  String get addCustom => 'कस्टम';

  @override
  String get customIntervalTitle => 'कस्टम रिमाइंडर';

  @override
  String get invalidInterval => '5 से 480 मिनट के बीच समय दर्ज करें';

  @override
  String waterReminderIntervalSet(Object minutes) {
    return 'आपको हर $minutes मिनट में याद दिलाया जाएगा';
  }

  @override
  String get waterReminderNotificationTitle => '💧 पानी पीने का समय';

  @override
  String get waterReminderNotificationBody =>
      'एक छोटा सा घूंट आपको बेहतर रखता है';

  @override
  String get waterReminderAlarmTitle => '💙 हाइड्रेटेड रहें';

  @override
  String get waterReminderAlarmBody => 'आपका शरीर आपका धन्यवाद करेगा';

  @override
  String get wellness => 'कल्याण';

  @override
  String get customIntervalRemoved => 'कस्टम इंटरवल हटा दिया गया';

  @override
  String get waterReminderEnabled => 'Water reminder enabled.';

  @override
  String get waterReminderCancelled => 'Water reminder cancelled.';
}
