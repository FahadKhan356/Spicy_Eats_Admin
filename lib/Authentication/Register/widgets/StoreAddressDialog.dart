import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Register/widgets/RestaurantAddress.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';

void showStoreAddressDialog(
  BuildContext context, {
  TextEditingController? storeController,
  TextEditingController? floorController,
  TextEditingController? cityController,
  TextEditingController? postalController,
  WidgetRef? ref,
}) {
  final address = ref!.watch(restaurantAddProvider);
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

                  return 'Mandatory field Can\'t be empty';
                },
              ),
              const SizedBox(height: 20),
              RegisterTextfield(
                controller: floorController!,
                labeltext: 'Floor/Suite',
                onvalidation: (value) {
                  return 'Mandatory field Can\'t be empty';
                },
              ),
              const SizedBox(height: 20),
              RegisterTextfield(
                controller: cityController!,
                labeltext: 'City and Postal Code',
                onvalidation: (value) {
                  return 'Mandatory field Can\'t be empty';
                },
              ),
              const SizedBox(height: 20),
              RegisterTextfield(
                controller: postalController!,
                labeltext: 'Postal Code',
                onvalidation: (value) {
                  return 'Mandatory field Can\'t be empty';
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
                            address == null
                                ? showCustomSnackbar(
                                    context: context,
                                    message: 'Please Pick Location',
                                    // showFromTop: true,
                                    backgroundColor: Colors.black)
                                : const SizedBox();
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
