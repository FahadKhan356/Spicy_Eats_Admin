 import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';

Widget buildStatCard(String label, String value, Color color, context) {
  final size = MediaQuery.of(context).size;
    return Expanded(flex: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  overflow: TextOverflow.clip,
                fontSize: Responsive.isDesktop(context)? size.width * 0.016 : Responsive.isTablet(context)?size.width * 0.025 : Responsive.isMobile(context)? size.width * 0.035 : 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
             const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: Responsive.isDesktop(context)?  size.width * 0.010  :  Responsive.isTablet(context)?  size.width * 0.014:   Responsive.isMobile(context)?size.width * 0.025 : 20 ,
                color:const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
}