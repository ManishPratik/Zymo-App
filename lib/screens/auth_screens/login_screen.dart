import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/screens/auth_screens/signInWithEmailScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Color(0xFF9B08FE),
              //     Color(0xFF673AB7),
              //     Color(0xFF9C27B0),
              //   ],
              //   stops: [0.33, 0.66, 1.0],
              // ),
              color: Colors.grey[900],
            ),
            child: Visibility(
              visible: isLoading,
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: Icon(Icons.arrow_back_sharp, color: Colors.black),
                  //   ),
                  // ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40)),
                    child: Container(
                      width: 1.sw,
                      height: .16.sh,
                      color: appColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Image.asset(
                            'dev_assets/new_logo.jpeg',
                            // color: Colors.white,
                            height: .12.sh,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: .02.sh,
                  ),
                  SizedBox(
                    // width: 1.sw,
                    height: .33.sh,
                    child: Text(
                      "Sign in to continue",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                        width: .9.sw,
                        height: .06.sh,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.email, color: Colors.black),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Sign in with Email',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          signInWithEmailScreen()));
                            })),
                  ),
                  SizedBox(
                    height: .02.sh,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                        width: .9.sw,
                        height: .06.sh,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.google,
                                    color: Colors.black),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            onPressed: signInWithGoogle)),
                  ),
                  SizedBox(
                    height: .02.sh,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                        width: .9.sw,
                        height: .06.sh,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.apple,
                                    color: Colors.black),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Sign in with Apple',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            onPressed: signInApple)),
                  ),
                ],
              ),
              child:
                  SizedBox(height: 1.sh, child: const Center(child: spinkit)),
            ),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignIn _google = GoogleSignIn(
        scopes: [
          'email',
//'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      final GoogleSignInAccount googleSignInAccount = (await _google.signIn())!;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;
      await Auth.postCreation(authResult, context);
      assert(!user.isAnonymous);

      // User currentUser = FirebaseAuth.instance.currentUser;
      Navigator.pop(context, true);
    } catch (error) {
      print("Something went wrong");
      CommonFunctions.showSnackbar(context, error.toString());
    }
  }

  // Future<void> performGoogleLogin() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await Auth().signInWithGoogle(context);
  //     await navigateToHome(context);
  //   } catch (e) {
  //     warningPopUp(context, oops, 'Sign up failed. $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future signInApple() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Auth().signInWithApple(context);

      // User currentUser = FirebaseAuth.instance.currentUser;
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      //added exception for no acc found for apple
      if (e.toString() ==
          'Exception: `webAuthenticationOptions` argument must be provided on Android.') {
        warningPopUp(context, oops,
            'Sign up failed.No Apple account found. Try Signing in with Google');
      } else {
        warningPopUp(
            context, oops, 'Sign up failed.No Apple account found. $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
