import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/widgets/MyTimeLine.dart';
import 'package:spicy_eats_admin/config/router.dart';

class Approve extends ConsumerStatefulWidget {
  static const String routename = '/Approve';
  const Approve({super.key});

  @override
  ConsumerState<Approve> createState() => _ApproveState();
}

class _ApproveState extends ConsumerState<Approve> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authRepoProvider).checkAuthSteps(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authrepo = ref.watch(authRepoProvider);
    final authStep = ref.watch(authStepsProvider) ?? currentAuthStep.value ?? 3;
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
                          iconBg: authStep >= 2 ? Colors.black : Colors.black26,
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
                              fontWeight: FontWeight.w600,
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
                          iconBg: authStep >= 3
                              ? Colors.orange.shade800
                              : Colors.black26,
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
                              fontWeight: FontWeight.bold,
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
              const SizedBox(height: 36),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.orange[800],
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Application Under Review',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your Spicy Eats restaurant partner application has been submitted and is currently being reviewed by our team.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Once approved, your dashboard will unlock automatically.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}
