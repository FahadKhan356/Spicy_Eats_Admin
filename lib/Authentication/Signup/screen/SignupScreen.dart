import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final password = TextEditingController();
final confirmpassword = TextEditingController();
final businessemail = TextEditingController();

class SignUpScreen extends StatefulWidget {
  static const String routename = '/Signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    businessemail.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
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

class Dekstoplayout extends ConsumerWidget {
  final BoxConstraints constraint;
  final GlobalKey<FormState> _dekstopSignupform = GlobalKey<FormState>();
  Dekstoplayout({super.key, required this.constraint});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final authrepo = ref.watch(authRepoProvider);
    return Form(
      key: _dekstopSignupform,
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
                                fontSize: constraint.maxWidth < 1024
                                    ? constraint.maxWidth * 0.04
                                    : constraint.maxWidth > 1024
                                        ? constraint.maxWidth * 0.03
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
                                      fontSize: constraint.maxWidth < 1024
                                          ? constraint.maxWidth * 0.03
                                          : constraint.maxWidth > 1024
                                              ? constraint.maxWidth * 0.025
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
                                    labeltext: 'Enter your Business Email',
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
                                    controller: confirmpassword,
                                    labeltext: 'Confirm Password',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }
                                      if (value.length <= 9) {
                                        return 'Password length should be atleast 9 ';
                                      }
                                      if (value != password.text) {
                                        return 'Password don\'t match';
                                      }
                                      return null;
                                    },
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
                                        if (_dekstopSignupform.currentState!
                                            .validate()) {
                                          // ref
                                          //     .read(authControllerProvider)
                                          //     .singupAndStoreNewUserData(
                                          //       businessEmail:
                                          //           businessemail.text,
                                          //       password: password.text,
                                          //     );
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

class MobileLayout extends ConsumerWidget {
  final BoxConstraints constraint;
  final GlobalKey<FormState> _mobileSignupform = GlobalKey<FormState>();
  MobileLayout({super.key, required this.constraint});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authrepo = ref.watch(authRepoProvider);
    return SingleChildScrollView(
      child: Form(
        key: _mobileSignupform,
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
                        fontSize: constraint.maxWidth < 762
                            ? constraint.maxWidth * 0.04
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
                              fontSize: constraint.maxWidth < 762
                                  ? constraint.maxWidth * 0.03
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
                            controller: businessemail,
                            labeltext: 'Enter your Business Email',
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
                            controller: confirmpassword,
                            labeltext: 'Confirm Password',
                            onvalidation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mandatory field Can\'t be empty ';
                              }
                              if (value.length <= 9) {
                                return 'Password length should be atleast 9 ';
                              }
                              if (value != password.text) {
                                return 'Password don\'t match ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: Responsive.isDesktop(context) ? 40 : 30,
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_mobileSignupform.currentState!
                                    .validate()) {
                                  try {
                                    await authrepo.signup(
                                      context: context,
                                      businessEmail: businessemail.text,
                                      password: password.text,
                                    );
                                    showCustomSnackbar(
                                        context: context,
                                        message:
                                            'Sign up successfully please sign in with same credentials');

                                    Navigator.pushNamed(
                                        context, LoginScreen.routename);
                                  } catch (e) {
                                    throw Exception(e);
                                  }
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
                          const SizedBox(
                            height: 10,
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
