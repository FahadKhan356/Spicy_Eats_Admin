import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Dashboard/model.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/CustomBox.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/FilterButtonDashboard.dart';
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
    final bottomTitle = {
      0: "Jan",
      20: "Feb",
      30: "March",
      40: "April",
      50: "Jan",
      60: "Feb",
      70: "March",
      80: "April",
      90: "Jan",
      100: "Feb",
      110: "March",
      120: "April",
    };
    SizeConfig().init(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: MyAppColor.primaryBg,
        key: drawerkey,
        drawer: const SizedBox(width: 200, child: SideDrawerMenu()),
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
                const Expanded(flex: 2, child: SideDrawerMenu()),
              Expanded(
                  flex: 10,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const HeaderPart(),
                          SizedBox(
                            height: (size.width / 100) * 4,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            width: SizeConfig.screenwidth,
                            child: Wrap(
                              // direction: Axis.horizontal,
                              spacing: 30,
                              runSpacing: 20,
                              alignment: WrapAlignment.start,
                              children: infoCardData
                                  .map((e) => CustomBox(infoCardModel: e))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: Responsive.isDesktop(context)
                                        ? 310
                                        : Responsive.isTablet(context)
                                            ? 310
                                            : 310,
                                    maxWidth: Responsive.isDesktop(context)
                                        ? 500
                                        : Responsive.isTablet(context)
                                            ? 400
                                            : double.maxFinite,
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Filterbuttondashboard(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          constraints: BoxConstraints(
                                            maxHeight: Responsive.isDesktop(
                                                    context)
                                                ? 250
                                                : Responsive.isTablet(context)
                                                    ? 250
                                                    : 250,
                                            maxWidth: Responsive.isDesktop(
                                                    context)
                                                ? 500
                                                : Responsive.isTablet(context)
                                                    ? 400
                                                    : double.maxFinite,
                                          ),
                                          child: BarChartRepresentation()),
                                    ],
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: Responsive.isDesktop(context)
                                        ? 310
                                        : Responsive.isTablet(context)
                                            ? 310
                                            : 310,
                                    maxWidth: Responsive.isDesktop(context)
                                        ? 500
                                        : Responsive.isTablet(context)
                                            ? 400
                                            : double.maxFinite,
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Filterbuttondashboard(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          constraints: BoxConstraints(
                                            maxHeight: Responsive.isDesktop(
                                                    context)
                                                ? 250
                                                : Responsive.isTablet(context)
                                                    ? 250
                                                    : 250,
                                            maxWidth: Responsive.isDesktop(
                                                    context)
                                                ? 500
                                                : Responsive.isTablet(context)
                                                    ? 400
                                                    : double.maxFinite,
                                          ),
                                          child: BarChartRepresentation()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 20,
                            children: List.generate(
                              10,
                              (index) => Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      Responsive.isDesktop(context) ? 150 : 100,
                                  maxWidth:
                                      Responsive.isDesktop(context) ? 350 : 250,
                                ),
                                color: Colors.red,
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          'ORDER ID - 752',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          'ORDER DATE - May 11,2020 . 05:56 PM',
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              'lib/assets/registerbg3.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Tacipapas x 7 more',
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                    const Text(
                                      'Payment-Online (Stripe)',
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ).toList(),
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
