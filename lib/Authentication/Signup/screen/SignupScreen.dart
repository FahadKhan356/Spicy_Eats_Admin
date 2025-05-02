import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/utils/commonImagePicker.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/Authentication/widgets/map.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends StatelessWidget {
  static const String routename = '/Signup';
  const SignUpScreen({super.key});

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    businessemail.dispose();
    contactno.dispose();
    lastname.dispose();
    firstandmiddlename.dispose();
    password.dispose();
  }

  final businessname = TextEditingController();
  final firstandmiddlename = TextEditingController();
  final lastname = TextEditingController();
  final businessemail = TextEditingController();
  final contactno = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'From Local Favorite to Delivery Star!',
                            style: GoogleFonts.mina(
                                fontSize: widget.constraint.maxWidth < 1024
                                    ? widget.constraint.maxWidth * 0.04
                                    : widget.constraint.maxWidth > 1024
                                        ? widget.constraint.maxWidth * 0.03
                                        : 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                                          ? widget.constraint.maxWidth * 0.03
                                          : widget.constraint.maxWidth > 1024
                                              ? widget.constraint.maxWidth *
                                                  0.025
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
                                      if (value.length <= 9) {
                                        return 'Password length should be atleast 9 ';
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
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height:
                                        Responsive.isDesktop(context) ? 40 : 30,
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_form.currentState!.validate()) {
                                          ref
                                              .read(authControllerProvider)
                                              .singupAndStoreNewUserData(
                                                  businessEmail:
                                                      businessemail.text,
                                                  password: password.text,
                                                  firstmiddleName:
                                                      firstandmiddlename.text,
                                                  contackNo: int.parse(
                                                      contactno.text));
                                          showCustomSnackbar(
                                              context: context,
                                              message:
                                                  'Successfully Created Account');
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
  final BoxConstraints constraint;
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
    contactno.dispose();
    lastname.dispose();
    firstandmiddlename.dispose();
    password.dispose();
  }

  final businessname = TextEditingController();
  final firstandmiddlename = TextEditingController();
  final lastname = TextEditingController();
  final businessemail = TextEditingController();
  final contactno = TextEditingController();
  final password = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'From Local Favorite to Delivery Star!',
                    style: GoogleFonts.mina(
                        fontSize: widget.constraint.maxWidth < 762
                            ? widget.constraint.maxWidth * 0.04
                            : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          textDirection: TextDirection.ltr,
                          'Let spicyeats handle the delivery while you focus on what you do best - creating amazing food! ',
                          style: TextStyle(
                              fontSize: widget.constraint.maxWidth < 762
                                  ? widget.constraint.maxWidth * 0.03
                                  : 22,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RegisterTextfield(
                            controller: businessname,
                            labeltext: 'Your Business Name',
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
                            controller: password,
                            labeltext: 'Enter Password',
                            onvalidation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mandatory field Can\'t be empty ';
                              }
                              if (value.length < 9) {
                                return 'Password length should be atleast 9 ';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.constraint.maxWidth > 300
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: widget.constraint.maxWidth > 400
                                          ? 2
                                          : 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            color: Colors.black12,
                                            height: 40,
                                            width: 80,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Image.asset(
                                                    'lib/assets/pak1.png',
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Expanded(
                                                    flex: 5,
                                                    child: Text(
                                                      '+92',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: widget.constraint.maxWidth > 500
                                          ? 8
                                          : 5,
                                      child: RegisterTextfield(
                                          controller: contactno,
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
                                )
                              : RegisterTextfield(
                                  controller: contactno,
                                  labeltext: 'Mobile Number',
                                  onvalidation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mandatory field Can\'t be empty ';
                                    }
                                    return null;
                                  }),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: Responsive.isDesktop(context) ? 40 : 30,
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_form.currentState!.validate()) {
                                  return;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                surfaceTintColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
