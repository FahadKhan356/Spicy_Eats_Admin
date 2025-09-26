import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/utils/colors.dart';
import 'package:spicy_eats_admin/utils/list.dart';

final selecteIndexProvider=StateProvider((ref)=>0);


class SideDrawerMenu extends ConsumerStatefulWidget {
  const SideDrawerMenu({super.key});

  @override
  ConsumerState<SideDrawerMenu> createState() => _SideDrawerMenuState();
}
 void onRoute(String route, BuildContext context){
  context.go(route);
}


class _SideDrawerMenuState extends ConsumerState<SideDrawerMenu> {
 
  bool isSelected=false;
  @override
  Widget build(BuildContext context) {
 final selectedIndex = ref.watch(selecteIndexProvider);

    final size = MediaQuery.of(context).size;
    return Drawer(
      //   surfaceTintColor: MyAppColor.mainPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        color: Colors.white,
        // height: SizeConfig.screenheight,
        // height: 100,

        width: 100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                // color: Colors.white,
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 80,
                  width: double.maxFinite,
                  child: Image.asset(
                    'lib/assets/SpicyEats.png',
                  ),
                  //  SvgPicture.asset(
                  //   'lib/assets/three_color.svg',
                  //   theme: SvgTheme(currentColor: Colors.white),
                  // ),
                ),
              ),
              ...List.generate(
                  menuTitles.length,
                  (index) => InkWell(
                        hoverColor: Colors.white70,
                        onTap: () {
                            ref.read(selecteIndexProvider.notifier).state=index;
                            Responsive.isMobile(context)? Navigator.of(context).pop(): null;
                                  onRoute(menuTitles[index]['route'],context);
                            isSelected = GoRouterState.of(context).uri.toString() == menuTitles[selectedIndex]['route'];
                          
                          // setState(() {
                          //   selectedindex = index;
                          //      onRoute(menuTitles[selectedindex]['route'],context);
                          //   // isSelected = GoRouterState.of(context).uri.toString() == menuTitles[selectedindex]['route'];
                          // });
                           
                        context.go( menuTitles[index]['route'],);
                     
                        
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Image.asset(
                                      menuicons[index],
                                      color: selectedIndex == index
                                          ? Colors.black
                                          : MyAppColor.iconGray,
                                      width: 60,
                                      height: Responsive.isDesktop(context)
                                          ? size.width * 0.02
                                          : size.width * 0.04,
                                    ),
                                  ),
                                  Text(
                                    menuTitles[index]['title'],
                                  ),
                                ],
                              ),
                              Container(
                                width: 3,
                                height: 40,
                                color: selectedIndex == index
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      )
                      )
            ],
          ),
        ),
      ),
    );
  }
}
