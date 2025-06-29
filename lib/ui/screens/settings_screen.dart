// Core Flutter and Dart imports
import 'dart:convert';
import 'dart:io';

// Package imports
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomozen/ui/screens/statistics_screen.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:wakelock_plus/wakelock_plus.dart';

// Local project imports
import '../../controllers/pomodoro_controller.dart';
import '../../l10n/arb/app_localizations.dart';
import '../../services/settings_service.dart';
import '../themes/app_theme.dart';
import '../widget/custom_button.dart';
import '../widget/custom_slider.dart';
import '../widget/custom_text_field.dart'; // Ensure CustomTextField is imported

/// Defines consistent spacing values for the application UI.
class AppSpacing {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
}

/// Defines consistent text styles for the application UI.
class AppTextStyles {
  static TextStyle headline1(AppThemeColors colors) => TextStyle(
        fontFamily: 'OpenRunde',
        fontSize: 24,
        height: 1.3,
        letterSpacing: -0.4,
        color: colors.grey10,
        fontWeight: FontWeight.w500,
      );

  static TextStyle sectionHeader(AppThemeColors colors) => TextStyle(
        fontFamily: 'OpenRunde',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colors.grey10,
      );

  static TextStyle title(AppThemeColors colors) => TextStyle(
        fontFamily: 'OpenRunde',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.grey1,
      );

  static TextStyle body(AppThemeColors colors) => TextStyle(
        fontFamily: 'OpenRunde',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.grey2,
      );

  static TextStyle smallBody(AppThemeColors colors) => TextStyle(
        fontFamily: 'OpenRunde',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colors.grey2,
      );

  static TextStyle buttonText(AppThemeColors colors) => TextStyle(
        color: colors.grey10,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenRunde',
      );

  static TextStyle toolText(AppThemeColors colors) => TextStyle(
        color: colors.grey8,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenRunde',
      );

  static TextStyle dialogTitle(AppThemeColors colors) => TextStyle(
        fontWeight: FontWeight.w600,
        color: colors.primary,
      );

  static TextStyle dialogContent(AppThemeColors colors) => TextStyle(
        fontWeight: FontWeight.w500,
        color: colors.grey1,
      );

  static TextStyle errorText(AppThemeColors colors) => TextStyle(
        color: colors.error,
      );
}

/// A widget that applies a shrink and return-to-normal animation on tap.
class AnimatedTapEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final double scaleEnd;

  const AnimatedTapEffect({
    Key? key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 150),
    this.scaleEnd = 0.98,
  }) : super(key: key);

  @override
  _AnimatedTapEffectState createState() => _AnimatedTapEffectState();
}

