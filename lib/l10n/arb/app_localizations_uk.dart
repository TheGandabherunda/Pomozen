// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get pomodoroTimer => 'Pomozen';

  @override
  String get home => 'Головна';

  @override
  String get settings => 'Налаштування';

  @override
  String get statistics => 'Статистика';

  @override
  String get about => 'Про застосунок';

  @override
  String get focusDuration => 'Фокус';

  @override
  String get shortBreak => 'Коротка перерва';

  @override
  String get longBreak => 'Довга перерва';

  @override
  String get sessions => 'Сесії';

  @override
  String sessionOfSessions(Object current, Object total) {
    return 'Сесія $current з $total';
  }

  @override
  String get start => 'Почати';

  @override
  String get pause => 'Пауза';

  @override
  String get skip => 'Пропустити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get reminders => 'Нагадування';

  @override
  String get notification => 'Сповіщення';

  @override
  String get alarm => 'Звук будильника';

  @override
  String get autoPlay => 'Автоматичне продовження';

  @override
  String get torchAlerts => 'Спалахи ліхтарика';

  @override
  String get persistentAlerts => 'Постійні сповіщення';

  @override
  String get dailyReminder => 'Щоденне нагадування';

  @override
  String dailyReminderSet(Object time) {
    return 'Щоденне нагадування встановлено на $time. 🔔';
  }

  @override
  String get dailyReminderCancelled => 'Щоденне нагадування скасовано. ⏸️';

  @override
  String get notificationsAndAlerts => 'Сповіщення та алерти';

  @override
  String get focusSessionCompletedNotificationTitle => 'Фокус завершено 🧘‍♀️';

  @override
  String focusSessionCompletedNotificationBody(Object nextMode) {
    return 'Час відновити сили. Далі: $nextMode';
  }

  @override
  String get shortBreakCompletedNotificationTitle =>
      'Коротка перерва завершена 🌸';

  @override
  String shortBreakCompletedNotificationBody(Object nextMode) {
    return 'Розум освіжено. Далі: $nextMode';
  }

  @override
  String get longBreakCompletedNotificationTitle =>
      'Довга перерва завершена 🌺';

  @override
  String longBreakCompletedNotificationBody(Object nextMode) {
    return 'Чудова робота. Далі: $nextMode';
  }

  @override
  String get ongoingTimerNotification => 'Таймер Pomozen працює';

  @override
  String get alarmTitle => 'Таймер Pomozen 🔔';

  @override
  String get alarmBody => 'Сесію завершено. Натисніть Стоп, щоб продовжити. 🌟';

  @override
  String get dailyReminderNotificationTitle => 'Час для фокусу. 🌅';

  @override
  String get dailyReminderNotificationBody =>
      'Ваша щоденна практика чекає. Почніть сесію. 🧘‍♂️';

  @override
  String get permissionRequired => 'Потрібен дозвіл';

  @override
  String get permissionDenied => 'Дозвіл відхилено';

  @override
  String get reminderPermissionDenied =>
      'Увімкніть сповіщення в Налаштуваннях, щоб отримувати нагадування та залишатися зосередженими. ✨';

  @override
  String get notificationPermissionDenied =>
      'Увімкніть сповіщення, щоб залишатися на зв’язку. 🔔';

  @override
  String get notificationPermissionDeniedAndGoToSettings =>
      'Дозвіл на сповіщення відхилено. Увімкніть у Налаштуваннях, щоб отримувати нагадування. 🔔';

  @override
  String get notificationPermissionRequiredForDailyReminder =>
      'Увімкніть сповіщення в Налаштуваннях, щоб встановити щоденне нагадування.';

  @override
  String get storagePermissionDenied =>
      'Надайте дозвіл \'Файли та медіа\' в Налаштуваннях для керування даними. 🔒';

  @override
  String get importPermissionRationale =>
      'Надайте дозвіл \'Файли та медіа\' в Налаштуваннях для імпорту даних. 🔒';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get error => 'Помилка';

  @override
  String get failedToPickFile => 'Не вдалося вибрати файл.';

  @override
  String get general => 'Загальне';

  @override
  String get keepScreenOn => 'Тримати екран увімкненим';

  @override
  String get soundEffects => 'Звукові ефекти';

  @override
  String get vibration => 'Вібрація';

  @override
  String get dndToggle => 'Не турбувати';

  @override
  String get lockScreenDisplay => 'Показувати на екрані блокування';

  @override
  String get language => 'Мова';

  @override
  String get timerSize => 'Розмір таймера';

  @override
  String get ringThickness => 'Товщина кільця';

  @override
  String get immersiveMode => 'Повноекранний режим';

  @override
  String get hideSeconds => 'Приховати секунди';

  @override
  String get startOfDay => 'Початок дня';

  @override
  String get startOfWeek => 'Початок тижня';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Світла';

  @override
  String get dark => 'Темна';

  @override
  String get system => 'Системна';

  @override
  String get systemTheme => 'Системна тема';

  @override
  String get lightTheme => 'Світла тема';

  @override
  String get darkTheme => 'Темна тема';

  @override
  String get appColors => 'Кольори застосунку';

  @override
  String get primaryColor => 'Колір фокусу';

  @override
  String get secondaryColor => 'Колір короткої перерви';

  @override
  String get tertiaryColor => 'Колір довгої перерви';

  @override
  String get glyphProgress => 'Glyph-прогрес';

  @override
  String get enableGlyphProgress => 'Увімкнути Glyph-прогрес';

  @override
  String get addLabel => 'Додати мітку';

  @override
  String get addCustomLabel => 'Нова мітка';

  @override
  String get editLabel => 'Редагувати мітку';

  @override
  String get deleteLabel => 'Видалити мітку';

  @override
  String deleteLabelConfirmation(Object labelName) {
    return 'Видалити \'$labelName\'? Цю дію неможливо скасувати. ⚠️';
  }

  @override
  String get labelColor => 'Колір мітки';

  @override
  String get labelName => 'Назва мітки';

  @override
  String get labelNameCannotBeEmpty => 'Назва мітки не може бути порожньою.';

  @override
  String get labelAlreadyExists => 'Така назва мітки вже існує.';

  @override
  String get addNewLabel => 'Додати нову мітку';

  @override
  String get unlabeled => 'Без мітки';

  @override
  String get orange => 'Помаранчевий';

  @override
  String get teal => 'Бірюзовий';

  @override
  String get blue => 'Синій';

  @override
  String get red => 'Червоний';

  @override
  String get green => 'Зелений';

  @override
  String get purple => 'Фіолетовий';

  @override
  String get indigo => 'Індиго';

  @override
  String get pink => 'Рожевий';

  @override
  String get brown => 'Коричневий';

  @override
  String get cyan => 'Блакитний';

  @override
  String get amber => 'Бурштиновий';

  @override
  String get sessionHistory => 'Історія сесій';

  @override
  String get time => 'Час';

  @override
  String get label => 'Мітка';

  @override
  String get note => 'Примітка';

  @override
  String get editSession => 'Редагувати сесію';

  @override
  String get deleteSession => 'Видалити сесію';

  @override
  String get deleteSessionConfirmation =>
      'Видалити цю сесію? Цю дію неможливо скасувати. 🗑️';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Вчора';

  @override
  String get minutesShort => 'хв';

  @override
  String get minutes => 'хвилин';

  @override
  String get focusMinutes => 'Хвилини фокусу';

  @override
  String get sessionNote => 'Примітка до сесії';

  @override
  String get sessionUpdatedSuccessfully =>
      'Сесію оновлено. Прогрес записано. ✨';

  @override
  String get sessionDeletedSuccessfully => 'Сесію видалено. 🗑️';

  @override
  String get filterByLabel => 'Фільтрувати за міткою';

  @override
  String get allSessions => 'Усі сесії';

  @override
  String get viewAll => 'Показати все';

  @override
  String get viewLess => 'Показати менше';

  @override
  String get focusMinutesZeroNotCompleted =>
      'Завершіть сесію фокусу, щоб позначити як виконану.';

  @override
  String get dateNewestFirst => 'Спочатку нові';

  @override
  String get focusMoreToLess => 'Фокус: за спаданням';

  @override
  String get focusLessToMore => 'Фокус: за зростанням';

  @override
  String get completedFirst => 'Спочатку завершені';

  @override
  String get notePresentFirst => 'Спочатку з примітками';

  @override
  String get labelAscending => 'Мітки А-Я';

  @override
  String get completed => 'Завершено';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get data => 'Дані';

  @override
  String get exportData => 'Експортувати дані';

  @override
  String get importData => 'Імпортувати дані';

  @override
  String get pomodoroData => 'Дані Pomodoro';

  @override
  String get dataExportedSuccessfully =>
      'Дані успішно експортовано. Вашу подорож фокусу збережено. 📊';

  @override
  String get dataExportFailed => 'Експорт не вдався. Спробуйте ще раз. ❌';

  @override
  String get exportCanceled => 'Експорт скасовано. ⏸️';

  @override
  String get importCanceled => 'Імпорт скасовано. Зміни не внесено. ⏸️';

  @override
  String get importDataConfirmation =>
      'Імпорт перезапише наявні дані. Продовжити? ⚠️';

  @override
  String get dataImportFailed =>
      'Імпорт даних не вдався. Перевірте файл і спробуйте ще раз. ❌';

  @override
  String dataImportedSuccessfully(Object count) {
    return 'Імпортовано $count сесій. Вашу історію фокусу відновлено. 🎉';
  }

  @override
  String get noValidFilesSelected => 'Не вибрано жодного дійсного файлу.';

  @override
  String get emptyCsvFile => 'Порожній CSV файл.';

  @override
  String get emptyJsonFile => 'Порожній JSON файл.';

  @override
  String get invalidCsvHeader =>
      'Недійсний заголовок CSV. Перевірте формат. 📄';

  @override
  String get invalidColumnCount => 'Недійсна кількість стовпців у рядку.';

  @override
  String get invalidRowData => 'Деякі рядки містять недійсні дані.';

  @override
  String get invalidDateFormat => 'Недійсний формат дати в CSV.';

  @override
  String get invalidFocusMinutes => 'Недійсні хвилини фокусу в CSV.';

  @override
  String get invalidIsCompleted => 'Недійсне значення \'Завершено\' в CSV.';

  @override
  String get importErrors => 'Помилки імпорту';

  @override
  String get ok => 'Гаразд';

  @override
  String get invalidSettingValue => 'Недійсне значення налаштування.';

  @override
  String get invalidLabelFormat => 'Недійсний формат мітки в рядку.';

  @override
  String get invalidLabelValue => 'Недійсне значення мітки в рядку.';

  @override
  String get invalidSettingFormat => 'Недійсний формат налаштування в рядку.';

  @override
  String get reset => 'Скинути';

  @override
  String get resetSettings => 'Скинути налаштування';

  @override
  String get resetAllData => 'Скинути всі дані';

  @override
  String get resetSettingsConfirmation =>
      'Скинути всі налаштування до значень за замовчуванням? 🔄';

  @override
  String get resetAllDataConfirmation =>
      'Видалити всю історію сесій та мітки? Цю дію неможливо скасувати. 🗑️';

  @override
  String get allDataResetSuccessfully =>
      'Усі дані скинуто. Готові до нового початку. 🌱';

  @override
  String get settingsResetSuccessfully =>
      'Налаштування відновлено до стандартних. 🔄';

  @override
  String get noData => 'Немає даних';

  @override
  String get noLabelsAvailable => 'Ще не створено жодної мітки. 🏷️';

  @override
  String get noSessionsAvailable => 'Ще не записано жодної сесії. 🧘‍♀️';

  @override
  String get noLabelsYet =>
      'Міток ще немає. Створіть мітку, щоб організувати свою подорож фокусу. ✨';

  @override
  String get noSessionsYet =>
      'Ваша подорож фокусу починається тут. Почніть першу сесію і спостерігайте, як розквітає ваша продуктивність. 🌸';

  @override
  String get weeklySummary => 'Тижневий підсумок';

  @override
  String get overview => 'Огляд';

  @override
  String get totalFocusTime => 'Загальний час фокусу';

  @override
  String get totalSessions => 'Всього сесій';

  @override
  String get successRate => 'Відсоток успіху';

  @override
  String get labelBreakdown => 'Розподіл за мітками';

  @override
  String get noLabeledSessionsYet => 'Сесій з мітками ще немає. 🏷️';

  @override
  String get focusTime => 'Час фокусу';

  @override
  String get dailyFocusTrends => 'Щоденні тренди фокусу';

  @override
  String get dailySuccessRateTrends => 'Щоденний відсоток успіху';

  @override
  String get trends => 'Тренди';

  @override
  String get totalTime => 'Загальний час';

  @override
  String get dailyTrends => 'Щоденні тренди';

  @override
  String get weeklyTrends => 'Тижневі тренди';

  @override
  String get averageFocusTimePerSession => 'Середній час фокусу';

  @override
  String get currentStreak => 'Поточна серія';

  @override
  String get days => 'днів';

  @override
  String get bestFocusDay => 'Найкращий день фокусу';

  @override
  String get notAvailable =>
      'Даних ще немає. Почніть свою усвідомлену подорож. 🌱';

  @override
  String get goalProgress => 'Прогрес до мети';

  @override
  String get featureComingSoon => 'Незабаром';

  @override
  String get trendsAndProgress => 'Тренди та прогрес';

  @override
  String get visualInsights => 'Візуальна аналітика';

  @override
  String get weekOf => 'Тиждень';

  @override
  String get skippedSessions => 'Пропущені сесії';

  @override
  String get mostFocusedTimeOfDay => 'Найбільш продуктивний час';

  @override
  String get calendarHeatmap => 'Календарна теплокарта';

  @override
  String get focusIntensity => 'Інтенсивність фокусу';

  @override
  String get startSessionPrompt =>
      'Плекайте усвідомлену концентрацію. Кожна сесія наближає вас до ваших цілей. 🧘‍♀️';

  @override
  String get startNow => 'Почати зараз';

  @override
  String get date => 'Дата';

  @override
  String get monthNames => 'Назви місяців';

  @override
  String get weekdaysShort => 'Короткі дні тижня';

  @override
  String get mondayShort => 'Пн';

  @override
  String get tuesdayShort => 'Вт';

  @override
  String get wednesdayShort => 'Ср';

  @override
  String get thursdayShort => 'Чт';

  @override
  String get fridayShort => 'Пт';

  @override
  String get saturdayShort => 'Сб';

  @override
  String get sundayShort => 'Нд';

  @override
  String get add => 'Додати';

  @override
  String get done => 'Готово';

  @override
  String get edit => 'Редагувати';

  @override
  String get focus => 'Фокус';

  @override
  String get delete => 'Видалити';

  @override
  String get reminder => 'Нагадування';

  @override
  String get aboutAndLegal => 'Про застосунок та правова інформація';

  @override
  String get aboutApp => 'Про Pomozen';

  @override
  String get appDescription =>
      'Усвідомлений застосунок-таймер Pomodoro з мінімалістичним дизайном, роботою офлайн та налаштуваннями для покращення вашого фокусу. 🧘‍♀️';

  @override
  String get featuresTitle => 'Ключові функції';

  @override
  String get featureStatistics =>
      '• Комплексна статистика з детальним відстеженням вашого прогресу. 📊';

  @override
  String get featureReminders =>
      '• Налаштовувані нагадування, які повертають вас до фокусу. ⏰';

  @override
  String get featureGlyphProgress =>
      '• Інтеграція Glyph Progress для користувачів Nothing Phone. ✨';

  @override
  String get featureHydrationReminder =>
      '• Нагадування про гідратацію, щоб залишатися у формі протягом дня. 💧';

  @override
  String get thankYouMessage =>
      'Дякуємо, що обрали Pomozen для підвищення продуктивності та усвідомленості. Нехай ваш фокус буде глибоким, а перерви — спокійними. 💖';

  @override
  String get appVersion => 'Версія';

  @override
  String get version => 'Версія';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get termsOfService => 'Умови використання';

  @override
  String get termsAndConditions => 'Умови використання';

  @override
  String get termsAndConditionsIntro =>
      'Ласкаво просимо до Pomozen. Ці умови регулюють використання нашого застосунку усвідомленої продуктивності. 🙏';

  @override
  String get openSourceTitle => 'Відкритий код';

  @override
  String get openSourceContent =>
      'Pomozen — застосунок з відкритим кодом, створений з прозорістю. Його код є публічним для перегляду, модифікації та розповсюдження. Ми віримо в спільноту та спільні знання для кращих інструментів. 🌟';

  @override
  String get dataCollectionTitle => 'Конфіденційність даних';

  @override
  String get dataCollectionContent =>
      'Ваша конфіденційність — наш пріоритет. Pomozen не збирає персональні дані чи статистику використання. Усі дані та налаштування зберігаються локально на вашому пристрої, ніколи не передаються назовні. Ваша подорож фокусу залишається приватною. 🔒';

  @override
  String get disclaimerTitle => 'Відмова від відповідальності';

  @override
  String get disclaimerContent =>
      'Pomozen надається \'як є\', без гарантій. Ми не несемо відповідальності за будь-які збитки, спричинені його використанням. Хоча ми прагнемо до точності, не можемо гарантувати безпомилкову або безперервну роботу. ⚖️';

  @override
  String get thirdPartyLibrariesTitle => 'Бібліотеки третіх сторін';

  @override
  String get thirdPartyLibrariesIntro =>
      'Цей застосунок використовує бібліотеки третіх сторін, кожна під власною ліцензією. Дякуємо спільноті відкритого коду. 🛠️';

  @override
  String get termsAndConditionsEnd =>
      'Використовуючи Pomozen, ви погоджуєтесь з цими умовами. Якщо ви не згодні, будь ласка, не користуйтесь застосунком. Дякуємо, що обрали усвідомлену продуктивність! ✨';

  @override
  String get linksTitle => 'Посилання';

  @override
  String get sourceCodeLink => 'Вихідний код';

  @override
  String get sendFeedbackLink => 'Надіслати відгук';

  @override
  String get fdroidLink => 'Посилання на F-Droid';

  @override
  String get privacyPolicyLink => 'Політика конфіденційності';

  @override
  String get waterReminder => 'Нагадування про гідратацію';

  @override
  String get interval => 'Нагадувати кожні';

  @override
  String get addCustom => 'Інше';

  @override
  String get customIntervalTitle => 'Власний інтервал';

  @override
  String get invalidInterval => 'Введіть час між 5 та 480 хвилинами';

  @override
  String waterReminderIntervalSet(Object minutes) {
    return 'Нагадування кожні $minutes хвилин';
  }

  @override
  String get waterReminderNotificationTitle => '💧 Час випити води';

  @override
  String get waterReminderNotificationBody =>
      'Маленький ковток допомагає залишатися у формі';

  @override
  String get waterReminderAlarmTitle => '💙 Залишайтеся гідратованими';

  @override
  String get waterReminderAlarmBody => 'Ваше тіло скаже вам дякую';

  @override
  String get wellness => 'Здоров’я';

  @override
  String get customIntervalRemoved => 'Власний інтервал видалено';

  @override
  String get waterReminderEnabled => 'Нагадування про воду увімкнено.';

  @override
  String get waterReminderCancelled => 'Нагадування про воду скасовано.';

  @override
  String get pomodoroTimerInfo =>
      'Налаштуйте тривалість сесій фокусу, коротких та довгих перерв, а також кількість сесій до довгої перерви.';

  @override
  String get notificationsAndAlertsInfo =>
      'Керуйте тим, як Pomozen сповіщає вас про зміни сесій та інші нагадування. Ви можете вмикати або вимикати різні алерти.';

  @override
  String get generalInfo =>
      'Загальні налаштування застосунку, включаючи мовні налаштування.';

  @override
  String get wellnessInfo =>
      'Налаштування, пов’язані з вашим самопочуттям, такі як нагадування про воду для підтримки гідратації.';

  @override
  String get appColorsInfo =>
      'Налаштуйте вигляд застосунку, вибравши різні кольорові теми та основний, другорядний і третинний кольори.';

  @override
  String get dataInfo =>
      'Керуйте даними Pomozen. Ви можете експортувати історію сесій та налаштування для резервного копіювання або імпортувати дані з попередньої резервної копії. Ви також можете скинути всі дані.';

  @override
  String get focusDurationSlider => 'Тривалість фокусу';

  @override
  String get shortBreakSlider => 'Коротка перерва';

  @override
  String get longBreakSlider => 'Довга перерва';

  @override
  String get sessionsSlider => 'Сесії';

  @override
  String get update => 'Оновити';

  @override
  String get aboutAndLegalInfo =>
      'Інформація про застосунок, включаючи деталі версії, умови використання та політику конфіденційності.';

  @override
  String get timerPreset => 'Пресет таймера';

  @override
  String get timerPresetInfo =>
      'Збережіть та швидко завантажуйте улюблені конфігурації таймера.';

  @override
  String get addPreset => 'Додати пресет';

  @override
  String get editPreset => 'Редагувати пресет';

  @override
  String get presetName => 'Назва пресету';

  @override
  String get presetNameCannotBeEmpty => 'Назва пресету не може бути порожньою.';

  @override
  String get presetUpdated => 'Пресет оновлено.';

  @override
  String get presetSaved => 'Пресет збережено.';

  @override
  String get deletePresetTitle => 'Видалити пресет?';

  @override
  String deletePresetConfirmation(Object presetName) {
    return 'Ви впевнені, що хочете видалити пресет \'$presetName\'? Цю дію неможливо скасувати.';
  }

  @override
  String presetApplied(Object presetName) {
    return 'Пресет \'$presetName\' застосовано.';
  }

  @override
  String get presetDeleted => 'Пресет видалено.';

  @override
  String get noPresetsAvailable => 'Немає доступних пресетів. Додайте один!';
}
