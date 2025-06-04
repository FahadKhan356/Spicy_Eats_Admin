import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/Authentication/Register/chooseplanscreen.dart';
import 'package:spicy_eats_admin/Authentication/Register/widgets/RestaurantAddress.dart';

import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';

import 'package:spicy_eats_admin/Authentication/utils/comon_image_picker.dart';

import 'package:spicy_eats_admin/Authentication/widgets/MyTimeLine.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';

var isimage = StateProvider<bool>((ref) => true);

class RestaurantRegister extends ConsumerStatefulWidget {
  static const String routename = '/Register';
  const RestaurantRegister({super.key});

  @override
  ConsumerState<RestaurantRegister> createState() => _RestaurantRegisterState();
}

final TextEditingController addressController = TextEditingController();
final TextEditingController floorController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController postalController = TextEditingController();

final businessemail = TextEditingController();
final businessname = TextEditingController();
final firstandmiddlename = TextEditingController();
final lastname = TextEditingController();
final cnicno = TextEditingController();
final contactno = TextEditingController();
final bankname = TextEditingController();
final accountownername = TextEditingController();
final iban = TextEditingController();
final password = TextEditingController();

Uint8List? idImage;
File? image;

class _RestaurantRegisterState extends ConsumerState<RestaurantRegister> {
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

    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authepo = ref.watch(authRepoProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              "Spicy Eats",
              style: TextStyle(
                  color: Colors.white, fontSize: size.width > 720 ? 20 : 15),
            ),
            Text(
              "Partner Portal",
              style: TextStyle(
                  color: Colors.white, fontSize: size.width > 720 ? 15 : 10),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                await authepo.signout(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
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
  const Dekstoplayout({super.key, required this.constraint});

  @override
  ConsumerState<Dekstoplayout> createState() => _DekstoplayoutState();
}

class _DekstoplayoutState extends ConsumerState<Dekstoplayout> {
  final GlobalKey<FormState> _dekstopKey = GlobalKey<FormState>();
  Future<void> handlePickImage() async {
    dynamic result = await pickImage();

    if (result != null && result is Uint8List) {
      const maxSizeInBytes = 2 * 1024 * 1024; // 2MB
      if (result.length > maxSizeInBytes) {
        showCustomSnackbar(
            backgroundColor: Colors.black,
            context: context,
            message:
                'Image too large (max ${maxSizeInBytes ~/ (1024 * 1024)}MB)');
      } else {
        setState(() {
          idImage = result;
        });
      }
    } else if (result is File) {
      setState(() {
        image = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(authControllerProvider);
    final isloading = ref.watch(isloadingprovider);
    final latitude = ref.watch(restaurantLatProvider);
    final longitude = ref.watch(restaurantLongProvider);
    final address = ref.watch(restaurantLocationSelectedProvider);
    final size = MediaQuery.of(context).size;
    final isImageSelected = ref.watch(isimage);
    final authStep = ref.watch(authStepsProvider);

    return Form(
      key: _dekstopKey,
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
                      afterlineColor: authStep != null && authStep >= 2
                          ? Colors.black
                          : Colors.black26,
                      icon: Icons.account_box,
                      iconColor: Colors.white,
                      iconBg: authStep != null && authStep >= 1
                          ? Colors.black
                          : Colors.black26,
                      widthsize: size.width / 5,
                      isFirst: true,
                      isLast: false,
                      endChild: Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: size.width / 77,
                            color: authStep != null && authStep >= 1
                                ? Colors.black
                                : Colors.black26),
                      ),
                    ),
                    MyTimeLine(
                      afterlineColor: authStep != null && authStep >= 3
                          ? Colors.black
                          : Colors.black26,
                      beforelineColor: authStep != null && authStep >= 2
                          ? Colors.black
                          : Colors.black26,
                      icon: Icons.restaurant,
                      iconColor: Colors.white,
                      iconBg: authStep != null && authStep >= 2
                          ? Colors.black
                          : Colors.black26,
                      widthsize: size.width / 5,
                      isFirst: false,
                      isLast: false,
                      endChild: Text(
                        'Register Restaurant',
                        style: TextStyle(
                            fontSize: size.width / 77,
                            color: authStep != null && authStep >= 2
                                ? Colors.black
                                : Colors.black26),
                      ),
                    ),
                    MyTimeLine(
                      afterlineColor: authStep != null && authStep >= 4
                          ? Colors.black
                          : Colors.black26,
                      beforelineColor: authStep != null && authStep >= 3
                          ? Colors.black
                          : Colors.black26,
                      icon: Icons.subscriptions,
                      iconColor: Colors.white,
                      iconBg: authStep != null && authStep >= 3
                          ? Colors.black
                          : Colors.black26,
                      widthsize: size.width / 3,
                      isFirst: false,
                      isLast: false,
                      endChild: Text(
                        'Choose Plan',
                        style: TextStyle(
                            fontSize: size.width / 75,
                            color: authStep != null && authStep >= 3
                                ? Colors.black
                                : Colors.black26),
                      ),
                    ),
                    MyTimeLine(
                      beforelineColor: authStep != null && authStep >= 4
                          ? Colors.black
                          : Colors.black26,
                      icon: Icons.verified_user_sharp,
                      iconColor: Colors.white,
                      iconBg: authStep != null && authStep >= 4
                          ? Colors.black
                          : Colors.black26,
                      widthsize: size.width / 5,
                      isFirst: false,
                      isLast: true,
                      endChild: Text(
                        'Approved',
                        style: TextStyle(
                            fontSize: size.width / 75,
                            color: authStep != null && authStep >= 4
                                ? Colors.black
                                : Colors.black26),
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
                                        controller: businessname,
                                        labeltext: 'Enter Your Restaurant Name',
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
                                          storeController: addressController,
                                          floorController: floorController,
                                          cityController: cityController,
                                          postalController: postalController,
                                          controller: addressController,
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: Responsive.isDesktop(context)
                                            ? 40
                                            : 30,
                                        width: double.maxFinite,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_dekstopKey.currentState!
                                                    .validate() &&
                                                idImage != null &&
                                                latitude != null &&
                                                address != null) {
                                              ref
                                                  .read(isloadingprovider
                                                      .notifier)
                                                  .state = true;

                                              await authController
                                                  .registerRestaurant(
                                                      ref: ref,
                                                      businessEmail:
                                                          businessname.text,
                                                      bussinessName:
                                                          businessname.text,
                                                      firstmiddleName:
                                                          firstandmiddlename
                                                              .text,
                                                      mobileNo: contactno.text,
                                                      bankName: bankname.text,
                                                      bankownerTitle:
                                                          accountownername.text,
                                                      iban: iban.text,
                                                      lat: latitude ?? 2.3,
                                                      long: longitude ?? 2.2,
                                                      address: addressController
                                                          .text,
                                                      lastName: lastname.text,
                                                      context: context,
                                                      image: idImage!);
                                              ref
                                                  .read(isloadingprovider
                                                      .notifier)
                                                  .state = false;
                                            } else if (idImage == null) {
                                              showCustomSnackbar(
                                                  // isweb: true,
                                                  showFromTop: true,
                                                  context: context,
                                                  backgroundColor: Colors.black,
                                                  message:
                                                      "Please Upload Authentic Identity Card Image");
                                            } else if (latitude == null ||
                                                address == null) {
                                              showCustomSnackbar(
                                                  // isweb: true,
                                                  showFromTop: true,
                                                  context: context,
                                                  backgroundColor: Colors.black,
                                                  message:
                                                      "Please Pick The location Manually");
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            surfaceTintColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: Colors.black,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Save',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              isloading
                                                  ? const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        strokeWidth: 3,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
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
  final GlobalKey<FormState> _mobileKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await ref.read(authRepoProvider).checkAuthSteps(context, ref);
  //     ref.read(isloadingprovider.notifier).state = false;
  //   });

  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final latitude = ref.watch(restaurantLatProvider);
    final longitude = ref.watch(restaurantLongProvider);
    final authStep = ref.watch(authStepsProvider);
    final address = ref.watch(restaurantLocationSelectedProvider);
    final size = MediaQuery.of(context).size;
    final isloading = ref.watch(isloadingprovider);

    File? image;

    Future<void> handlePickImage() async {
      dynamic result = await pickImage();
      if (result != null || result is Uint8List) {
        int maxSizeInBytes = 2 * 1024 * 1025;
        if (result.length > maxSizeInBytes) {
          showCustomSnackbar(
              backgroundColor: Colors.black,
              context: context,
              message:
                  'Image too large (max ${maxSizeInBytes ~/ (1024 * 1024)}MB)');
        } else {
          setState(() {
            idImage = result;
          });
        }
      }
    }

    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                      // color: Colors.red,
                      width: double.infinity,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              MyTimeLine(
                                afterlineColor:
                                    authStep != null && authStep >= 2
                                        ? Colors.black
                                        : Colors.black26,
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
                                      color: authStep != null && authStep >= 1
                                          ? Colors.black
                                          : Colors.black26),
                                ),
                                icon: Icons.account_box,
                                iconColor: Colors.white,
                                iconBg: authStep != null && authStep >= 1
                                    ? Colors.black
                                    : Colors.black26,
                              ),
                              MyTimeLine(
                                afterlineColor:
                                    authStep != null && authStep >= 3
                                        ? Colors.black
                                        : Colors.black26,
                                beforelineColor:
                                    authStep != null && authStep >= 2
                                        ? Colors.black
                                        : Colors.black26,
                                icon: Icons.restaurant,
                                iconColor: Colors.white,
                                iconBg: authStep != null && authStep >= 2
                                    ? Colors.black
                                    : Colors.black26,
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
                                      color: authStep != null && authStep >= 2
                                          ? Colors.black
                                          : Colors.black26),
                                ),
                              ),
                              MyTimeLine(
                                afterlineColor:
                                    authStep != null && authStep >= 4
                                        ? Colors.black
                                        : Colors.black26,
                                beforelineColor:
                                    authStep != null && authStep >= 3
                                        ? Colors.black
                                        : Colors.black26,
                                icon: Icons.subscriptions,
                                iconColor: Colors.white,
                                iconBg: authStep != null && authStep >= 3
                                    ? Colors.black
                                    : Colors.black26,
                                widthsize: size.width < 350
                                    ? size.width / 5
                                    : size.width / 4.5,
                                isFirst: false,
                                isLast: false,
                                endChild: Text(
                                  textAlign: TextAlign.center,
                                  'Choose Plan',
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth > 600
                                          ? size.width / 60
                                          : 8,
                                      color: authStep != null && authStep >= 3
                                          ? Colors.black
                                          : Colors.black26),
                                ),
                              ),
                              MyTimeLine(
                                beforelineColor:
                                    authStep != null && authStep >= 4
                                        ? Colors.black
                                        : Colors.black26,
                                icon: Icons.verified_user_sharp,
                                iconColor: Colors.white,
                                iconBg: authStep != null && authStep >= 4
                                    ? Colors.black
                                    : Colors.black26,
                                widthsize: size.width < 350
                                    ? size.width / 5
                                    : size.width / 4.5,
                                isFirst: false,
                                isLast: true,
                                endChild: Text(
                                  textAlign: TextAlign.center,
                                  'Approved',
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth > 600
                                          ? size.width / 60
                                          : 8,
                                      color: authStep != null && authStep >= 4
                                          ? Colors.black
                                          : Colors.black26),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Stack(children: [
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Register Your Restaurant',
                                    style: GoogleFonts.mina(
                                        fontSize: widget.constraint.maxWidth <
                                                900
                                            ? widget.constraint.maxWidth * 0.05
                                            : widget.constraint.maxWidth > 400
                                                ? widget.constraint.maxWidth *
                                                    0.03
                                                : 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Form(
                                    key: _mobileKey,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RegisterTextfield(
                                            controller: businessname,
                                            labeltext:
                                                'Enter Your Restaurant Name',
                                            onvalidation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Mandatory field Can\'t be empty ';
                                              }

                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          RegisterTextfield(
                                            controller: businessemail,
                                            labeltext:
                                                'Enter Your Business Email',
                                            onvalidation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          constraints.maxWidth >
                                                                  300
                                                              ? 80
                                                              : 40,
                                                      maxHeight:
                                                          constraints.maxWidth >
                                                                  300
                                                              ? 40
                                                              : 60,
                                                    ),
                                                    color: Colors.black12,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        // constraints.maxWidth > 200
                                                        //     ?
                                                        Flexible(
                                                          child: Image.asset(
                                                            'lib/assets/pak1.png',
                                                            height: constraints
                                                                        .maxWidth <
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

                                                        constraints.maxWidth >
                                                                300
                                                            ? const Flexible(
                                                                child: Text(
                                                                  '+92',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10),
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
                                              storeController:
                                                  addressController,
                                              floorController: floorController,
                                              cityController: cityController,
                                              postalController:
                                                  postalController,
                                              controller: addressController,
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Add your bank details to recieve payments',
                                                style: GoogleFonts.mina(
                                                    fontSize: widget.constraint
                                                                .maxWidth <
                                                            400
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                    Icons.lock,
                                                    color: Colors.green,
                                                    shadows: const [
                                                      BoxShadow(
                                                          color: Colors.black,
                                                          offset:
                                                              Offset(0.2, 0.1))
                                                    ],
                                                    size: widget.constraint
                                                                .maxWidth <
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
                                                                  0.03
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
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          RegisterTextfield(
                                            controller: bankname,
                                            labeltext: 'Bank Name',
                                            onvalidation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                            labeltext:
                                                'Bank Account Owner/Title',
                                            onvalidation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                                    widget.constraint.maxWidth <
                                                            400
                                                        ? size.height * 0.03
                                                        : 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxHeight: 200,
                                                  minHeight: 100,
                                                  maxWidth: double.maxFinite,
                                                ),
                                                child: DottedBorder(
                                                  color: Colors.grey,
                                                  strokeWidth: 3,
                                                  dashPattern: const [12, 8],
                                                  child:
                                                      kIsWeb && idImage != null
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
                                                                      child:
                                                                          Center(
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
                                                          : !kIsWeb &&
                                                                  idImage !=
                                                                      null
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
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
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Image.file(
                                                                              image!,
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
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Center(
                                                                      child: IconButton(
                                                                          onPressed: () async {
                                                                            handlePickImage();

                                                                            image != null
                                                                                ? ref.read(isimage.notifier).state = true
                                                                                : ref.read(isimage.notifier).state = false;
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.camera_front_rounded,
                                                                            size: widget.constraint.maxWidth > 900
                                                                                ? 80
                                                                                : 50,
                                                                          )),
                                                                    ),
                                                                    Text(
                                                                      'Upload Identity Card Photo',
                                                                      style: TextStyle(
                                                                          fontSize: size.width > 767
                                                                              ? size.width *
                                                                                  0.015
                                                                              : 10,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color:
                                                                              Colors.black),
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
                                                                          .state =
                                                                      true
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
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(50))),
                                                              child: const Icon(
                                                                Icons.refresh,
                                                                size: 15,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height:
                                                Responsive.isDesktop(context)
                                                    ? 40
                                                    : 30,
                                            width: double.maxFinite,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_mobileKey.currentState!
                                                        .validate() &&
                                                    idImage != null &&
                                                    latitude != null &&
                                                    address != null) {
                                                  ref
                                                      .read(isloadingprovider
                                                          .notifier)
                                                      .state = true;

                                                  await authController
                                                      .registerRestaurant(
                                                          ref: ref,
                                                          businessEmail:
                                                              businessname.text,
                                                          bussinessName:
                                                              businessname.text,
                                                          firstmiddleName:
                                                              firstandmiddlename
                                                                  .text,
                                                          mobileNo:
                                                              contactno.text,
                                                          bankName:
                                                              bankname.text,
                                                          bankownerTitle:
                                                              accountownername
                                                                  .text,
                                                          iban: iban.text,
                                                          lat: latitude ?? 2.3,
                                                          long:
                                                              longitude ?? 2.2,
                                                          address:
                                                              addressController
                                                                  .text,
                                                          lastName:
                                                              lastname.text,
                                                          context: context,
                                                          image: idImage!);

                                                  ref
                                                      .read(isloadingprovider
                                                          .notifier)
                                                      .state = false;
                                                } else if (idImage == null) {
                                                  showCustomSnackbar(
                                                      showFromTop: true,
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.black,
                                                      message:
                                                          "Please Provide Cnic image");
                                                } else if (latitude == null ||
                                                    address == null) {
                                                  showCustomSnackbar(
                                                      // isweb: true,
                                                      showFromTop: true,
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.black,
                                                      message:
                                                          "Please Pick The location Manually");
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                surfaceTintColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                backgroundColor: Colors.black,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  isloading
                                                      ? const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            strokeWidth: 3,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ]),
            ));
  }
}
