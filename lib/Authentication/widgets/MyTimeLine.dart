import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';

var createAccountProvider = StateProvider<bool>((ref) => false);
var registerRestaurantProvider = StateProvider<bool>((ref) => false);
var accountApprovedProvider = StateProvider<bool>((ref) => false);
var choosePlanProvider = StateProvider<bool>((ref) => false);

class MyTimeLine extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Widget? endChild;
  final Widget? startChild;
  final double widthsize;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const MyTimeLine({
    super.key,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.isFirst,
    required this.isLast,
    this.endChild,
    this.startChild,
    required this.widthsize,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: widthsize,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: const LineStyle(color: Colors.black45),
        afterLineStyle: const LineStyle(color: Colors.black45),
        indicatorStyle: IndicatorStyle(
          width: size.width < 300 ? 20 : 100,
          color: iconBg,
          iconStyle: IconStyle(
            iconData: icon,
            color: iconColor,
          ),
        ),
        endChild: endChild,
        startChild: startChild,
      ),
    );
  }
}
