import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/Authentication/Register/widgets/MobileTimeLineTask.dart';
import 'package:spicy_eats_admin/Authentication/Register/widgets/RestaurantAddress.dart';

import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';

import 'package:spicy_eats_admin/Authentication/utils/comon_image_picker.dart';

import 'package:spicy_eats_admin/Authentication/widgets/MyTimeLine.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var isimage = StateProvider<bool>((ref) => true);

class RestaurantRegister extends StatelessWidget {
  static const String routename = '/Register';
  const RestaurantRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constrain) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: constrain.maxWidth > 767
                    ? Dekstoplayout(
                        constraint: constrain,
                      )
                    : MobileLayout(
                        constraint: constrain,
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class Dekstoplayout extends ConsumerStatefulWidget {
  final BoxConstraints constraint;
  const Dekstoplayout({super.key, required this.constraint});

  @override
  ConsumerState<Dekstoplayout> createState() => _DekstoplayoutState();
}

class _DekstoplayoutState extends ConsumerState<Dekstoplayout> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  Uint8List? idImage;
  File? image;

  Future<void> handlePickImage() async {
    dynamic result = await pickImage();

    if (result is Uint8List) {
      setState(() {
        idImage = result;
      });
    } else if (result is File) {
      setState(() {
        image = result;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    businessemail.dispose();
    businessname.dispose();
    bankname.dispose();
    contactno.dispose();
    accountownername.dispose();
    iban.dispose();
    cnicno.dispose();
    lastname.dispose();
    firstandmiddlename.dispose();
    restaurantaddress.dispose();
    password.dispose();
  }

  final businessname = TextEditingController();
  final firstandmiddlename = TextEditingController();
  final lastname = TextEditingController();
  final cnicno = TextEditingController();
  final businessemail = TextEditingController();
  final contactno = TextEditingController();
  final bankname = TextEditingController();
  final accountownername = TextEditingController();
  final iban = TextEditingController();
  final restaurantaddress = TextEditingController();
  final password = TextEditingController();

  double? latitude;
  double? longitude;
  String? address;
  // final TextEditingController businessController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final address = ref.watch(restaurantLocationSelectedProvider);
    final size = MediaQuery.of(context).size;
    final isImageSelected = ref.watch(isimage);
    return Form(
      key: _form,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            // color: Colors.red,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MyTimeLine(
                      widthsize: size.width / 5,
                      isFirst: true,
                      isLast: false,
                      endChild: Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: size.width / 77, color: Colors.black),
                      ),
                    ),
                    MyTimeLine(
                      widthsize: size.width / 5,
                      isFirst: false,
                      isLast: false,
                      endChild: Text(
                        'Register Restaurant',
                        style: TextStyle(
                            fontSize: size.width / 77, color: Colors.black),
                      ),
                    ),
                    MyTimeLine(
                      widthsize: size.width / 3,
                      isFirst: false,
                      isLast: false,
                      endChild: Text(
                        'Approved',
                        style: TextStyle(
                            fontSize: size.width / 75, color: Colors.black),
                      ),
                    ),
                    MyTimeLine(
                      widthsize: size.width / 5,
                      isFirst: false,
                      isLast: true,
                      endChild: Text(
                        'Choose Plan',
                        style: TextStyle(
                            fontSize: size.width / 75, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        // topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: Container(
                      child: Image.asset(
                        'lib/assets/registerbg1.jpg',
                        fit: BoxFit.cover,
                        height: double.maxFinite,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Register Your Restaurant',
                                    style: GoogleFonts.mina(
                                        fontSize: widget.constraint.maxWidth <
                                                1024
                                            ? widget.constraint.maxWidth * 0.035
                                            : widget.constraint.maxWidth > 1024
                                                ? widget.constraint.maxWidth *
                                                    0.025
                                                : 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RegisterTextfield(
                                        controller: businessemail,
                                        labeltext: 'Enter Your Business Email',
                                        onvalidation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mandatory field Can\'t be empty ';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RegisterTextfield(
                                        controller: firstandmiddlename,
                                        labeltext:
                                            'First & Middle Name per CNIC',
                                        onvalidation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mandatory field Can\'t be empty ';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RegisterTextfield(
                                        controller: lastname,
                                        labeltext: 'Last Name Per CNIC',
                                        onvalidation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mandatory field Can\'t be empty ';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              color: Colors.black12,
                                              height: 40,
                                              width: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Image.asset(
                                                    'lib/assets/pak1.png',
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  const Text('+92')
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: RegisterTextfield(
                                                controller: contactno,
                                                labeltext: 'Mobile Number',
                                                onvalidation: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Mandatory field Can\'t be empty ';
                                                  }
                                                  final mobileno =
                                                      int.tryParse(value);
                                                  if (mobileno == null) {
                                                    return 'please enter only numbers';
                                                  }
                                                  return null;
                                                }),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Restaurantaddress(
                                          controller: restaurantaddress,
                                          onvalidation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Mandatory field Can\'t be empty';
                                            }
                                            return null;
                                          },
                                          labeltext: 'Restaurant Address'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              'lib/assets/map2.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                Responsive.isDesktop(context)
                                                    ? 40
                                                    : 30,
                                            width: double.maxFinite,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                surfaceTintColor: Colors.blue,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.5),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, MyMap.routename);
                                              },
                                              child: const Text(
                                                'Select restaurant location',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      address != null && address == true
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                'Location is not selected',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Add your bank details to recieve payments',
                                            style: GoogleFonts.mina(
                                                fontSize:
                                                    widget.constraint.maxWidth <
                                                            400
                                                        ? widget.constraint
                                                                .maxWidth *
                                                            0.06
                                                        : 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.lock,
                                                color: Colors.green,
                                                shadows: const [
                                                  BoxShadow(
                                                      color: Colors.black,
                                                      offset: Offset(0.2, 0.1))
                                                ],
                                                size:
                                                    widget.constraint.maxWidth <
                                                            400
                                                        ? widget.constraint
                                                                .maxWidth *
                                                            0.05
                                                        : 15,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Your details are secure and encrypted with us.',
                                                  style: GoogleFonts.mina(
                                                      fontSize: widget
                                                                  .constraint
                                                                  .maxWidth <
                                                              400
                                                          ? widget.constraint
                                                                  .maxWidth *
                                                              0.04
                                                          : 12,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      RegisterTextfield(
                                        controller: bankname,
                                        labeltext: 'Bank Name',
                                        onvalidation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mandatory field Can\'t be empty ';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RegisterTextfield(
                                        controller: accountownername,
                                        labeltext: 'Bank Account Owner/Title',
                                        onvalidation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mandatory field Can\'t be empty ';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RegisterTextfield(
                                        controller: iban,
                                        labeltext: 'IBAN',
                                        onvalidation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mandatory field Can\'t be empty ';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Legal Documents',
                                        style: GoogleFonts.mina(
                                            fontSize:
                                                widget.constraint.maxWidth < 400
                                                    ? size.height * 0.03
                                                    : 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxHeight: 200,
                                              minHeight: 100,
                                              maxWidth: double.maxFinite,
                                            ),
                                            child: DottedBorder(
                                              color: Colors.grey,
                                              strokeWidth: 3,
                                              dashPattern: const [12, 8],
                                              child: kIsWeb && idImage != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              child: Center(
                                                                child: Image
                                                                    .memory(
                                                                  idImage!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : !kIsWeb && image != null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Center(
                                                                    child: Image
                                                                        .file(
                                                                      image!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Center(
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    handlePickImage();

                                                                    image !=
                                                                            null
                                                                        ? ref.read(isimage.notifier).state =
                                                                            true
                                                                        : ref.read(isimage.notifier).state =
                                                                            false;
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .camera_front_rounded,
                                                                    size: widget.constraint.maxWidth >
                                                                            900
                                                                        ? 80
                                                                        : 50,
                                                                  )),
                                                            ),
                                                            Text(
                                                              'Upload Identity Card Photo',
                                                              style: TextStyle(
                                                                  fontSize: size
                                                                              .width >
                                                                          767
                                                                      ? size.width *
                                                                          0.015
                                                                      : 10,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          ],
                                                        ),
                                            ),
                                          ),
                                          kIsWeb && idImage != null
                                              ? Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      handlePickImage();
                                                      idImage != null
                                                          ? ref
                                                              .read(isimage
                                                                  .notifier)
                                                              .state = true
                                                          : ref
                                                              .read(isimage
                                                                  .notifier)
                                                              .state = false;
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          50))),
                                                      child: const Icon(
                                                        Icons.refresh,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : !kIsWeb && image == null
                                                  ? Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          handlePickImage();
                                                          image != null
                                                              ? ref
                                                                  .read(isimage
                                                                      .notifier)
                                                                  .state = true
                                                              : ref
                                                                  .read(isimage
                                                                      .notifier)
                                                                  .state = false;
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          height: 50,
                                                          width: 50,
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          50))),
                                                          child: const Icon(
                                                            Icons.refresh,
                                                            size: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                        ],
                                      ),
                                      isImageSelected == false
                                          ? const Text(
                                              'upload image please',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: Responsive.isDesktop(context)
                                            ? 40
                                            : 30,
                                        width: double.maxFinite,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (address == null) {
                                              ref
                                                  .read(
                                                      restaurantLocationSelectedProvider
                                                          .notifier)
                                                  .state = true;
                                            }
                                            if (_form.currentState!
                                                .validate()) {
                                              return;
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            surfaceTintColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: Colors.black,
                                          ),
                                          child: const Text(
                                            ' Get Started ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileLayout extends ConsumerStatefulWidget {
  final BoxConstraints constraint;
  const MobileLayout({super.key, required this.constraint});

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    businessemail.dispose();
    businessname.dispose();
    bankname.dispose();
    contactno.dispose();
    accountownername.dispose();
    iban.dispose();
    cnicno.dispose();
    lastname.dispose();
    firstandmiddlename.dispose();
    restaurantaddress.dispose();
    password.dispose();
  }

  final businessname = TextEditingController();
  final firstandmiddlename = TextEditingController();
  final lastname = TextEditingController();
  final cnicno = TextEditingController();
  final businessemail = TextEditingController();
  final contactno = TextEditingController();
  final bankname = TextEditingController();
  final accountownername = TextEditingController();
  final iban = TextEditingController();
  final restaurantaddress = TextEditingController();
  final password = TextEditingController();

  double? latitude;
  double? longitude;
  String? address;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  Uint8List? idImage;

  @override
  Widget build(BuildContext context) {
    final isImageSelected = ref.watch(isimage);
    final address = ref.watch(restaurantLocationSelectedProvider);
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              // color: Colors.red,
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MyTimeLine(
                        widthsize: size.width < 350
                            ? size.width / 5
                            : size.width / 4.5,
                        isFirst: true,
                        isLast: false,
                        endChild: Text(
                          textAlign: TextAlign.center,
                          'Create Account',
                          style: TextStyle(
                              fontSize: constraints.maxWidth > 600
                                  ? size.width / 60
                                  : 8,
                              color: Colors.black),
                        ),
                      ),
                      MyTimeLine(
                        widthsize: size.width < 350
                            ? size.width / 5
                            : size.width / 4.5,
                        isFirst: false,
                        isLast: false,
                        endChild: Text(
                          textAlign: TextAlign.center,
                          'Register Restaurant',
                          style: TextStyle(
                              fontSize: constraints.maxWidth > 600
                                  ? size.width / 60
                                  : 8,
                              color: Colors.black),
                        ),
                      ),
                      MyTimeLine(
                        widthsize: size.width < 350
                            ? size.width / 5
                            : size.width / 4.5,
                        isFirst: false,
                        isLast: false,
                        endChild: Text(
                          textAlign: TextAlign.center,
                          'Approved',
                          style: TextStyle(
                              fontSize: constraints.maxWidth > 600
                                  ? size.width / 60
                                  : 8,
                              color: Colors.black),
                        ),
                      ),
                      MyTimeLine(
                        widthsize: size.width < 350
                            ? size.width / 5
                            : size.width / 4.5,
                        isFirst: false,
                        isLast: true,
                        endChild: Text(
                          textAlign: TextAlign.center,
                          'Choose Plan',
                          style: TextStyle(
                              fontSize: constraints.maxWidth > 600
                                  ? size.width / 60
                                  : 8,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register Your Restaurant',
                              style: GoogleFonts.mina(
                                  fontSize: widget.constraint.maxWidth < 900
                                      ? widget.constraint.maxWidth * 0.05
                                      : widget.constraint.maxWidth > 400
                                          ? widget.constraint.maxWidth * 0.03
                                          : 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RegisterTextfield(
                                    controller: businessemail,
                                    labeltext: 'Enter Your Business Email',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: firstandmiddlename,
                                    labeltext: 'First & Middle Name per CNIC',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: lastname,
                                    labeltext: 'Last Name Per CNIC',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  constraints.maxWidth > 300
                                                      ? 80
                                                      : 40,
                                              maxHeight:
                                                  constraints.maxWidth > 300
                                                      ? 40
                                                      : 60,
                                            ),
                                            color: Colors.black12,
                                            // height: 40,
                                            // width: 80,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // constraints.maxWidth > 200
                                                //     ?
                                                Flexible(
                                                  child: Image.asset(
                                                    'lib/assets/pak1.png',
                                                    height:
                                                        constraints.maxWidth <
                                                                300
                                                            ? 20
                                                            : 30,
                                                    width:
                                                        // constraints.maxWidth <
                                                        //         300
                                                        //     ? 20
                                                        //     :
                                                        30,
                                                  ),
                                                ),

                                                constraints.maxWidth > 300
                                                    ? Flexible(
                                                        child: const Text(
                                                          '+92',
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: RegisterTextfield(
                                            controller: contactno,
                                            labeltext: 'Mobile Number',
                                            onvalidation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Mandatory field Can\'t be empty ';
                                              }
                                              final mobileno =
                                                  int.tryParse(value);
                                              if (mobileno == null) {
                                                return 'please enter only numbers';
                                              }
                                              return null;
                                            }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Restaurantaddress(
                                      controller: restaurantaddress,
                                      onvalidation: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Mandatory field Can\'t be empty';
                                        }
                                        return null;
                                      },
                                      labeltext: 'Restaurant Address'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Stack(
                                    children: [
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'lib/assets/map2.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: Responsive.isDesktop(context)
                                              ? 40
                                              : 30,
                                          width: double.maxFinite,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              surfaceTintColor: Colors.blue,
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.5),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, MyMap.routename);
                                            },
                                            child: Text(
                                              'Select restaurant location',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white,
                                                  fontSize: size.width < 400
                                                      ? size.width / 20
                                                      : 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  address != null && address == true
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            'Location is not selected',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add your bank details to recieve payments',
                                        style: GoogleFonts.mina(
                                            fontSize:
                                                widget.constraint.maxWidth < 400
                                                    ? widget.constraint
                                                            .maxWidth *
                                                        0.05
                                                    : 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.lock,
                                            color: Colors.green,
                                            shadows: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.2, 0.1))
                                            ],
                                            size: widget.constraint.maxWidth <
                                                    400
                                                ? widget.constraint.maxWidth *
                                                    0.05
                                                : 15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Your details are secure and encrypted with us.',
                                              style: GoogleFonts.mina(
                                                  fontSize: widget.constraint
                                                              .maxWidth <
                                                          400
                                                      ? widget.constraint
                                                              .maxWidth *
                                                          0.03
                                                      : 12,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: bankname,
                                    labeltext: 'Bank Name',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: accountownername,
                                    labeltext: 'Bank Account Owner/Title',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: iban,
                                    labeltext: 'IBAN',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Legal Documents',
                                    style: GoogleFonts.mina(
                                        fontSize:
                                            widget.constraint.maxWidth < 400
                                                ? size.height * 0.03
                                                : 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 200,
                                          minHeight: 100,
                                          maxWidth: double.maxFinite,
                                        ),
                                        child: DottedBorder(
                                          color: Colors.grey,
                                          strokeWidth: 3,
                                          dashPattern: const [12, 8],
                                          child: idImage != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Center(
                                                            child: Image.memory(
                                                              idImage!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Center(
                                                      child: IconButton(
                                                          onPressed: () async {
                                                            pickImage();
                                                            // pickimagefromgallery();
                                                            idImage != null
                                                                ? ref
                                                                        .read(isimage
                                                                            .notifier)
                                                                        .state =
                                                                    true
                                                                : ref
                                                                    .read(isimage
                                                                        .notifier)
                                                                    .state = false;
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .camera_front_rounded,
                                                            size: widget.constraint
                                                                        .maxWidth >
                                                                    300
                                                                ? 80
                                                                : 50,
                                                          )),
                                                    ),
                                                    Text(
                                                      'Upload Identity Card Photo',
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.width > 400
                                                                  ? size.width *
                                                                      0.03
                                                                  : 10,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      idImage != null
                                          ? Positioned(
                                              top: 0,
                                              left: 0,
                                              child: InkWell(
                                                onTap: () async {
                                                  pickImage();
                                                  idImage != null
                                                      ? ref
                                                          .read(
                                                              isimage.notifier)
                                                          .state = true
                                                      : ref
                                                          .read(
                                                              isimage.notifier)
                                                          .state = false;
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  height: 50,
                                                  width: 50,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          50))),
                                                  child: const Icon(
                                                    Icons.refresh,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  isImageSelected == false
                                      ? const Text(
                                          'upload image please',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height:
                                        Responsive.isDesktop(context) ? 40 : 30,
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (address == null) {
                                          ref
                                              .read(
                                                  restaurantLocationSelectedProvider
                                                      .notifier)
                                              .state = true;
                                        }
                                        if (_form.currentState!.validate()) {}
                                      },
                                      style: ElevatedButton.styleFrom(
                                        surfaceTintColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: Colors.black,
                                      ),
                                      child: const Text(
                                        ' Get Started ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
