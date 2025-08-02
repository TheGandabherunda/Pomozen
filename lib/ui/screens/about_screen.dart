import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../../l10n/arb/app_localizations.dart';
import '../themes/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      print('Error getting app version: $e');
      setState(() {
        _appVersion = 'N/A';
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context)!;

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
          localizations.aboutApp ?? 'About App',
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
            // App Icon, Name, Description, Version
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // App Icon
                  Image.asset(
                    'assets/app_icon.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.apps,
                        size: 80,
                        color: appColors.primary,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  Text(
                    localizations.pomodoroTimer ?? 'Pomozen',
                    // Localized app name
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appColors.grey10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${localizations.appVersion ?? 'Version'}: $_appVersion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 14,
                      color: appColors.grey2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              localizations.appDescription ??
                  'A Pomodoro timer app with Material Design 3, offline support, and customizable settings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 32),

            // Key Features Section
            Text(
              localizations.featuresTitle ?? 'Key Features',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.grey10,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    localizations.featureStatistics ??
                        '• Comprehensive Statistics with separate labels for detailed tracking.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: appColors.grey1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    localizations.featureReminders ??
                        '• Customizable Reminders to keep you on track.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: appColors.grey1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    localizations.featureHydrationReminder ??
                        '• Hydration Reminder to help you stay hydrated throughout the day.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: appColors.grey1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Open Source Section
            Text(
              localizations.openSourceTitle ?? 'Open Source',
              textAlign: TextAlign.start,
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
              textAlign: TextAlign.start,
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
              textAlign: TextAlign.start,
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
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.grey1,
              ),
            ),
            const SizedBox(height: 32),

            // Links Section
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
            Column(
              children: [
                ListTile(
                  title: Text(
                    localizations.sourceCodeLink ?? 'Source Code',
                    // Localized source code link
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: appColors.primary, // Make it look like a link
                    ),
                  ),
                  trailing: Icon(Icons.open_in_new,
                      size: 20, color: appColors.primary),
                  onTap: () =>
                      _launchURL(
                          'https://github.com/ProjectSolutus/Pomozen.git'), // Example link
                ),
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
                  onTap: () =>
                      _sendEmail(
                          'arunuserx@gmail.com', 'Feedback about Pomozen'),
                ),
                // ListTile(
                //   title: Text(
                //     localizations.fdroidLink ?? 'Fdroid Link',
                //     // Localized F-Droid link
                //     style: TextStyle(
                //       fontFamily: 'OpenRunde',
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //       color: appColors.primary,
                //     ),
                //   ),
                //   trailing: Icon(Icons.open_in_new,
                //       size: 20, color: appColors.primary),
                //   onTap: () => _launchURL(
                //       'https://f-droid.org/packages/com.example.pomozen/'), // Example link
                // ),
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
                  onTap: () =>
                      _launchURL(
                          'https://thegandabherunda.github.io/Pomozen/privacy_policy'), // Example link
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Add some space before the thank you message

            // Thank You Message
            Center(
              child: Text(
                localizations.thankYouMessage ??
                    'Thank you for choosing Pomozen to enhance your productivity!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenRunde',
                  fontSize: 14,
                  color: appColors.grey1,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
