import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pomozen/controllers/pomodoro_controller.dart';
import 'package:pomozen/ui/themes/app_theme.dart';
import 'package:pomozen/ui/widget/custom_button.dart';
import 'package:pomozen/ui/widget/custom_text_field.dart';

import '../../l10n/arb/app_localizations.dart';

class PomodoroScreen extends StatefulWidget {
  PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
  final GlobalKey _labelKey = GlobalKey();
  final RxBool _isEditMode = false.obs;
  final RxBool _isDropdownOpen = false.obs;

  static const double labelBoxWidth = 220;
  static const double labelBoxHeight = 56;
  static const double labelPickerItemExtent = 48;

  late PomodoroController controller;
  FixedExtentScrollController? _wheelController;

  // Animation Controllers
  late AnimationController _resetButtonAnimationController;
  late AnimationController _playPauseButtonAnimationController;
  late AnimationController _skipButtonAnimationController;
  late AnimationController _timerAnimationController;
  late AnimationController _labelBoxAnimationController;
  late AnimationController _screenShrinkAnimationController;

  // Animation Values
  late Animation<double> _playPauseButtonScaleAnimation;
  late Animation<double> _timerScaleAnimation;
  late Animation<double> _labelBoxScaleAnimation;
  late Animation<double> _screenShrinkScaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PomodoroController>();

