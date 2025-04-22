import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/Authentication/Register/RegisterScreen.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class LoginScreen extends StatelessWidget {
  static const String routename = '/Login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constrain) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 5),
          switchInCurve: Curves.bounceIn,
          switchOutCurve: Curves.bounceInOut,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: constrain.maxWidth >= 767
                  ? const DekstopLayout()
                  : MobileLayout(constraint: constrain)),
        );
      }),
    ));
  }
}

//for Dekstop and tablet
class DekstopLayout extends StatelessWidget {
  const DekstopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Image.asset(
                            'lib/assets/SpicyeatsLogo-removebg.png',
                            height: 70,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Welcome Back',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Enter your email and password to access your account',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: MyAppColor.iconGray),
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
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    cursorColor: MyAppColor.iconGray,
                                    decoration: InputDecoration(
                                        hintText: 'Enter Email Here',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: MyAppColor.iconGray,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: MyAppColor.iconGray,
                                              width: 1),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    cursorColor: MyAppColor.iconGray,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.visibility_off,
                                          ),
                                          onPressed: () {},
                                        ),
                                        hintText: 'Enter Password Here',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: MyAppColor.iconGray,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: MyAppColor.iconGray,
                                              width: 1),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                              value: true,
                                              onChanged: (value) {}),
                                          Text("Remember Me",
                                              style: TextStyle(
                                                  overflow: TextOverflow.clip)),
                                        ],
                                      ),
                                      const Text(
                                        "Forget Your Password?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.clip),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height:
                                        Responsive.isDesktop(context) ? 40 : 30,
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: Colors.black,
                                      ),
                                      child: const Text(
                                        'Log In ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, RegisterScreen.routename),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Don\'t Have An Account?',
                                          style: TextStyle(
                                              color: MyAppColor.iconGray),
                                        ),
                                        Text(
                                          'Register Now',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                          Colors.black,
                          Colors.black.withOpacity(0.7),
                        ])),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: Text(
                                ' "Great food deserves to be seen. Sign in to showcase your dishes to thousands of hungry customers!" ',
                                style: GoogleFonts.lobster(
                                  fontSize: 25,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Expanded(child: Image.asset('lib/assets/bg1.png')),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  BoxConstraints constraint;
  MobileLayout({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.maxFinite,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Image.asset(
                    'lib/assets/SpicyeatsLogo-removebg.png',
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Welcome Back',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Enter your email and password to access your account',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          // shadows: [BoxShadow(color: Colors.black)]
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: MyAppColor.iconGray,
                          decoration: InputDecoration(
                              hintText: 'Enter Email Here',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: MyAppColor.iconGray, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: MyAppColor.iconGray, width: 1),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: MyAppColor.iconGray,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.visibility_off,
                                ),
                                onPressed: () {},
                              ),
                              hintText: 'Enter Password Here',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: MyAppColor.iconGray, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: MyAppColor.iconGray, width: 1),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        constraint.maxWidth < 400
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: true, onChanged: (value) {}),
                                        Text(
                                          "Remember Me",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            // fontSize: constraint.maxWidth < 767
                                            //     ? 10
                                            //     : 20
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Forget Your Password?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // fontSize:
                                        //     constraint.maxWidth < 767 ? 10 : 20
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: true, onChanged: (value) {}),
                                      Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          // fontSize: constraint.maxWidth < 767
                                          //     ? 10
                                          //     : 20
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Forget Your Password?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      // fontSize:
                                      //     constraint.maxWidth < 767 ? 10 : 20
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 40 : 30,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              'Log In ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       'Don\'t Have An Account?',
                        //       style: TextStyle(color: MyAppColor.iconGray),
                        //     ),
                        //     Text(
                        //       'Register Now',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
