import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Dashboard/model.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/CustomBox.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/FilterButtonDashboard.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/RecentOrderWidget.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/barchart.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/headerPart.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/side_drawer_menu.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/size_config.dart';
import 'package:spicy_eats_admin/menu/controller/MenuManagerController.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

  final GlobalKey<ScaffoldState> drawerkey = GlobalKey<ScaffoldState>();

class Dashboard extends ConsumerStatefulWidget {
  static const String routename = '/Dashboard';
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {


  Future<void> initialDataFetch() async {
    await ref.read(menuManagerController).fetchRestaurantData();
  }

  @override
  void initState() {
    initialDataFetch();
    // TODO: implement initState
    super.initState();
  }

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
      
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // if (Responsive.isDesktop(context))
              //   const Expanded(flex: 2, child: SideDrawerMenu()),
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
                                          child:
                                              const BarChartRepresentation()),
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
                                          child:
                                              const BarChartRepresentation()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: Center(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 20,
                                children: List.generate(10,
                                        (index) => const Recentorderwidget())
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
