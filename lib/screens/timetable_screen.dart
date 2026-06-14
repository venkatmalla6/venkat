import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../data/timetable_data.dart';
import '../services/notification_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  THEME & COLORS
// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF0A0A0F);
  static const card = Color(0xFF111118);
  static const cardBorder = Color(0x12FFFFFF);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);
  static const accentGreen = Color(0xFF10B981);
  static const breakRow = Color(0xFF1E293B);

  static const devopsOrange = Color(0xFFF97316);
  static const devopsAmber = Color(0xFFFB923C);
  static const devopsGlow = Color(0x4DF97316);

  static const awsYellow = Color(0xFFF59E0B);
  static const awsAmber = Color(0xFFFBBF24);
  static const awsGlow = Color(0x4DF59E0B);

  static const netCyan = Color(0xFF06B6D4);
  static const netLight = Color(0xFF22D3EE);
  static const netGlow = Color(0x4D06B6D4);
}

// ─────────────────────────────────────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────────────────────────────────────
Color primaryColor(String id) {
  switch (id) {
    case 'aws':
      return AppColors.awsYellow;
    case 'networking':
      return AppColors.netCyan;
    default:
      return AppColors.devopsOrange;
  }
}

Color glowColor(String id) {
  switch (id) {
    case 'aws':
      return AppColors.awsGlow;
    case 'networking':
      return AppColors.netGlow;
    default:
      return AppColors.devopsGlow;
  }
}

