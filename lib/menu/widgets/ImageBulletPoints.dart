import 'package:flutter/material.dart';

Widget imageBulletPoints({String? text}) {
  return Row(
    children: [
     const Icon(Icons.circle, size: 8, color: Colors.black87),
     const  SizedBox(width: 6),
      Expanded(child: Text(text!,style: const TextStyle(overflow: TextOverflow.ellipsis),)),
    ],
  );
}
