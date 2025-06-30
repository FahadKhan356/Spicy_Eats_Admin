import 'package:flutter/material.dart';

class OrderRejectConfirmBtn extends StatelessWidget {
  const OrderRejectConfirmBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 30,
          width: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onPressed: () {},
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          height: 30,
          width: 90,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {},
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white, fontSize: 10),
              )),
        )
      ],
    );
  }
}