LinearGradient tabActiveGradient(String id) {
  switch (id) {
    case 'aws':
      return const LinearGradient(
        colors: [Color(0x33F59E0B), Color(0x1AFBBF24)],
      );
    case 'networking':
      return const LinearGradient(
        colors: [Color(0x3306B6D4), Color(0x1A22D3EE)],
      );
    default:
      return const LinearGradient(
        colors: [Color(0x33F97316), Color(0x1AFB923C)],
      );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TIMETABLE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background glow
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.7, -0.7),
                    radius: 1.0,
                    colors: [Color(0x146366F1), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: allTimetables.map((tt) => _buildSquareCard(context, tt)).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x266366F1),
              border: Border.all(color: const Color(0x4D6366F1)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              '🎓  STUDY TIMETABLE 2026',
              style: TextStyle(
                color: Color(0xFFA5B4FC),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '7-Day Study Plans',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'DevOps · AWS · Networking  —  Theory, Hands-on & Revision',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSquareCard(BuildContext context, TimetableData tt) {
    final color = primaryColor(tt.id);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimetableDetailScreen(data: tt)),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0x12FFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tt.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              tt.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DETAIL SCREEN (one timetable)
// ─────────────────────────────────────────────────────────────────────────────
class TimetableDetailScreen extends StatefulWidget {
  final TimetableData data;
  const TimetableDetailScreen({super.key, required this.data});

  @override
  State<TimetableDetailScreen> createState() => _TimetableDetailScreenState();
}

class _TimetableDetailScreenState extends State<TimetableDetailScreen> {
  DateTime? _startDate;
  final Map<String, bool> _completed = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final startStr = prefs.getString('${widget.data.id}_start_date');
    if (startStr != null) {
      _startDate = DateTime.parse(startStr);
      _focusedDay = _startDate!;
      _selectedDay = DateTime.now();
    }
    for (final day in widget.data.days) {
      final key = '${widget.data.id}_day_${day.dayNumber}';
      _completed[key] = prefs.getBool(key) ?? false;
    }
    if (mounted) setState(() {});
  }

  Future<void> _startPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    await prefs.setString('${widget.data.id}_start_date', start.toIso8601String());

    await NotificationService().requestPermissions();

    setState(() {
      _startDate = start;
      _focusedDay = start;
      _selectedDay = start;
    });

    _scheduleAllNotifications(start);
  }

  Future<void> _scheduleAllNotifications(DateTime start) async {
    for (int i = 0; i < widget.data.days.length; i++) {
      final day = widget.data.days[i];
      final key = '${widget.data.id}_day_${day.dayNumber}';
      if (_completed[key] == true) continue;

      // Schedule reminder for 8:00 PM on that specific day
      final scheduleDate = start.add(Duration(days: i));
      final notificationTime = DateTime(
        scheduleDate.year, scheduleDate.month, scheduleDate.day, 20, 0, 0);

      final id = widget.data.id.hashCode + day.dayNumber;

      await NotificationService().scheduleDailyReminder(
        id: id,
        title: 'Study Reminder: ${widget.data.label}',
        body: 'Don\'t forget to complete Day ${day.dayNumber} learning today!',
        scheduledDate: notificationTime,
      );
    }
  }

  Future<void> _toggleComplete(DayData day) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.data.id}_day_${day.dayNumber}';
    final isDone = !(_completed[key] ?? false);

    setState(() {
      _completed[key] = isDone;
    });
    await prefs.setBool(key, isDone);

    final notifId = widget.data.id.hashCode + day.dayNumber;
    if (isDone) {
      await NotificationService().cancelNotification(notifId);
    } else {
      if (_startDate != null) {
        final scheduleDate = _startDate!.add(Duration(days: day.dayNumber - 1));
        final notificationTime = DateTime(
            scheduleDate.year, scheduleDate.month, scheduleDate.day, 20, 0, 0);
        await NotificationService().scheduleDailyReminder(
          id: notifId,
          title: 'Study Reminder: ${widget.data.label}',
          body: 'Don\'t forget to complete Day ${day.dayNumber} learning today!',
          scheduledDate: notificationTime,
        );
      }
    }
  }

  int get _doneCount =>
      widget.data.days.where((d) => _completed['${widget.data.id}_day_${d.dayNumber}'] == true).length;

  DayData? _getDayDataForDate(DateTime date) {
    if (_startDate == null) return null;
    final cleanDate = DateTime(date.year, date.month, date.day);
    final cleanStart = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final diff = cleanDate.difference(cleanStart).inDays;
    
    if (diff >= 0 && diff < widget.data.days.length) {
      return widget.data.days[diff];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pct = widget.data.days.isEmpty ? 0.0 : _doneCount / widget.data.days.length;
    final color = primaryColor(widget.data.id);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: color),
        title: Text(
          widget.data.label,
          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.data.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.data.label} — 7-Day Plan',
                            style: TextStyle(
                              color: color,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            widget.data.subtitle,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _ProgressBar(
                    id: widget.data.id,
                    doneCount: _doneCount,
                    total: widget.data.days.length,
                    pct: pct,
                    color: color),
                const SizedBox(height: 14),
                
                // Calendar or Start Button
                if (_startDate == null)
                  _buildStartPlanButton(color)
                else
                  _buildCalendar(color),
                  
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        
        // Show only the selected day, or all if none selected
        if (_startDate != null)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final day = widget.data.days[i];
                final dayDate = _startDate!.add(Duration(days: i));
                
                // If a day is selected in calendar, only show that day's card
                if (_selectedDay != null) {
                  final isSame = isSameDay(_selectedDay, dayDate);
                  if (!isSame) return const SizedBox.shrink();
                }

                final key = '${widget.data.id}_day_${day.dayNumber}';
                final isDone = _completed[key] ?? false;
                
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 6),
                        child: Text(
                          DateFormat('EEEE, MMM d').format(dayDate),
                          style: TextStyle(
                            color: isSameDay(DateTime.now(), dayDate) 
                                ? color 
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _DayCard(
                        day: day,
                        isDone: isDone,
                        primaryColor: color,
                        onToggle: () => _toggleComplete(day),
                      ),
                    ],
                  ),
                );
              },
              childCount: widget.data.days.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    ));
  }

  Widget _buildStartPlanButton(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x12FFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.rocket_launch_rounded, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ready to begin?',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Start the plan to map your schedule to the calendar and get daily reminders.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.3),
              ),
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _startPlan,
                    splashColor: Colors.white.withValues(alpha: 0.2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text(
                        'Start 7-Day Plan Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: _startDate!.subtract(const Duration(days: 30)),
            lastDay: _startDate!.add(const Duration(days: 60)),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                // Toggle selection off if tapping the same day
                if (isSameDay(_selectedDay, selectedDay)) {
                  _selectedDay = null; 
                } else {
                  _selectedDay = selectedDay;
                }
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              weekendTextStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              outsideTextStyle: const TextStyle(color: AppColors.textMuted),
              todayDecoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
              ),
              selectedDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              leftChevronIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0x1AFFFFFF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
              ),
              rightChevronIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0x1AFFFFFF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
              weekendStyle: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            eventLoader: (day) {
              final dayData = _getDayDataForDate(day);
              if (dayData != null) {
                return ['Has Plan']; // Shows a dot marker
              }
              return [];
            },
          ),
        ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PROGRESS BAR
