import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../common/section_header.dart';

class WeeklyStatsChart extends StatelessWidget {
  final Map<int, double> weeklyStats;

  const WeeklyStatsChart({
    super.key,
    required this.weeklyStats,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total
    double total = weeklyStats.values.fold(0, (sum, val) => sum + val);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'This Week',
          actionText: '${total.toStringAsFixed(1)} km',
        ),
        const SizedBox(height: AppConstants.stackMd),
        Container(
          height: 200,
          padding: const EdgeInsets.only(
            top: AppConstants.stackLg,
            bottom: AppConstants.stackMd,
            left: AppConstants.stackMd,
            right: AppConstants.stackMd,
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getTitles,
                    reservedSize: 28,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarGroup(1, weeklyStats[1] ?? 0),
                _buildBarGroup(2, weeklyStats[2] ?? 0),
                _buildBarGroup(3, weeklyStats[3] ?? 0),
                _buildBarGroup(4, weeklyStats[4] ?? 0),
                _buildBarGroup(5, weeklyStats[5] ?? 0),
                _buildBarGroup(6, weeklyStats[6] ?? 0),
                _buildBarGroup(7, weeklyStats[7] ?? 0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMaxY() {
    double maxVal = 0;
    for (var val in weeklyStats.values) {
      if (val > maxVal) maxVal = val;
    }
    // Add 20% headroom, minimum 5
    return (maxVal * 1.2).clamp(5.0, double.infinity);
  }

  Widget _getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1: text = 'M'; break;
      case 2: text = 'T'; break;
      case 3: text = 'W'; break;
      case 4: text = 'T'; break;
      case 5: text = 'F'; break;
      case 6: text = 'S'; break;
      case 7: text = 'S'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.accentNeon,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _calculateMaxY(),
            color: AppColors.backgroundPrimary, // Track color
          ),
        ),
      ],
    );
  }
}
