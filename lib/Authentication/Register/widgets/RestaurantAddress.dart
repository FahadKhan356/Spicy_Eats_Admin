import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

var isNextProvider = StateProvider<bool>((ref) => false);
var showmapProvider = StateProvider<bool>((ref) => false);

class Restaurantaddress extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) onvalidation;
  final String labeltext;
  final TextEditingController storeController;
  final TextEditingController floorController;
  final TextEditingController cityController;
  final TextEditingController postalController;

  const Restaurantaddress({
    super.key,
    required this.controller,
    required this.storeController,
    required this.floorController,
    required this.cityController,
    required this.postalController,
    required this.onvalidation,
    required this.labeltext,
  });

  @override
  ConsumerState<Restaurantaddress> createState() => _RestaurantaddressState();
}

bool showmenu = false;

class _RestaurantaddressState extends ConsumerState<Restaurantaddress> {
  @override
  void initState() {
    super.initState();

    widget.storeController.addListener(_checkFields);
    widget.floorController.addListener(_checkFields);
    widget.cityController.addListener(_checkFields);
    widget.postalController.addListener(_checkFields);
  }

// Optional: update `isNextProvider` if you want validation right away
  void _checkFields() {
    //solution 1 : for
    //  exception was thrown: Bad state: Cannot use "ref" after the widget was disposed.
    if (!mounted) return;
    ref.read(isNextProvider.notifier).state =
        widget.storeController.text.isNotEmpty &&
            widget.floorController.text.isNotEmpty &&
            widget.cityController.text.isNotEmpty &&
            widget.postalController.text.isNotEmpty;
  }

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
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )),
            ),
            showmenu
                ? MyDrop(
                    storeController: widget.storeController,
                    floorController: widget.floorController,
                    cityController: widget.cityController,
                    postalController: widget.postalController,
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}

class MyDrop extends ConsumerStatefulWidget {
  final TextEditingController storeController;
  final TextEditingController floorController;
  final TextEditingController cityController;
  final TextEditingController postalController;

  const MyDrop({
    super.key,
    required this.storeController,
    required this.floorController,
    required this.cityController,
    required this.postalController,
  });

  @override
  ConsumerState<MyDrop> createState() => _MyDropState();
}

class _MyDropState extends ConsumerState<MyDrop> {
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  showStoreAddressDialog(
                    context,
                    storeController: widget.storeController,
                    floorController: widget.floorController,
                    cityController: widget.cityController,
                    postalController: widget.postalController,
                    ref: ref,
                  );
                },
                style: ElevatedButton.styleFrom(
                  // surfaceTintColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Icon(
                        size: 15,
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    size.width > 200
                        ? Expanded(
                            flex: 7,
                            child: Text(
                              'Enter manually',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showStoreAddressDialog(
  BuildContext context, {
  TextEditingController? storeController,
  TextEditingController? floorController,
  TextEditingController? cityController,
  TextEditingController? postalController,
  WidgetRef? ref,
}) {
  final ismap = ref!.watch(showmapProvider);
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      final width = MediaQuery.of(context).size.width;
      final isSmallScreen = width < 500;

      Widget dialogContent = SingleChildScrollView(
        child: Container(
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
                const Text(
                  'Store Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (!isSmallScreen) const SizedBox(height: 16),
              RegisterTextfield(
                controller: storeController!,
                labeltext: 'Store Address',
                onvalidation: (value) {
                  if (value != null || value!.isNotEmpty) {}

                  return null;
                },
              ),
              const SizedBox(height: 20),
              RegisterTextfield(
                controller: floorController!,
                labeltext: 'Floor/Suite',
                onvalidation: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RegisterTextfield(
                controller: cityController!,
                labeltext: 'City and Postal Code',
                onvalidation: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RegisterTextfield(
                controller: postalController!,
                labeltext: 'Postal Code',
                onvalidation: (value) {
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // if (ismap)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 1,
                ),
                child: const MyMap(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      final isNext = ref.watch(isNextProvider);
                      return Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                isNext ? Colors.black : Colors.white,
                          ),
                          onPressed: () {
                            isNext
                                ? () {
                                    ref.read(showmapProvider.notifier).state =
                                        true;
                                  }
                                : null;
                          },
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: isNext ? Colors.white : Colors.grey)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      if (isSmallScreen) {
        // Fullscreen mobile style
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Store Address',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
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
