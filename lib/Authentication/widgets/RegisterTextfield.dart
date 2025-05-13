import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class RegisterTextfield extends StatelessWidget {
  final String labeltext;
  final String? Function(String?) onvalidation;
  final TextEditingController? controller;

  const RegisterTextfield(
      {super.key,
      required this.labeltext,
      required this.onvalidation,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: onvalidation,
      cursorColor: MyAppColor.iconGray,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          focusColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          label: Text(labeltext),
          labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
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
    );
  }
}
