import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/Authentication/Login/LoginScreen.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends StatefulWidget {
  static const String routename = '/Signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController confirmpassword;
  late TextEditingController businessemail;
  late TextEditingController password;

  @override
  void initState() {
    confirmpassword = TextEditingController();
    businessemail = TextEditingController();
    password = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    businessemail.dispose();
    password.dispose();
    confirmpassword.dispose();
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
                        password: password,
                        bussinessEmail: businessemail,
                        confrimPassword: confirmpassword,
                        constraint: constrain,
                      )
                    : MobileLayout(
                        password: password,
                        bussinessEmail: businessemail,
                        confrimPassword: confirmpassword,
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
  final TextEditingController confrimPassword;
  final TextEditingController bussinessEmail;
  final TextEditingController password;

  final BoxConstraints constraint;

  const Dekstoplayout({
    super.key,
    required this.constraint,
    required this.bussinessEmail,
    required this.confrimPassword,
    required this.password,
  });

  @override
  ConsumerState<Dekstoplayout> createState() => _DekstoplayoutState();
}

class _DekstoplayoutState extends ConsumerState<Dekstoplayout> {
  final GlobalKey<FormState> _dekstopSignupform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
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
                                    controller: widget.bussinessEmail,
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
                                    controller: widget.password,
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
                                    controller: widget.confrimPassword,
                                    labeltext: 'Confirm Password',
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty ';
                                      }
                                      if (value.length <= 9) {
                                        return 'Password length should be atleast 9 ';
                                      }
                                      if (value != widget.password.text) {
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
                                      onPressed: () async {
                                        if (_dekstopSignupform.currentState!
                                            .validate()) {
                                          await authController
                                              .signUp(
                                                context: context,
                                                businessEmail:
                                                    widget.bussinessEmail.text,
                                                password:
                                                    widget.confrimPassword.text,
                                              )
                                              .then((value) =>
                                                  Navigator.pushNamed(context,
                                                      LoginScreen.routename));
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
  final TextEditingController confrimPassword;
  final TextEditingController bussinessEmail;
  final TextEditingController password;
  final BoxConstraints constraint;

  const MobileLayout({
    super.key,
    required this.constraint,
    required this.bussinessEmail,
    required this.confrimPassword,
    required this.password,
  });

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout> {
  final GlobalKey<FormState> _mobileSignupform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
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
                            controller: widget.bussinessEmail,
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
                            controller: widget.password,
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
                            controller: widget.confrimPassword,
                            labeltext: 'Confirm Password',
                            onvalidation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mandatory field Can\'t be empty ';
                              }
                              if (value.length <= 9) {
                                return 'Password length should be atleast 9 ';
                              }
                              if (value != widget.password.text) {
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
                                  await authController.signUp(
                                    context: context,
                                    businessEmail: widget.bussinessEmail.text,
                                    password: widget.password.text,
                                  );
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
