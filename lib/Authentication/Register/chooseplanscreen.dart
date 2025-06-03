import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';

import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/widgets/MyTimeLine.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';

class ChoosePlanScreen extends ConsumerStatefulWidget {
  static const String routename = '/Chooseplan';
  const ChoosePlanScreen({super.key});

  @override
  ConsumerState<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends ConsumerState<ChoosePlanScreen> {
  int platformDelivery = 30;
  int ownDelivery = 14;

  int deliveryOption = 30;
  bool pickupEnabled = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authRepoProvider).checkAuthSteps(context, ref);
      ref.read(isloadingprovider.notifier).state = false;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final authStep = ref.watch(authStepsProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: const Text(
          "Uber Eats for Merchants",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.help_outline))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isWide ? 600 : double.maxFinite),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
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
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        await supabaseClient.auth.signOut();
                      },
                      child: const Text('log out')),
                ),
                // Step Indicator

                const SizedBox(height: 32),
                const Text(
                  "dani, choose how you want to partner.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text("You can change selections later."),
                const SizedBox(height: 24),

                // Delivery Box
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Delivery",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        deliveryRadioTile(
                          value: platformDelivery,
                          title: 'Use delivery people on Uber',
                          subtitle: '30% fee per order',
                        ),
                        deliveryRadioTile(
                          value: ownDelivery,
                          title: 'Use your own delivery staff',
                          subtitle: '14% fee per order',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Pickup Box
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          side: BorderSide(color: Colors.black),
                          activeColor: Colors.amber,
                          // focusColor: Colors.red,
                          checkColor: Colors.black,

                          fillColor: WidgetStateProperty.all(Colors.white),
                          value: pickupEnabled,
                          onChanged: (val) {
                            setState(() {
                              pickupEnabled = val!;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Pickup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              SizedBox(height: 6),
                              Text(
                                  "Let customers pick up their orders to get more sales at a lower cost."),
                              Text("14% fee per order",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "There’s a €400 activation fee per location typically paid after you fulfill your first few orders. ",
                  style: TextStyle(fontSize: 13),
                ),
                TextButton(onPressed: () {}, child: const Text("Learn More")),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          ' Submit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // isloading
                        //     ? const SizedBox(
                        //         height: 20,
                        //         width: 20,
                        //         child:
                        //             CircularProgressIndicator(
                        //           padding:
                        //               EdgeInsets.all(
                        //                   2),
                        //           strokeWidth: 3,
                        //           color: Colors.white,
                        //         ),
                        //       )
                        //     : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deliveryRadioTile({
    required int value,
    required String title,
    required String subtitle,
  }) {
    return RadioListTile<int>(
      fillColor: WidgetStatePropertyAll(Colors.black),
      value: value,
      groupValue: deliveryOption,
      onChanged: (val) => setState(() => deliveryOption = val!),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget stepIndicator(String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? Colors.black : Colors.grey.shade300,
          child: Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
        const SizedBox(height: 2),
        Text("Est. 3-5 min",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}
