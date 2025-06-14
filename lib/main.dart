// Core Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Third-party package imports
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Project-specific imports
import 'package:pomozen/controllers/pomodoro_controller.dart';
import 'package:pomozen/l10n/arb/app_localizations.dart';
import 'package:pomozen/services/settings_service.dart';
import 'package:pomozen/ui/screens/about_screen.dart';
import 'package:pomozen/ui/screens/home_screen.dart';
import 'package:pomozen/ui/screens/pomodoro_screen.dart';
import 'package:pomozen/ui/screens/settings_screen.dart';
import 'package:pomozen/ui/screens/statistics_screen.dart';
import 'package:pomozen/ui/screens/terms_and_conditions_screen.dart';
import 'package:pomozen/ui/themes/app_theme.dart';

// Main Application Entry Point
void main() async {
  // Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SessionDataAdapter());

  // Service and Controller Dependency Injection
  final settingsService = SettingsService();
  await settingsService.init();
  Get.put(settingsService, permanent: true);
  Get.put(settingsService.sessionsBox, permanent: true);
  final pomodoroController = PomodoroController(Get.find<SettingsService>());
  Get.put(pomodoroController, permanent: true);

  // Run the App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settingsService = Get.find<SettingsService>();

      // Locale Configuration
      final Locale currentLocale = Locale(settingsService.language.value);

      // Theme Configuration
      final Brightness currentBrightness =
      settingsService.themeMode.value == ThemeMode.system
          ? WidgetsBinding.instance.window.platformBrightness
          : (settingsService.themeMode.value == ThemeMode.light
          ? Brightness.light
          : Brightness.dark);

      final Map<String, Color> namedColors =
      AppTheme.getNamedColors(currentBrightness);

      final Color? primaryColor =
      namedColors[settingsService.selectedPrimaryColorName.value];
      final Color? secondaryColor =
      namedColors[settingsService.selectedSecondaryColorName.value];
      final Color? tertiaryColor =
      namedColors[settingsService.selectedTertiaryColorName.value];

      return GetMaterialApp(
        title: 'PomoZen',
        debugShowCheckedModeBanner: false,

        // Theme Definitions
        theme: AppTheme.lightTheme(
          primaryColorOverride: primaryColor,
          secondaryColorOverride: secondaryColor,
          tertiaryColorOverride: tertiaryColor,
        ),
        darkTheme: AppTheme.darkTheme(
          primaryColorOverride: primaryColor,
          secondaryColorOverride: secondaryColor,
          tertiaryColorOverride: tertiaryColor,
        ),
        themeMode: settingsService.themeMode.value,

        // Localization Setup
        locale: currentLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('kn', ''),
          Locale('hi', ''),
        ],

        // Routing Configuration
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const HomeScreen()),
          GetPage(name: '/pomodoro', page: () => PomodoroScreen()),
          GetPage(name: '/settings', page: () => const PomodoroSettingsScreen()),
          GetPage(name: '/statistics', page: () => const StatisticsScreen()),
          GetPage(name: '/terms', page: () => const TermsAndConditionsScreen()),
          GetPage(name: '/about', page: () => const AboutScreen()),
        ],
      );
    });
  }
}
