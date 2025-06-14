import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pie_chart_sz/ValueSettings.dart';
import 'package:pie_chart_sz/pie_chart_sz.dart';
import 'package:pomozen/controllers/pomodoro_controller.dart';
import 'package:pomozen/ui/themes/app_theme.dart';
import 'package:pomozen/ui/widget/custom_button.dart';
import 'package:pomozen/ui/widget/custom_text_field.dart';

import '../../l10n/arb/app_localizations.dart';

part 'statistics_screen.g.dart';

/// Represents a single session data entry for statistics.
@HiveType(typeId: 0)
class SessionData extends HiveObject {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final int focusMinutes;
  @HiveField(2)
  final String? note;
  @HiveField(3)
  final String? labelName;
  @HiveField(4)
  final bool isCompleted;
  @HiveField(5)
  final DateTime startTime;

  SessionData(this.startTime, this.date, this.focusMinutes,
      {this.note, this.labelName, this.isCompleted = true});

  factory SessionData.fromMap(Map<dynamic, dynamic> map) {
    return SessionData(
      DateTime.parse(map['startTime'] as String),
      DateTime.parse(map['date'] as String),
      map['focusMinutes'] as int,
      note: map['note'] as String?,
      labelName: map['labelName'] as String?,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'date': date.toIso8601String(),
      'note': note,
      'labelName': labelName,
      'isCompleted': isCompleted,
      'focusMinutes': focusMinutes,
    };
  }
}

