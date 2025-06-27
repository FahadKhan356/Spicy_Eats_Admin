import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicy_eats_admin/utils/colors.dart';
import 'package:spicy_eats_admin/utils/list.dart';

class SideDrawerMenu extends StatefulWidget {
  const SideDrawerMenu({super.key});

  @override
  State<SideDrawerMenu> createState() => _SideDrawerMenuState();
}

class _SideDrawerMenuState extends State<SideDrawerMenu> {
  int selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      //   surfaceTintColor: MyAppColor.mainPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        // height: SizeConfig.screenheight,
        // height: 100,

        width: 100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                // color: Colors.white,
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 80,
                  width: double.maxFinite,
                  child: Image.asset(
                    'lib/assets/SpicyEats.png',
                  ),
                  //  SvgPicture.asset(
                  //   'lib/assets/three_color.svg',
                  //   theme: SvgTheme(currentColor: Colors.white),
                  // ),
                ),
              ),
              ...List.generate(
                  menuicons.length,
                  (index) => InkWell(
                        hoverColor: Colors.white70,
                        onTap: () {
                          setState(() {
                            selectedindex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Image.asset(
                                      menuicons[index],
                                      color: selectedindex == index
                                          ? Colors.black
                                          : MyAppColor.iconGray,
                                      width: 60,
                                      height: Responsive.isDesktop(context)
                                          ? size.width * 0.02
                                          : size.width * 0.04,
                                    ),
                                  ),
                                  Text(
                                    menuTitles[index],
                                  ),
                                ],
                              ),
                              Container(
                                width: 3,
                                height: 40,
                                color: selectedindex == index
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
