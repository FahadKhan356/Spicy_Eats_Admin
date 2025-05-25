import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Register/widgets/StoreAddressDialog.dart';

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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
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
                    const Expanded(
                      flex: 3,
                      child: Icon(
                        size: 15,
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    size.width > 200
                        ? const Expanded(
                            flex: 7,
                            child: Text(
                              'Enter manually',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          )
                        : const SizedBox(),
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
