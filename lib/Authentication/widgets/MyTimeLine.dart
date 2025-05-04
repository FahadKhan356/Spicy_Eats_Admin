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
  final Widget endChild;

  const MyTimeLine({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.endChild,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width / 8,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TimelineTile(
          axis: TimelineAxis.horizontal,
          alignment: TimelineAlign.center,
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: const LineStyle(color: Colors.black45),
          afterLineStyle: const LineStyle(color: Colors.black45),
          indicatorStyle: IndicatorStyle(
            width: 36,
            color: Colors.green,
            iconStyle: IconStyle(
              iconData: Icons.done,
              color: Colors.white,
            ),
          ),
          endChild: endChild),
    );
  }
}
