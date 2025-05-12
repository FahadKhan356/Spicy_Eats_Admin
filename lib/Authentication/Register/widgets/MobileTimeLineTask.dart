import 'package:flutter/material.dart';

class Mobiletimelinetask extends StatelessWidget {
  const Mobiletimelinetask({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double circlesize = size.width / 15;
    return
        //  size.width >= 201
        //     ?
        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: size.width / 4, maxHeight: size.width / 150),
          color: Colors.black,
        ),
        ClipRRect(
          // borderRadius: BorderRadius.circular(circlesize / 2),
          child: Container(
            height: circlesize,
            width: circlesize,
            color: Colors.green,
            child: Icon(
              Icons.done,
              size: 15,
            ),
          ),
        )
      ],
    );
    // : const SizedBox();
  }
}
