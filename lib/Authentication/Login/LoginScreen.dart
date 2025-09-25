import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats_admin/Authentication/Register/screens/RestaurantRegister.dart';
import 'package:spicy_eats_admin/Authentication/Signup/screen/SignupScreen.dart';
import 'package:spicy_eats_admin/Authentication/authCallBack.dart';
import 'package:spicy_eats_admin/Authentication/controller/AuthController.dart';
import 'package:spicy_eats_admin/Authentication/repository/AuthRepository.dart';
import 'package:spicy_eats_admin/Authentication/widgets/RegisterTextfield.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/responsiveness.dart';
import 'package:spicy_eats_admin/utils/colors.dart';

var hidePasswordProvider = StateProvider<bool>((ref) => true);

class LoginScreen extends StatefulWidget {
  static const String routename = '/Login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

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
                  ? DekstopLayout(
                      emailcontroller: emailController,
                      passwordcontroller: passwordController,
                    )
                  : MobileLayout(
                      constraint: constrain,
                      emailcontroller: emailController,
                      passwordcontroller: passwordController,
                    )),
        );
      }),
    ));
  }
}

//for Dekstop and tablet
class DekstopLayout extends ConsumerStatefulWidget {
  final TextEditingController emailcontroller;
  final TextEditingController passwordcontroller;

  const DekstopLayout(
      {super.key,
      required this.emailcontroller,
      required this.passwordcontroller});

  @override
  ConsumerState<DekstopLayout> createState() => _DekstopLayoutState();
}

class _DekstopLayoutState extends ConsumerState<DekstopLayout> {
  final GlobalKey<FormState> _dekstopformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final hidePassword = ref.watch(hidePasswordProvider);
    final authController = ref.watch(authControllerProvider);
    final isloader = ref.watch(isloadingprovider);
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
                    child: Form(
                      key: _dekstopformkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Image.asset(
                              'lib/assets/SpicyEats.png',
                              height: 60,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RegisterTextfield(
                                    controller: widget.emailcontroller,
                                    labeltext: 'Email',
                                    onvalidation: (value) {
                                      var emailPattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty';
                                      }
                                      var regExp = RegExp(emailPattern);
                                      if (!regExp.hasMatch(value)) {
                                        return 'Please Provide a Valid Email';
                                      }

                                      return null;
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                RegisterTextfield(
                                    isObsecure: hidePassword,
                                    controller: widget.passwordcontroller,
                                    labeltext: 'Password',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          ref
                                              .read(
                                                  hidePasswordProvider.notifier)
                                              .state = !hidePassword;
                                        },
                                        icon: !hidePassword
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off)),
                                    onvalidation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mandatory field Can\'t be empty';
                                      }
                                      if (value.length < 9) {
                                        return 'Please Provide Password of atleast 9 characters';
                                      }

