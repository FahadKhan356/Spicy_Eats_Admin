import 'package:flutter/material.dart';

void showCustomSnackbar({
  // bool? isweb,
  required context,
  required String message,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 3),
  double elevation = 2.0,
  IconData? icon,
  bool? showFromTop,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // padding: isweb!
      //     ? const EdgeInsets.symmetric(horizontal: 300)
      //     : EdgeInsets.zero,
      margin: showFromTop == true
          ? EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -
                  100, // Adjust 100 as needed
              left: 20,
              right: 20,
            )
          : null,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: FloatingSnackbarContent(
        message: message,
        backgroundColor: backgroundColor ?? Colors.amberAccent,
      )));
}

class FloatingSnackbarContent extends StatelessWidget {
  const FloatingSnackbarContent(
      {super.key,
      required this.message,
      required this.backgroundColor,
      this.icon});
  final String message;
  final Color backgroundColor;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 10,
        //     offset: Offset(1, 1),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 24),
          if (icon != null) const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.white),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ],
      ),
    );
  }
}
