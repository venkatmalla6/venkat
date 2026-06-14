import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/timetable_data.dart';

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
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, bool> _completed = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: allTimetables.length, vsync: this);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final tt in allTimetables) {
        for (final day in tt.days) {
          final key = '${tt.id}_day_${day.dayNumber}';
          _completed[key] = prefs.getBool(key) ?? false;
        }
      }
    });
  }

  Future<void> _toggleComplete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completed[key] = !(_completed[key] ?? false);
    });
    await prefs.setBool(key, _completed[key]!);
  }

  int _doneCount(TimetableData tt) =>
      tt.days.where((d) => _completed['${tt.id}_day_${d.dayNumber}'] == true).length;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: allTimetables.map((tt) {
                      return _TimetablePanel(
                        data: tt,
                        completedMap: _completed,
                        onToggle: (key) => _toggleComplete(key),
                        doneCount: _doneCount(tt),
                      );
                    }).toList(),
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

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          return Row(
            children: List.generate(allTimetables.length, (i) {
              final tt = allTimetables[i];
              final isActive = _tabController.index == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _tabController.animateTo(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      gradient: isActive ? tabActiveGradient(tt.id) : null,
                      color: isActive ? null : AppColors.card,
                      border: Border.all(
                        color: isActive
                            ? primaryColor(tt.id)
                            : AppColors.cardBorder,
                        width: isActive ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: glowColor(tt.id),
                                blurRadius: 16,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(tt.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(
                          tt.label,
                          style: TextStyle(
                            color: isActive
                                ? primaryColor(tt.id)
                                : AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PANEL (one timetable)
// ─────────────────────────────────────────────────────────────────────────────
class _TimetablePanel extends StatelessWidget {
  final TimetableData data;
  final Map<String, bool> completedMap;
  final void Function(String key) onToggle;
  final int doneCount;

  const _TimetablePanel({
    required this.data,
    required this.completedMap,
    required this.onToggle,
    required this.doneCount,
  });

  @override
  Widget build(BuildContext context) {
    final pct = doneCount / data.days.length;
    final color = primaryColor(data.id);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                Row(
                  children: [
                    Text(data.emoji,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.label} — 7-Day Plan',
                            style: TextStyle(
                              color: color,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            data.subtitle,
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
                // Progress bar
                _ProgressBar(
                    id: data.id,
                    doneCount: doneCount,
                    total: data.days.length,
                    pct: pct,
                    color: color),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final day = data.days[i];
              final key = '${data.id}_day_${day.dayNumber}';
              final isDone = completedMap[key] ?? false;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _DayCard(
                  day: day,
                  isDone: isDone,
                  primaryColor: color,
                  onToggle: () => onToggle(key),
                ),
              );
            },
            childCount: data.days.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('📊 Overall Progress',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Text('$doneCount / $total days completed',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: const Color(0x1AFFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: done
            ? Color.alphaBlend(const Color(0x0A10B981), AppColors.card)
            : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: done ? AppColors.accentGreen.withValues(alpha: 0.35) : AppColors.cardBorder,
        ),
        boxShadow: done
            ? [BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.08), blurRadius: 12)]
            : null,
      ),
      child: Column(
        children: [
          _buildHeader(color, done),
          if (_expanded) _buildBody(color),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color, bool done) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          borderRadius: _expanded
              ? const BorderRadius.vertical(top: Radius.circular(16))
              : BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Day badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.day.dayNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'DAY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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
        children: [
          // Schedule table
          _ScheduleTable(day: widget.day, color: color),
          // Tags
          _TagsRow(tags: widget.day.covered, color: color),
          // Q&A
          _QASection(qa: widget.day.qa, color: color),
        ],
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