// ─────────────────────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final String id;
  final int doneCount;
  final int total;
  final double pct;
  final Color color;
  const _ProgressBar(
      {required this.id,
      required this.doneCount,
      required this.total,
      required this.pct,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0x12FFFFFF),
            border: Border.all(color: const Color(0x2AFFFFFF), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('📊 Overall Progress',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  Text('$doneCount / $total days completed',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: const Color(0x1AFFFFFF),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DAY CARD
// ─────────────────────────────────────────────────────────────────────────────
class _DayCard extends StatefulWidget {
  final DayData day;
  final bool isDone;
  final Color primaryColor;
  final VoidCallback onToggle;

  const _DayCard({
    required this.day,
    required this.isDone,
    required this.primaryColor,
    required this.onToggle,
  });

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final done = widget.isDone;
    final color = widget.primaryColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: done
                ? Color.alphaBlend(const Color(0x1A10B981), const Color(0x1AFFFFFF))
                : const Color(0x12FFFFFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: done ? AppColors.accentGreen.withValues(alpha: 0.5) : const Color(0x2AFFFFFF),
              width: 1.5,
            ),
            boxShadow: done
                ? [BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.15), blurRadius: 20)]
                : [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              _buildHeader(color, done),
              if (_expanded) _buildBody(color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color color, bool done) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          borderRadius: _expanded
              ? const BorderRadius.vertical(top: Radius.circular(16))
              : BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Day badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.day.dayNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'DAY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.day.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.day.subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Complete toggle
            GestureDetector(
              onTap: widget.onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : const Color(0x1AFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: done ? AppColors.accentGreen : AppColors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      done ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: done ? AppColors.accentGreen : AppColors.textMuted,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      done ? 'Done' : 'Mark',
                      style: TextStyle(
                        color: done ? AppColors.accentGreen : AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Chevron
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.textMuted, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Schedule table
          _ScheduleTable(day: widget.day, color: color),
          // Tags
          _TagsRow(tags: widget.day.covered, color: color),
          // Explanation
          if (widget.day.explanation != null)
            _ExplanationSection(
              explanation: widget.day.explanation!,
              imageAsset: widget.day.imageAsset,
              color: color,
            ),
          // Q&A
          _QASection(qa: widget.day.qa, color: color),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  EXPLANATION SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _ExplanationSection extends StatelessWidget {
  final String explanation;
  final String? imageAsset;
  final Color color;

  const _ExplanationSection({
    required this.explanation,
    this.imageAsset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 6),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageAsset != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                child: Image.asset(
                  imageAsset!,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        'Textbook Explanation',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data: explanation,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                      h1: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, height: 1.6),
                      h2: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700, height: 1.5),
                      h3: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                      strong: TextStyle(color: color, fontWeight: FontWeight.w700),
                      em: const TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic),
                      listBullet: TextStyle(color: color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCHEDULE TABLE
// ─────────────────────────────────────────────────────────────────────────────
class _ScheduleTable extends StatelessWidget {
  final DayData day;
  final Color color;
  const _ScheduleTable({required this.day, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Daily Schedule',
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          // Header row
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: const Row(
              children: [
                SizedBox(
                    width: 95,
                    child: Text('Time',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700))),
                Expanded(
                    child: Text('Topic',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700))),
                SizedBox(
                    width: 90,
                    child: Text('Activity',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700))),
              ],
            ),
          ),
          // Data rows
          ...day.schedule.asMap().entries.map((e) {
            final i = e.key;
            final row = e.value;
            final isLast = i == day.schedule.length - 1;
            return Container(
              decoration: BoxDecoration(
                color: row.isBreak
                    ? AppColors.breakRow.withValues(alpha: 0.5)
                    : (i.isEven
                        ? const Color(0x0DFFFFFF)
                        : Colors.transparent),
                borderRadius: isLast
                    ? const BorderRadius.vertical(bottom: Radius.circular(8))
                    : null,
                border: Border(
                    top: BorderSide(
                        color: AppColors.cardBorder.withValues(alpha: 0.5))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 95,
                    child: Text(row.time,
                        style: TextStyle(
                            color: row.isBreak
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                            fontSize: 10,
                            fontFamily: 'monospace')),
                  ),
                  Expanded(
                    child: Text(row.topic,
                        style: TextStyle(
                            color: row.isBreak
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                            fontSize: 11,
                            fontStyle: row.isBreak
                                ? FontStyle.italic
                                : FontStyle.normal)),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(row.activity,
                        style: TextStyle(
                            color: row.isBreak
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                            fontSize: 10)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TAGS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _TagsRow extends StatelessWidget {
  final List<String> tags;
  final Color color;
  const _TagsRow({required this.tags, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          const Text('📌 Covered: ',
              style:
                  TextStyle(color: AppColors.textMuted, fontSize: 11)),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Text(t,
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Q&A SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _QASection extends StatefulWidget {
  final List<QAItem> qa;
  final Color color;
  const _QASection({required this.qa, required this.color});

  @override
  State<_QASection> createState() => _QASectionState();
}

class _QASectionState extends State<_QASection> {
  bool _open = false;
  final Set<int> _revealed = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            // Header
            GestureDetector(
              onTap: () => setState(() => _open = !_open),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    const Text('❓',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    const Text('Practice Questions & Answers',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${widget.qa.length} Q',
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textMuted, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            if (_open) ...[
              Divider(
                  height: 1,
                  color: AppColors.cardBorder),
              ...widget.qa.asMap().entries.map((e) {
                final i = e.key;
                final item = e.value;
                final revealed = _revealed.contains(i);
                return _QAItemWidget(
                  index: i,
                  item: item,
                  color: widget.color,
                  revealed: revealed,
                  onToggle: () => setState(() {
                    revealed
                        ? _revealed.remove(i)
                        : _revealed.add(i);
                  }),
                  isLast: i == widget.qa.length - 1,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Q&A ITEM
// ─────────────────────────────────────────────────────────────────────────────
class _QAItemWidget extends StatelessWidget {
  final int index;
  final QAItem item;
  final Color color;
  final bool revealed;
  final VoidCallback onToggle;
  final bool isLast;

  const _QAItemWidget({
    required this.index,
    required this.item,
    required this.color,
    required this.revealed,
    required this.onToggle,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(bottom: BorderSide(color: AppColors.cardBorder))
            : null,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(12))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question row
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.question,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: revealed
                          ? AppColors.accentGreen.withValues(alpha: 0.15)
                          : const Color(0x1AFFFFFF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: revealed
                            ? AppColors.accentGreen
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          revealed ? 'Hide' : 'Show',
                          style: TextStyle(
                            color: revealed
                                ? AppColors.accentGreen
                                : AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        AnimatedRotation(
                          turns: revealed ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 13,
                            color: revealed
                                ? AppColors.accentGreen
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Answer
          if (revealed)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x0DFFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                    left: BorderSide(color: color, width: 3)),
              ),
              child: Text(
                item.answer,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
