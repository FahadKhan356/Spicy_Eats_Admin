import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicy_eats_admin/Dashboard/model.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/config/size_config.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class CustomBox extends StatelessWidget {
  final InfoCardModel infoCardModel;
  CustomBox({super.key, required this.infoCardModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Container(
      constraints: BoxConstraints(
        minWidth: Responsive.isDesktop(context)
            ? size.width / 7
            : SizeConfig.screenwidth / 2 - 40,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.only(
          top: 20,
          right: Responsive.isMobile(context) ? 20 : 40,
          left: 20,
          bottom: 20),
      child: Column(
        children: [
          SvgPicture.asset(
            infoCardModel.icon,
            width: 35,
          ),
          SizedBox(height: SizeConfig.blockSizevertical * 2),
          Text(
            infoCardModel.amount,
            style: const TextStyle(
                height: 1.3, fontSize: 16, color: MyAppColor.secondary),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
