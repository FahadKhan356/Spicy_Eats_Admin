
import 'dart:ui';

import 'package:flutter/material.dart';

Widget elevatedCustomButton({required VoidCallback onpress, Widget? label, double? bheight, double? bwidth , Widget? icon}){
  return SizedBox(
    height: bheight,
    width: bwidth,
    child: ElevatedButton.icon(
      icon: icon,
    style:   ElevatedButton.styleFrom(
      // padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22,),
      iconColor: Colors.white,backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
    ),
      onPressed: onpress, label: label?? const SizedBox()));
}