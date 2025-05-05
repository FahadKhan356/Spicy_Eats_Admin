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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SizedBox(
        // height: SizeConfig.screenheight,
        // height: 100,

        width: 100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 30,
                  width: 25,
                  child: SvgPicture.asset('lib/assets/three_color.svg'),
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
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: SvgPicture.asset(
                                  menuicons[index],
                                  color: selectedindex == index
                                      ? Colors.black
                                      : MyAppColor.iconGray,
                                  width: 30,
                                  height: Responsive.isDesktop(context)
                                      ? size.width * 0.02
                                      : size.width * 0.04,
                                ),
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
