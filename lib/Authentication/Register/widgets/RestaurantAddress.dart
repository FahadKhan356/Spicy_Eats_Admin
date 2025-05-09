import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class Restaurantaddress extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) onvalidation;
  final String labeltext;

  const Restaurantaddress(
      {super.key,
      required this.controller,
      required this.onvalidation,
      required this.labeltext});

  @override
  State<Restaurantaddress> createState() => _RestaurantaddressState();
}

bool showmenu = false;

class _RestaurantaddressState extends State<Restaurantaddress> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            TextFormField(
              controller: widget.controller,
              validator: widget.onvalidation,
              cursorColor: MyAppColor.iconGray,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showmenu = !showmenu;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down)),
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.transparent,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  label: Text(widget.labeltext),
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 12),
                  floatingLabelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                    //  const BorderSide(
                    //     color: MyAppColor.iconGray,
                    //     width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                    //  const BorderSide(
                    //     color: MyAppColor.iconGray,
                    //     width: 1),
                  )),
            ),
            showmenu ? const MyDrop() : const SizedBox(),
          ],
        ),
      ],
    );
  }
}

class MyDrop extends StatelessWidget {
  const MyDrop({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 100,
        width: double.maxFinite,
        // color: Colors.red,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Text(
              'No Result',
            )),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // surfaceTintColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      Text(
                        'Enter manually',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
