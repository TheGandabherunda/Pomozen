import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomozen/controllers/pomodoro_controller.dart';
import 'package:pomozen/services/settings_service.dart';
import 'package:pomozen/ui/screens/pomodoro_screen.dart';
import 'package:pomozen/ui/screens/statistics_screen.dart';

import '../../l10n/arb/app_localizations.dart';
import '../themes/app_theme.dart';

// Home Screen Widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final PomodoroController _pomodoroController;

  static final List<Widget> _widgetOptions = <Widget>[
    PomodoroScreen(),
    const StatisticsScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pomodoroController = Get.find<PomodoroController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settingsService = Get.find<SettingsService>();

      if (!settingsService.notificationPermissionAsked.value) {
        await settingsService.setNotificationPermissionAsked(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: appColors.grey7,
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: SizedBox(
            height: 88,
            child: BottomAppBar(
              color: appColors.grey7,
              elevation: 0,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: localizations.pomodoroTimer,
                    child: InkWell(
                      onTap: () => _onItemTapped(0),
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: Center(
                          child: Icon(
                            _selectedIndex == 0
                                ? Icons.timer_rounded
                                : Icons.timer_outlined,
                            size: 24,
                            color: _selectedIndex == 0
                                ? appColors.grey10
                                : appColors.grey3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: localizations.statistics,
                    child: InkWell(
                      onTap: () => _onItemTapped(1),
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: Center(
                          child: Icon(
                            _selectedIndex == 1
                                ? Icons.insert_chart_rounded
                                : Icons.insert_chart_outlined,
                            size: 24,
                            color: _selectedIndex == 1
                                ? appColors.grey10
                                : appColors.grey3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Ripple Effect Overlay
        Obx(
              () => _pomodoroController.triggerRippleAnimation.value
              ? AppleStyleRippleOverlay(
            key: UniqueKey(),
            onAnimationComplete: () {
              _pomodoroController.acknowledgeRippleAnimation();
            },
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// Apple-Style Ripple Effect Overlay
class AppleStyleRippleOverlay extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const AppleStyleRippleOverlay({
    Key? key,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  _AppleStyleRippleOverlayState createState() =>
      _AppleStyleRippleOverlayState();
}

class _AppleStyleRippleOverlayState extends State<AppleStyleRippleOverlay>
    with TickerProviderStateMixin {
  late AnimationController _masterController;

  late Animation<double> _primaryScale;
  late Animation<double> _primaryOpacity;
  late Animation<double> _secondaryScale;
  late Animation<double> _secondaryOpacity;
  late Animation<double> _tertiaryScale;
  late Animation<double> _tertiaryOpacity;
  late Animation<double> _backgroundBlur;
  late Animation<double> _backgroundOpacity;
  late Animation<double> _colorTransition;

  Color _primaryColor = Colors.transparent;
  Color _secondaryColor = Colors.transparent;
  Color _tertiaryColor = Colors.transparent;
  Color _backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _initializeDefaultAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appColors = AppTheme.colorsOf(context);
      setState(() {
        _primaryColor = appColors.primary;
        _secondaryColor = appColors.secondary;
        _tertiaryColor = appColors.tertiary;
        _backgroundColor = appColors.grey7;
      });

      _setupAnimations();
      _startAnimation();
    });
  }

  void _initializeDefaultAnimations() {
    _primaryScale = const AlwaysStoppedAnimation(0.0);
    _primaryOpacity = const AlwaysStoppedAnimation(0.0);
    _secondaryScale = const AlwaysStoppedAnimation(0.0);
    _secondaryOpacity = const AlwaysStoppedAnimation(0.0);
    _tertiaryScale = const AlwaysStoppedAnimation(0.0);
    _tertiaryOpacity = const AlwaysStoppedAnimation(0.0);
    _backgroundBlur = const AlwaysStoppedAnimation(0.0);
    _backgroundOpacity = const AlwaysStoppedAnimation(0.0);
    _colorTransition = const AlwaysStoppedAnimation(0.0);
  }

  void _setupAnimations() {
    const appleEaseIn = Cubic(0.42, 0.0, 0.58, 1.0);
    const appleEaseOut = Cubic(0.25, 0.8, 0.25, 1.0);

    _primaryScale = Tween<double>(
      begin: 0.0,
      end: 2.5,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.0, 0.65, curve: appleEaseIn),
    ));

    _primaryOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.35)
            .chain(CurveTween(curve: appleEaseIn)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.35, end: 0.2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 0.0)
            .chain(CurveTween(curve: appleEaseOut)),
        weight: 50.0,
      ),
    ]).animate(_masterController);

    _secondaryScale = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.1, 0.75, curve: appleEaseIn),
    ));

    _secondaryOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3)
            .chain(CurveTween(curve: appleEaseIn)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.15)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.15, end: 0.0)
            .chain(CurveTween(curve: appleEaseOut)),
        weight: 50.0,
      ),
    ]).animate(_masterController);

    _tertiaryScale = Tween<double>(
      begin: 0.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.2, 0.85, curve: appleEaseIn),
    ));

    _tertiaryOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.25)
            .chain(CurveTween(curve: appleEaseIn)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.25, end: 0.1)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.0)
            .chain(CurveTween(curve: appleEaseOut)),
        weight: 50.0,
      ),
    ]).animate(_masterController);

    _backgroundBlur = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 6.0)
            .chain(CurveTween(curve: appleEaseIn)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 6.0, end: 3.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 3.0, end: 0.0)
            .chain(CurveTween(curve: appleEaseOut)),
        weight: 50.0,
      ),
    ]).animate(_masterController);

    _backgroundOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.08)
            .chain(CurveTween(curve: appleEaseIn)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.08, end: 0.04)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.04, end: 0.0)
            .chain(CurveTween(curve: appleEaseOut)),
        weight: 50.0,
      ),
    ]).animate(_masterController);

    _colorTransition = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: appleEaseIn)),
        weight: 45.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: appleEaseOut)),
        weight: 55.0,
      ),
    ]).animate(_masterController);
  }

  void _startAnimation() {
    _masterController.forward();

    _masterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _masterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _masterController,
          builder: (context, _) {
            return Stack(
              children: [
                // Backdrop blur effect
                if (_backgroundBlur.value > 0)
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _backgroundBlur.value,
                      sigmaY: _backgroundBlur.value,
                    ),
                    child: Container(
                      color: _backgroundColor
                          .withOpacity(_backgroundOpacity.value),
                    ),
                  ),
                // Main ripple effect
                CustomPaint(
                  painter: EnhancedAppleRipplePainter(
                    primaryScale: _primaryScale.value,
                    primaryOpacity: _primaryOpacity.value,
                    secondaryScale: _secondaryScale.value,
                    secondaryOpacity: _secondaryOpacity.value,
                    tertiaryScale: _tertiaryScale.value,
                    tertiaryOpacity: _tertiaryOpacity.value,
                    colorTransition: _colorTransition.value,
                    screenSize: size,
                    primaryColor: _primaryColor,
                    secondaryColor: _secondaryColor,
                    tertiaryColor: _tertiaryColor,
                  ),
                  size: Size.infinite,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom Painter for Enhanced Apple Ripple Effect
class EnhancedAppleRipplePainter extends CustomPainter {
  final double primaryScale;
  final double primaryOpacity;
  final double secondaryScale;
  final double secondaryOpacity;
  final double tertiaryScale;
  final double tertiaryOpacity;
  final double colorTransition;
  final Size screenSize;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  EnhancedAppleRipplePainter({
    required this.primaryScale,
    required this.primaryOpacity,
    required this.secondaryScale,
    required this.secondaryOpacity,
    required this.tertiaryScale,
    required this.tertiaryOpacity,
    required this.colorTransition,
    required this.screenSize,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(screenSize.width / 2, screenSize.height - 20);
    final maxRadius = screenSize.longestSide * 0.8;

    final blendedPrimary = Color.lerp(
      primaryColor.withOpacity(0.35),
      secondaryColor.withOpacity(0.3),
      colorTransition * 0.4,
    )!;

    final blendedSecondary = Color.lerp(
      secondaryColor.withOpacity(0.3),
      tertiaryColor.withOpacity(0.25),
      colorTransition * 0.5,
    )!;

    final blendedTertiary = Color.lerp(
      tertiaryColor.withOpacity(0.25),
      primaryColor.withOpacity(0.15),
      colorTransition * 0.6,
    )!;

    // Drawing ripples
    if (tertiaryOpacity > 0) {
      _drawSmoothRipple(
        canvas,
        center,
        maxRadius * tertiaryScale,
        tertiaryOpacity,
        blendedTertiary,
        20.0,
      );
    }

    if (secondaryOpacity > 0) {
      _drawSmoothRipple(
        canvas,
        center,
        maxRadius * secondaryScale,
        secondaryOpacity,
        blendedSecondary,
        15.0,
      );
    }

    if (primaryOpacity > 0) {
      _drawSmoothRipple(
        canvas,
        center,
        maxRadius * primaryScale,
        primaryOpacity,
        blendedPrimary,
        10.0,
      );
    }

    // Drawing inner glow
    if (primaryOpacity > 0) {
      _drawInnerGlow(
          canvas, center, maxRadius * primaryScale * 0.4, primaryOpacity);
    }
  }

  void _drawSmoothRipple(Canvas canvas, Offset center, double radius,
      double opacity, Color color, double blurRadius) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        color.withOpacity(opacity * 0.6),
        color.withOpacity(opacity * 0.4),
        color.withOpacity(opacity * 0.2),
        color.withOpacity(opacity * 0.08),
        Colors.transparent,
      ],
      stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas.drawCircle(center, radius, paint);

    final rimPaint = Paint()
      ..color = color.withOpacity(opacity * 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius * 0.4);

    canvas.drawCircle(center, radius * 0.97, rimPaint);
  }

  void _drawInnerGlow(
      Canvas canvas, Offset center, double radius, double opacity) {
    final glowGradient = RadialGradient(
      colors: [
        primaryColor.withOpacity(opacity * 0.35),
        secondaryColor.withOpacity(opacity * 0.2),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final glowPaint = Paint()
      ..shader = glowGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20.0);

    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(EnhancedAppleRipplePainter oldDelegate) {
    return oldDelegate.primaryScale != primaryScale ||
        oldDelegate.primaryOpacity != primaryOpacity ||
        oldDelegate.secondaryScale != secondaryScale ||
        oldDelegate.secondaryOpacity != secondaryOpacity ||
        oldDelegate.tertiaryScale != tertiaryScale ||
        oldDelegate.tertiaryOpacity != tertiaryOpacity ||
        oldDelegate.colorTransition != colorTransition;
  }
}
