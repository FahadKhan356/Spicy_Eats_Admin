import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class RegisterTextfield extends StatelessWidget {
  final String labeltext;
  final String? Function(String?) onvalidation;
  final TextEditingController controller;

  RegisterTextfield(
      {super.key,
      required this.labeltext,
      required this.onvalidation,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: onvalidation,
      cursorColor: MyAppColor.iconGray,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          label: Text(labeltext),
          labelStyle: const TextStyle(color: Colors.black),
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
