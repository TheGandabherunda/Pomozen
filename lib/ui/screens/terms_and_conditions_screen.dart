import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../l10n/arb/app_localizations.dart';
import '../themes/app_theme.dart';

class TermsAndConditionsScreen extends GetView {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context)!;

    // List of third-party libraries
    final List<String> thirdPartyLibraries = [
      'csv',
      'file_picker',
      'flutter_local_notifications',
      'fl_chart',
      'fluttertoast',
      'get',
      'hive',
      'hive_flutter',
      'intl',
      'wakelock_plus',
      'permission_handler',
      'do_not_disturb',
      'flutter_heatmap_calendar',
      'flutter_timezone',
      'android_intent_plus',
      'pie_chart_sz',
      'smooth_corner',
      'awesome_notifications',
    ];

    return Scaffold(
      backgroundColor: appColors.grey7,
      appBar: AppBar(
        backgroundColor: appColors.grey7,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              size: 24, color: appColors.primary),
          onPressed: () {
            HapticFeedback.lightImpact();
            Get.back();
          },
        ),
        title: Text(
          localizations.termsAndConditions ?? 'Terms & Conditions',
          style: TextStyle(
            fontFamily: 'OpenRunde',
            fontSize: 24,
            height: 1.3,
            letterSpacing: -0.4,
            color: appColors.grey10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Section
            Text(
              localizations.termsAndConditionsIntro ??
                  'Welcome to Pomozen! This document outlines the terms and conditions for using our application.',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontStyle: FontStyle.italic,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 32),

            // Open Source Section
            Text(
              localizations.openSourceTitle,
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.grey10,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.openSourceContent ??
                  'Pomozen is an open-source application. This means its source code is publicly available for anyone to inspect, modify, and distribute. We believe in transparency and community collaboration.',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 32),

            // No Data Collection Section
            Text(
              localizations.dataCollectionTitle ?? 'No Data Collection',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.grey10,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.dataCollectionContent ??
                  'We value your privacy. Pomozen does not collect any personal data or usage statistics from its users. All your session data and settings are stored locally on your device and are not transmitted to any external servers.',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 32),

            // Disclaimer Section
            Text(
              localizations.disclaimerTitle ?? 'Disclaimer of Liability',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.grey10,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.disclaimerContent ??
                  'Pomozen is provided "as is" without any warranties, express or implied. We are not responsible for any direct, indirect, incidental, consequential, or special damages arising out of or in any way connected with the use or inability to use this application. While we strive for accuracy and reliability, we cannot guarantee that the app will be error-free or uninterrupted.',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 32),

            // Third-Party Libraries Section
            Text(
              localizations.thirdPartyLibrariesTitle ?? 'Third-Party Libraries',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.grey10,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.thirdPartyLibrariesIntro ??
                  'This application utilizes the following third-party libraries, each governed by its own license:',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: thirdPartyLibraries
                  .map(
                    (library) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        '• $library',
                        style: TextStyle(
                          fontFamily: 'OpenRunde',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: appColors.grey1,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),

            // End of Terms and Conditions Section
            Text(
              localizations.termsAndConditionsEnd ??
                  'By using Pomozen, you agree to these terms and conditions. If you do not agree with any part of these terms, you must not use the application.',
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
