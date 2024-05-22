import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:achievement_app/models/achievement.dart';

class AchievementChart extends StatelessWidget {
  final Box<Achievement> achievementBox = Hive.box('achievements');

  @override
  Widget build(BuildContext context) {
    Map<String, int> categoryCounts = _calculateCategoryCounts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Pencapaian'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTotalAchievementInfo(categoryCounts),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildPieChart(categoryCounts),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateCategoryCounts() {
    Map<String, int> categoryCounts = {};

    for (var achievement in achievementBox.values) {
      categoryCounts[achievement.category] =
          (categoryCounts[achievement.category] ?? 0) + 1;
    }

    return categoryCounts;
  }

  Widget _buildTotalAchievementInfo(Map<String, int> categoryCounts) {
    int totalAchievements = categoryCounts.values.fold(0, (a, b) => a + b);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Total Pencapaian: $totalAchievements',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPieChart(Map<String, int> categoryCounts) {
    List<PieChartSectionData> sections = _buildSections(categoryCounts);

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(enabled: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(Map<String, int> categoryCounts) {
    List<Color> categoryColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
    ];

    return categoryCounts.entries.map((entry) {
      int colorIndex = categoryCounts.keys.toList().indexOf(entry.key);
      Color color = categoryColors[colorIndex % categoryColors.length];

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: entry.key,
        color: color,
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();
  }
}
