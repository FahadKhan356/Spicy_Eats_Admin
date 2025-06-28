import 'package:fl_chart/fl_chart.dart';
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
    void showdate() async {
      await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024, 1),
          lastDate: DateTime(2025, 12),
          builder: (context, child) {
            return Center(
              child: SizedBox(
                width: 500,
                height: 400,
                child: child,
              ),
            );
          });
    }

    final bottomTitle = {
      0: "Jan",
      20: "Feb",
      30: "March",
      40: "April",
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
                        children: [
                          const HeaderPart(),
                          SizedBox(
                            height: (size.width / 100) * 4,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.black12,
                            width: SizeConfig.screenwidth,
                            child: Wrap(
                              // direction: Axis.horizontal,
                              spacing: 30,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: infoCardData
                                  .map((e) => CustomBox(infoCardModel: e))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.black12,
                            height: 300,
                            width: 800,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: ElevatedButton(
                                      onPressed: showdate, child: Text('date')),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                    height: 250,
                                    width: 800,
                                    child: BarChartRepresentation()),
                              ],
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
