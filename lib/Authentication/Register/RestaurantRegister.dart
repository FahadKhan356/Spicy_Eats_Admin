import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:spicy_eats_admin/Authentication/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/utils/commonImagePicker.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantRegister extends StatelessWidget {
  static const String routename = '/Register';
  const RestaurantRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'lib/assets/SpicyeatsLogo-removebg.png',
          width: 40,
          height: 40,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
                height: 30,
                width: size.width > 767
                    ? 100
                    : size.width < 767 && size.width > 300
                        ? 100
                        : size.width < 300 && size.width > 120
                            ? 80
                            : 10,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, LoginScreen.routename),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width > 767
                            ? 14
                            : size.width < 767 && size.width > 300
                                ? 14
                                : size.width < 300 && size.width > 120
                                    ? 10
                                    : 8),
                  ),
                )),
          )
        ],
      ),
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
  Dekstoplayout({super.key, required this.constraint});

  @override
  ConsumerState<Dekstoplayout> createState() => _DekstoplayoutState();
}

class _DekstoplayoutState extends ConsumerState<Dekstoplayout> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  Uint8List? idImage;
  Future<void> pickImage() async {
    try {
      final pickedimage = await ImagePickerWeb.getImageAsBytes();
      if (pickedimage != null) {
        setState(() {
          idImage = pickedimage;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
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
    mobileno.dispose();
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
  final mobileno = TextEditingController();
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
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Container(
                child: Image.asset(
                  'lib/assets/registerbg2.jpg',
                  fit: BoxFit.cover,
                  height: double.maxFinite,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.constraint.maxWidth / 100),
                          child: Text(
                            'From Local Favorite to Delivery Star!',
                            style: GoogleFonts.mina(
                                fontSize: widget.constraint.maxWidth < 1024
                                    ? widget.constraint.maxWidth * 0.02
                                    : 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  textDirection: TextDirection.ltr,
                                  'Let spicyeats handle the delivery while you focus on what you do best - creating amazing food! ',
                                  style: TextStyle(
                                      fontSize: widget.constraint.maxWidth <
                                              1024
                                          ? widget.constraint.maxWidth * 0.02
                                          : 22,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      ref
                                          .read(lastNameProvider.notifier)
                                          .state = value;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: password,
                                    labeltext: 'Enter Password',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }
                                      if (value.length < 9) {
                                        return 'Password length should be atleast 9 ';
                                      }
                                      ref
                                          .read(lastNameProvider.notifier)
                                          .state = value;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: businessname,
                                    labeltext: 'Your Business Name',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }
                                      ref
                                          .read(businessNameProvider.notifier)
                                          .state = value;
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
                                      ref
                                          .read(firstAndMiddleNameProvider
                                              .notifier)
                                          .state = value;
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
                                      ref
                                          .read(lastNameProvider.notifier)
                                          .state = value;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RegisterTextfield(
                                    controller: cnicno,
                                    labeltext: 'CNIC number',
                                    onvalidation: (value) {
                                      final nicno = int.tryParse(value ?? '');
                                      if (nicno == null) {
                                        return 'please Enter numbers';
                                      }
                                      if (value!.length < 12 ||
                                          value.length > 12) {
                                        return 'Please enter atleats 12 digits';
                                      }

                                      ref
                                          .read(lastNameProvider.notifier)
                                          .state = value;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
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
                                                  MainAxisAlignment.spaceAround,
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
                                              controller: mobileno,
                                              labeltext: 'Mobile Number',
                                              onvalidation: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Mandatory field Can\'t be empty ';
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
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
                                            child: const Text(
                                              'Select restaurant location',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                          0.04
                                                      : 12,
                                                  fontWeight: FontWeight.w900,
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
                                      ref
                                          .read(firstAndMiddleNameProvider
                                              .notifier)
                                          .state = value;
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
                                      ref
                                          .read(firstAndMiddleNameProvider
                                              .notifier)
                                          .state = value;
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
                                      ref
                                          .read(firstAndMiddleNameProvider
                                              .notifier)
                                          .state = value;
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
                                                                    900
                                                                ? 80
                                                                : 50,
                                                          )),
                                                    ),
                                                    Text(
                                                      'Upload Identity Card Photo',
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.width > 767
                                                                  ? size.width *
                                                                      0.015
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
                                        if (_form.currentState!.validate()) {
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class MobileLayout extends ConsumerStatefulWidget {
  BoxConstraints constraint;
  MobileLayout({super.key, required this.constraint});

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
    mobileno.dispose();
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
  final mobileno = TextEditingController();
  final password = TextEditingController();

  double? latitude;
  double? longitude;
  String? address;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  Uint8List? idImage;

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();
      if (pickedFile != null) {
        setState(() {
          idImage = pickedFile;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImageSelected = ref.watch(isimage);
    final address = ref.watch(restaurantLocationSelectedProvider);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'From Local Favorite to Delivery Star!',
                        style: GoogleFonts.mina(
                          fontSize: widget.constraint.maxWidth < 400
                              ? widget.constraint.maxWidth * 0.07
                              : 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              textDirection: TextDirection.ltr,
                              'Let spicyeats handle the delivery while you focus on what you do best - creating amazing food! ',
                              style: TextStyle(
                                  fontSize: widget.constraint.maxWidth < 400
                                      ? widget.constraint.maxWidth * 0.07
                                      : 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                  ref.read(lastNameProvider.notifier).state =
                                      value;
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTextfield(
                                controller: password,
                                labeltext: 'Enter Password',
                                onvalidation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mandatory field Can\'t be empty ';
                                  }
                                  if (value.length < 9) {
                                    return 'Password length should be atleast 9 ';
                                  }
                                  ref.read(lastNameProvider.notifier).state =
                                      value;
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
                                  ref
                                      .read(firstAndMiddleNameProvider.notifier)
                                      .state = value;
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
                                  ref.read(lastNameProvider.notifier).state =
                                      value;
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTextfield(
                                controller: cnicno,
                                labeltext: 'CNIC number',
                                onvalidation: (value) {
                                  final nicno = int.tryParse(value ?? '');
                                  if (nicno == null) {
                                    return 'please Enter numbers';
                                  }
                                  if (value!.length < 12 || value.length > 12) {
                                    return 'Please enter atleats 12 digits';
                                  }

                                  ref.read(lastNameProvider.notifier).state =
                                      value;
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTextfield(
                                controller: businessemail,
                                labeltext: 'Enter Your Business Email',
                                onvalidation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mandatory field Can\'t be empty ';
                                  }
                                  ref.read(lastNameProvider.notifier).state =
                                      value;
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.constraint.maxWidth > 200
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            color: Colors.grey[100],
                                            height: 40,
                                            width: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Image.asset(
                                                  'lib/assets/pak1.png',
                                                  fit: BoxFit.cover,
                                                  height: widget.constraint
                                                              .maxWidth >
                                                          200
                                                      ? 20
                                                      : size.height * 0.02,
                                                  width: widget.constraint
                                                              .maxWidth >
                                                          200
                                                      ? 30
                                                      : size.width * 0.02,
                                                ),
                                                Text(
                                                  '+92',
                                                  style: TextStyle(
                                                    fontSize: widget.constraint
                                                                .maxWidth >
                                                            200
                                                        ? 14
                                                        : 6,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: RegisterTextfield(
                                          controller: mobileno,
                                          labeltext: 'Mobile Number',
                                          onvalidation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Mandatory field Can\'t be empty ';
                                            }
                                            return null;
                                          }), //textfield
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Stack(
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
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
                                                  BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, MyMap.routename);
                                        },
                                        child: const Text(
                                          'Select restaurant location',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              address != null && address == true
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add your bank details to recieve payments',
                                    style: GoogleFonts.mina(
                                        fontSize: widget.constraint.maxWidth <
                                                400
                                            ? widget.constraint.maxWidth * 0.06
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
                                        size: widget.constraint.maxWidth < 400
                                            ? widget.constraint.maxWidth * 0.05
                                            : 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Your details are secure and encrypted with us.',
                                          style: GoogleFonts.mina(
                                              fontSize: widget
                                                          .constraint.maxWidth <
                                                      400
                                                  ? widget.constraint.maxWidth *
                                                      0.04
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
                                  ref
                                      .read(firstAndMiddleNameProvider.notifier)
                                      .state = value;
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
                                  ref
                                      .read(firstAndMiddleNameProvider.notifier)
                                      .state = value;
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
                                  ref
                                      .read(firstAndMiddleNameProvider.notifier)
                                      .state = value;
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Legal Documents',
                                style: GoogleFonts.mina(
                                    fontSize: widget.constraint.maxWidth < 400
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
                                                    CrossAxisAlignment.start,
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
                                                                .state = true
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
                                                      fontSize: size.width > 400
                                                          ? size.width * 0.03
                                                          : 10,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                      .read(isimage.notifier)
                                                      .state = true
                                                  : ref
                                                      .read(isimage.notifier)
                                                      .state = false;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              height: 50,
                                              width: 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
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
                                height: Responsive.isDesktop(context) ? 40 : 30,
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
                                    if (_form.currentState!.validate()) {
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
    );
  }
}
