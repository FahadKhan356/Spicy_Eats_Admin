import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicy_eats_admin/Dashboard/model.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/size_config.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class CustomBox extends StatelessWidget {
  final InfoCardModel infoCardModel;
  const CustomBox({super.key, required this.infoCardModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Container(
      constraints: BoxConstraints(
        minWidth: Responsive.isDesktop(context)
            ? size.width / 8
            : SizeConfig.screenwidth / 2 - 40,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
        ],
        // borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        // border: Border.all(color: MyAppColor.mainPrimary)
      ),
      // padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   infoCardModel.icon,
              //   width: 35,
              // ),
              SizedBox(
                height: SizeConfig.blockSizevertical * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      infoCardModel.label,
                      style: const TextStyle(
                        height: 1.3,
                        fontSize: 16,
                        color: MyAppColor.mainPrimary,
                      ),
                    ),
                    // Small container with arrow and percent text
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '+12%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  infoCardModel.amount,
                  style: const TextStyle(
                      height: 1.3, fontSize: 16, color: MyAppColor.mainPrimary),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Responsive.isDesktop(context)
                    ? size.width / 8
                    : SizeConfig.screenwidth / 2 - 40,
                child: AspectRatio(
                    aspectRatio: 16 / 6,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false, reservedSize: 40),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final labels = {
                                  0: "Jan",
                                  1: "Feb",
                                  2: "Mar",
                                  3: "Apr",
                                  4: "May",
                                  5: "Jun",
                                  6: "Jul",
                                  7: "Aug",
                                  8: "Sep",
                                  9: "Oct",
                                  10: "Nov",
                                  11: "Dec"
                                };
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 6,
                                  child: Text(
                                    labels[value.toInt()] ?? '',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 10),
                                  ),
                                );
                              },
                              interval: 1,
                              reservedSize: 28,
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: false,
                            spots: [
                              FlSpot(0, 2),
                              FlSpot(1, 2.5),
                              FlSpot(2, 3),
                              FlSpot(3, 5),
                              FlSpot(4, 1),
                              FlSpot(5, 7.5),
                              FlSpot(6, 5),
                              FlSpot(7, 6),
                              FlSpot(8, 4.5),
                              FlSpot(9, 3.5),
                              FlSpot(10, 4),
                              FlSpot(11, 6),
                            ],
                            color: Colors.deepOrangeAccent,
                            barWidth: 1,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.deepOrangeAccent.withOpacity(0.6),
                                  Colors.deepOrangeAccent.withOpacity(0.0),
                                ],
                                stops: [0.0, 1.0], // Fill ~60% below the line
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
