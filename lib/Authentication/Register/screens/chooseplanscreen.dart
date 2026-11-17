import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';

import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/widgets/MyTimeLine.dart';
import 'package:spicy_eats_admin/config/router.dart';
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
    final authStep = ref.watch(authStepsProvider) ?? currentAuthStep.value ?? 2;
    final size = MediaQuery.of(context).size;
    final authrepo = ref.watch(authRepoProvider);
    final authController = ref.watch(authControllerProvider);
    final address = ref.watch(restaurantAddressProvider);
    final isloader = ref.watch(isloadingprovider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Spicy Eats",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                      fontSize: size.width > 720 ? 20 : 16,
                    ),
                  ),
                  Text(
                    "Partner Portal",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white70,
                      fontSize: size.width > 720 ? 13 : 11,
                    ),
                  ),
                ],
              ),
              if (size.width > 500 &&
                  address != null &&
                  address.trim().isNotEmpty)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.orange[700],
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              address,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  await authrepo.signout(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 18,
                      ),
                      if (size.width >= 370) ...[
                        const SizedBox(width: 6),
                        const Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width > 600 ? 32 : 16,
            vertical: 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
                width: double.infinity,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MyTimeLine(
                          afterlineColor:
                              authStep >= 1 ? Colors.black : Colors.black26,
                          widthsize: size.width < 500
                              ? 90
                              : (size.width / 5).clamp(110.0, 200.0),
                          isFirst: true,
                          isLast: false,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Create Account',
                            style: TextStyle(
                              fontSize: size.width > 600 ? 13 : 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  authStep >= 1 ? Colors.black : Colors.black38,
                            ),
                          ),
                          icon: Icons.account_box,
                          iconColor: Colors.white,
                          iconBg: authStep >= 1 ? Colors.black : Colors.black26,
                        ),
                        MyTimeLine(
                          afterlineColor:
                              authStep >= 2 ? Colors.black : Colors.black26,
                          beforelineColor:
                              authStep >= 1 ? Colors.black : Colors.black26,
                          icon: Icons.restaurant,
                          iconColor: Colors.white,
                          iconBg: authStep >= 1 ? Colors.black : Colors.black26,
                          widthsize: size.width < 500
                              ? 90
                              : (size.width / 5).clamp(110.0, 200.0),
                          isFirst: false,
                          isLast: false,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Register Restaurant',
                            style: TextStyle(
                              fontSize: size.width > 600 ? 13 : 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  authStep >= 1 ? Colors.black : Colors.black38,
                            ),
                          ),
                        ),
                        MyTimeLine(
                          afterlineColor:
                              authStep >= 3 ? Colors.black : Colors.black26,
                          beforelineColor:
                              authStep >= 2 ? Colors.black : Colors.black26,
                          icon: Icons.subscriptions,
                          iconColor: Colors.white,
                          iconBg: authStep >= 2
                              ? Colors.orange.shade800
                              : Colors.black26,
                          widthsize: size.width < 500
                              ? 90
                              : (size.width / 5).clamp(110.0, 200.0),
                          isFirst: false,
                          isLast: false,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Choose Plan',
                            style: TextStyle(
                              fontSize: size.width > 600 ? 13 : 11,
                              fontWeight: FontWeight.bold,
                              color:
                                  authStep >= 2 ? Colors.black : Colors.black38,
                            ),
                          ),
                        ),
                        MyTimeLine(
                          beforelineColor:
                              authStep >= 3 ? Colors.black : Colors.black26,
                          icon: Icons.verified_user_sharp,
                          iconColor: Colors.white,
                          iconBg: authStep >= 3 ? Colors.black : Colors.black26,
                          widthsize: size.width < 500
                              ? 90
                              : (size.width / 5).clamp(110.0, 200.0),
                          isFirst: false,
                          isLast: true,
                          endChild: Text(
                            textAlign: TextAlign.center,
                            'Approved',
                            style: TextStyle(
                              fontSize: size.width > 600 ? 13 : 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  authStep >= 3 ? Colors.black : Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose how you want to partner with Spicy Eats",
                      style: TextStyle(
                        fontSize: size.width > 600 ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Select your preferred delivery & pickup commission plan. You can update this anytime later.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Delivery Box
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.delivery_dining,
                                  color: Colors.orange[800],
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Delivery Options",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          deliveryRadioTile(
                            isPlatformdelivery: true,
                            value: platformDeliveryCommission,
                            title: 'Use Spicy Eats delivery partners',
                            subtitle:
                                '30% commission per order • Real-time GPS tracking & rider support',
                          ),
                          const SizedBox(height: 10),
                          deliveryRadioTile(
                            isPlatformdelivery: false,
                            value: ownDeliveryCommission,
                            title: 'Use your own delivery staff',
                            subtitle:
                                '14% commission per order • Manage deliveries with your own riders',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pickup Box
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        setState(() {
                          pickupEnabled = !pickupEnabled;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: pickupEnabled
                                ? Colors.black
                                : Colors.grey.shade200,
                            width: pickupEnabled ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              side: const BorderSide(color: Colors.black54),
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              value: pickupEnabled,
                              onChanged: (val) {
                                setState(() {
                                  pickupEnabled = val ?? false;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Enable Self-Pickup",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "14% fee",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Let customers pick up their orders directly from your restaurant to get more sales at a lower commission.",
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange[800],
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Rs 0 upfront activation fee — commission is only deducted from completed orders on Spicy Eats.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isloader
                            ? null
                            : () async {
                                ref.read(isloadingprovider.notifier).state =
                                    true;
                                try {
                                  await authController.storePlan(
                                    context: context,
                                    deliveryCommission: deliveryOption,
                                    usesPlatformDelivery: usesPlatformDelivery,
                                    offersPickup: pickupEnabled,
                                    pickUpCommission: pickupCommision,
                                    userid: userid,
                                  );
                                } finally {
                                  if (mounted) {
                                    ref.read(isloadingprovider.notifier).state =
                                        false;
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Save Plan & Continue',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (isloader) ...[
                              const SizedBox(width: 12),
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deliveryRadioTile({
    required int value,
    required String title,
    required String subtitle,
    required bool isPlatformdelivery,
  }) {
    final bool selected = deliveryOption == value;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          deliveryOption = value;
          usesPlatformDelivery = isPlatformdelivery;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Colors.orange.withValues(alpha: 0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: RadioListTile<int>(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          fillColor: const WidgetStatePropertyAll(Colors.black),
          value: value,
          groupValue: deliveryOption,
          onChanged: (val) {
            setState(() {
              deliveryOption = val!;
              usesPlatformDelivery = isPlatformdelivery;
            });
          },
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
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