class _AnimatedTapEffectState extends State<AnimatedTapEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double _scaleTransformValue;

  @override
  void initState() {
    super.initState();
    _scaleTransformValue = 1;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 1.0 - widget.scaleEnd,
    )..addListener(() {
        setState(() => _scaleTransformValue = 1 - _animationController.value);
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Initiates the shrink animation.
  void _shrinkButtonSize() {
    _animationController.forward();
  }

  /// Restores the button size after a delay.
  void _restoreButtonSize() {
    Future.delayed(
      widget.duration,
      () {
        if (mounted) {
          _animationController.reverse();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
        _shrinkButtonSize();
        _restoreButtonSize();
      },
      onTapDown: (_) => _shrinkButtonSize(),
      onTapCancel: _restoreButtonSize,
      child: AnimatedBuilder(
        animation: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeOutCubic,
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleTransformValue,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// The main settings screen for the Pomodoro application.
class PomodoroSettingsScreen extends StatefulWidget {
  const PomodoroSettingsScreen({super.key});

  @override
  State<PomodoroSettingsScreen> createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends State<PomodoroSettingsScreen>
    with TickerProviderStateMixin {
  late PomodoroController controller;
  String _appVersion = 'Loading...';

  // State variables for water reminder interval dropdown
  final GlobalKey _waterReminderIntervalKey = GlobalKey();
  final RxBool _isWaterReminderDropdownOpen = false.obs;
  late AnimationController _waterReminderBoxAnimationController;
  late Animation<double> _waterReminderBoxScaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PomodoroController>();
    _getAppVersion();

    // Initialize animation controller for water reminder interval box
    _waterReminderBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _waterReminderBoxScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _waterReminderBoxAnimationController,
      curve: Curves.easeOutCirc,
      reverseCurve: Curves.easeOutCirc,
    ));
  }

  @override
  void dispose() {
    _waterReminderBoxAnimationController.dispose();
    _isWaterReminderDropdownOpen.close();
    super.dispose();
  }

  /// Fetches and sets the application version.
  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  // Helper function to launch URLs in the default browser or custom tab
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        // Using platformDefault which prefers Custom Tabs on Android,
        // then falls back to the default browser. This is generally
        // more robust for web links.
        mode: LaunchMode.platformDefault,
      );
    } else {
      // Log the error to the console.
      print('Could not launch $url');
    }
  }

  // Helper function to send email via the default email client
  Future<void> _sendEmail(String email, String subject) async {
    // Explicitly encode the subject to ensure spaces are %20
    final String encodedSubject = Uri.encodeComponent(subject);

    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=$encodedSubject', // Use 'query' for custom parameter string
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        // For mailto links, externalApplication is still the most direct way
        // to try and open the email client.
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Log the error to the console.
      print('Could not launch email client');
    }
  }

  /// Helper widget to build consistent text styles across the screen.
  Widget _buildSettingText(
    String text, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
    TextOverflow? overflow,
    required BuildContext context,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'OpenRunde',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? appColors.grey10,
      ),
    );
  }

  /// Helper widget to build a slider setting content.
  /// Modified to be used within a ListTile.
  Widget _buildSliderContent({
    required BuildContext context,
    required String title,
    required RxInt value,
    required int min,
    required int max,
    required int defaultValue,
    required String Function(int) labelBuilder,
    required void Function(double) onChanged,
    required bool showTooltip,
  }) {
    final appColors = AppTheme.colorsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionHeader(appColors),
        ),
        const SizedBox(height: AppSpacing.small),
        Row(
          children: [
            Expanded(
              child: Obx(() => CustomSliderWithTooltip(
                    min: min.toDouble(),
                    max: max.toDouble(),
                    initialValue: value.value.toDouble(),
                    onChanged: (newValue) {
                      final int newIntValue = newValue.round();
                      if (newIntValue != value.value) {
                        HapticFeedback.lightImpact();
                      }
                      onChanged(newValue);
                    },
                    activeColor: appColors.primary,
                    unfocusedActiveColor: appColors.grey10,
                    inactiveColor: appColors.grey3,
                    showValueTooltip: showTooltip,
                    minLabel: labelBuilder(min),
                    maxLabel: labelBuilder(max),
                    labelTextStyle: AppTextStyles.smallBody(appColors),
                    tooltipBackgroundColor: appColors.primary,
                    tooltipTextStyle: AppTextStyles.toolText(appColors),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  /// Helper widget to build a ListTile for sliders that opens a bottom sheet.
  Widget _buildSliderListTile({
    required BuildContext context,
    required String title,
    required RxInt value,
    required int min,
    required int max,
    required int defaultValue,
    required String Function(int) labelBuilder,
    required void Function(double) onChanged,
    required bool showTooltip,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return AnimatedTapEffect(
      onTap: () {
        _showSliderBottomSheet(
          context: context,
          title: title,
          value: value,
          min: min,
          max: max,
          defaultValue: defaultValue,
          labelBuilder: labelBuilder,
          onChanged: onChanged,
          showTooltip: showTooltip,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.title(appColors),
            ),
            Expanded(
              child: Obx(() => Text(
                    labelBuilder(value.value),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: appColors.primary),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the bottom sheet for a slider.
  void _showSliderBottomSheet({
    required BuildContext context,
    required String title,
    required RxInt value,
    required int min,
    required int max,
    required int defaultValue,
    required String Function(int) labelBuilder,
    required void Function(double) onChanged,
    required bool showTooltip,
  }) {
    final appColors = AppTheme.colorsOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.grey5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSliderContent(
                  context: bc,
                  title: title,
                  // Title is displayed inside the content
                  value: value,
                  min: min,
                  max: max,
                  defaultValue: defaultValue,
                  labelBuilder: labelBuilder,
                  onChanged: onChanged,
                  showTooltip: showTooltip,
                ),
                const SizedBox(height: AppSpacing.medium),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: AppLocalizations.of(context)!.ok,
                    color: appColors.primary,
                    borderRadius: 8,
                    textPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                        vertical: AppSpacing.small),
                    textColor: appColors.grey10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper widget to build a switch setting.
  Widget _buildSwitchSetting({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? trailingWidget,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return AnimatedTapEffect(
        onTap: () {
          onChanged(!value);
        },
        child: ListTile(
          title: Text(
            title,
            style: AppTextStyles.title(appColors),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingWidget != null) ...[
                trailingWidget,
                const SizedBox(width: AppSpacing.small),
              ],
              Switch(
                value: value,
                onChanged: null,
                activeColor: appColors.primary,
                activeTrackColor: appColors.primary.withOpacity(0.2),
                inactiveThumbColor: value ? appColors.primary : appColors.grey5,
                inactiveTrackColor: value
                    ? appColors.primary
                    : appColors.grey3.withOpacity(0.8),
              ),
            ],
          ),
        ));
  }

  /// Helper widget to build a radio button setting.
  Widget _buildRadioSetting<T>({
    required BuildContext context,
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return AnimatedTapEffect(
      onTap: () {
        onChanged(value);
      },
      child: RadioListTile<T>(
        title: Text(
          title,
          style: AppTextStyles.title(appColors),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: (newValue) {
          onChanged(newValue);
          HapticFeedback.lightImpact();
        },
        activeColor: appColors.primary,
        visualDensity: const VisualDensity(vertical: -2, horizontal: -4),
      ),
    );
  }

  /// Helper widget for Theme selection tile.
  Widget _buildThemeSettingTile({
    required BuildContext context,
    required String title,
    required ThemeMode selectedThemeMode,
    required Function(ThemeMode) onChanged,
    required AppLocalizations localizations,
  }) {
    final appColors = AppTheme.colorsOf(context);

    String currentThemeName;
    switch (selectedThemeMode) {
      case ThemeMode.system:
        currentThemeName = localizations.systemTheme;
        break;
      case ThemeMode.light:
        currentThemeName = localizations.lightTheme;
        break;
      case ThemeMode.dark:
        currentThemeName = localizations.darkTheme;
        break;
    }

    return AnimatedTapEffect(
      onTap: () {
        _showThemeSelectionBottomSheet(
          context: context,
          selectedThemeMode: selectedThemeMode,
          onChanged: onChanged,
          localizations: localizations,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.title(appColors),
            ),
            Expanded(
              child: Text(
                currentThemeName,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: appColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget for a boxed selection item in bottom sheets.
  Widget _buildSelectionBox({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return AnimatedTapEffect(
      onTap: onTap,
      scaleEnd: 0.95,
      child: SizedBox(
        width: 100,
        height: 140,
        child: Card(
          color: isSelected ? appColors.grey6 : appColors.grey5,
          elevation: isSelected ? 0 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? appColors.grey10 : appColors.grey2,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.small, horizontal: AppSpacing.small),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? appColors.grey10 : appColors.grey2,
                ),
                const SizedBox(height: AppSpacing.large),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(appColors).copyWith(
                      color: isSelected ? appColors.grey10 : appColors.grey2,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows the bottom sheet for Theme selection.
  void _showThemeSelectionBottomSheet({
    required BuildContext context,
    required ThemeMode selectedThemeMode,
    required Function(ThemeMode) onChanged,
    required AppLocalizations localizations,
  }) {
    final appColors = AppTheme.colorsOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.grey5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Text(
                  localizations.theme,
                  style: AppTextStyles.sectionHeader(appColors),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium, vertical: AppSpacing.small),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: _buildSelectionBox(
                        context: context,
                        title: localizations.systemTheme,
                        icon: Icons.brightness_auto_outlined,
                        isSelected: selectedThemeMode == ThemeMode.system,
                        onTap: () {
                          onChanged(ThemeMode.system);
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: _buildSelectionBox(
                        context: context,
                        title: localizations.lightTheme,
                        icon: Icons.sunny,
                        isSelected: selectedThemeMode == ThemeMode.light,
                        onTap: () {
                          onChanged(ThemeMode.light);
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: _buildSelectionBox(
                        context: context,
                        title: localizations.darkTheme,
                        icon: Icons.nightlight,
                        isSelected: selectedThemeMode == ThemeMode.dark,
                        onTap: () {
                          onChanged(ThemeMode.dark);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        );
      },
    );
  }

  /// Helper widget for Language selection tile.
  Widget _buildLanguageSettingTile({
    required BuildContext context,
    required String title,
    required String selectedLanguageCode,
    required Function(String) onChanged,
    required AppLocalizations localizations,
  }) {
    final appColors = AppTheme.colorsOf(context);

    String currentLanguageName;
    switch (selectedLanguageCode) {
      case 'en':
        currentLanguageName = 'English';
        break;
      case 'kn':
        currentLanguageName = 'ಕನ್ನಡ';
        break;
      case 'hi':
        currentLanguageName = 'हिन्दी';
        break;
      default:
        currentLanguageName = selectedLanguageCode;
    }

    return AnimatedTapEffect(
      onTap: () {
        _showLanguageSelectionBottomSheet(
          context: context,
          selectedLanguageCode: selectedLanguageCode,
          onChanged: onChanged,
          localizations: localizations,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.title(appColors),
            ),
            Expanded(
              child: Text(
                currentLanguageName,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: appColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the bottom sheet for Language selection.
  void _showLanguageSelectionBottomSheet({
    required BuildContext context,
    required String selectedLanguageCode,
    required Function(String) onChanged,
    required AppLocalizations localizations,
  }) {
    final appColors = AppTheme.colorsOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.grey5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Text(
                  localizations.language,
                  style: AppTextStyles.sectionHeader(appColors),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium, vertical: AppSpacing.small),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: _buildSelectionBox(
                        context: context,
                        title: 'English',
                        icon: Icons.language_rounded,
                        isSelected: selectedLanguageCode == 'en',
                        onTap: () {
                          onChanged('en');
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: _buildSelectionBox(
                        context: context,
                        title: 'ಕನ್ನಡ',
                        icon: Icons.language_rounded,
                        isSelected: selectedLanguageCode == 'kn',
                        onTap: () {
                          onChanged('kn');
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: _buildSelectionBox(
                        context: context,
                        title: 'हिन्दी',
                        icon: Icons.language_rounded,
                        isSelected: selectedLanguageCode == 'hi',
                        onTap: () {
                          onChanged('hi');
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        );
      },
    );
  }

  /// Helper widget for Color selection tile.
  Widget _buildColorSettingTile({
    required BuildContext context,
    required String title,
    required RxString selectedColorName,
    required Function(String) onChanged,
  }) {
    final appColors = AppTheme.colorsOf(context);
    final Map<String, Color> availableColors =
        AppTheme.getNamedColors(Theme.of(context).brightness);

    return AnimatedTapEffect(
      onTap: () {
        _showColorSelectionBottomSheet(
          context: context,
          selectedColorName: selectedColorName,
          onChanged: onChanged,
          availableColors: availableColors,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.title(appColors),
            ),
            Obx(() {
              final color = availableColors[selectedColorName.value] ??
                  Colors.transparent;
              return Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: appColors.grey3,
                        width: 1,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Shows the bottom sheet for Color selection.
  void _showColorSelectionBottomSheet({
    required BuildContext context,
    required RxString selectedColorName,
    required Function(String) onChanged,
    required Map<String, Color> availableColors,
  }) {
    final appColors = AppTheme.colorsOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.grey5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Text(
                  'Select Color',
                  style: AppTextStyles.sectionHeader(appColors),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: AppSpacing.medium,
                    mainAxisSpacing: AppSpacing.medium,
                    childAspectRatio: 1,
                  ),
                  itemCount: availableColors.length,
                  itemBuilder: (context, index) {
                    final colorName = availableColors.keys.elementAt(index);
                    final color = availableColors[colorName]!;

                    return Obx(() {
                      final isSelected = selectedColorName.value == colorName;
                      return AnimatedTapEffect(
                        onTap: () {
                          onChanged(colorName);
                          Get.back();
                        },
                        scaleEnd: 0.95,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? appColors.grey10
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: _getContrastingTextColor(color),
                                  size: 24,
                                )
                              : null,
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        );
      },
    );
  }

  /// Helper method to determine a contrasting text color for a given background color.
  Color _getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Helper widget to build a general list tile.
  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required Color titleColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return AnimatedTapEffect(
      onTap: onTap,
      scaleEnd: 0.98,
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.title(appColors).copyWith(color: titleColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: iconColor),
      ),
    );
  }

  // NEW: Helper method to show custom interval dialog for water reminder
  Future<void> _showCustomIntervalDialog(BuildContext context,
      AppLocalizations localizations, AppThemeColors appColors) async {
    TextEditingController controller = TextEditingController();
    final settingsService = Get.find<SettingsService>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: appColors.grey6,
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(dialogContext).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSettingText(
                  localizations.customIntervalTitle ??
                      'Custom Interval (minutes)',
                  context: dialogContext,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appColors.primary,
                ),
                const SizedBox(height: 16),
                // Replaced TextField with CustomTextField
                CustomTextField(
                  controller: controller,
                  hintText: localizations.minutes ?? 'Minutes',
                  fillColor: appColors.grey6,
                  borderColor: appColors.grey4,
                  focusedBorderColor: appColors.primary,
                  enabledBorderColor: appColors.grey3,
                  textColor: appColors.grey10,
                  hintTextColor: appColors.grey2,
                  isInputValid: true,
                  // Assuming validity is handled by validator or state
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  errorBorderColor: appColors.error,
                  onSubmitted: (_) {
                    // Optional: handle submission if needed, e.g., dismiss keyboard
                    FocusScope.of(dialogContext).unfocus();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedTapEffect(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Get.back();
                      },
                      child: CustomButton(
                        onPressed: null,
                        text: localizations.cancel,
                        color: appColors.grey3,
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.medium,
                            vertical: AppSpacing.small),
                        textColor: appColors.grey10,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    AnimatedTapEffect(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        final int? customMinutes =
                            int.tryParse(controller.text);
                        if (customMinutes != null && customMinutes > 0) {
                          settingsService
                              .setWaterReminderIntervalMinutes(customMinutes);
                          Fluttertoast.showToast(
                              msg: localizations.waterReminderIntervalSet
                                      ?.call(customMinutes) ??
                                  'Water reminder interval set to $customMinutes minutes.');
                          Get.back();
                        } else {
                          Fluttertoast.showToast(
                              msg: localizations.invalidInterval ??
                                  'Please enter a valid interval.');
                        }
                      },
                      child: CustomButton(
                        onPressed: null,
                        text: localizations.ok,
                        color: appColors.primary,
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.medium,
                            vertical: AppSpacing.small),
                        textColor: appColors.grey10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // New helper widget to build the water reminder interval selector
  Widget _buildWaterReminderIntervalSelector(
    BuildContext context,
    AppThemeColors appColors,
    AppLocalizations localizations,
    int currentInterval,
    List<int> availableIntervals,
  ) {
    // Define the dimensions for the custom dropdown box
    const double dropdownBoxWidth = 180;
    const double dropdownBoxHeight = 56;
    const double dropdownItemHeight = 48;

    final List<int> defaultIntervals = [30, 45, 60];

    return AnimatedBuilder(
      animation: _waterReminderBoxScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _waterReminderBoxScaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        key: _waterReminderIntervalKey,
        width: dropdownBoxWidth,
        height: dropdownBoxHeight,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent, // Or a subtle background if desired
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Display the currently selected interval
            Center(
              child: Text(
                currentInterval == 0
                    ? localizations.addCustom ?? 'Custom Interval'
                    : '$currentInterval ${localizations.minutesShort}',
                style: TextStyle(
                  fontFamily: 'OpenRunde',
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  color: appColors.grey10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // The dropdown arrow button
            Positioned(
              right: 0,
              child: GestureDetector(
                onTapDown: (_) {
                  if (mounted) _waterReminderBoxAnimationController.forward();
                },
                onTap: () async {
                  HapticFeedback.lightImpact();
                  _isWaterReminderDropdownOpen.value = true;

                  // Calculate the position for the pop-up menu
                  final RenderBox renderBox = _waterReminderIntervalKey
                      .currentContext!
                      .findRenderObject() as RenderBox;
                  final Offset offset = renderBox.localToGlobal(Offset.zero);
                  final Size size = renderBox.size;

                  await showMenu<int>(
                    elevation: 0,
                    color: appColors.grey5,
                    context: context,
                    // Adjusted position to make it open exactly below the container
                    position: RelativeRect.fromRect(
                      Rect.fromLTWH(
                          offset.dx, offset.dy, size.width, size.height),
                      Offset.zero & MediaQuery.of(context).size,
                    ).shift(Offset(0, size.height + AppSpacing.extraSmall)),
                    // Shift down by container height + small spacing
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    constraints: BoxConstraints.tightFor(width: size.width),
                    items: [
                      // Map available intervals to PopupMenuItems
                      ...availableIntervals.map((interval) {
                        final isCustom = !defaultIntervals.contains(interval) &&
                            interval != 0;
                        return PopupMenuItem<int>(
                          height: dropdownItemHeight,
                          value: interval,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, interval);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$interval ${localizations.minutesShort}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'OpenRunde',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: appColors.grey10,
                                    ),
                                  ),
                                ),
                                if (isCustom)
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded,
                                        color: appColors.error, size: 20),
                                    onPressed: () {
                                      // Revert to a default value (e.g., 30 minutes)
                                      controller.settingsService
                                          .setWaterReminderIntervalMinutes(
                                              30); // Default to 30 min
                                      Fluttertoast.showToast(
                                          msg: localizations
                                                  .customIntervalRemoved ??
                                              'Custom interval removed. Reverted to 30 minutes.');
                                      Navigator.pop(context); // Close the menu
                                    },
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                      PopupMenuDivider(
                        color: appColors.grey4,
                      ),
                      // "Add Custom" button
                      PopupMenuItem<int>(
                        height: dropdownItemHeight,
                        enabled: false, // Disable direct tap on this item
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedTapEffect(
                          onTap: () {
                            Navigator.pop(context,
                                0); // Use 0 as a special value for custom
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: null,
                              // onPressed handled by AnimatedTapEffect
                              text: localizations.addCustom ?? 'Add Custom',
                              color: appColors.primary,
                              borderRadius: 8,
                              textPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.medium,
                                  vertical: AppSpacing.small),
                              textColor: appColors.grey10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).then((newValue) {
                    _isWaterReminderDropdownOpen.value = false;
                    if (mounted) _waterReminderBoxAnimationController.reverse();

                    if (newValue != null) {
                      if (newValue == 0) {
                        // If "Add Custom" was selected
                        _showCustomIntervalDialog(
                            context, localizations, appColors);
                      } else {
                        // A predefined interval was selected
                        controller.settingsService
                            .setWaterReminderIntervalMinutes(newValue);
                      }
                    }
                  });
                },
                onTapUp: (_) {
                  if (mounted) _waterReminderBoxAnimationController.reverse();
                },
                onTapCancel: () {
                  if (mounted) _waterReminderBoxAnimationController.reverse();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.grey5,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => AnimatedRotation(
                        turns: _isWaterReminderDropdownOpen.value ? -0.5 : 0.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.fastOutSlowIn,
                        child: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: appColors.grey10,
                          size: 32,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a section header with an info bubble.
  Widget _buildSectionHeaderWithInfo({
    required BuildContext context,
    required String title,
    required String infoMessage,
  }) {
    final appColors = AppTheme.colorsOf(context);
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.sectionHeader(appColors),
        ),
        const SizedBox(width: AppSpacing.small),
        AnimatedTapEffect(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) => Dialog(
                backgroundColor: appColors.grey6,
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: MediaQuery.of(dialogContext).size.width * 0.85,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSettingText(
                        title,
                        context: dialogContext,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: appColors.primary,
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: SingleChildScrollView(
                          child: _buildSettingText(
                            infoMessage,
                            context: dialogContext,
                            fontWeight: FontWeight.w500,
                            color: appColors.grey1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        color: appColors.grey5,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedTapEffect(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.back();
                            },
                            child: CustomButton(
                              onPressed: null,
                              text: AppLocalizations.of(context)!.ok,
                              color: appColors.primary,
                              borderRadius: 8,
                              textPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.medium,
                                  vertical: AppSpacing.small),
                              textColor: appColors.grey10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: appColors.grey2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context)!;
    final settingsService = Get.find<SettingsService>();

    final RxBool showSliderTooltips = true.obs;

    return Scaffold(
      backgroundColor: appColors.grey7,
      appBar: AppBar(
        backgroundColor: appColors.grey7,
        leading: AnimatedTapEffect(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_rounded,
              size: 24, color: appColors.primary),
        ),
        title: Text(
          localizations.settings,
          style: AppTextStyles.headline1(appColors),
        ),
        actions: [
          AnimatedTapEffect(
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => Dialog(
                  backgroundColor: appColors.grey6,
                  insetPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    width: MediaQuery.of(dialogContext).size.width * 0.85,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSettingText(
                          localizations.resetSettings,
                          context: dialogContext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: appColors.error,
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: SingleChildScrollView(
                            child: _buildSettingText(
                              localizations.resetSettingsConfirmation,
                              context: dialogContext,
                              fontWeight: FontWeight.w500,
                              color: appColors.grey1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: appColors.grey5,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedTapEffect(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Get.back();
                              },
                              child: CustomButton(
                                onPressed: null,
                                text: localizations.cancel,
                                color: appColors.grey4,
                                borderRadius: 8,
                                textPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.medium,
                                    vertical: AppSpacing.small),
                                textColor: appColors.grey10,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.small),
                            AnimatedTapEffect(
                              onTap: () async {
                                await settingsService.resetToDefaults();
                                Get.back();
                                Fluttertoast.showToast(
                                    msg: localizations
                                        .settingsResetSuccessfully);
                                HapticFeedback.mediumImpact();
                                Get.updateLocale(
                                    Locale(settingsService.language.value));
                              },
                              child: CustomButton(
                                onPressed: null,
                                text: localizations.reset,
                                color: appColors.error,
                                borderRadius: 8,
                                textPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.medium,
                                    vertical: AppSpacing.small),
                                textColor: appColors.grey10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Icon(Icons.restart_alt_rounded, color: appColors.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pomodoro Timer Settings Section
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.pomodoroTimer,
              infoMessage: localizations.pomodoroTimerInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    Obx(() => _buildSliderListTile(
                          context: context,
                          title: localizations.focusDuration,
                          value: controller.settingsService.focusDuration,
                          min: 5,
                          max: 60,
                          defaultValue: 25,
                          labelBuilder: (value) =>
                              '$value ${localizations.minutesShort}',
                          onChanged: (value) => controller.settingsService
                              .setFocusDuration(value.round()),
                          showTooltip: showSliderTooltips.value,
                        )),
                    Divider(color: appColors.grey5),
                    Obx(() => _buildSliderListTile(
                          context: context,
                          title: localizations.shortBreak,
                          value: controller.settingsService.shortBreakDuration,
                          min: 1,
                          max: 30,
                          defaultValue: 5,
                          labelBuilder: (value) =>
                              '$value ${localizations.minutesShort}',
                          onChanged: (value) => controller.settingsService
                              .setShortBreakDuration(value.round()),
                          showTooltip: showSliderTooltips.value,
                        )),
                    Divider(color: appColors.grey5),
                    Obx(() => _buildSliderListTile(
                          context: context,
                          title: localizations.longBreak,
                          value: controller.settingsService.longBreakDuration,
                          min: 1,
                          max: 45,
                          defaultValue: 20,
                          labelBuilder: (value) =>
                              '$value ${localizations.minutesShort}',
                          onChanged: (value) => controller.settingsService
                              .setLongBreakDuration(value.round()),
                          showTooltip: showSliderTooltips.value,
                        )),
                    Divider(color: appColors.grey5),
                    Obx(() => _buildSliderListTile(
                          context: context,
                          title: localizations.sessions,
                          value: controller.settingsService.totalSessions,
                          min: 2,
                          max: 15,
                          defaultValue: 4,
                          labelBuilder: (value) =>
                              '$value ${localizations.sessions}',
                          onChanged: (value) => controller.settingsService
                              .setTotalSessions(value.round()),
                          showTooltip: showSliderTooltips.value,
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.large),

            // Notifications and Alerts Settings Section
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.notificationsAndAlerts,
              infoMessage: localizations.notificationsAndAlertsInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    Obx(() => _buildSwitchSetting(
                          context: context,
                          title: localizations.reminder,
                          value: controller.settingsService.reminder.value,
                          onChanged: (value) async {
                            controller.settingsService.setReminder(value);
                            if (value) {
                              final bool granted = await controller
                                  .requestNotificationPermissions();
                              if (!granted) {
                                controller.settingsService.setReminder(false);
                                Fluttertoast.showToast(
                                  msg: localizations
                                      .notificationPermissionDenied,
                                );
                              }
                            } else {
                              controller.cancelAllNotifications();
                            }
                          },
                        )),
                    Obx(() => controller.settingsService.reminder.value
                        ? Column(
                            children: [
                              _buildRadioSetting<bool>(
                                context: context,
                                title: localizations.notification,
                                value: false,
                                groupValue:
                                    controller.settingsService.isAlarm.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.settingsService
                                        .setIsAlarm(value);
                                  }
                                },
                              ),
                              _buildRadioSetting<bool>(
                                context: context,
                                title: localizations.alarm,
                                value: true,
                                groupValue:
                                    controller.settingsService.isAlarm.value,
                                onChanged: (value) async {
                                  if (value != null) {
                                    controller.settingsService
                                        .setIsAlarm(value);
                                    final bool enabled = await controller
                                        .areNotificationsEnabled();
                                    if (!enabled) {
                                      await controller
                                          .requestNotificationPermissions();
                                    }
                                  }
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink()),
                    Obx(() {
                      final dailyReminderEnabled =
                          settingsService.dailyReminderTimeHour.value != null &&
                              settingsService.dailyReminderTimeMinute.value !=
                                  null;
                      final TimeOfDay? selectedTime = dailyReminderEnabled
                          ? TimeOfDay(
                              hour:
                                  settingsService.dailyReminderTimeHour.value!,
                              minute: settingsService
                                  .dailyReminderTimeMinute.value!,
                            )
                          : null;

                      return _buildSwitchSetting(
                        context: context,
                        title: localizations.dailyReminder ?? 'Daily Reminder',
                        value: dailyReminderEnabled,
                        onChanged: (value) async {
                          if (value) {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme:
                                        Theme.of(context).colorScheme.copyWith(
                                              primary: appColors.primary,
                                              onPrimary: appColors.grey10,
                                              surface: appColors.grey6,
                                              onSurface: appColors.grey10,
                                            ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        textStyle:
                                            AppTextStyles.buttonText(appColors),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.medium,
                                            vertical: AppSpacing.small),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        foregroundColor: appColors.grey10,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              await settingsService
                                  .setDailyReminderTime(picked);
                              controller.scheduleDailyReminder();
                              Fluttertoast.showToast(
                                  msg: localizations.dailyReminderSet
                                          ?.call(picked.format(context)) ??
                                      'Daily reminder set for ${picked.format(context)}');
                            } else {
                              await settingsService.setDailyReminderTime(null);
                            }
                          } else {
                            await settingsService.setDailyReminderTime(null);
                            controller.cancelDailyReminder();
                            Fluttertoast.showToast(
                                msg: localizations.dailyReminderCancelled ??
                                    'Daily reminder cancelled.');
                          }
                        },
                        trailingWidget:
                            dailyReminderEnabled && selectedTime != null
                                ? Text(
                                    selectedTime.format(context),
                                    style: AppTextStyles.body(appColors),
                                  )
                                : null,
                      );
                    }),
                    Obx(() => _buildSwitchSetting(
                          context: context,
                          title: localizations.autoPlay,
                          value: controller.settingsService.autoPlay.value,
                          onChanged: (value) {
                            controller.settingsService.setAutoPlay(value);
                          },
                        )),
                    Obx(() => _buildSwitchSetting(
                          context: context,
                          title: localizations.torchAlerts,
                          value: controller.settingsService.torchAlerts.value,
                          onChanged: (value) async {
                            controller.settingsService.setTorchAlerts(value);
                            if (value) {
                              await Permission.camera.request();
                            }
                          },
                        )),
                    Obx(() => _buildSwitchSetting(
                          context: context,
                          title: localizations.keepScreenOn,
                          value: controller.settingsService.keepScreenOn.value,
                          onChanged: (value) {
                            controller.settingsService.setKeepScreenOn(value);
                            if (value) {
                              WakelockPlus.enable();
                            } else {
                              WakelockPlus.disable();
                            }
                          },
                        )),
                    Obx(() => _buildSwitchSetting(
                          context: context,
                          title: localizations.dndToggle,
                          value: controller.settingsService.dndToggle.value,
                          onChanged: (value) {
                            controller.handleDndToggle(value);
                          },
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.large),

            // General Settings Section
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.general,
              infoMessage: localizations.generalInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    Obx(() => _buildLanguageSettingTile(
                          context: context,
                          title: localizations.language,
                          selectedLanguageCode:
                              controller.settingsService.language.value,
                          onChanged: (value) {
                            controller.settingsService.setLanguage(value);
                            Get.updateLocale(Locale(value));
                          },
                          localizations: localizations,
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.large),

            // NEW: Wellness Settings Section
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.wellness ?? 'Wellness',
              infoMessage: localizations.wellnessInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    Obx(() => _buildSwitchSetting(
                          context: context,
                          title:
                              localizations.waterReminder ?? 'Water Reminder',
                          value: controller
                              .settingsService.waterReminderEnabled.value,
                          onChanged: (value) async {
                            controller.settingsService
                                .setWaterReminderEnabled(value);
                            if (value) {
                              final bool granted = await controller
                                  .requestNotificationPermissions();
                              if (!granted) {
                                // If permission is not granted, revert the switch state in settings service
                                controller.settingsService
                                    .setWaterReminderEnabled(false);
                                Fluttertoast.showToast(
                                  msg: localizations
                                      .notificationPermissionDenied,
                                );
                              } else {
                                // Permission granted, reminder will be scheduled by listener in controller
                                Fluttertoast.showToast(
                                    msg: localizations.waterReminderEnabled ??
                                        'Water reminder enabled.');
                              }
                            } else {
                              controller.cancelWaterReminder();
                              Fluttertoast.showToast(
                                  msg: localizations.waterReminderCancelled ??
                                      'Water reminder cancelled.');
                            }
                          },
                        )),
                    Obx(() {
                      final currentInterval = controller
                          .settingsService.waterReminderIntervalMinutes.value;
                      final List<int> defaultIntervals = [30, 45, 60];
                      final List<int> availableIntervals = [];

                      // Add default intervals
                      availableIntervals.addAll(defaultIntervals);

                      // Add current interval if it's not a default one and not 0 (custom)
                      if (!defaultIntervals.contains(currentInterval) &&
                          currentInterval != 0) {
                        availableIntervals.add(currentInterval);
                      }
                      // Sort to keep it clean (optional, but good for UX)
                      availableIntervals.sort();

                      return controller
                              .settingsService.waterReminderEnabled.value
                          ? Column(
                              children: [
                                Divider(color: appColors.grey5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.small),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          localizations.interval ?? 'Interval',
                                          style: AppTextStyles.title(appColors),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            // Use the custom water reminder interval selector
                                            child:
                                                _buildWaterReminderIntervalSelector(
                                              context,
                                              appColors,
                                              localizations,
                                              currentInterval,
                                              availableIntervals,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: appColors.grey5),
                                _buildRadioSetting<String>(
                                  context: context,
                                  title: localizations.notification,
                                  value: 'notification',
                                  groupValue: controller
                                      .settingsService.waterReminderType.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.settingsService
                                          .setWaterReminderType(value);
                                    }
                                  },
                                ),
                                _buildRadioSetting<String>(
                                  context: context,
                                  title: localizations.alarm,
                                  value: 'alarm',
                                  groupValue: controller
                                      .settingsService.waterReminderType.value,
                                  onChanged: (value) async {
                                    if (value != null) {
                                      controller.settingsService
                                          .setWaterReminderType(value);
                                      final bool enabled = await controller
                                          .areNotificationsEnabled();
                                      if (!enabled) {
                                        await controller
                                            .requestNotificationPermissions();
                                      }
                                    }
                                  },
                                ),
                              ],
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.large),

            // Appearance and App Colors Settings Section
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.appColors,
              infoMessage: localizations.appColorsInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    Obx(() => _buildThemeSettingTile(
                          context: context,
                          title: localizations.theme,
                          selectedThemeMode: settingsService.themeMode.value,
                          onChanged: (value) {
                            settingsService.setThemeMode(value);
                          },
                          localizations: localizations,
                        )),
                    Divider(color: appColors.grey5),
                    _buildColorSettingTile(
                      context: context,
                      title: localizations.primaryColor,
                      selectedColorName:
                          settingsService.selectedPrimaryColorName,
                      onChanged: (colorName) => settingsService
                          .setSelectedPrimaryColorName(colorName),
                    ),
                    _buildColorSettingTile(
                      context: context,
                      title: localizations.secondaryColor,
                      selectedColorName:
                          settingsService.selectedSecondaryColorName,
                      onChanged: (colorName) => settingsService
                          .setSelectedSecondaryColorName(colorName),
                    ),
                    _buildColorSettingTile(
                      context: context,
                      title: localizations.tertiaryColor,
                      selectedColorName:
                          settingsService.selectedTertiaryColorName,
                      onChanged: (colorName) => settingsService
                          .setSelectedTertiaryColorName(colorName),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.large),

            // Data Management Section
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.data,
              infoMessage: localizations.dataInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    _buildListTile(
                      context: context,
                      title: localizations.exportData,
                      onTap: () async {
                        await _exportData(context, localizations);
                      },
                      titleColor: appColors.grey1,
                      iconColor: appColors.grey2,
                    ),
                    _buildListTile(
                      context: context,
                      title: localizations.importData,
                      onTap: () async {
                        await _importData(context, localizations);
                      },
                      titleColor: appColors.grey1,
                      iconColor: appColors.grey2,
                    ),
                    _buildListTile(
                      context: context,
                      title: localizations.resetAllData,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => Dialog(
                            backgroundColor: appColors.grey6,
                            insetPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              width: MediaQuery.of(dialogContext).size.width *
                                  0.85,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildSettingText(
                                    localizations.resetAllData,
                                    context: dialogContext,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.error,
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: _buildSettingText(
                                        localizations.resetAllDataConfirmation,
                                        context: dialogContext,
                                        fontWeight: FontWeight.w500,
                                        color: appColors.grey1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Divider(
                                    color: appColors.grey5,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AnimatedTapEffect(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          Get.back();
                                        },
                                        child: CustomButton(
                                          onPressed: null,
                                          text: localizations.cancel,
                                          color: appColors.grey3,
                                          borderRadius: 8,
                                          textPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.medium,
                                                  vertical: AppSpacing.small),
                                          textColor: appColors.grey10,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.small),
                                      AnimatedTapEffect(
                                        onTap: () async {
                                          await controller.settingsService
                                              .clearAllData();
                                          await controller.settingsService
                                              .resetToDefaults();
                                          Get.back();
                                          Fluttertoast.showToast(
                                              msg: localizations
                                                  .allDataResetSuccessfully);
                                          HapticFeedback.mediumImpact();
                                          Get.updateLocale(Locale(
                                              settingsService.language.value));
                                        },
                                        child: CustomButton(
                                          onPressed: null,
                                          text: localizations.reset,
                                          color: appColors.error,
                                          borderRadius: 8,
                                          textPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.medium,
                                                  vertical: AppSpacing.small),
                                          textColor: appColors.grey10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      titleColor: appColors.error,
                      iconColor: appColors.error.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.large),

            // About and T&C Tiles Section (Original)
            _buildSectionHeaderWithInfo(
              context: context,
              title: localizations.aboutAndLegal ?? 'About & Legal',
              infoMessage: localizations.aboutAndLegalInfo,
            ),
            const SizedBox(height: AppSpacing.medium),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    _buildListTile(
                      context: context,
                      title: localizations.aboutApp ?? 'About App',
                      onTap: () {
                        Get.toNamed('/about');
                      },
                      titleColor: appColors.grey1,
                      iconColor: appColors.grey2,
                    ),
                    _buildListTile(
                      context: context,
                      title: localizations.termsAndConditions ??
                          'Terms & Conditions',
                      onTap: () {
                        Get.toNamed('/terms');
                      },
                      titleColor: appColors.grey1,
                      iconColor: appColors.grey2,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.extraLarge),

            // New Links Section (Copied from about_screen.dart)
            Text(
              localizations.linksTitle ?? 'Links', // Localized links title
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.grey10,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: appColors.grey6,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        localizations.sendFeedbackLink ?? 'Send Feedback',
                        // Localized send feedback link
                        style: TextStyle(
                          fontFamily: 'OpenRunde',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appColors.primary,
                        ),
                      ),
                      trailing: Icon(Icons.mail_outline,
                          size: 20, color: appColors.primary),
                      onTap: () => _sendEmail(
                          'arunuserx@gmail.com', 'Feedback about Pomozen'),
                    ),
                    ListTile(
                      title: Text(
                        localizations.privacyPolicyLink ?? 'Privacy Policy',
                        // Localized privacy policy link
                        style: TextStyle(
                          fontFamily: 'OpenRunde',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appColors.primary,
                        ),
                      ),
                      trailing: Icon(Icons.open_in_new,
                          size: 20, color: appColors.primary),
                      onTap: () => _launchURL(
                          'https://projectsolutus.github.io/Pomozen/privacy_policy'), // Example link
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // App Version Display (Moved to after the new section)
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '${localizations.appVersion ?? 'App Version'} $_appVersion',
                style: AppTextStyles.body(appColors),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
          ],
        ),
      ),
    );
  }

  /// Exports session data and all active settings (including labels) to a CSV file.
  Future<void> _exportData(
      BuildContext context, AppLocalizations localizations) async {
    try {
      final sessionsBox = controller.settingsService.sessionsBox;
      final settingsService = controller.settingsService;

      final List<List<dynamic>> csvData = [];

      // Session Data Section
      csvData.add(const ['---SESSIONS---']);
      csvData.add(const [
        'StartTime',
        'Date',
        'Focus Minutes',
        'Label',
        'Note',
        'Is Completed'
      ]);
      int sessionCount = 0;
      for (var session in sessionsBox.values) {
        csvData.add([
          session.startTime.toIso8601String(),
          session.date.toIso8601String().split('T').first,
          session.focusMinutes,
          session.labelName ?? '',
          session.note ?? '',
          session.isCompleted ? 'true' : 'false',
        ]);
        sessionCount++;
      }
      print('Exporting $sessionCount sessions.');
      csvData.add([]);

      // Settings Data Section
      csvData.add(const ['---SETTINGS---']);
      csvData.add(const ['Setting Name', 'Value']);
      int settingCount = 0;
      csvData.add(['focusDuration', settingsService.focusDuration.value]);
      settingCount++;
      csvData.add(
          ['shortBreakDuration', settingsService.shortBreakDuration.value]);
      settingCount++;
      csvData
          .add(['longBreakDuration', settingsService.longBreakDuration.value]);
      settingCount++;
      csvData.add(['totalSessions', settingsService.totalSessions.value]);
      settingCount++;
      csvData.add(['reminder', settingsService.reminder.value]);
      settingCount++;
      csvData.add(['isAlarm', settingsService.isAlarm.value]);
      settingCount++;
      csvData.add(['autoPlay', settingsService.autoPlay.value]);
      settingCount++;
      csvData.add(['torchAlerts', settingsService.torchAlerts.value]);
      settingCount++;
      csvData.add(['keepScreenOn', settingsService.keepScreenOn.value]);
      settingCount++;
      csvData.add(['dndToggle', settingsService.dndToggle.value]);
      settingCount++;
      csvData.add(['language', settingsService.language.value]);
      settingCount++;
      if (settingsService.dailyReminderTimeHour.value != null &&
          settingsService.dailyReminderTimeMinute.value != null) {
        csvData.add([
          'dailyReminderTimeHour',
          settingsService.dailyReminderTimeHour.value
        ]);
        settingCount++;
        csvData.add([
          'dailyReminderTimeMinute',
          settingsService.dailyReminderTimeMinute.value
        ]);
        settingCount++;
      } else {
        csvData.add(['dailyReminderTimeHour', 'null']);
        settingCount++;
        csvData.add(['dailyReminderTimeMinute', 'null']);
        settingCount++;
      }
      csvData.add(['startOfDay', settingsService.startOfDay.value]);
      settingCount++;
      csvData.add(['startOfWeek', settingsService.startOfWeek.value]);
      settingCount++;
      csvData.add(['themeMode', settingsService.themeMode.value.toString()]);
      settingCount++;
      csvData.add([
        'selectedStatsLabel',
        settingsService.selectedStatsLabel.value != null
            ? jsonEncode(settingsService.selectedStatsLabel.value)
            : 'null'
      ]);
      settingCount++;
      csvData.add([
        'selectedPrimaryColorName',
        settingsService.selectedPrimaryColorName.value
      ]);
      settingCount++;
      csvData.add([
        'selectedSecondaryColorName',
        settingsService.selectedSecondaryColorName.value
      ]);
      settingCount++;
      csvData.add([
        'selectedTertiaryColorName',
        settingsService.selectedTertiaryColorName.value
      ]);
      settingCount++;
      // NEW: Water Reminder Settings Export
      csvData.add(
          ['waterReminderEnabled', settingsService.waterReminderEnabled.value]);
      settingCount++;
      csvData.add([
        'waterReminderIntervalMinutes',
        settingsService.waterReminderIntervalMinutes.value
      ]);
      settingCount++;
      csvData
          .add(['waterReminderType', settingsService.waterReminderType.value]);
      settingCount++;

      print('Exporting $settingCount settings.');
      print(
          'Focus Duration (exported): ${settingsService.focusDuration.value}');
      print(
          'Short Break Duration (exported): ${settingsService.shortBreakDuration.value}');
      print(
          'Long Break Duration (exported): ${settingsService.longBreakDuration.value}');
      print(
          'Total Sessions (exported): ${settingsService.totalSessions.value}');
      csvData.add([]);

      // Labels Data Section
      csvData.add(const ['---LABELS---']);
      csvData.add(const ['Label Name', 'Color Value']);
      int labelCount = 0;
      for (var label in settingsService.labels) {
        csvData.add([
          label['name'],
          label['color'],
        ]);
        labelCount++;
      }
      print(
          'Exporting $labelCount active labels: ${settingsService.labels.value}');
      csvData.add([]);

      String csv = const ListToCsvConverter().convert(csvData);

      final Uint8List bytes = Uint8List.fromList(utf8.encode(csv));
      String fileName = 'pomozen_data.csv';

      String? selectedPath = await FilePicker.platform.saveFile(
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: bytes,
      );

      if (selectedPath != null) {
        Fluttertoast.showToast(msg: localizations.dataExportedSuccessfully);
      } else {
        Fluttertoast.showToast(msg: localizations.exportCanceled);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '${localizations.dataExportFailed}: $e');
      print('Export error: $e');
    }
  }

  /// Imports session data and settings from a CSV file.
  Future<void> _importData(
      BuildContext context, AppLocalizations localizations) async {
    final appColors = AppTheme.colorsOf(context);

    try {
      final bool? confirmImport = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => Dialog(
          backgroundColor: appColors.grey6,
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(dialogContext).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSettingText(
                  localizations.importData,
                  context: dialogContext,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appColors.primary,
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: _buildSettingText(
                      localizations.importDataConfirmation,
                      context: dialogContext,
                      fontWeight: FontWeight.w500,
                      color: appColors.grey1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Divider(
                  color: appColors.grey5,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedTapEffect(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Get.back(result: false);
                      },
                      child: CustomButton(
                        onPressed: null,
                        text: localizations.cancel,
                        color: appColors.grey3,
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.medium,
                            vertical: AppSpacing.small),
                        textColor: appColors.grey10,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    AnimatedTapEffect(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Get.back(result: true);
                      },
                      child: CustomButton(
                        onPressed: null,
                        text: localizations.ok,
                        color: appColors.primary,
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.medium,
                            vertical: AppSpacing.small),
                        textColor: appColors.grey10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (confirmImport == null || !confirmImport) {
        Fluttertoast.showToast(msg: localizations.importCanceled);
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) {
        Fluttertoast.showToast(msg: localizations.importCanceled);
        return;
      }

      File file = File(result.files.single.path!);
      String csvString = await file.readAsString();
      List<List<dynamic>> rowsAsListOfList =
          const CsvToListConverter().convert(csvString);

      print('DEBUG: Raw CSV rows parsed:');
      for (var row in rowsAsListOfList) {
        print('DEBUG: Row: $row');
      }

      if (rowsAsListOfList.isEmpty) {
        Fluttertoast.showToast(msg: localizations.emptyCsvFile);
        return;
      }

      await controller.settingsService.clearAllData();

      final List<String> errors = [];
      final List<Map<String, dynamic>> importedLabels = [];

      bool inSessionsSection = false;
      bool inSettingsSection = false;
      bool inLabelsSection = false;

      int? tempDailyReminderHour;

      for (int i = 0; i < rowsAsListOfList.length; i++) {
        final row = rowsAsListOfList[i];
        if (row.isEmpty ||
            row.length == 0 ||
            (row.length > 0 &&
                (row[0] == null || row[0].toString().trim().isEmpty))) {
          continue;
        }

        final firstCell = row[0].toString().trim();

        if (firstCell == '---SESSIONS---') {
          print('DEBUG: Found SESSIONS section marker.');
          inSessionsSection = true;
          inSettingsSection = false;
          inLabelsSection = false;
          if (i + 1 < rowsAsListOfList.length &&
              rowsAsListOfList[i + 1].length >= 6 &&
              rowsAsListOfList[i + 1][0].toString().trim() == 'StartTime') {
            i++;
            print('DEBUG: Skipped SESSIONS header row.');
          } else {
            print(
                'WARNING: Expected Session header not found after ---SESSIONS--- marker. Current row: $row');
          }
          continue;
        } else if (firstCell == '---SETTINGS---') {
          print('DEBUG: Found SETTINGS section marker.');
          inSessionsSection = false;
          inSettingsSection = true;
          inLabelsSection = false;
          if (i + 1 < rowsAsListOfList.length &&
              rowsAsListOfList[i + 1].length >= 2 &&
              rowsAsListOfList[i + 1][0].toString().trim() == 'Setting Name') {
            i++;
            print('DEBUG: Skipped SETTINGS header row.');
          } else {
            print(
                'WARNING: Expected Settings header not found after ---SETTINGS--- marker. Current row: $row');
          }
          continue;
        } else if (firstCell == '---LABELS---') {
          print('DEBUG: Found LABELS section marker.');
          inSessionsSection = false;
          inSettingsSection = false;
          inLabelsSection = true;
          if (i + 1 < rowsAsListOfList.length &&
              rowsAsListOfList[i + 1].length >= 2 &&
              rowsAsListOfList[i + 1][0].toString().trim() == 'Label Name') {
            i++;
            print('DEBUG: Skipped LABELS header row.');
          } else {
            print(
                'WARNING: Expected Labels header not found after ---LABELS--- marker. Current row: $row');
          }
          continue;
        }

        if (inSessionsSection) {
          const expectedSessionLength = 6;
          if (row.length != expectedSessionLength) {
            errors.add(
                '${localizations.invalidColumnCount} ${i + 1}: Expected $expectedSessionLength, got ${row.length}. Row: $row');
            continue;
          }

          try {
            final startTimeString = row[0].toString();
            final dateString = row[1].toString();
            final focusMinutesString = row[2].toString();
            final String? labelName =
                row[3].toString().isEmpty ? null : row[3].toString();
            final String? note =
                row[4].toString().isEmpty ? null : row[4].toString();
            final String isCompletedString = row[5].toString().toLowerCase();

            final DateTime startTime = DateTime.parse(startTimeString);
            final DateTime date = DateTime.parse(dateString);
            final int? focusMinutes = int.tryParse(focusMinutesString);
            final bool isCompleted = isCompletedString == 'true';

            if (focusMinutes == null) {
              errors.add(
                  '${localizations.invalidFocusMinutes} on line ${i + 1}. Row: $row');
              continue;
            }

            await controller.settingsService.sessionsBox.add(SessionData(
              startTime,
              date,
              focusMinutes,
              labelName: labelName,
              note: note,
              isCompleted: isCompleted,
            ));
          } catch (e) {
            errors
                .add('${localizations.invalidRowData} ${i + 1}: $e. Row: $row');
          }
        } else if (inSettingsSection) {
          const expectedSettingLength = 2;
          if (row.length != expectedSettingLength) {
            errors.add(
                '${localizations.invalidSettingFormat} ${i + 1}: Expected $expectedSettingLength, got ${row.length}. Row: $row');
            continue;
          }
          final String settingName = row[0].toString().trim();
          final String valueString = row[1].toString().trim();

          print(
              'DEBUG: Processing setting: $settingName with value: $valueString');

          try {
            switch (settingName) {
              case 'focusDuration':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  print('DEBUG: Setting focusDuration to $value from CSV.');
                  await controller.settingsService.setFocusDuration(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'shortBreakDuration':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  await controller.settingsService.setShortBreakDuration(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'longBreakDuration':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  await controller.settingsService.setLongBreakDuration(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'totalSessions':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  await controller.settingsService.setTotalSessions(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'reminder':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setReminder(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'isAlarm':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setIsAlarm(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'autoPlay':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setAutoPlay(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'torchAlerts':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setTorchAlerts(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'keepScreenOn':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setKeepScreenOn(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'dndToggle':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setDndToggle(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'language':
                await controller.settingsService.setLanguage(valueString);
                Get.updateLocale(Locale(valueString));
                break;
              case 'dailyReminderTimeHour':
                tempDailyReminderHour = int.tryParse(valueString);
                break;
              case 'dailyReminderTimeMinute':
                final int? minute = int.tryParse(valueString);
                if (tempDailyReminderHour != null && minute != null) {
                  final TimeOfDay time =
                      TimeOfDay(hour: tempDailyReminderHour, minute: minute);
                  await controller.settingsService.setDailyReminderTime(time);
                  controller.scheduleDailyReminder();
                } else if (valueString == 'null' &&
                    tempDailyReminderHour == null) {
                  await controller.settingsService.setDailyReminderTime(null);
                  controller.cancelDailyReminder();
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} dailyReminderTime on line ${i + 1}: Invalid hour or minute.');
                }
                tempDailyReminderHour = null;
                break;
              case 'startOfDay':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  await controller.settingsService.setStartOfDay(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'startOfWeek':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  await controller.settingsService.setStartOfWeek(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'themeMode':
                ThemeMode? parsedThemeMode;
                if (valueString == ThemeMode.light.toString()) {
                  parsedThemeMode = ThemeMode.light;
                } else if (valueString == ThemeMode.dark.toString()) {
                  parsedThemeMode = ThemeMode.dark;
                } else if (valueString == ThemeMode.system.toString()) {
                  parsedThemeMode = ThemeMode.system;
                }
                if (parsedThemeMode != null) {
                  await controller.settingsService
                      .setThemeMode(parsedThemeMode);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid ThemeMode.');
                }
                break;
              case 'selectedStatsLabel':
                if (valueString == 'null') {
                  await controller.settingsService.setSelectedStatsLabel(null);
                } else {
                  try {
                    final Map<String, dynamic> labelMap =
                        Map<String, dynamic>.from(jsonDecode(valueString));
                    await controller.settingsService
                        .setSelectedStatsLabel(labelMap);
                  } catch (e) {
                    errors.add(
                        '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid JSON label map. Error: $e');
                  }
                }
                break;
              case 'enableGlyphProgress':
                // Glyph related code removed, so this setting will be ignored during import.
                // You might want to handle it by logging a warning or just skipping it.
                print(
                    'Skipping import of enableGlyphProgress as it is removed.');
                break;
              case 'selectedPrimaryColorName':
                await controller.settingsService
                    .setSelectedPrimaryColorName(valueString);
                break;
              case 'selectedSecondaryColorName':
                await controller.settingsService
                    .setSelectedSecondaryColorName(valueString);
                break;
              case 'selectedTertiaryColorName':
                await controller.settingsService
                    .setSelectedTertiaryColorName(valueString);
                break;
              // NEW: Water Reminder Settings Import
              case 'waterReminderEnabled':
                if (valueString == 'true' || valueString == 'false') {
                  await controller.settingsService
                      .setWaterReminderEnabled(valueString == 'true');
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid boolean.');
                }
                break;
              case 'waterReminderIntervalMinutes':
                final int? value = int.tryParse(valueString);
                if (value != null) {
                  await controller.settingsService
                      .setWaterReminderIntervalMinutes(value);
                } else {
                  errors.add(
                      '${localizations.invalidSettingValue} $settingName on line ${i + 1}: "$valueString" is not a valid integer.');
                }
                break;
              case 'waterReminderType':
                await controller.settingsService
                    .setWaterReminderType(valueString);
                break;
              default:
                print('Unknown setting: $settingName on line ${i + 1}.');
            }
          } catch (e) {
            errors.add(
                '${localizations.invalidSettingValue} $settingName on line ${i + 1}: $e. Row: $row');
          }
        } else if (inLabelsSection) {
          print('DEBUG: Processing label row: $row');
          if (row.length < 2 ||
              row[0] == null ||
              row[1] == null ||
              row[0].toString().isEmpty ||
              row[1].toString().isEmpty) {
            errors.add(
                '${localizations.invalidLabelFormat} ${i + 1}: Label row is incomplete or malformed. Row: $row');
            print('DEBUG: Skipping malformed label row: $row');
            continue;
          }
          final String labelName = row[0].toString();
          final String colorValueString = row[1].toString();
          try {
            final int? colorValue = int.tryParse(colorValueString);
            if (colorValue != null) {
              importedLabels.add({
                'name': labelName,
                'color': colorValue,
              });
              print(
                  'DEBUG: Added label during import: {name: $labelName, color: $colorValue}');
            } else {
              errors.add(
                  '${localizations.invalidLabelValue} $labelName on line ${i + 1}: "$colorValueString" is not a valid color integer.');
            }
          } catch (e) {
            errors.add(
                '${localizations.invalidLabelValue} $labelName on line ${i + 1}: $e. Row: $row');
          }
        }
      }

      print(
          'DEBUG: Attempting to set labels. Imported labels collected: $importedLabels');
      if (importedLabels.isNotEmpty) {
        await controller.settingsService.setLabels(importedLabels);
        print('Successfully imported ${importedLabels.length} labels.');
      } else {
        await controller.settingsService.setLabels([]);
        print('No labels found in CSV, labels list cleared.');
      }

      Get.updateLocale(Locale(controller.settingsService.language.value));

      if (errors.isNotEmpty) {
        showDialog(
          context: context,
          builder: (dialogContext) => Dialog(
            backgroundColor: appColors.grey6,
            insetPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: MediaQuery.of(dialogContext).size.width * 0.85,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSettingText(
                    localizations.importErrors,
                    context: dialogContext,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: appColors.error,
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: errors
                            .map((e) => _buildSettingText(
                                  e,
                                  context: dialogContext,
                                  fontWeight: FontWeight.w500,
                                  color: appColors.error,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: appColors.grey5,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedTapEffect(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Get.back();
                        },
                        child: CustomButton(
                          onPressed: null,
                          text: localizations.ok,
                          color: appColors.primary,
                          borderRadius: 8,
                          textPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.small),
                          textColor: appColors.grey10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }

      Fluttertoast.showToast(
          msg: localizations.dataImportedSuccessfully(
              controller.settingsService.sessionsBox.length));
    } on PlatformException catch (e) {
      if (e.code == 'storage_permission_denied') {
        _showPermissionDeniedDialog(context, localizations, appColors);
      } else {
        print('PlatformException during import: ${e.code} - ${e.message}');
        Fluttertoast.showToast(
            msg: '${localizations.dataImportFailed}: ${e.message}');
      }
    } catch (e) {
      print('General error during import: $e');
      Fluttertoast.showToast(msg: '${localizations.dataImportFailed}: $e');
    }
  }

  /// Shows a detailed permission denied dialog.
  void _showPermissionDeniedDialog(BuildContext context,
      AppLocalizations localizations, AppThemeColors appColors) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: appColors.grey6,
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(dialogContext).size.width * 0.85,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingText(
                localizations.permissionRequired,
                context: dialogContext,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appColors.primary,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildSettingText(
                    localizations.importPermissionRationale,
                    context: dialogContext,
                    fontWeight: FontWeight.w500,
                    color: appColors.grey1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                color: appColors.grey5,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedTapEffect(
                    onTap: () {
                      Get.back();
                    },
                    child: CustomButton(
                      onPressed: null,
                      text: localizations.cancel,
                      color: appColors.grey3,
                      borderRadius: 8,
                      textPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                          vertical: AppSpacing.small),
                      textColor: appColors.grey10,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  AnimatedTapEffect(
                    onTap: () {
                      Get.back();
                      openAppSettings();
                    },
                    child: CustomButton(
                      onPressed: null,
                      text: localizations.openSettings,
                      color: appColors.primary,
                      borderRadius: 8,
                      textPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                          vertical: AppSpacing.small),
                      textColor: appColors.grey10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper function to compare two lists for equality.
  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return false; // Changed from return false to return true after the loop if all elements match
  }
}
