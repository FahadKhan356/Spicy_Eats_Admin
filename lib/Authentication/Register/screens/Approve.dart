import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/widgets/MyTimeLine.dart';

class Approve extends ConsumerWidget {
  static const String routename = '/Approve';
  const Approve({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final authrepo = ref.watch(authRepoProvider);
    final authStep = ref.watch(authStepsProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: Colors.black,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: size.width > 150
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Spicy Eats",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.orange[700],
                                  fontSize: size.width > 720 ? 20 : 15),
                            ),
                            Text(
                              "Partner Portal",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: size.width > 720 ? 15 : 10),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            await authrepo.signout(context);
                          },
                          child: Row(children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            size.width < 370
                                ? const SizedBox()
                                : const Text(
                                    'Log out',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white),
                                  ),
                          ]),
                        ),
                      ],
                    )
                  : const SizedBox()),
        ),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: double.maxFinite),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                // color: Colors.red,
                width: double.infinity,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MyTimeLine(
                          afterlineColor: authStep != null && authStep >= 2
                              ? Colors.black
                              : Colors.black26,
                          widthsize: size.width < 350
                              ? size.width / 5
                              : size.width / 4.5,
                          isFirst: true,
                          isLast: false,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Create Account',
                            style: TextStyle(
                                fontSize:
                                    size.width > 600 ? size.width / 60 : 8,
                                color: authStep != null && authStep >= 1
                                    ? Colors.black
                                    : Colors.black26),
                          ),
                          icon: Icons.account_box,
                          iconColor: Colors.white,
                          iconBg: authStep != null && authStep >= 1
                              ? Colors.black
                              : Colors.black26,
                        ),
                        MyTimeLine(
                          afterlineColor: authStep != null && authStep >= 3
                              ? Colors.black
                              : Colors.black26,
                          beforelineColor: authStep != null && authStep >= 2
                              ? Colors.black
                              : Colors.black26,
                          icon: Icons.restaurant,
                          iconColor: Colors.white,
                          iconBg: authStep != null && authStep >= 2
                              ? Colors.black
                              : Colors.black26,
                          widthsize: size.width < 350
                              ? size.width / 5
                              : size.width / 4.5,
                          isFirst: false,
                          isLast: false,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Register Restaurant',
                            style: TextStyle(
                                fontSize:
                                    size.width > 600 ? size.width / 60 : 8,
                                color: authStep != null && authStep >= 2
                                    ? Colors.black
                                    : Colors.black26),
                          ),
                        ),
                        MyTimeLine(
                          afterlineColor: authStep != null && authStep >= 4
                              ? Colors.black
                              : Colors.black26,
                          beforelineColor: authStep != null && authStep >= 3
                              ? Colors.black
                              : Colors.black26,
                          icon: Icons.subscriptions,
                          iconColor: Colors.white,
                          iconBg: authStep != null && authStep >= 3
                              ? Colors.black
                              : Colors.black26,
                          widthsize: size.width < 350
                              ? size.width / 5
                              : size.width / 4.5,
                          isFirst: false,
                          isLast: false,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Choose Plan',
                            style: TextStyle(
                                fontSize:
                                    size.width > 600 ? size.width / 60 : 8,
                                color: authStep != null && authStep >= 3
                                    ? Colors.black
                                    : Colors.black26),
                          ),
                        ),
                        MyTimeLine(
                          beforelineColor: authStep != null && authStep >= 4
                              ? Colors.black
                              : Colors.black26,
                          icon: Icons.verified_user_sharp,
                          iconColor: Colors.white,
                          iconBg: authStep != null && authStep >= 4
                              ? Colors.black
                              : Colors.black26,
                          widthsize: size.width < 350
                              ? size.width / 5
                              : size.width / 4.5,
                          isFirst: false,
                          isLast: true,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Approved',
                            style: TextStyle(
                                fontSize:
                                    size.width > 600 ? size.width / 60 : 8,
                                color: authStep != null && authStep >= 4
                                    ? Colors.black
                                    : Colors.black26),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Step Indicator
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: size.width < 768
                            ? double.maxFinite
                            : size.width * 0.6),
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Icon(
                                Icons.access_time_sharp,
                                color: Colors.black,
                                size: size.width < 768 ? 40 : 60,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Pending Review',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'Your restaurant application is under review.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width < 768 ? 15 : 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'Please wait for some time while we review your information.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width < 768 ? 15 : 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