/// The main screen for displaying statistics.
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  final PomodoroController controller = Get.find<PomodoroController>();
  late ScrollController _dailyChartScrollController;
  late ScrollController _weeklyChartScrollController;

  late final Function() _sessionsListener;

  final RxBool _showAllHistory = false.obs;

  final RxString _selectedHistorySortOption = 'date_desc'.obs;

  late AnimationController _startButtonAnimationController;
  late AnimationController _viewButtonAnimationController;
  late AnimationController _editDeleteIconAnimationController;
  late AnimationController _addLabelButtonAnimationController;
  late AnimationController _saveButtonAnimationController;
  late AnimationController _cancelButtonAnimationController;

  late Animation<double> _startButtonScaleAnimation;
  late Animation<double> _viewButtonScaleAnimation;
  late Animation<double> _editDeleteIconScaleAnimation;
  late Animation<double> _addLabelButtonScaleAnimation;
  late Animation<double> _saveButtonScaleAnimation;
  late Animation<double> _cancelButtonScaleAnimation;

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

  @override
  void initState() {
    super.initState();
    _dailyChartScrollController = ScrollController();
    _weeklyChartScrollController = ScrollController();

    _startButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _viewButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _editDeleteIconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _addLabelButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _saveButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _cancelButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _startButtonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _startButtonAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
    _viewButtonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _viewButtonAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
    _editDeleteIconScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _editDeleteIconAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
    _addLabelButtonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _addLabelButtonAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
    _saveButtonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _saveButtonAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
    _cancelButtonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _cancelButtonAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTodayDailyChart();
      _scrollToTodayWeeklyChart();
    });

    _sessionsListener = () {
      if (mounted) {
        setState(() {});
      }
    };

    controller.settingsService.sessionsBox
        .listenable()
        .addListener(_sessionsListener);
  }

  @override
  void dispose() {
    _dailyChartScrollController.dispose();
    _weeklyChartScrollController.dispose();

    _startButtonAnimationController.dispose();
    _viewButtonAnimationController.dispose();
    _editDeleteIconAnimationController.dispose();
    _addLabelButtonAnimationController.dispose();
    _saveButtonAnimationController.dispose();
    _cancelButtonAnimationController.dispose();

    controller.settingsService.sessionsBox
        .listenable()
        .removeListener(_sessionsListener);
    _showAllHistory.close();
    _selectedHistorySortOption.close();
    super.dispose();
  }

  /// Handles tap down animation for buttons.
  void _onButtonTapDown(AnimationController controller) {
    controller.forward();
  }

  /// Handles tap up animation for buttons.
  void _onButtonTapUp(AnimationController controller) {
    controller.reverse();
  }

  /// Handles tap cancel animation for buttons.
  void _onButtonTapCancel(AnimationController controller) {
    controller.reverse();
  }

  /// Scrolls the daily trends chart to center on the current day.
  void _scrollToTodayDailyChart() {
    const int todayIndex = 60;
    const double barWidth = 24.0;
    const double groupSpace = 32.0;
    const double barGroupTotalWidth = (barWidth * 3) + groupSpace;

    final double screenWidth =
        MediaQuery.of(context).size.width - 32.0;
    final double targetOffset = (todayIndex * barGroupTotalWidth) -
        (screenWidth / 2) +
        (barGroupTotalWidth / 2);

    if (_dailyChartScrollController.hasClients) {
      _dailyChartScrollController.animateTo(
        targetOffset.clamp(
            0.0, _dailyChartScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Scrolls the weekly trends chart to center on the current week.
  void _scrollToTodayWeeklyChart() {
    const int currentWeekIndex = 30;
    const double barWidth = 12.0;
    const double groupSpace = 24.0;
    const double barGroupTotalWidth = (barWidth * 3) + groupSpace;

    final double screenWidth =
        MediaQuery.of(context).size.width - 32.0;
    final double targetOffset = (currentWeekIndex * barGroupTotalWidth) -
        (screenWidth / 2) +
        (barGroupTotalWidth / 2);

    if (_weeklyChartScrollController.hasClients) {
      _weeklyChartScrollController.animateTo(
        targetOffset.clamp(
            0.0, _weeklyChartScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
        title: _buildSettingText(
          localizations.statistics,
          context: context,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: appColors.grey10,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _CupertinoLabelPicker(
              controller: controller,
              appColors: appColors,
              localizations: localizations,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              final sessions = _getFilteredSessions(localizations);

              if (sessions.isEmpty ||
                  sessions.any((s) => s.focusMinutes == null)) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Icon(Icons.spa_rounded,
                            size: 88, color: appColors.grey3),
                        const SizedBox(height: 16),
                        _buildSettingText(
                          localizations.noSessionsYet,
                          context: context,
                          textAlign: TextAlign.center,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: appColors.grey4,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTapDown: (_) =>
                              _onButtonTapDown(_startButtonAnimationController),
                          onTapUp: (_) =>
                              _onButtonTapUp(_startButtonAnimationController),
                          onTapCancel: () => _onButtonTapCancel(
                              _startButtonAnimationController),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Get.offAllNamed('/');
                          },
                          child: AnimatedBuilder(
                            animation: _startButtonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _startButtonScaleAnimation.value,
                                child: CustomButton(
                                  textPadding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                  icon: Icons.play_arrow_rounded,
                                  iconSize: 32,
                                  onPressed: null,
                                  text: localizations.startNow,
                                  color: appColors.primary,
                                  textColor: appColors.grey10,
                                ),
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              }

              final totalFocusTime = sessions.fold<int>(
                  0, (sum, session) => sum + (session.focusMinutes ?? 0));
              final totalCompletedSessions =
                  sessions.where((session) => session.isCompleted).length;
              final totalSkippedSessions =
                  sessions.where((session) => !session.isCompleted).length;
              final totalSessionsCount = sessions.length;
              final successRate = totalSessionsCount > 0
                  ? (totalCompletedSessions / totalSessionsCount) * 100
                  : 0.0;
              final averageFocusTimePerSession = totalSessionsCount > 0
                  ? totalFocusTime / totalSessionsCount
                  : 0.0;

              final Map<String, int> labelFocusTimes = {};
              for (var session in sessions) {
                final label = session.labelName ?? localizations.unlabeled;
                labelFocusTimes[label] =
                    (labelFocusTimes[label] ?? 0) + (session.focusMinutes ?? 0);
              }

              final Map<DateTime, int> dailyFocusMinutesMap = {};
              final Map<DateTime, int> dailyCompletedFocusMinutesForStreak = {};

              for (var session in sessions) {
                final date = DateTime(
                    session.date.year, session.date.month, session.date.day);

                dailyFocusMinutesMap.update(
                    date, (value) => value + (session.focusMinutes ?? 0),
                    ifAbsent: () => (session.focusMinutes ?? 0));

                if (session.isCompleted && (session.focusMinutes ?? 0) > 0) {
                  dailyCompletedFocusMinutesForStreak.update(
                      date, (value) => value + (session.focusMinutes ?? 0),
                      ifAbsent: () => (session.focusMinutes ?? 0));
                }
              }

              final sortedDatesForStreak =
              dailyCompletedFocusMinutesForStreak.keys.toList()..sort();
              int currentStreak = 0;
              int maxStreak = 0;
              DateTime? bestFocusDay;
              int maxFocusMinutesInDay = 0;

              if (sortedDatesForStreak.isNotEmpty) {
                currentStreak = 0;
                maxStreak = 0;
                DateTime? previousDate;
                for (int i = 0; i < sortedDatesForStreak.length; i++) {
                  final currentDate = sortedDatesForStreak[i];
                  if (previousDate == null ||
                      currentDate.difference(previousDate).inDays == 1) {
                    currentStreak++;
                  } else {
                    currentStreak = 1;
                  }
                  maxStreak = max(maxStreak, currentStreak);
                  previousDate = currentDate;
                }

                final today = DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);
                final yesterday = today.subtract(const Duration(days: 1));

                if (dailyCompletedFocusMinutesForStreak.containsKey(today) &&
                    (dailyCompletedFocusMinutesForStreak[today] ?? 0) > 0) {
                } else if (dailyCompletedFocusMinutesForStreak
                    .containsKey(yesterday) &&
                    (dailyCompletedFocusMinutesForStreak[yesterday] ?? 0) > 0 &&
                    currentStreak > 0) {
                } else {
                  currentStreak = 0;
                }
              }

              if (dailyFocusMinutesMap.isNotEmpty) {
                dailyFocusMinutesMap.forEach((date, minutes) {
                  if (minutes > maxFocusMinutesInDay) {
                    maxFocusMinutesInDay = minutes;
                    bestFocusDay = date;
                  }
                });
              }

              final Map<int, int> hourlyFocusTimes = {};
              for (var session in sessions) {
                final hour = session.startTime.hour;
                hourlyFocusTimes.update(
                    hour, (value) => value + (session.focusMinutes ?? 0),
                    ifAbsent: () => (session.focusMinutes ?? 0));
              }

              int mostFocusedHour = -1;
              int maxFocusMinutesInHour = 0;
              if (hourlyFocusTimes.isNotEmpty) {
                hourlyFocusTimes.forEach((hour, minutes) {
                  if (minutes > maxFocusMinutesInHour) {
                    maxFocusMinutesInHour = minutes;
                    mostFocusedHour = hour;
                  }
                });
              }

              String mostFocusedTimeOfDayText = localizations.notAvailable;
              if (mostFocusedHour != -1) {
                String period = mostFocusedHour < 12 ? 'AM' : 'PM';
                int displayHour = mostFocusedHour % 12;
                if (displayHour == 0) displayHour = 12;
                mostFocusedTimeOfDayText =
                '$displayHour $period (${maxFocusMinutesInHour} ${localizations.minutes})';
              }

              List<SessionData> sortedSessions = List.from(sessions);
              final sortOption = _selectedHistorySortOption.value;

              switch (sortOption) {
                case 'date_desc':
                  sortedSessions.sort((a, b) => b.date.compareTo(a.date));
                  break;
                case 'focus_desc':
                  sortedSessions.sort((a, b) =>
                      (b.focusMinutes ?? 0).compareTo(a.focusMinutes ?? 0));
                  break;
                case 'focus_asc':
                  sortedSessions.sort((a, b) =>
                      (a.focusMinutes ?? 0).compareTo(b.focusMinutes ?? 0));
                  break;
                case 'completed_first':
                  sortedSessions.sort((a, b) {
                    if (a.isCompleted && !b.isCompleted) return -1;
                    if (!a.isCompleted && b.isCompleted) return 1;
                    return b.date.compareTo(a.date);
                  });
                  break;
                case 'note_present_first':
                  sortedSessions.sort((a, b) {
                    final aHasNote = a.note != null && a.note!.isNotEmpty;
                    final bHasNote = b.note != null && b.note!.isNotEmpty;
                    if (aHasNote && !bHasNote) return -1;
                    if (!aHasNote && bHasNote) return 1;
                    return b.date.compareTo(a.date);
                  });
                  break;
                case 'label_asc':
                  sortedSessions.sort((a, b) {
                    final aLabel = a.labelName ?? localizations.unlabeled;
                    final bLabel = b.labelName ?? localizations.unlabeled;
                    return aLabel.compareTo(bLabel);
                  });
                  break;
                default:
                  sortedSessions.sort((a, b) =>
                      b.date.compareTo(a.date));
                  break;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Overview Section
                    Card(
                      color: appColors.grey6,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                          bottom: 24.0, left: 16.0, right: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSettingText(
                              localizations.overview,
                              context: context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appColors.grey10,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              context,
                              localizations.totalFocusTime,
                              '${totalFocusTime} ${localizations.minutes}',
                              appColors.primary,
                            ),
                            _buildStatCard(
                              context,
                              localizations.totalSessions,
                              '$totalSessionsCount',
                              appColors.secondary,
                            ),
                            _buildStatCard(
                              context,
                              localizations.successRate,
                              '${successRate.toStringAsFixed(1)}%',
                              appColors.tertiary,
                            ),
                            _buildStatCard(
                              context,
                              localizations.averageFocusTimePerSession,
                              '${averageFocusTimePerSession.toStringAsFixed(1)} ${localizations.minutes}',
                              appColors.tertiary,
                            ),
                            _buildStatCard(
                              context,
                              localizations.skippedSessions,
                              '$totalSkippedSessions',
                              appColors.error,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Trends & Progress Section
                    Card(
                      color: appColors.grey6,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                          bottom: 24.0, left: 16.0, right: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSettingText(
                              localizations.trendsAndProgress,
                              context: context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appColors.grey10,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              context,
                              localizations.currentStreak,
                              '$currentStreak ${localizations.days}',
                              appColors.aOrange,
                            ),
                            _buildStatCard(
                              context,
                              localizations.bestFocusDay,
                              bestFocusDay != null
                                  ? '${bestFocusDay!.day}/${bestFocusDay!.month}/${bestFocusDay!.year} (${maxFocusMinutesInDay} ${localizations.minutes})'
                                  : localizations.notAvailable,
                              appColors.aPurple,
                            ),
                            _buildStatCard(
                              context,
                              localizations.mostFocusedTimeOfDay,
                              mostFocusedTimeOfDayText,
                              appColors.aGreen,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Task & Category Breakdown Section
                    Card(
                      color: appColors.grey6,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                          bottom: 24.0, left: 16.0, right: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSettingText(
                              localizations.labelBreakdown,
                              context: context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appColors.grey10,
                            ),
                            const SizedBox(height: 16),
                            if (labelFocusTimes.isEmpty)
                              _buildSettingText(
                                localizations.noLabeledSessionsYet,
                                context: context,
                                color: appColors.grey3,
                              )
                            else
                              _buildLabelBreakdownChart(context,
                                  labelFocusTimes, appColors, localizations),
                          ],
                        ),
                      ),
                    ),

                    /// Visual Insights - Charts
                    Card(
                      color: appColors.grey6,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                          bottom: 24.0, left: 16.0, right: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSettingText(
                              localizations.visualInsights,
                              context: context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appColors.grey10,
                            ),
                            const SizedBox(height: 16),
                            _buildDailyTrendsChart(
                                context,
                                sessions,
                                dailyFocusMinutesMap,
                                appColors,
                                localizations),
                            const SizedBox(height: 24),
                            _buildWeeklyTrendsChart(
                                context,
                                sessions,
                                appColors,
                                localizations),
                            const SizedBox(height: 24),
                            _buildCalendarHeatmap(
                                context, sessions, appColors, localizations),
                          ],
                        ),
                      ),
                    ),

                    /// Session History Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSettingText(
                            localizations.sessionHistory,
                            context: context,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: appColors.grey10,
                          ),
                          _HistorySortDropdown(
                            appColors: appColors,
                            localizations: localizations,
                            selectedHistorySortOption:
                            _selectedHistorySortOption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => _buildSessionHistory(
                        context,
                        sortedSessions,
                        appColors,
                        localizations,
                        _showAllHistory.value)),
                    if (!_showAllHistory.value &&
                        sessions.any((s) =>
                        !DateUtils.isSameDay(s.date, DateTime.now())))
                      Center(
                        child: GestureDetector(
                          onTapDown: (_) =>
                              _onButtonTapDown(_viewButtonAnimationController),
                          onTapUp: (_) =>
                              _onButtonTapUp(_viewButtonAnimationController),
                          onTapCancel: () => _onButtonTapCancel(
                              _viewButtonAnimationController),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _showAllHistory.value = true;
                          },
                          child: AnimatedBuilder(
                            animation: _viewButtonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _viewButtonScaleAnimation.value,
                                child: TextButton(
                                  onPressed: null,
                                  child: _buildSettingText(
                                    localizations.viewAll,
                                    context: context,
                                    color: appColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (_showAllHistory.value)
                      Center(
                        child: GestureDetector(
                          onTapDown: (_) =>
                              _onButtonTapDown(_viewButtonAnimationController),
                          onTapUp: (_) =>
                              _onButtonTapUp(_viewButtonAnimationController),
                          onTapCancel: () => _onButtonTapCancel(
                              _viewButtonAnimationController),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _showAllHistory.value = false;
                          },
                          child: AnimatedBuilder(
                            animation: _viewButtonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _viewButtonScaleAnimation.value,
                                child: TextButton(
                                  onPressed: null,
                                  child: _buildSettingText(
                                    localizations.viewLess,
                                    context: context,
                                    color: appColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Filters sessions based on the selected label in settings.
  List<SessionData> _getFilteredSessions(AppLocalizations localizations) {
    final allSessions = Get.find<Box<SessionData>>().values.toList();
    final selectedLabel = controller.settingsService.selectedStatsLabel.value;

    if (selectedLabel == null ||
        selectedLabel['name'] == localizations.allSessions) {
      return allSessions;
    } else {
      return allSessions
          .where((session) => session.labelName == selectedLabel['name'])
          .toList();
    }
  }

  /// Builds a card to display a single statistic.
  Widget _buildStatCard(
      BuildContext context, String title, String value, Color color) {
    final appColors = AppTheme.colorsOf(context);
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: appColors.grey7,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingText(
                title,
                context: context,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.grey1,
              ),
              const SizedBox(height: 8),
              _buildSettingText(
                value,
                context: context,
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a pie chart to visualize focus time breakdown by label.
  Widget _buildLabelBreakdownChart(
      BuildContext context,
      Map<String, int> labelFocusTimes,
      AppThemeColors appColors,
      AppLocalizations localizations) {
    final total = labelFocusTimes.values.fold(0, (sum, val) => sum + val);

    if (total == 0) {
      return _buildSettingText(
        localizations.noLabeledSessionsYet,
        context: context,
        color: appColors.grey3,
      );
    }

    final List<Color> chartColors = [];
    final List<double> chartValues = [];

    final List<Color> defaultChartColors = [
      appColors.primary,
      appColors.secondary,
      appColors.tertiary,
      appColors.aOrange,
      appColors.aGreen,
      appColors.aPurple,
      appColors.aTeal,
      appColors.grey4,
    ];

    int i = 0;
    labelFocusTimes.forEach((label, minutes) {
      final isUnlabeled = label == localizations.unlabeled;
      final color = isUnlabeled
          ? appColors.grey5
          : (controller.settingsService.labels
          .firstWhereOrNull((l) => l['name'] == label)?['color'] !=
          null
          ? Color(controller.settingsService.labels
          .firstWhere((l) => l['name'] == label)['color'])
          : defaultChartColors[i % defaultChartColors.length]);

      chartColors.add(color);
      chartValues.add(minutes.toDouble());
      i++;
    });

    return Card(
      color: appColors.grey7,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.width * 0.65,
                child: PieChartSz(
                  colors: chartColors,
                  values: chartValues,
                  gapSize: 0.1,
                  centerText: localizations.labelBreakdown,
                  centerTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appColors.grey1,
                  ),
                  valueSettings: Valuesettings(
                    showValues: true,
                    ValueTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appColors.grey1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: labelFocusTimes.keys.map((label) {
                final isUnlabeled = label == localizations.unlabeled;
                final color = isUnlabeled
                    ? appColors.grey3
                    : (controller.settingsService.labels.firstWhereOrNull(
                        (l) => l['name'] == label)?['color'] !=
                    null
                    ? Color(controller.settingsService.labels
                    .firstWhere((l) => l['name'] == label)['color'])
                    : defaultChartColors[
                labelFocusTimes.keys.toList().indexOf(label) %
                    defaultChartColors.length]);
                return _buildLegend(label, color);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a bar chart to display daily focus time, sessions, and success rate trends.
  Widget _buildDailyTrendsChart(
      BuildContext context,
      List<SessionData> sessions,
      Map<DateTime, int> dailyFocusMinutesMap,
      AppThemeColors appColors,
      AppLocalizations localizations) {
    final Map<DateTime, Map<String, dynamic>> dailyData = {};
    for (var session in sessions) {
      final date =
      DateTime(session.date.year, session.date.month, session.date.day);
      dailyData.putIfAbsent(
          date, () => {'focus': 0, 'completed': 0, 'total': 0});
      dailyData[date]!['focus'] =
          (dailyData[date]!['focus'] as int) + (session.focusMinutes ?? 0);
      dailyData[date]!['total'] = (dailyData[date]!['total'] as int) + 1;
      if (session.isCompleted) {
        dailyData[date]!['completed'] =
            (dailyData[date]!['completed'] as int) + 1;
      }
    }

    final List<Map<String, dynamic>> trends = [];
    final DateTime today =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    for (int i = -60; i <= 60; i++) {
      final date = today.add(Duration(days: i));
      trends.add({
        'date': date,
        'focus': dailyData[date]?['focus'] is int
            ? dailyData[date]!['focus'] as int
            : 0,
        'sessions': dailyData[date]?['total'] is int
            ? dailyData[date]!['total'] as int
            : 0,
        'successRate': dailyData[date]?['total'] is int &&
            (dailyData[date]!['total'] as int) > 0
            ? ((dailyData[date]!['completed'] as int) /
            (dailyData[date]!['total'] as int)) *
            100
            : 0.0,
      });
    }

    int maxFocusMinutes = 0;
    int maxSessions = 0;
    for (var data in trends) {
      maxFocusMinutes = max(maxFocusMinutes, data['focus'] as int);
      maxSessions = max(maxSessions, data['sessions'] as int);
    }

    double actualMaxData =
    max(maxFocusMinutes.toDouble(), maxSessions.toDouble());

    double chartMaxY;
    double intervalSize;

    if (actualMaxData <= 100) {
      chartMaxY = 100.0;
      intervalSize = 20.0;
    } else {
      double bufferedMax = actualMaxData * 1.1;
      if (bufferedMax <= 125) {
        chartMaxY = 125.0;
        intervalSize = 25.0;
      } else if (bufferedMax <= 150) {
        chartMaxY = 150.0;
        intervalSize = 25.0;
      } else if (bufferedMax <= 200) {
        chartMaxY = 200.0;
        intervalSize = 50.0;
      } else if (bufferedMax <= 250) {
        chartMaxY = 250.0;
        intervalSize = 50.0;
      } else if (bufferedMax <= 300) {
        chartMaxY = 300.0;
        intervalSize = 50.0;
      } else if (bufferedMax <= 400) {
        chartMaxY = 400.0;
        intervalSize = 100.0;
      } else if (bufferedMax <= 500) {
        chartMaxY = 500.0;
        intervalSize = 100.0;
      } else {
        intervalSize = 100.0;
        chartMaxY = (bufferedMax / intervalSize).ceil() * intervalSize;
      }
    }

    if (chartMaxY > 0 && intervalSize == 0) {
      intervalSize = chartMaxY / 5;
    } else if (chartMaxY == 0) {
      intervalSize = 20.0;
    }

    final int numberOfLabels = (chartMaxY / intervalSize).round() + 1;

    const double chartHeight = 300.0;
    const double bottomTitlesReservedSize = 40.0;

    const double barWidth = 24.0;
    const double groupSpace = 32.0;
    final double chartWidth = trends.length * ((barWidth * 3) + groupSpace);

    return Card(
      color: appColors.grey7,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingText(
              localizations.dailyTrends,
              context: context,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: appColors.grey10,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: chartHeight - bottomTitlesReservedSize,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(numberOfLabels, (index) {
                          final yValue =
                          (chartMaxY - (index * intervalSize)).round();
                          return Align(
                            alignment: Alignment.centerRight,
                            child: _buildSettingText(
                              '$yValue',
                              context: context,
                              fontSize: 10,
                              color: appColors.grey1,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: bottomTitlesReservedSize),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _dailyChartScrollController,
                    child: SizedBox(
                      height: chartHeight,
                      width: chartWidth,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: chartMaxY,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              tooltipMargin: 24,
                              getTooltipColor: (BarChartGroupData) =>
                              appColors.grey5,
                              tooltipBorderRadius: BorderRadius.circular(8.0),
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                final data = trends[group.x.toInt()];
                                final date = data['date'] as DateTime;
                                String dateText;
                                if (DateUtils.isSameDay(date, DateTime.now())) {
                                  dateText = localizations.today;
                                } else if (DateUtils.isSameDay(
                                    date,
                                    DateTime.now()
                                        .subtract(const Duration(days: 1)))) {
                                  dateText = localizations.yesterday;
                                } else {
                                  dateText = '${date.day}/${date.month}';
                                }

                                String valueText;
                                Color valueColor;
                                if (rodIndex == 0) {
                                  valueText =
                                  '${(data['focus'] as int).toInt()} ${localizations.minutes}';
                                  valueColor = appColors.primary;
                                } else if (rodIndex == 1) {
                                  valueText =
                                  '${(data['sessions'] as int).toInt()} ${localizations.sessions}';
                                  valueColor = appColors.secondary;
                                } else {
                                  valueText =
                                  '${(data['successRate'] as double).toStringAsFixed(1)}%';
                                  valueColor = appColors.tertiary;
                                }

                                return BarTooltipItem(
                                  '',
                                  TextStyle(
                                      fontFamily: 'OpenRunde',
                                      color: valueColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${dateText}\n',
                                      style: TextStyle(
                                          fontFamily: 'OpenRunde',
                                          color: appColors.grey10,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: valueText,
                                      style: TextStyle(
                                          fontFamily: 'OpenRunde',
                                          color: valueColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final date =
                                  trends[value.toInt()]['date'] as DateTime;
                                  String text;
                                  if (DateUtils.isSameDay(
                                      date, DateTime.now())) {
                                    text = localizations.today;
                                  } else if (DateUtils.isSameDay(
                                      date,
                                      DateTime.now()
                                          .subtract(const Duration(days: 1)))) {
                                    text = localizations.yesterday;
                                  } else {
                                    text = '${date.day}/${date.month}';
                                  }
                                  return SideTitleWidget(
                                    space: 20,
                                    meta: meta,
                                    child: _buildSettingText(text,
                                        context: context,
                                        fontSize: 10,
                                        color: appColors.grey1),
                                  );
                                },
                                interval: 1,
                                reservedSize: bottomTitlesReservedSize,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border:
                            Border.all(color: appColors.grey5, width: 1),
                          ),
                          barGroups: trends.asMap().entries.map((e) {
                            final index = e.key;
                            final data = e.value;

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: (data['focus'] as int).toDouble(),
                                  color: appColors.primary,
                                  width: barWidth,
                                ),
                                BarChartRodData(
                                  toY: (data['sessions'] as int).toDouble(),
                                  color: appColors.secondary,
                                  width: barWidth,
                                ),
                                BarChartRodData(
                                  toY: data['successRate'].toDouble(),
                                  color: appColors.tertiary,
                                  width: barWidth,
                                ),
                              ],
                              showingTooltipIndicators: const [],
                            );
                          }).toList(),
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildLegend(localizations.focusTime, appColors.primary),
                const SizedBox(width: 16),
                _buildLegend(localizations.sessions, appColors.secondary),
                const SizedBox(width: 16),
                _buildLegend(localizations.successRate, appColors.tertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a bar chart to display weekly focus time, sessions, and success rate trends.
  Widget _buildWeeklyTrendsChart(
      BuildContext context,
      List<SessionData> sessions,
      AppThemeColors appColors,
      AppLocalizations localizations) {
    final Map<DateTime, Map<String, dynamic>> weeklyData = {};
    final int startOfWeekDay = controller.settingsService.startOfWeek.value;

    for (var session in sessions) {
      final date = session.date;
      final weekStart = _getStartOfWeek(date, startOfWeekDay);
      weeklyData.putIfAbsent(weekStart,
              () => {'focus': 0, 'completed': 0, 'total': 0, 'sessions': 0});
      weeklyData[weekStart]!['focus'] =
          (weeklyData[weekStart]!['focus'] as int) +
              (session.focusMinutes ?? 0);
      weeklyData[weekStart]!['total'] =
          (weeklyData[weekStart]!['total'] as int) + 1;
      weeklyData[weekStart]!['sessions'] =
          (weeklyData[weekStart]!['sessions'] as int) + 1;
      if (session.isCompleted) {
        weeklyData[weekStart]!['completed'] =
            (weeklyData[weekStart]!['completed'] as int) + 1;
      }
    }

    final List<Map<String, dynamic>> trends = [];
    final DateTime today =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final DateTime startOfTodayWeek = _getStartOfWeek(today, startOfWeekDay);

    for (int i = -17; i <= 17; i++) {
      final weekStart = _getStartOfWeek(
          startOfTodayWeek.add(Duration(days: 7 * i)), startOfWeekDay);
      trends.add({
        'weekStart': weekStart,
        'focus': weeklyData[weekStart]?['focus'] is int
            ? weeklyData[weekStart]!['focus'] as int
            : 0,
        'sessions': weeklyData[weekStart]?['sessions'] is int
            ? weeklyData[weekStart]!['sessions'] as int
            : 0,
        'successRate': weeklyData[weekStart]?['total'] is int &&
            (weeklyData[weekStart]!['total'] as int) > 0
            ? ((weeklyData[weekStart]!['completed'] as int) /
            (weeklyData[weekStart]!['total'] as int)) *
            100
            : 0.0,
      });
    }

    int maxFocusMinutes = 0;
    int maxSessions = 0;
    for (var data in trends) {
      maxFocusMinutes = max(maxFocusMinutes, data['focus'] as int);
      maxSessions = max(maxSessions, data['sessions'] as int);
    }

    double actualMaxData =
    max(maxFocusMinutes.toDouble(), maxSessions.toDouble());

    double chartMaxY;
    double intervalSize;

    if (actualMaxData <= 100) {
      chartMaxY = 100.0;
      intervalSize = 20.0;
    } else {
      double bufferedMax = actualMaxData * 1.1;
      if (bufferedMax <= 125) {
        chartMaxY = 125.0;
        intervalSize = 25.0;
      } else if (bufferedMax <= 150) {
        chartMaxY = 150.0;
        intervalSize = 25.0;
      } else if (bufferedMax <= 200) {
        chartMaxY = 200.0;
        intervalSize = 50.0;
      } else if (bufferedMax <= 250) {
        chartMaxY = 250.0;
        intervalSize = 50.0;
      } else if (bufferedMax <= 300) {
        chartMaxY = 300.0;
        intervalSize = 50.0;
      } else if (bufferedMax <= 400) {
        chartMaxY = 400.0;
        intervalSize = 100.0;
      } else if (bufferedMax <= 500) {
        chartMaxY = 500.0;
        intervalSize = 100.0;
      } else {
        intervalSize = 100.0;
        chartMaxY = (bufferedMax / intervalSize).ceil() * intervalSize;
      }
    }

    if (chartMaxY > 0 && intervalSize == 0) {
      intervalSize = chartMaxY / 5;
    } else if (chartMaxY == 0) {
      intervalSize = 20.0;
    }

    const double chartHeight = 300.0;
    const double bottomTitlesReservedSize = 40.0;

    const double barWidth = 24.0;
    const double groupSpace = 32.0;
    final double chartWidth = trends.length * ((barWidth * 3) + groupSpace);

    final int numberOfLabels = (chartMaxY / intervalSize).round() + 1;

    return Card(
      color: appColors.grey7,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingText(
              localizations.weeklyTrends,
              context: context,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: appColors.grey10,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: chartHeight - bottomTitlesReservedSize,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(numberOfLabels, (index) {
                          final yValue =
                          (chartMaxY - (index * intervalSize)).round();
                          return Align(
                            alignment: Alignment.centerRight,
                            child: _buildSettingText(
                              '$yValue',
                              context: context,
                              fontSize: 10,
                              color: appColors.grey1,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: bottomTitlesReservedSize),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _weeklyChartScrollController,
                    child: SizedBox(
                      height: chartHeight,
                      width: chartWidth,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: chartMaxY,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              tooltipMargin: 24,
                              getTooltipColor: (BarChartGroupData) =>
                              appColors.grey5,
                              tooltipBorderRadius: BorderRadius.circular(8.0),
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                final data = trends[group.x.toInt()];
                                final weekStart = data['weekStart'] as DateTime;

                                String valueText;
                                Color valueColor;
                                if (rodIndex == 0) {
                                  valueText =
                                  '${(data['focus'] as int).toInt()} ${localizations.minutes}';
                                  valueColor = appColors.primary;
                                } else if (rodIndex == 1) {
                                  valueText =
                                  '${(data['sessions'] as int).toInt()} ${localizations.sessions}';
                                  valueColor = appColors.secondary;
                                } else {
                                  valueText =
                                  '${(data['successRate'] as double).toStringAsFixed(1)}%';
                                  valueColor = appColors.tertiary;
                                }

                                return BarTooltipItem(
                                  '',
                                  TextStyle(
                                      fontFamily: 'OpenRunde',
                                      color: valueColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                      '${localizations.weekOf} ${weekStart.day}/${weekStart.month}\n',
                                      style: TextStyle(
                                          fontFamily: 'OpenRunde',
                                          color: appColors.grey10,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: valueText,
                                      style: TextStyle(
                                          fontFamily: 'OpenRunde',
                                          color: valueColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final weekStart = trends[value.toInt()]
                                  ['weekStart'] as DateTime;
                                  return SideTitleWidget(
                                    space: 16,
                                    meta: meta,
                                    child: _buildSettingText(
                                        '${weekStart.day}/${weekStart.month}',
                                        context: context,
                                        fontSize: 10,
                                        color: appColors.grey1),
                                  );
                                },
                                interval: 1,
                                reservedSize: bottomTitlesReservedSize,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border:
                            Border.all(color: appColors.grey5, width: 1),
                          ),
                          barGroups: trends.asMap().entries.map((e) {
                            final index = e.key;
                            final data = e.value;

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: (data['focus'] as int).toDouble(),
                                  color: appColors.primary,
                                  width: barWidth,
                                ),
                                BarChartRodData(
                                  toY: (data['sessions'] as int).toDouble(),
                                  color: appColors.secondary,
                                  width: barWidth,
                                ),
                                BarChartRodData(
                                  toY: data['successRate'].toDouble(),
                                  color: appColors.tertiary,
                                  width: barWidth,
                                ),
                              ],
                              showingTooltipIndicators: const [],
                            );
                          }).toList(),
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildLegend(localizations.focusTime, appColors.primary),
                const SizedBox(width: 16),
                _buildLegend(localizations.sessions, appColors.secondary),
                const SizedBox(width: 16),
                _buildLegend(localizations.successRate, appColors.tertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a calendar heatmap to visualize daily focus times using flutter_heatmap_calendar.
  Widget _buildCalendarHeatmap(BuildContext context, List<SessionData> sessions,
      AppThemeColors appColors, AppLocalizations localizations) {
    final Map<DateTime, int> dailyFocusMinutes = {};
    for (var session in sessions) {
      final date =
      DateTime(session.date.year, session.date.month, session.date.day);
      dailyFocusMinutes.update(
          date, (value) => value + (session.focusMinutes ?? 0),
          ifAbsent: () => (session.focusMinutes ?? 0));
    }

    final DateTime now = DateTime.now();
    final DateTime startDate = DateTime(now.year - 1, now.month, now.day);
    final DateTime endDate = DateTime(now.year, now.month, now.day);

    return Card(
      color: appColors.grey7,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingText(
              localizations.calendarHeatmap,
              context: context,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: appColors.grey10,
            ),
            const SizedBox(height: 16),
            HeatMapCalendar(
              fontSize: 16,
              defaultColor: appColors.grey6,
              initDate: now,
              datasets: dailyFocusMinutes,
              colorsets: {
                0: appColors.grey6,
                1: appColors.primary.withOpacity(0.2),
                16: appColors.primary.withOpacity(0.5),
                31: appColors.primary,
              },
              textColor: appColors.grey1,
              borderRadius: 6,
              size: 40,
              showColorTip: true,
              colorTipHelper: [
                _buildSettingText('0-1 ${localizations.minutes}  ',
                    context: context, fontSize: 14, color: appColors.grey1),
                _buildSettingText('  1-15 ${localizations.minutes}',
                    context: context, fontSize: 14, color: appColors.grey1),
                _buildSettingText('  16-30 ${localizations.minutes}',
                    context: context, fontSize: 14, color: appColors.grey1),
                _buildSettingText('  30+ ${localizations.minutes}',
                    context: context, fontSize: 14, color: appColors.grey1),
              ],
              colorMode: ColorMode.color,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Calculates the start of the week based on the given date and startOfWeekDay setting.
  DateTime _getStartOfWeek(DateTime date, int startOfWeekDay) {
    DateTime startOfWeekDate = DateTime(date.year, date.month, date.day);
    int weekday = startOfWeekDate.weekday;
    if (weekday == DateTime.sunday) {
      weekday = 7;
    }

    int difference = (weekday - startOfWeekDay + 7) % 7;
    return startOfWeekDate.subtract(Duration(days: difference));
  }

  /// Builds a list of session history, grouped by date.
  Widget _buildSessionHistory(BuildContext context, List<SessionData> sessions,
      AppThemeColors appColors, AppLocalizations localizations, bool showAll) {
    final Map<DateTime, List<SessionData>> groupedSessions = {};
    for (var session in sessions) {
      final date =
      DateTime(session.date.year, session.date.month, session.date.day);
      groupedSessions.putIfAbsent(date, () => []).add(session);
    }

    final sortedDates = groupedSessions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final List<DateTime> datesToShow;
    final today =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (!showAll) {
      datesToShow = sortedDates
          .where((date) => DateUtils.isSameDay(date, today))
          .toList();
    } else {
      datesToShow = sortedDates;
    }

    return Card(
      color: appColors.grey6,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: datesToShow.length,
              itemBuilder: (context, dateIndex) {
                final date = datesToShow[dateIndex];
                final sessionsOnDate = groupedSessions[date]!;

                String dateHeader;
                if (DateUtils.isSameDay(date, today)) {
                  dateHeader = localizations.today;
                } else if (DateUtils.isSameDay(
                    date, today.subtract(const Duration(days: 1)))) {
                  dateHeader = localizations.yesterday;
                } else {
                  dateHeader = '${date.day}/${date.month}/${date.year}';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buildSettingText(
                        dateHeader,
                        context: context,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appColors.grey1,
                      ),
                    ),
                    ...sessionsOnDate.map((session) {
                      final labelColor = session.labelName != null
                          ? (controller.settingsService.labels.firstWhereOrNull(
                              (l) =>
                          l['name'] ==
                              session.labelName)?['color'] !=
                          null
                          ? Color(controller.settingsService.labels
                          .firstWhere((l) =>
                      l['name'] == session.labelName)['color'])
                          : appColors.grey5)
                          : appColors.grey5;

                      return Column(
                        children: [
                          Card(
                            color: appColors.grey7,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0.0),
                            child: ListTile(
                              contentPadding:
                              const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              visualDensity: const VisualDensity(vertical: -4),
                              leading: Icon(Icons.square_rounded,
                                  color: labelColor, size: 40),
                              title: _buildSettingText(
                                '${session.focusMinutes ?? 0} ${localizations.minutes}',
                                context: context,
                                color: appColors.grey10,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  _buildSettingText(
                                    session.labelName ??
                                        localizations.unlabeled,
                                    context: context,
                                    color: labelColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  SizedBox(height: 4),
                                  _buildSettingText(
                                    '${localizations.completed}: ${session.isCompleted ? localizations.yes : localizations.no}',
                                    context: context,
                                    color: appColors.grey1,
                                    fontSize: 12,
                                  ),
                                  SizedBox(height: 4),
                                  if (session.note != null &&
                                      session.note!.isNotEmpty)
                                    Row(
                                      children: [
                                        _buildSettingText(
                                          '${localizations.note} :',
                                          context: context,
                                          color: appColors.grey2,
                                          fontSize: 12,
                                        ),
                                        _buildSettingText(
                                          session.note!,
                                          context: context,
                                          color: appColors.grey2,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTapDown: (_) => _onButtonTapDown(
                                        _editDeleteIconAnimationController),
                                    onTapUp: (_) => _onButtonTapUp(
                                        _editDeleteIconAnimationController),
                                    onTapCancel: () => _onButtonTapCancel(
                                        _editDeleteIconAnimationController),
                                    onTap: () async {
                                      _showEditSessionDialog(context, session,
                                          localizations, appColors);
                                    },
                                    child: AnimatedBuilder(
                                      animation: _editDeleteIconScaleAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _editDeleteIconScaleAnimation
                                              .value,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appColors.grey6,
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            height: 40,
                                            width: 40,
                                            child: Center(
                                              child: Icon(Icons.edit,
                                                  color: appColors.primary,
                                                  size: 20),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  GestureDetector(
                                    onTapDown: (_) => _onButtonTapDown(
                                        _editDeleteIconAnimationController),
                                    onTapUp: (_) => _onButtonTapUp(
                                        _editDeleteIconAnimationController),
                                    onTapCancel: () => _onButtonTapCancel(
                                        _editDeleteIconAnimationController),
                                    onTap: () async {
                                      _showDeleteSessionConfirmation(context,
                                          session, localizations, appColors);
                                    },
                                    child: AnimatedBuilder(
                                      animation: _editDeleteIconScaleAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _editDeleteIconScaleAnimation
                                              .value,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appColors.grey6
                                                  .withOpacity(0.8),
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            height: 40,
                                            width: 40,
                                            child: Center(
                                              child: Icon(Icons.delete,
                                                  color: appColors.error,
                                                  size: 20),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                ],
                              ),
                            ),
                          ),
                          if (sessionsOnDate.last != session ||
                              dateIndex < datesToShow.length - 1)
                            const Divider(
                              color: Colors.transparent,
                              indent: 8,
                              endIndent: 8,
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a color legend for charts.
  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        _buildSettingText(
          label,
          context: context,
          fontSize: 12,
          color: color,
        ),
      ],
    );
  }

  /// Shows a dialog to edit an existing session's details.
  void _showEditSessionDialog(BuildContext context, SessionData session,
      AppLocalizations localizations, AppThemeColors appColors) {
    final focusMinutesController =
    TextEditingController(text: session.focusMinutes.toString());
    final noteController = TextEditingController(text: session.note);
    Rxn<Map<String, dynamic>> selectedLabel = Rxn<Map<String, dynamic>>(
      session.labelName != null
          ? controller.settingsService.labels
          .firstWhereOrNull((l) => l['name'] == session.labelName)
          : null,
    );
    RxBool isCompleted = session.isCompleted.obs;

    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: appColors.grey6,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(dialogContext).size.width * 0.85,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingText(localizations.editSession,
                  context: dialogContext,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: focusMinutesController,
                        hintText: localizations.focusMinutes,
                        keyboardType: TextInputType.number,
                        fillColor: appColors.grey6,
                        borderColor: appColors.grey4,
                        focusedBorderColor: appColors.primary,
                        enabledBorderColor: appColors.primary,
                        textColor: appColors.grey10,
                        hintTextColor: appColors.grey2,
                        isInputValid: true,
                        onSubmitted: (_) {
                          FocusScope.of(dialogContext).unfocus();
                        },
                        errorBorderColor: appColors.error,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: noteController,
                        hintText: localizations.sessionNote,
                        maxLines: 3,
                        fillColor: appColors.grey6,
                        borderColor: appColors.grey4,
                        focusedBorderColor: appColors.primary,
                        enabledBorderColor: appColors.primary,
                        textColor: appColors.grey10,
                        hintTextColor: appColors.grey2,
                        isInputValid: true,
                        onSubmitted: (_) {
                          FocusScope.of(dialogContext).unfocus();
                        },
                        errorBorderColor: appColors.error,
                      ),
                      const SizedBox(height: 16),
                      _buildSettingText(
                        localizations.label,
                        context: dialogContext,
                        color: appColors.grey10,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        final List<Map<String, dynamic>?> labels = [
                          null,
                          ...controller.settingsService.labels.value,
                        ];
                        return Container(
                          decoration: BoxDecoration(
                            color: appColors.grey5,
                            borderRadius: BorderRadius.circular(8),
                            border:
                            Border.all(color: appColors.grey2, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonFormField<Map<String, dynamic>?>(
                            value: selectedLabel.value,
                            icon: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: appColors.grey10,
                              size: 32,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            isExpanded: true,
                            dropdownColor: appColors.grey4,
                            items: labels.map((label) {
                              final displayColor = label == null
                                  ? appColors.grey5
                                  : Color(label['color']);
                              final displayName = label == null
                                  ? localizations.unlabeled
                                  : label['name'];

                              return DropdownMenuItem<Map<String, dynamic>?>(
                                value: label,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: displayColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildSettingText(
                                      displayName,
                                      context: dialogContext,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      color: appColors.grey10,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedLabel.value = value;
                            },
                            selectedItemBuilder: (context) {
                              return labels.map((label) {
                                final displayColor = label == null
                                    ? appColors.grey5
                                    : Color(label['color']);
                                final displayName = label == null
                                    ? localizations.unlabeled
                                    : label['name'];
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: displayColor,
                                          borderRadius:
                                          BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildSettingText(
                                        displayName,
                                        context: dialogContext,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        color: appColors.grey10,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        );
                      }),
                      Obx(() => CheckboxListTile(
                        title: _buildSettingText(localizations.completed,
                            context: dialogContext,
                            color: appColors.grey10),
                        value: isCompleted.value,
                        onChanged: (bool? value) {
                          if (value != null) {
                            isCompleted.value = value;
                          }
                        },
                        activeColor: appColors.primary,
                        checkColor: appColors.grey10,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                color: appColors.grey4,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTapDown: (_) =>
                        _onButtonTapDown(_cancelButtonAnimationController),
                    onTapUp: (_) =>
                        _onButtonTapUp(_cancelButtonAnimationController),
                    onTapCancel: () =>
                        _onButtonTapCancel(_cancelButtonAnimationController),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(dialogContext);
                    },
                    child: AnimatedBuilder(
                      animation: _cancelButtonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _cancelButtonScaleAnimation.value,
                          child: CustomButton(
                            borderRadius: 8,
                            textPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            onPressed: null,
                            text: localizations.cancel,
                            color: appColors.grey3,
                            textColor: appColors.grey10,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTapDown: (_) =>
                        _onButtonTapDown(_saveButtonAnimationController),
                    onTapUp: (_) =>
                        _onButtonTapUp(_saveButtonAnimationController),
                    onTapCancel: () =>
                        _onButtonTapCancel(_saveButtonAnimationController),
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      final int? newFocusMinutes =
                      int.tryParse(focusMinutesController.text);

                      if (newFocusMinutes != null && newFocusMinutes >= 0) {
                        bool finalIsCompleted = isCompleted.value;
                        if (newFocusMinutes == 0) {
                          finalIsCompleted = false;
                          Fluttertoast.showToast(
                              msg: localizations.focusMinutesZeroNotCompleted);
                        }

                        final updatedSession = SessionData(
                          session.startTime,
                          session.date,
                          newFocusMinutes,
                          note: noteController.text.isEmpty
                              ? null
                              : noteController.text,
                          labelName: selectedLabel.value?['name'],
                          isCompleted: finalIsCompleted,
                        );
                        final sessionsBox = Get.find<Box<SessionData>>();
                        final sessionIndex =
                        sessionsBox.values.toList().indexOf(session);
                        if (sessionIndex != -1) {
                          await sessionsBox.putAt(sessionIndex, updatedSession);
                          Fluttertoast.showToast(
                              msg: localizations.sessionUpdatedSuccessfully);
                          Get.back();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Error: Session not found for update.");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: localizations.invalidFocusMinutes);
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _saveButtonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _saveButtonScaleAnimation.value,
                          child: CustomButton(
                            borderRadius: 8,
                            textPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            onPressed: null,
                            text: localizations.save,
                            color: appColors.primary,
                            textColor: appColors.grey10,
                          ),
                        );
                      },
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

  /// Shows a confirmation dialog before deleting a session.
  void _showDeleteSessionConfirmation(BuildContext context, SessionData session,
      AppLocalizations localizations, AppThemeColors appColors) {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: appColors.grey6,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(dialogContext).size.width * 0.85,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingText(
                localizations.deleteSession,
                context: dialogContext,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appColors.error,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildSettingText(
                    localizations.deleteSessionConfirmation,
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
                  GestureDetector(
                    onTapDown: (_) =>
                        _onButtonTapDown(_cancelButtonAnimationController),
                    onTapUp: (_) =>
                        _onButtonTapUp(_cancelButtonAnimationController),
                    onTapCancel: () =>
                        _onButtonTapCancel(_cancelButtonAnimationController),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(dialogContext);
                    },
                    child: AnimatedBuilder(
                      animation: _cancelButtonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _cancelButtonScaleAnimation.value,
                          child: CustomButton(
                            borderRadius: 8,
                            textPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            onPressed: null,
                            text: localizations.cancel,
                            color: appColors.grey3,
                            textColor: appColors.grey10,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTapDown: (_) =>
                        _onButtonTapDown(_saveButtonAnimationController),
                    onTapUp: (_) =>
                        _onButtonTapUp(_saveButtonAnimationController),
                    onTapCancel: () =>
                        _onButtonTapCancel(_saveButtonAnimationController),
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      await session.delete();
                      Fluttertoast.showToast(
                          msg: localizations.sessionDeletedSuccessfully);
                      Get.back();
                    },
                    child: AnimatedBuilder(
                      animation: _saveButtonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _saveButtonScaleAnimation.value,
                          child: CustomButton(
                            borderRadius: 8,
                            textPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            onPressed: null,
                            text: localizations.delete,
                            color: appColors.error,
                            textColor: appColors.grey10,
                          ),
                        );
                      },
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
}

/// A Cupertino-style label picker for filtering statistics.
class _CupertinoLabelPicker extends StatefulWidget {
  final PomodoroController controller;
  final AppThemeColors appColors;
  final AppLocalizations localizations;

  const _CupertinoLabelPicker({
    required this.controller,
    required this.appColors,
    required this.localizations,
  });

  @override
  State<_CupertinoLabelPicker> createState() => _CupertinoLabelPickerState();
}

class _CupertinoLabelPickerState extends State<_CupertinoLabelPicker>
    with TickerProviderStateMixin {
  final GlobalKey _labelKey = GlobalKey();
  late FixedExtentScrollController _wheelController;

  static const double labelBoxWidth = 220;
  static const double labelBoxHeight = 56;
  static const double labelPickerItemExtent = 48;

  final RxBool _isDropdownOpen = false.obs;

  late AnimationController _labelBoxAnimationController;

  late Animation<double> _labelBoxScaleAnimation;

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

  @override
  void initState() {
    super.initState();
    _updateWheelController();

    _labelBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _labelBoxScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _labelBoxAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
  }

  @override
  void didUpdateWidget(covariant _CupertinoLabelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateWheelController();
  }

  void _updateWheelController() {
    final labels = [
      {
        'name': widget.localizations.allSessions,
        'color': widget.appColors.grey5.value
      },
      ...widget.controller.settingsService.labels.value,
    ];
    int currentIndex = () {
      final v = widget.controller.settingsService.selectedStatsLabel.value;
      if (v == null) return 0;
      final idx = labels.indexWhere((l) => l['name'] == v['name']);
      return idx >= 0 ? idx : 0;
    }();
    _wheelController = FixedExtentScrollController(initialItem: currentIndex);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    _isDropdownOpen.close();
    _labelBoxAnimationController.dispose();
    super.dispose();
  }

  /// Scrolls the ListWheelScrollView to the selected item.
  void _scrollToSelectedLabel(int newIndex) {
    if (_wheelController.hasClients) {
      _wheelController.animateToItem(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
      );
    }
  }

  void onSelectedItemChanged(int idx) {
    HapticFeedback.lightImpact();
    final labels = [
      {
        'name': widget.localizations.allSessions,
        'color': widget.appColors.grey6.value
      },
      ...widget.controller.settingsService.labels.value,
    ];
    final label = labels[idx];
    widget.controller.settingsService.setSelectedStatsLabel(
      label['name'] == widget.localizations.allSessions
          ? null
          : label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      {
        'name': widget.localizations.allSessions,
        'color': widget.appColors.grey6.value
      },
      ...widget.controller.settingsService.labels.value,
    ];

    return Center(
      child: AnimatedBuilder(
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
          margin: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() {
                final currentSelectedLabel =
                    widget.controller.settingsService.selectedStatsLabel.value;
                int initialItem = 0;
                if (currentSelectedLabel != null) {
                  final index = labels.indexWhere(
                          (l) => l?['name'] == currentSelectedLabel['name']);
                  if (index != -1) {
                    initialItem = index;
                  }
                }
                if (_wheelController.initialItem != initialItem) {
                  _wheelController =
                      FixedExtentScrollController(initialItem: initialItem);
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollStartNotification) {
                      _labelBoxAnimationController.forward();
                    } else if (notification is ScrollEndNotification) {
                      _labelBoxAnimationController.reverse();
                    }
                    return false;
                  },
                  child: ListWheelScrollView.useDelegate(
                    controller: _wheelController,
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
                        final isSelected = (widget.controller.settingsService
                            .selectedStatsLabel.value ==
                            null &&
                            idx == 0) ||
                            (widget.controller.settingsService
                                .selectedStatsLabel.value !=
                                null &&
                                widget.controller.settingsService
                                    .selectedStatsLabel.value!['name'] ==
                                    label!['name']);
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
                              child: _buildSettingText(
                                label['name'],
                                context: context,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                color: isSelected
                                    ? widget.appColors.grey10
                                    : widget.appColors.grey1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 32),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
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
                  onTapDown: (_) => _labelBoxAnimationController.forward(),
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    _isDropdownOpen.value = true;

                    final RenderBox renderBox = _labelKey.currentContext!
                        .findRenderObject() as RenderBox;
                    final Offset offset = renderBox.localToGlobal(Offset.zero);
                    final Size size = renderBox.size;

                    await showMenu<void>(
                      elevation: 0,
                      color: widget.appColors.grey5,
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy + size.height - 6,
                        offset.dx + size.width,
                        offset.dy + size.height + 300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      constraints: BoxConstraints.tightFor(width: size.width),
                      items: [
                        ...labels.map((label) {
                          final isAllSessions = label!['name'] ==
                              widget.localizations.allSessions;
                          final color = Color(label['color']);
                          return PopupMenuItem<void>(
                            height: 40,
                            value: label,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                widget.controller.settingsService
                                    .setSelectedStatsLabel(
                                    isAllSessions ? null : label);
                                final newIndex = labels.indexWhere(
                                        (l) => l?['name'] == label['name']);
                                _scrollToSelectedLabel(newIndex);
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSettingText(
                                      label['name'],
                                      context: context,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ).then((_) {
                      _isDropdownOpen.value = false;
                      _labelBoxAnimationController.reverse();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.appColors.grey5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => AnimatedRotation(
                      turns: _isDropdownOpen.value ? -0.5 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: widget.appColors.grey10,
                        size: 32,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget for sorting history sessions.
class _HistorySortDropdown extends StatefulWidget {
  final AppThemeColors appColors;
  final AppLocalizations localizations;
  final RxString selectedHistorySortOption;

  const _HistorySortDropdown({
    required this.appColors,
    required this.localizations,
    required this.selectedHistorySortOption,
  });

  @override
  State<_HistorySortDropdown> createState() => _HistorySortDropdownState();
}

class _HistorySortDropdownState extends State<_HistorySortDropdown>
    with TickerProviderStateMixin {
  final GlobalKey _sortDropdownKey = GlobalKey();
  final RxBool _isSortDropdownOpen = false.obs;

  late AnimationController _sortBoxAnimationController;

  late Animation<double> _sortBoxScaleAnimation;

  /// Helper widget to build consistent text styles across the screen.
  Widget _buildSettingText(
      String text, {
        double fontSize = 16,
        FontWeight fontWeight = FontWeight.w500,
        Color? color,
        TextAlign textAlign = TextAlign.start,
        int? maxLines,
        TextOverflow? overflow,
        BuildContext? context,
      }) {
    final appColors = AppTheme.colorsOf(context ?? Get.context!);
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
  void initState() {
    super.initState();
    _sortBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _sortBoxScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
          parent: _sortBoxAnimationController,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc,
        ));
  }

  @override
  void dispose() {
    _isSortDropdownOpen.close();
    _sortBoxAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sortOptions = [
      {'value': 'date_desc', 'label': widget.localizations.dateNewestFirst},
      {'value': 'focus_desc', 'label': widget.localizations.focusMoreToLess},
      {'value': 'focus_asc', 'label': widget.localizations.focusLessToMore},
      {
        'value': 'completed_first',
        'label': widget.localizations.completedFirst
      },
      {
        'value': 'note_present_first',
        'label': widget.localizations.notePresentFirst
      },
      {'value': 'label_asc', 'label': widget.localizations.labelAscending},
    ];

    final currentSelectedOption = sortOptions.firstWhere(
          (option) => option['value'] == widget.selectedHistorySortOption.value,
      orElse: () => sortOptions.first,
    );

    return Center(
      child: AnimatedBuilder(
        animation: _sortBoxScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _sortBoxScaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          key: _sortDropdownKey,
          width: 160,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: _buildSettingText(
                      currentSelectedOption['label']!,
                      context: context,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      color: widget.appColors.grey1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTapDown: (_) => _sortBoxAnimationController.forward(),
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    _isSortDropdownOpen.value = true;

                    final RenderBox renderBox = _sortDropdownKey.currentContext!
                        .findRenderObject() as RenderBox;
                    final Offset offset = renderBox.localToGlobal(Offset.zero);
                    final Size size = renderBox.size;

                    await showMenu<String>(
                      elevation: 0,
                      color: widget.appColors.grey5,
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy + size.height - 6,
                        offset.dx + size.width,
                        offset.dy + size.height + 300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      constraints: BoxConstraints.tightFor(width: size.width),
                      items: sortOptions.map((option) {
                        return PopupMenuItem<String>(
                          height: 48,
                          value: option['value'],
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(
                                  context, option['value']);
                            },
                            child: Container(
                              width: double.infinity,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0),
                              alignment: Alignment.centerLeft,
                              child: _buildSettingText(
                                option['label']!,
                                context: context,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ).then((newValue) {
                      _isSortDropdownOpen.value = false;
                      _sortBoxAnimationController.reverse();
                      if (newValue != null) {
                        widget.selectedHistorySortOption.value = newValue;
                      }
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.appColors.grey5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => AnimatedRotation(
                      turns: _isSortDropdownOpen.value ? 0.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      child: Icon(
                        Icons.sort,
                        color: widget.appColors.grey10,
                        size: 24,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
