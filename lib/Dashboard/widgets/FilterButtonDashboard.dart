import 'package:flutter/material.dart';

class Filterbuttondashboard extends StatelessWidget {
  const Filterbuttondashboard({super.key});

  @override
  Widget build(BuildContext context) {
    void showdate() async {
      await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024, 1),
          lastDate: DateTime(2025, 12),
          builder: (context, child) {
            return Center(
              child: SizedBox(
                width: 500,
                height: 400,
                child: child,
              ),
            );
          });
    }

    return Row(children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26, width: 1)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '04/02/2024',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '11/02/2024',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      SizedBox(
        height: 30,
        width: 120,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onPressed: showdate,
            child: const Text(
              'Filter By Date',
              style: TextStyle(color: Colors.white, fontSize: 12),
            )),
      ),
    ]);
  }
}
