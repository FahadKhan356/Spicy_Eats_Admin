import 'package:spicy_eats_admin/Authentication/Signup/screen/SignupScreen.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/dummyMenu/ExpandableCategoryMenu.dart';
import 'package:spicy_eats_admin/menu/Menu.dart' hide MenuScreen;

List<String> menuicons = [
  "lib/assets/Dashboard.png",
  "lib/assets/Menu.png",
  "lib/assets/Dishes.png",
  "lib/assets/Orders.png",
  "lib/assets/Promotion.png",
];

List<Map<String,dynamic>> menuTitles = [
  {'title': 'Dashboard', 'route':Dashboard.routename},
 

     {'title': 'Menu', 'route':MenuManagerScreen.routename,},
    {'title': 'Dishes', 'route':MenuScreen.routename},
     {'title': 'Orders', 'route':'/menu'},
      {'title': 'Promotions', 'route':'/menu'},

];