    _resetButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _playPauseButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _skipButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _timerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _labelBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _screenShrinkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _playPauseButtonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _playPauseButtonAnimationController,
      curve: Curves.easeOutCirc,
      reverseCurve: Curves.easeOutCirc,
    ));
    _timerScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _timerAnimationController,
      curve: Curves.easeOutCirc,
      reverseCurve: Curves.easeOutCirc,
    ));
    _labelBoxScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _labelBoxAnimationController,
      curve: Curves.easeOutCirc,
      reverseCurve: Curves.easeOutCirc,
    ));

    _screenShrinkScaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _screenShrinkAnimationController,
        curve: Curves.easeOutCirc,
        reverseCurve: Curves.fastOutSlowIn,
      ),
    );

    // Existing listener for session completion animation
    controller.triggerRippleAnimation.listen((shouldAnimate) {
      if (shouldAnimate) {
        // Add a mounted check to ensure the state is still active
        if (mounted) {
          _screenShrinkAnimationController.forward().then((_) {
            if (mounted) {
              _screenShrinkAnimationController.reverse();
            }
            controller.acknowledgeRippleAnimation();
          });
        }
      }
    });

    // NEW: Listener for app start animation
    controller.triggerAppStartAnimation.listen((shouldAnimate) {
      if (shouldAnimate) {
        if (mounted) {
          _screenShrinkAnimationController.forward().then((_) {
            if (mounted) {
              _screenShrinkAnimationController.reverse();
            }
            controller
                .acknowledgeAppStartAnimation(); // Acknowledge after animation
          });
        }
      }
    });

    // NEW: Immediate check for app start animation if already true (e.g., hot restart)
    if (controller.triggerAppStartAnimation.value) {
      if (mounted) {
        _screenShrinkAnimationController.forward().then((_) {
          if (mounted) {
            _screenShrinkAnimationController.reverse();
          }
          controller.acknowledgeAppStartAnimation();
        });
      }
    }
  }

  int _getLabelIndex(List<Map<String, dynamic>> labels,
      Map<String, dynamic>? currentLabel, AppLocalizations localizations) {
    if (currentLabel == null) return 0;
    final idx = labels.indexWhere((l) => l['name'] == currentLabel['name']);
    return idx >= 0 ? idx : 0;
  }

  @override
  void dispose() {
    // Dispose animation controllers
    _resetButtonAnimationController.dispose();
    _playPauseButtonAnimationController.dispose();
    _skipButtonAnimationController.dispose();
    _timerAnimationController.dispose();
    _labelBoxAnimationController.dispose();
    _screenShrinkAnimationController.dispose();

    _wheelController?.dispose();
    _isEditMode.close();
    _isDropdownOpen.close();
    super.dispose();
  }

  void _onButtonTapDown(AnimationController controller) {
    // Add mounted check before calling forward
    if (mounted) {
      controller.forward();
      _timerAnimationController.forward();
    }
  }

  void _onButtonTapUp(AnimationController controller) {
    // Add mounted check before calling reverse
    if (mounted) {
      controller.reverse();
      _timerAnimationController.reverse();
    }
  }

  void _onButtonTapCancel(AnimationController controller) {
    // Add mounted check before calling reverse
    if (mounted) {
      controller.reverse();
      _timerAnimationController.reverse();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.grey7,
      appBar: AppBar(
        backgroundColor: appColors.grey7,
        title: Text(
          localizations.pomodoroTimer,
          style: TextStyle(
            fontFamily: 'OpenRunde',
            fontSize: 24,
            height: 1.6,
            letterSpacing: -0.4,
            color: appColors.grey10,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: appColors.primary,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: AnimatedBuilder(
          animation: _screenShrinkScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _screenShrinkScaleAnimation.value,
              child: child,
            );
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(() => _buildCupertinoLabelPicker(
                    context, appColors, localizations)),
                const SizedBox(height: 80),
                AnimatedBuilder(
                  animation: _timerScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _timerScaleAnimation.value,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Center(
                      child: Obx(() {
                        final appColors = AppTheme.colorsOf(context);
                        Color progressColor;
                        Color backgroundColor;

                        Color activeSessionColor;
                        switch (controller.currentMode.value) {
                          case PomodoroMode.focus:
                            activeSessionColor = appColors.primary;
                            break;
                          case PomodoroMode.shortBreak:
                            activeSessionColor = appColors.secondary;
                            break;
                          case PomodoroMode.longBreak:
                            activeSessionColor = appColors.tertiary;
                            break;
                        }

                        switch (controller.currentMode.value) {
                          case PomodoroMode.focus:
                            progressColor = appColors.primary;
                            backgroundColor =
                                appColors.primary.withOpacity(0.2);
                            break;
                          case PomodoroMode.shortBreak:
                            progressColor = appColors.secondary;
                            backgroundColor =
                                appColors.secondary.withOpacity(0.2);
                            break;
                          case PomodoroMode.longBreak:
                            progressColor = appColors.tertiary;
                            backgroundColor =
                                appColors.tertiary.withOpacity(0.2);
                            break;
                        }

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Replaced custom CircularProgress with CircularProgressIndicator
                            SizedBox(
                              width: 260,
                              height: 260,
                              child: CircularProgressIndicator(
                                value: controller.progress.value,
                                year2023: false,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    progressColor),
                                backgroundColor: backgroundColor,
                                strokeWidth: 16,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(controller.currentTime.value),
                                  style: TextStyle(
                                    fontFamily: 'OpenRunde',
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.grey10,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: activeSessionColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  child: Text(
                                    _getModeText(controller.currentMode.value,
                                        localizations),
                                    style: TextStyle(
                                      fontFamily: 'OpenRunde',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: appColors.grey10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Opacity(
                            opacity: controller.isRunning.value ? 0.5 : 1.0,
                            child: AbsorbPointer(
                              absorbing: controller.isRunning.value,
                              child: _buildActionButton(
                                icon: Icons.refresh,
                                onPressed: controller.resetTimer,
                                appColors: appColors,
                                animationController:
                                    _resetButtonAnimationController,
                                heroTag:
                                    'refresh_button_${Icons.refresh.codePoint}',
                              ),
                            ),
                          ),
                          _buildPlayPauseButton(
                            isRunning: controller.isRunning.value,
                            onPlay: controller.startTimer,
                            onPause: controller.pauseTimer,
                            appColors: appColors,
                            localizations: localizations,
                            animationController:
                                _playPauseButtonAnimationController,
                            scaleAnimation: _playPauseButtonScaleAnimation,
                          ),
                          _buildActionButton(
                            icon: Icons.skip_next,
                            onPressed: controller.skipToNextMode,
                            appColors: appColors,
                            animationController: _skipButtonAnimationController,
                            heroTag: 'skip_button_${Icons.skip_next.codePoint}',
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  Color activeSessionColor;
                  switch (controller.currentMode.value) {
                    case PomodoroMode.focus:
                      activeSessionColor = appColors.primary;
                      break;
                    case PomodoroMode.shortBreak:
                      activeSessionColor = appColors.secondary;
                      break;
                    case PomodoroMode.longBreak:
                      activeSessionColor = appColors.tertiary;
                      break;
                  }
                  return _buildSessionBarGraph(
                    controller.totalSessions.value,
                    controller.currentSession.value,
                    controller.isRunning.value,
                    appColors,
                    controller.progress.value,
                    activeSessionColor,
                  );
                }),
                const SizedBox(height: 8),
                Obx(() => Text(
                      localizations.sessionOfSessions(
                        controller.currentSession.value,
                        controller.totalSessions.value,
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenRunde',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: appColors.grey3,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialogs
  Future<void> _showAddLabelDialog(BuildContext context) async {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final namedColors = AppTheme.getNamedColors(Theme.of(context).brightness);
    Color selectedColor = namedColors['Orange'] ?? Colors.blue;
    final availableColors = namedColors.values.toList();

    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: appColors.grey6,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(localizations.addLabel,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: appColors.grey10,
                    )),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        final Map<Color, AnimationController> colorControllers =
                            {};
                        final Map<Color, Animation<double>>
                            colorScaleAnimations = {};

                        for (final color in availableColors) {
                          if (!colorControllers.containsKey(color)) {
                            colorControllers[color] = AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 250),
                              lowerBound: 0.0,
                              upperBound: 0.1,
                            );
                            colorScaleAnimations[color] =
                                Tween<double>(begin: 1.0, end: 0.9).animate(
                              CurvedAnimation(
                                parent: colorControllers[color]!,
                                curve: Curves.easeOutCirc,
                                reverseCurve: Curves.easeOutCirc,
                              ),
                            );
                          }
                        }

                        // Ensure controllers are disposed when the dialog is popped
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!Navigator.canPop(context)) {
                            colorControllers.values
                                .forEach((controller) => controller.dispose());
                          }
                        });

                        void onColorBoxTapDown(AnimationController controller) {
                          if (mounted) controller.forward();
                        }

                        void onColorBoxTapUp(AnimationController controller) {
                          if (mounted) controller.reverse();
                        }

                        void onColorBoxTapCancel(
                            AnimationController controller) {
                          if (mounted) controller.reverse();
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: nameController,
                              hintText: localizations.labelName,
                              fillColor: appColors.grey6,
                              borderColor: appColors.grey4,
                              focusedBorderColor: appColors.primary,
                              enabledBorderColor: appColors.primary,
                              textColor: appColors.grey10,
                              hintTextColor: appColors.grey2,
                              isInputValid: true,
                              onSubmitted: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              errorBorderColor: appColors.error,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              localizations.labelColor,
                              style: TextStyle(
                                fontFamily: 'OpenRunde',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: appColors.grey10,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: availableColors.map((color) {
                                  final isSelected = selectedColor == color;
                                  final currentController =
                                      colorControllers[color]!;
                                  final currentScaleAnimation =
                                      colorScaleAnimations[color]!;

                                  return AnimatedColorBox(
                                    key: ValueKey(color),
                                    color: color,
                                    isSelected: isSelected,
                                    appColors: appColors,
                                    scaleAnimation: currentScaleAnimation,
                                    onTapDown: () =>
                                        onColorBoxTapDown(currentController),
                                    onTapUp: () =>
                                        onColorBoxTapUp(currentController),
                                    onTapCancel: () =>
                                        onColorBoxTapCancel(currentController),
                                    onTap: () {
                                      setState(() {
                                        selectedColor = color;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(
                  color: appColors.grey4,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedCustomButton(
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: localizations.cancel,
                        color: appColors.grey3,
                        textColor: appColors.grey10),
                    const SizedBox(width: 12),
                    AnimatedCustomButton(
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isEmpty) {
                            Fluttertoast.showToast(
                                msg: localizations.labelNameCannotBeEmpty);
                            return;
                          }
                          final currentLabels =
                              controller.settingsService.labels.value;
                          if (currentLabels.any((label) =>
                              label['name'].toString().toLowerCase() ==
                              name.toLowerCase())) {
                            Fluttertoast.showToast(
                                msg: localizations.labelAlreadyExists);
                            return;
                          }
                          controller.addLabel(name, selectedColor);
                          HapticFeedback.mediumImpact();
                          Navigator.pop(context);
                        },
                        text: localizations.save,
                        color: appColors.primary,
                        textColor: appColors.grey10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditLabelDialog(
      BuildContext context, Map<String, dynamic> label) async {
    final appColors = AppTheme.colorsOf(context);
    final localizations = AppLocalizations.of(context);
    final nameController = TextEditingController(text: label['name']);
    final namedColors = AppTheme.getNamedColors(Theme.of(context).brightness);
    final availableColors = namedColors.values.toList();
    Color selectedColor = availableColors.firstWhere(
      (c) => c.value == label['color'],
      orElse: () => availableColors.first,
    );

    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: appColors.grey6,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(localizations.editLabel,
                    style: TextStyle(
                      fontFamily: 'OpenRunde',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: appColors.grey10,
                    )),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        final Map<Color, AnimationController> colorControllers =
                            {};
                        final Map<Color, Animation<double>>
                            colorScaleAnimations = {};

                        for (final color in availableColors) {
                          if (!colorControllers.containsKey(color)) {
                            colorControllers[color] = AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 150),
                              lowerBound: 0.0,
                              upperBound: 0.1,
                            );
                            colorScaleAnimations[color] =
                                Tween<double>(begin: 1.0, end: 0.9).animate(
                              CurvedAnimation(
                                parent: colorControllers[color]!,
                                curve: Curves.easeOutCirc,
                                reverseCurve: Curves.easeOutCirc,
                              ),
                            );
                          }
                        }

                        // Ensure controllers are disposed when the dialog is popped
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!Navigator.canPop(context)) {
                            colorControllers.values
                                .forEach((controller) => controller.dispose());
                          }
                        });

                        void onColorBoxTapDown(AnimationController controller) {
                          if (mounted) controller.forward();
                        }

                        void onColorBoxTapUp(AnimationController controller) {
                          if (mounted) controller.reverse();
                        }

                        void onColorBoxTapCancel(
                            AnimationController controller) {
                          if (mounted) controller.reverse();
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: nameController,
                              hintText: localizations.labelName,
                              fillColor: appColors.grey6,
                              borderColor: appColors.grey4,
                              focusedBorderColor: appColors.primary,
                              enabledBorderColor: appColors.primary,
                              textColor: appColors.grey10,
                              hintTextColor: appColors.grey2,
                              isInputValid: true,
                              onSubmitted: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              errorBorderColor: appColors.error,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              localizations.labelColor,
                              style: TextStyle(
                                fontFamily: 'OpenRunde',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: appColors.grey10,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: availableColors.map((color) {
                                  final isSelected = selectedColor == color;
                                  final currentController =
                                      colorControllers[color]!;
                                  final currentScaleAnimation =
                                      colorScaleAnimations[color]!;

                                  return AnimatedColorBox(
                                    key: ValueKey(color),
                                    color: color,
                                    isSelected: isSelected,
                                    appColors: appColors,
                                    scaleAnimation: currentScaleAnimation,
                                    onTapDown: () =>
                                        onColorBoxTapDown(currentController),
                                    onTapUp: () =>
                                        onColorBoxTapUp(currentController),
                                    onTapCancel: () =>
                                        onColorBoxTapCancel(currentController),
                                    onTap: () {
                                      setState(() {
                                        selectedColor = color;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(
                  color: appColors.grey3,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedCustomButton(
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: localizations.cancel,
                        color: appColors.grey3,
                        textColor: appColors.grey10),
                    const SizedBox(width: 12),
                    AnimatedCustomButton(
                        borderRadius: 8,
                        textPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isEmpty) {
                            Fluttertoast.showToast(
                                msg: localizations.labelNameCannotBeEmpty);
                            return;
                          }
                          final currentLabels =
                              controller.settingsService.labels.value;
                          if (currentLabels.any((l) =>
                              l['name'].toString().toLowerCase() ==
                                  name.toLowerCase() &&
                              l['name'] != label['name'])) {
                            Fluttertoast.showToast(
                                msg: localizations.labelAlreadyExists);
                            return;
                          }
                          final updatedLabel = {
                            'name': name,
                            'color': selectedColor.value,
                          };
                          controller.updateLabel(label, updatedLabel);
                          HapticFeedback.mediumImpact();
                          Navigator.pop(context);
                        },
                        text: localizations.save,
                        color: appColors.primary,
                        textColor: appColors.grey10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Label Picker
  Widget _buildCupertinoLabelPicker(
    BuildContext context,
    AppThemeColors appColors,
    AppLocalizations localizations,
  ) {
    final labels = [
      {'name': localizations.unlabeled, 'color': appColors.grey4.value},
      ...controller.settingsService.labels.value,
    ];
    int initialIndex =
        _getLabelIndex(labels, controller.currentLabel.value, localizations);

    _wheelController?.dispose();
    _wheelController = FixedExtentScrollController(initialItem: initialIndex);

    void onSelectedItemChanged(int idx) {
      HapticFeedback.lightImpact();
      final label = labels[idx];
      controller.selectLabel(
        label['name'] == localizations.unlabeled ? null : label,
      );
    }

    return AnimatedBuilder(
      animation: _labelBoxScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _labelBoxScaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        key: _labelKey,
        width: labelBoxWidth,
        height: labelBoxHeight,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollStartNotification) {
                  // Add mounted check before calling forward
                  if (mounted) _labelBoxAnimationController.forward();
                } else if (notification is ScrollEndNotification) {
                  // Add mounted check before calling reverse
                  if (mounted) _labelBoxAnimationController.reverse();
                }
                return false;
              },
              child: ListWheelScrollView.useDelegate(
                controller: _wheelController!,
                itemExtent: labelPickerItemExtent,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.0,
                perspective: 0.002,
                diameterRatio: 1.5,
                onSelectedItemChanged: onSelectedItemChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: labels.length,
                  builder: (context, idx) {
                    final label = labels[idx];
                    return Obx(() {
                      final isSelected =
                          (controller.currentLabel.value == null && idx == 0) ||
                              (controller.currentLabel.value != null &&
                                  controller.currentLabel.value!['name'] ==
                                      label['name']);
                      final color = Color(label['color']);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              label['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'OpenRunde',
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                color: isSelected
                                    ? appColors.grey10
                                    : appColors.grey2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                        ],
                      );
                    });
                  },
                ),
              ),
            ),
            IgnorePointer(
              child: Container(
                height: labelPickerItemExtent,
                width: labelBoxWidth,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                // Add mounted check before calling forward
                onTapDown: (_) {
                  if (mounted) _labelBoxAnimationController.forward();
                },
                onTap: () async {
                  HapticFeedback.lightImpact();
                  _isDropdownOpen.value = true;
                  final RenderBox renderBox =
                      _labelKey.currentContext!.findRenderObject() as RenderBox;
                  final Offset offset = renderBox.localToGlobal(Offset.zero);
                  final Size size = renderBox.size;

                  await showMenu<void>(
                    elevation: 0,
                    color: appColors.grey5,
                    context: context,
                    position: RelativeRect.fromLTRB(
                      offset.dx + size.width,
                      offset.dy + size.height - 6,
                      offset.dx,
                      offset.dy + size.height + 300,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    constraints: BoxConstraints.tightFor(width: size.width),
                    items: [
                      ...labels.map((label) {
                        final isDefault =
                            label['name'] == localizations.unlabeled;
                        final color = Color(label['color']);
                        return PopupMenuItem<void>(
                          height: 40,
                          value: label,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              if (_isEditMode.value && !isDefault) {
                                await _showEditLabelDialog(context, label);
                                _isEditMode.value = false;
                              } else {
                                controller
                                    .selectLabel(isDefault ? null : label);
                                final newIndex = _getLabelIndex(
                                    labels,
                                    controller.currentLabel.value,
                                    localizations);
                                if (_wheelController != null) {
                                  // Add mounted check before animating
                                  if (mounted) {
                                    _wheelController!.animateToItem(
                                      newIndex,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    label['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'OpenRunde',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: appColors.grey10,
                                    ),
                                  ),
                                ),
                                if (!isDefault)
                                  Obx(
                                    () => InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        if (_isEditMode.value) {
                                          await _showEditLabelDialog(
                                              context, label);
                                          _isEditMode.value = false;
                                        } else {
                                          _showDeleteLabelConfirmation(context,
                                              label, localizations, appColors);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.grey4,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        height: 32,
                                        width: 32,
                                        child: Center(
                                          child: Icon(
                                            _isEditMode.value
                                                ? Icons.edit
                                                : Icons.delete,
                                            color: _isEditMode.value
                                                ? appColors.primary
                                                : appColors.error,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                      PopupMenuDivider(
                        color: appColors.grey4,
                      ),
                      PopupMenuItem<void>(
                        enabled: false,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => AnimatedCustomButton(
                                  textPadding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 8),
                                  text: _isEditMode.value
                                      ? localizations.done
                                      : localizations.edit,
                                  color: appColors.grey3,
                                  icon: _isEditMode.value
                                      ? Icons.check
                                      : Icons.edit,
                                  iconSize: 20,
                                  textSize: 14,
                                  borderRadius: 8,
                                  onPressed: () {
                                    _isEditMode.value = !_isEditMode.value;
                                  },
                                  textColor: appColors.grey10)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: AnimatedCustomButton(
                                    textPadding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8),
                                    text: localizations.add,
                                    color: appColors.primary,
                                    icon: Icons.add,
                                    iconSize: 20,
                                    textSize: 14,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showAddLabelDialog(context);
                                    },
                                    textColor: appColors.grey10)),
                          ],
                        ),
                      ),
                    ],
                  ).then((_) {
                    _isDropdownOpen.value = false;
                    _isEditMode.value = false;
                    // Add mounted check before calling reverse
                    if (mounted) _labelBoxAnimationController.reverse();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.grey5,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => AnimatedRotation(
                        turns: _isDropdownOpen.value ? -0.5 : 0.0,
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

  // Helper Functions
  String _formatTime(double seconds) {
    int totalSeconds = (seconds + 0.5).floor();
    if (totalSeconds < 0) totalSeconds = 0;
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getModeText(PomodoroMode mode, AppLocalizations localizations) {
    switch (mode) {
      case PomodoroMode.focus:
        return localizations.focus;
      case PomodoroMode.shortBreak:
        return localizations.shortBreak;
      case PomodoroMode.longBreak:
        return localizations.longBreak;
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required AppThemeColors appColors,
    required AnimationController animationController,
    required String heroTag,
  }) {
    return GestureDetector(
      onTapDown: (_) => _onButtonTapDown(animationController),
      onTapUp: (_) => _onButtonTapUp(animationController),
      onTapCancel: () => _onButtonTapCancel(animationController),
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: Tween<double>(begin: 1.0, end: 0.9)
                .animate(CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeOutCirc,
                  reverseCurve: Curves.easeOutCirc,
                ))
                .value,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: appColors.grey3.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: FloatingActionButton(
                    heroTag: heroTag,
                    highlightElevation: 0,
                    onPressed: null,
                    backgroundColor: Colors.transparent,
                    foregroundColor: appColors.grey2,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(icon, size: 24),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayPauseButton({
    required bool isRunning,
    required VoidCallback onPlay,
    required VoidCallback onPause,
    required AppThemeColors appColors,
    required AppLocalizations localizations,
    required AnimationController animationController,
    required Animation<double> scaleAnimation,
  }) {
    Color activeSessionColor;
    switch (controller.currentMode.value) {
      case PomodoroMode.focus:
        activeSessionColor = appColors.primary;
        break;
      case PomodoroMode.shortBreak:
        activeSessionColor = appColors.secondary;
        break;
      case PomodoroMode.longBreak:
        activeSessionColor = appColors.tertiary;
        break;
    }

    return GestureDetector(
      onTapDown: (_) => _onButtonTapDown(animationController),
      onTapUp: (_) => _onButtonTapUp(animationController),
      onTapCancel: () => _onButtonTapCancel(animationController),
      onTap: () {
        HapticFeedback.lightImpact();
        isRunning ? onPause() : onPlay();
      },
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    highlightElevation: 0,
                    heroTag: 'playPause',
                    onPressed: null,
                    backgroundColor: activeSessionColor.withOpacity(0.5),
                    foregroundColor: appColors.grey10,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 64,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionBarGraph(
      int totalSessions,
      int currentSession,
      bool isRunning,
      AppThemeColors appColors,
      double currentProgress,
      Color activeSessionColor) {
    return Container(
      height: 32,
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(totalSessions, (index) {
          final isCurrentSession = (index + 1) == currentSession;
          final isCompletedSession = (index + 1) < currentSession;
          double barHeight = 12;
          Color barColor = appColors.grey4;
          if (isCurrentSession && isRunning) {
            barHeight = 12 + (32 - 12) * currentProgress;
            barColor = activeSessionColor;
          } else if (isCompletedSession) {
            barHeight = 32;
            barColor = activeSessionColor.withOpacity(0.5);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 12,
              height: barHeight,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showDeleteLabelConfirmation(
      BuildContext context,
      Map<String, dynamic> label,
      AppLocalizations localizations,
      AppThemeColors appColors) {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
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
                localizations.deleteLabel,
                context: dialogContext,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appColors.error,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildSettingText(
                    localizations.deleteLabelConfirmation(label['name']),
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
                  AnimatedCustomButton(
                    borderRadius: 8,
                    textPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    text: localizations.cancel,
                    color: appColors.grey3,
                    textColor: appColors.grey10,
                  ),
                  const SizedBox(width: 8),
                  AnimatedCustomButton(
                    borderRadius: 8,
                    textPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onPressed: () {
                      controller.deleteLabel(label);
                      Navigator.pop(dialogContext);
                    },
                    text: localizations.delete,
                    color: appColors.error,
                    textColor: appColors.grey10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widgets
// Removed the custom CircularProgress and CircularProgressPainter classes
// as they are no longer needed after replacing with Material CircularProgressIndicator.

class AnimatedCustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final double? iconSize;
  final double? textSize;
  final double borderRadius;
  final EdgeInsetsGeometry textPadding;
  final RxBool? isEnabled;

  const AnimatedCustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.color,
    required this.textColor,
    this.icon,
    this.iconSize,
    this.textSize,
    this.borderRadius = 8,
    this.textPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.isEnabled,
  }) : super(key: key);

  @override
  _AnimatedCustomButtonState createState() => _AnimatedCustomButtonState();
}

class _AnimatedCustomButtonState extends State<AnimatedCustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCirc,
      reverseCurve: Curves.easeOutCirc,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    // Add mounted check before calling forward
    if (mounted) _animationController.forward();
  }

  void _onTapUp() {
    // Add mounted check before calling reverse
    if (mounted) _animationController.reverse();
  }

  void _onTapCancel() {
    // Add mounted check before calling reverse
    if (mounted) _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      onTap: () {
        if (widget.isEnabled == null || widget.isEnabled!.value) {
          HapticFeedback.lightImpact();
          widget.onPressed();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: CustomButton(
              onPressed: null,
              text: widget.text,
              color: widget.color,
              textColor: widget.textColor,
              icon: widget.icon,
              iconSize: widget.iconSize ?? 24.0,
              textSize: widget.textSize ?? 14.0,
              borderRadius: widget.borderRadius,
              textPadding: widget.textPadding as EdgeInsets,
            ),
          );
        },
      ),
    );
  }
}

class AnimatedColorBox extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final AppThemeColors appColors;
  final VoidCallback onTap;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final Animation<double> scaleAnimation;

  const AnimatedColorBox({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.appColors,
    required this.onTap,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.scaleAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapCancel(),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: appColors.grey10, width: 2)
                    : null,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: appColors.grey10)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
