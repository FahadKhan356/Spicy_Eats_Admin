import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/Dashboard/widgets/Order_reject_confirmbtn.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';

class Recentorderwidget extends StatelessWidget {
  const Recentorderwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxHeight: 150,
        maxWidth: Responsive.isDesktop(context)
            ? 350
            : Responsive.isTablet(context)
                ? 350
                : double.maxFinite,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 3,
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'ORDER ID - 752',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'ORDER DATE - May 11,2020 . 05:56 PM',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    'lib/assets/registerbg3.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Tacipapas x 7 more',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Payment-Online (Stripe)',
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Spacer(),
          const Divider(
            color: Colors.black12,
            thickness: 2,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Price -  \$148.70',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              OrderRejectConfirmBtn(),
            ],
          ),
        ],
      ),
    );
  }
}
