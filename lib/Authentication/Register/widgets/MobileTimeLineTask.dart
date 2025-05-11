import 'package:flutter/material.dart';

class Mobiletimelinetask extends StatelessWidget {
  const Mobiletimelinetask({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= 201
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: size.width / 2.5, maxHeight: size.width / 140),

                // width: 200,
                color: Colors.black,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(size.width < 350 ? 10 : 5),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: size.width < 350 && size.width > 200 ? 20 : 5,
                      maxHeight: size.width < 350 && size.width > 200 ? 20 : 5),
                  height: 30,
                  width: 30,
                  color: Colors.green,
                  child: Icon(
                    Icons.done,
                    size: 15,
                  ),
                ),
              )
            ],
          )
        : const SizedBox();
  }
}
