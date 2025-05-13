import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/widgets/customMap.dart';

class MyMap extends ConsumerStatefulWidget {
  static const String routename = '/map';
  const MyMap({super.key});

  @override
  ConsumerState<MyMap> createState() => _MyMapState();
}

class _MyMapState extends ConsumerState<MyMap> {
  @override
  Widget build(BuildContext context) {
    final lat = ref.watch(restaurantLatProvider);
    final long = ref.watch(restaurantLongProvider);
    final address = ref.watch(restaurantAddProvider);

    return SafeArea(
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(80),
        //   child: Container(
        //     decoration: const BoxDecoration(boxShadow: [
        //       BoxShadow(
        //           color: Colors.black45,
        //           spreadRadius: 1,
        //           blurRadius: 4,
        //           offset: Offset(1, 1)),
        //     ]),
        //     child: AppBar(
        //       title: const Center(
        //         child: Text(
        //           'Select Restaurant Location',
        //           style: TextStyle(
        //               fontSize: 30,
        //               fontWeight: FontWeight.bold,
        //               letterSpacing: 2),
        //         ),
        //       ),
        //       leading: IconButton(
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //           icon: const Icon(
        //             Icons.arrow_back_ios,
        //             color: Colors.black,
        //           )),
        //     ),
        //   ),
        // ),
        body: SizedBox(
          // height: 300,
          child: Column(
            children: [
              Expanded(
                child: CustomMap(
                    initialLatitude: 25.3936435,
                    initialLongitude: 68.3838603,
                    onPicked: (result) {
                      // you can get the location result here
                      if (mounted) {
                        ref.read(restaurantAddProvider.notifier).state =
                            result.completeAddress;
                        ref.read(restaurantLatProvider.notifier).state =
                            result.latitude;
                        ref.read(restaurantLongProvider.notifier).state =
                            result.longitude;
                        ref
                            .read(restaurantLocationSelectedProvider.notifier)
                            .state = false;
                      }

                      print(address);
                      print(lat);
                      print(long);
                      // print(result.completeAddress);
                      // print(result.latitude);
                      // print(result.longitude);
                    }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: address != null
            ? Text('$address (Lat: $lat, Long: $long)')
            : const Text('Loading location...'),
      ),
    );
  }
}
