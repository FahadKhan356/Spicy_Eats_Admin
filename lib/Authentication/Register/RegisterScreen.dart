import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  onPressed: () {},
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                )),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constrain) {
        if (constrain.maxWidth > 767) {
          return Dekstoplayout(
            constraint: constrain,
          );
        } else {
          return MobileLayout(
            constraint: constrain,
          );
        }
      }),
    );
  }
}

class Dekstoplayout extends StatelessWidget {
  BoxConstraints constraint;
  Dekstoplayout({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.black,
            Colors.black,
          ])),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              child: Image.asset(
                'lib/assets/registerbg2.jpg',
                fit: BoxFit.cover,
                height: double.maxFinite,
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraint.maxWidth / 100),
                            child: Text(
                              'From Local Favorite to Delivery Star!',
                              style: GoogleFonts.mina(
                                  fontSize: constraint.maxWidth < 1024
                                      ? constraint.maxWidth * 0.02
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    textDirection: TextDirection.ltr,
                                    'Let spicyeats handle the delivery while you focus on what you do best - creating amazing food! ',
                                    style: TextStyle(
                                        fontSize: constraint.maxWidth < 1024
                                            ? constraint.maxWidth * 0.02
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
                                    TextFormField(
                                      cursorColor: MyAppColor.iconGray,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                          label:
                                              const Text('Your Business Name'),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                            //  const BorderSide(
                                            //     color: MyAppColor.iconGray,
                                            //     width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                            //  const BorderSide(
                                            //     color: MyAppColor.iconGray,
                                            //     width: 1),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      cursorColor: MyAppColor.iconGray,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                          label: const Text(
                                              'First & Middle Name per CNIC'),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      cursorColor: MyAppColor.iconGray,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                          label:
                                              const Text('Last Name Per CNIC'),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      cursorColor: MyAppColor.iconGray,
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                          label: const Text(
                                              'Enter Your Business Email'),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          )),
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
                                            child: TextFormField(
                                              cursorColor: Colors.grey[100],
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5,
                                                          horizontal: 10),
                                                  label: const Text(
                                                      'Mobile Number'),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: Responsive.isDesktop(context)
                                          ? 40
                                          : 30,
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
                ),
              )),
        ],
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  BoxConstraints constraint;
  MobileLayout({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              child: Image.asset(
                'lib/assets/registerbg2.jpg',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.1, -0.2),
                      blurRadius: 6)
                ],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'From Local Favorite to Delivery Star!',
                        style: GoogleFonts.mina(
                            fontSize: constraint.maxWidth < 400
                                ? constraint.maxWidth * 0.05
                                : 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            textDirection: TextDirection.ltr,
                            'Let spicyeats handle the delivery while you focus on what you do best - creating amazing food! ',
                            style: TextStyle(
                                fontSize: constraint.maxWidth < 400
                                    ? constraint.maxWidth * 0.04
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
                            TextFormField(
                              cursorColor: MyAppColor.iconGray,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  label: const Text('Your Business Name'),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                    //  const BorderSide(
                                    //     color: MyAppColor.iconGray,
                                    //     width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                    //  const BorderSide(
                                    //     color: MyAppColor.iconGray,
                                    //     width: 1),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              cursorColor: MyAppColor.iconGray,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  label: const Text(
                                      'First & Middle Name per CNIC'),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              cursorColor: MyAppColor.iconGray,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  label: const Text('Last Name Per CNIC'),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              cursorColor: MyAppColor.iconGray,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  label:
                                      const Text('Enter Your Business Email'),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                                    child: TextFormField(
                                      cursorColor: Colors.grey[100],
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                          label: const Text('Mobile Number'),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}
