import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaquerydata;
  static late double screenheight;
  static late double screenwidth;
  static late double blockSizeHorizantal;
  static late double blockSizevertical;

  void init(BuildContext context) {
    _mediaquerydata = MediaQuery.of(context);

    screenheight = _mediaquerydata.size.height;
    screenwidth = _mediaquerydata.size.width;
    blockSizeHorizantal = screenwidth / 100;
    blockSizevertical = screenheight / 100;
  }
}
