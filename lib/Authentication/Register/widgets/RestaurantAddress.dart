import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/Register/widgets/DropDownStoreAddress.dart';
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
