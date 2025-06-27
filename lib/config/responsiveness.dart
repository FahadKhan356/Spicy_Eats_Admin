import 'package:flutter/material.dart';

// for displaying specific displays for mobiles , tablet and dekstop layout

class Responsive extends StatelessWidget {
  //widget to show mobile screen (320px - 767px)
  final Widget mobile;

  //optional widget to show tablet screen (768px - 1024px)
  final Widget tablet;

  //widget to show dekstop screen (1025px - above px)
  final Widget dekstop;

  Responsive(
      {super.key,
      required this.mobile,
      required this.tablet,
      required this.dekstop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 767;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 &&
      MediaQuery.of(context).size.width >= 767;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1025;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width >= 1025) {
      return dekstop;
    } else if (size.width >= 768) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
