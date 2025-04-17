import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Dashboard/model.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/CustomBox.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/barchart.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/headerPart.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/side_drawer_menu.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/size_config.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  GlobalKey<ScaffoldState> drawerkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: MyAppColor.primaryBg,
        key: drawerkey,
        drawer: const SizedBox(width: 100, child: SideDrawerMenu()),
        appBar: !Responsive.isDesktop(context)
            ? AppBar(
                elevation: 0,
                leading: IconButton(
                    onPressed: () {
                      drawerkey.currentState!.openDrawer();
                    },
                    icon: const Icon(Icons.menu)),
              )
            : const PreferredSize(preferredSize: Size.zero, child: SizedBox()),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(flex: 1, child: SideDrawerMenu()),
              Expanded(
                  flex: 10,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const HeaderPart(),
                          SizedBox(
                            height: (size.width / 100) * 4,
                          ),
                          SizedBox(
                            width: SizeConfig.screenwidth,
                            child: Wrap(
                              // direction: Axis.horizontal,
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.spaceEvenly,
                              children: infoCardData
                                  .map((e) => CustomBox(infoCardModel: e))
                                  .toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 200,
                            child: BarChartRepresentation(),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
