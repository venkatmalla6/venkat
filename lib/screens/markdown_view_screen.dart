import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../data/timetable_data.dart';
import 'timetable_screen.dart'; // for AppColors and primaryColor

class MarkdownViewScreen extends StatelessWidget {
  final DayData day;
  final String timetableId;

  const MarkdownViewScreen({
    super.key,
    required this.day,
    required this.timetableId,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor(timetableId);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: color),
        title: Text(
          'Day ${day.dayNumber}: ${day.title}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
      body: day.explanation == null || day.explanation!.isEmpty
          ? const Center(
              child: Text(
                'No notes available for this day.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : Markdown(
              data: day.explanation!,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.6,
                ),
                h1: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                h2: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                h3: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                listBullet: TextStyle(color: color),
                code: const TextStyle(
                  backgroundColor: Color(0x1AFFFFFF),
                  color: AppColors.textSecondary,
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: const Color(0x12FFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x2AFFFFFF)),
                ),
                strong: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
