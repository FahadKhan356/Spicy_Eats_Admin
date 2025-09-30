

import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

Widget addDishTextField({required String labeltext, String? hintText,required TextEditingController controller, String? Function(String?)? validator,int? maxLines, TextInputType? keyboardType}){
  return TextFormField(
    
    maxLines: maxLines,
    keyboardType: keyboardType,
                       decoration: InputDecoration(
                        hintText: hintText ?? '',
                        hintStyle: const TextStyle(color: Colors.black, fontSize: 10, overflow: TextOverflow.ellipsis),
        
          filled: true,
          fillColor: MyAppColor.textfieldFillColor,
          focusColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          label:  Text(labeltext),
          labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
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
                      controller: controller,
                   
                      validator: validator,// (v) { if(v == null || v.trim().isEmpty){ return 'Required'; } else{ return null;} },
                    );
}