import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
import 'package:spicy_eats_admin/orders/screen/OrdersScreen.dart';
import 'package:spicy_eats_admin/promotions/screen/PromotionsScreen.dart';

class NavItem {
  final String title;
  final String route;
  final String icon;
  final bool enabled;

  const NavItem({
    required this.title,
    required this.route,
    required this.icon,
    this.enabled = true,
  });
}

const List<NavItem> navItems = [
  NavItem(
    title: 'Dashboard',
    route: Dashboard.routename,
    icon: 'lib/assets/Dashboard.png',
  ),
  NavItem(
    title: 'Menu Manager',
    route: MenuManagerScreen.routename,
    icon: 'lib/assets/Menu.png',
  ),
  NavItem(
    title: 'Orders',
    route: OrdersScreen.routename,
    icon: 'lib/assets/Orders.png',
  ),
  NavItem(
    title: 'Promotions',
    route: PromotionsScreen.routename,
    icon: 'lib/assets/Promotion.png',
  ),
];
