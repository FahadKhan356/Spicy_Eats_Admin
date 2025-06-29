import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';

class BarChartRepresentation extends StatelessWidget {
  const BarChartRepresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        // Or adjust based on your data max value2. Temporarily REMOVE interval from SideTitles
        barGroups: _generateBarGroups(context),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.center,
        gridData: const FlGridData(
          drawVerticalLine: false,
          drawHorizontalLine: false,
          // horizontalInterval: 30,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 40,
              // interval: 30,
              getTitlesWidget: (value, meta) {
                final val = value.toDouble().round();
                switch (val) {
                  case 0:
                    return const Text('0',
                        style: TextStyle(fontSize: 12, color: Colors.grey));

                  case 30:
                    return const Text('10k',
                        style: TextStyle(fontSize: 12, color: Colors.grey));
                  case 60:
                    return const Text('50k',
                        style: TextStyle(fontSize: 12, color: Colors.grey));
                  case 90:
                    return const Text('100k',
                        style: TextStyle(fontSize: 12, color: Colors.grey));
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final index = value.toDouble().round();

                List<String?> months = [
                  'JAN',
                  'FEB',
                  'MAR',
                  'APR',
                  'MAY',
                  'JUN',
                  'JUL',
                ];
                if (index >= 0 && index < months.length) {
                  return Text(months[index] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  List<BarChartGroupData> _generateBarGroups(BuildContext context) {
    final List<double>? values = [
      20,
      35,
      50,
      90,
      60,
      40,
      25,
    ];
    return List.generate(values!.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: Colors.black,
            width: Responsive.isDesktop(context) ? 20 : 10,
            borderRadius: BorderRadius.zero,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: Colors.white,
            ),
          ),
        ],
      );
    });
  }
}
