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
                  onPressed: () {
                    showStoreAddressDialog(context);
                  },
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

void showStoreAddressDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      final width = MediaQuery.of(context).size.width;
      final isSmallScreen = width < 500;

      Widget dialogContent = Container(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen
              ? double.infinity
              : width < 750 && !isSmallScreen
                  ? width * 0.8
                  : width * 0.5,
        ),
        margin: isSmallScreen ? EdgeInsets.zero : const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              isSmallScreen ? BorderRadius.zero : BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isSmallScreen)
              Text(
                'Store Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (!isSmallScreen) const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Store Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Floor/Suite',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'City and Postal Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Next logic
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      );

      if (isSmallScreen) {
        // Fullscreen mobile style
        return Scaffold(
          appBar: AppBar(
            title: Text('Store Address'),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: dialogContent,
          ),
        );
      } else {
        // Floating dialog style
        return Dialog(
          backgroundColor: Colors.transparent, // fix for unwanted white bg
          insetPadding: const EdgeInsets.all(16),
          child: dialogContent,
        );
      }
    },
  );
}
