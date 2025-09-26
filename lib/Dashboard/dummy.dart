
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/Dashboard/Dashboard.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/side_drawer_menu.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/menu/screen/MenuScreen.dart';
class DashboardLayout extends StatefulWidget {
  final Widget child;
  const DashboardLayout({super.key, required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _currentIndex = 0;

  final List<String> routes = [
    Dashboard.routename,
    MenuManagerScreen.routename,
    '/promo',
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    _currentIndex = routes.indexOf(currentRoute);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.blueGrey.shade900,
            child: Column(
              children: [
                _buildMenuItem(context, "Dashboard", Dashboard.routename),
                _buildMenuItem(context, "Menu", MenuManagerScreen.routename),
                _buildMenuItem(context, "Promo", "/promo"),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                Dashboard(),
                const MenuManagerScreen(),
                const Center(child: Text("Promo Page", style: TextStyle(fontSize: 30))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final isSelected = currentRoute == route;

    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.red,
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      onTap: () {
        if (!isSelected) {
          context.go(route);
        }
      },
    );
  }
}
