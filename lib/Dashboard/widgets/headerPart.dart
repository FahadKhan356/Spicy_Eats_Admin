import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class HeaderPart extends StatelessWidget {
  const HeaderPart({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        color: MyAppColor.primaryBg,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                      fontSize: Responsive.isDesktop(context)
                          ? size.width * 0.02
                          : size.width * 0.03,
                      height: 1.3,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Payment updates ',
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context)
                        ? size.width * 0.02
                        : size.width * 0.03,
                    height: 1.3,
                  ),
                )
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            Container(
              height:
                  // Responsive.isDesktop(context)
                  //     ? size.width * 0.025
                  //     :
                  size.width * 0.04,
              width: size.width * 0.4,
              child: TextFormField(
                cursorColor: Colors.black,
                // cursorHeight: 20,
                decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: Responsive.isDesktop(context)
                          ? size.width * 0.02
                          : size.width * 0.03,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white)),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
