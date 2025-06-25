import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/Approve.dart';
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
  int platformDeliveryCommission = 30;
  int ownDeliveryCommission = 14;
  bool pickupEnabled = false;
  int pickupCommision = 14;
  bool usesPlatformDelivery = true;
  int deliveryOption = 30;
  final userid = supabaseClient.auth.currentUser!.id;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authRepoProvider).checkAuthSteps(context, ref);
      ref.read(isloadingprovider.notifier).state = false;
      await ref.read(authRepoProvider).fetchaddress(ref);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authStep = ref.watch(authStepsProvider);
    final size = MediaQuery.of(context).size;
    final authrepo = ref.watch(authRepoProvider);
    final authController = ref.watch(authControllerProvider);
    final address = ref.watch(restaurantAddressProvider);
    final isloader = ref.watch(isloadingprovider);

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
                        size.width > 300
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      address != null
                                          ? Flexible(
                                              child: Text(
                                                ' $address',
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white),
                                              ),
                                            )
                                          : const Center(
                                              child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ))
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                          isPlatformdelivery: true,
                          value: platformDeliveryCommission,
                          title: 'Use delivery people on Uber',
                          subtitle: '30% fee per order',
                        ),
                        deliveryRadioTile(
                          isPlatformdelivery: false,
                          value: ownDeliveryCommission,
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
                          side: const BorderSide(color: Colors.black),
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
                            children: [
                              const Text("Pickup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 6),
                              const Text(
                                  "Let customers pick up their orders to get more sales at a lower cost."),
                              const Text("14% fee per order",
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
                usesPlatformDelivery
                    ? TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Learn More",
                          style: TextStyle(color: Colors.black),
                        ))
                    : SizedBox(),

                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Approve.routename);
                      },
                      child: Text('Approve')),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(isloadingprovider.notifier).state = true;

                      await authController.storePlan(
                          context: context,
                          deliveryCommission: deliveryOption,
                          usesPlatformDelivery: usesPlatformDelivery,
                          offersPickup: pickupEnabled,
                          pickUpCommission: pickupCommision,
                          userid: userid);
                      ref.read(isloadingprovider.notifier).state = false;
                    },
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
                        isloader
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const SizedBox(),
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
    required isPlatformdelivery,
  }) {
    return RadioListTile<int>(
      fillColor: const WidgetStatePropertyAll(Colors.black),
      value: value,
      groupValue: deliveryOption,
      onChanged: (val) {
        setState(() {
          deliveryOption = val!;
          usesPlatformDelivery = isPlatformdelivery;
        });
      },
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
          child: const Icon(Icons.check, color: Colors.white, size: 16),
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