                                      return null;
                                    }),
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
                                            value: true, onChanged: (value) {}),
                                        const Text("Remember Me",
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
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, SignUpScreen.routename),
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Don\'t Have An Account?',
                                      style:
                                          TextStyle(color: MyAppColor.iconGray),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height:
                                      Responsive.isDesktop(context) ? 40 : 30,
                                  width: double.maxFinite,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_dekstopformkey.currentState!
                                          .validate()) {
                                        ref
                                            .read(isloadingprovider.notifier)
                                            .state = true;
                                        await authController.signIn(
                                            ref: ref,
                                            email: widget.emailcontroller.text,
                                            password:
                                                widget.passwordcontroller.text,
                                            context: context);

                                        ref
                                            .read(isloadingprovider.notifier)
                                            .update((cb) => false);
                                      } else {
                                        ref
                                            .read(isloadingprovider.notifier)
                                            .update((cb) => false);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
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
                                          'Log In ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white),
                                        ),
                                        // isloader?
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        isloader
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  padding: EdgeInsets.all(2),
                                                  strokeWidth: 3,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildOrDivider(),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height:
                                      Responsive.isDesktop(context) ? 40 : 30,
                                  width: double.maxFinite,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      authController.signupWithGoogleUniversal(
                                          context: context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('lib/assets/google.png'),
                                        const Text(
                                          'Sign in with Google',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                          Colors.black.withValues(alpha: 0.7),
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

class MobileLayout extends ConsumerStatefulWidget {
  final TextEditingController emailcontroller;
  final TextEditingController passwordcontroller;

  final BoxConstraints constraint;
  const MobileLayout(
      {super.key,
      required this.constraint,
      required this.emailcontroller,
      required this.passwordcontroller});

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout> {
  final GlobalKey<FormState> _mobileformkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final hidePassword = ref.watch(hidePasswordProvider);
    final isloader = ref.watch(isloadingprovider);
    final authController = ref.watch(authControllerProvider);
    return ClipRRect(
      child: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _mobileformkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'lib/assets/SpicyEats.png',
                          height: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                              color: Colors.black,
                              // shadows: [BoxShadow(color: Colors.black)]
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RegisterTextfield(
                          controller: widget.emailcontroller,
                          labeltext: 'Email',
                          onvalidation: (value) {
                            var emailPattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
                            if (value == null || value.isEmpty) {
                              return 'Mandatory field Can\'t be empty';
                            }
                            var regExp = RegExp(emailPattern);
                            if (!regExp.hasMatch(value)) {
                              return 'Please Provide a Valid Email';
                            }

                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      RegisterTextfield(
                          isObsecure: hidePassword,
                          controller: widget.passwordcontroller,
                          labeltext: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                ref.read(hidePasswordProvider.notifier).state =
                                    !hidePassword;
                              },
                              icon: !hidePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)),
                          onvalidation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mandatory field Can\'t be empty';
                            }
                            if (value.length < 9) {
                              return 'Please Provide Password of atleast 9 characters';
                            }

                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.constraint.maxWidth < 400
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: true, onChanged: (value) {}),
                                      const Text(
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
                                  const Text(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: true, onChanged: (value) {}),
                                    const Text(
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
                                const Text(
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
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, SignUpScreen.routename),
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Don\'t Have An Account?',
                            style: TextStyle(color: MyAppColor.iconGray),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 40 : 30,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_mobileformkey.currentState!.validate()) {
                              ref.read(isloadingprovider.notifier).state = true;
                              await authController.signIn(
                                  ref: ref,
                                  email: widget.emailcontroller.text,
                                  password: widget.passwordcontroller.text,
                                  context: context);

                              ref.read(isloadingprovider.notifier).state =
                                  false;
                            } else {
                              ref.read(isloadingprovider.notifier).state =
                                  false;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Log In ',
                                style: TextStyle(
                                    fontSize: widget.constraint.maxWidth > 400
                                        ? widget.constraint.maxWidth / 45
                                        : 12,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                              ),
                              // isloader?
                              const SizedBox(
                                width: 10,
                              ),
                              isloader
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        padding: EdgeInsets.all(2),
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildOrDivider(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 40 : 30,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              authController.signupWithGoogleUniversal(
                                  context: context);
                            } catch (e) {
                              showCustomSnackbar(
                                  backgroundColor: Colors.black,
                                  context: context,
                                  message: 'Error: $e');
                            }
                            Navigator.pushNamed(
                                context, AuthCallbackPage.routename);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Image.asset('lib/assets/google.png')),
                              widget.constraint.maxWidth > 300
                                  ? Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontSize: widget.constraint.maxWidth >
                                                400
                                            ? widget.constraint.maxWidth / 45
                                            : 12,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildOrDivider() {
  return Row(
    children: [
      Expanded(
        child: Divider(
          thickness: 1,
          color: Colors.grey[400],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'OR',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        child: Divider(
          thickness: 1,
          color: Colors.grey[400],
        ),
      ),
    ],
  );
}
