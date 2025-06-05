import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letzrentnew/screens/auth_screens/signup.dart';

import '../../Services/auth_services.dart';
import '../../Utils/constants.dart';

class signInWithEmailScreen extends StatefulWidget {
  const signInWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<signInWithEmailScreen> createState() => _signInWithEmailScreenState();
}

class _signInWithEmailScreenState extends State<signInWithEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: GestureDetector(
                  //     onTap: (){
                  //       Navigator.pop(context);
                  //     },
                  //     child: Icon(Icons.arrow_back_sharp,color: Colors.white),
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
                    height: .17.sh,
                    child: Text(
                      "Sign in to continue",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: .9.sw,
                      height: .06.sh,
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[850],
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          // Handle onChanged if needed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: .02.sh,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: .9.sw,
                      height: .06.sh,
                      child: TextFormField(
                        controller: passwordController,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[850],
                          hintText: 'Enter your password',

                          hintStyle: TextStyle(
                              color:
                                  Colors.white), // Set hint text color to white
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            child: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                            color: Colors
                                .white), // Set entered text color to white
                        obscureText: _isObscure, // Set password visibility
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          // Additional password validation if needed
                          return null;
                        },
                        onChanged: (value) {
                          // Handle onChanged if needed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: .02.sh,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          auth.forgotPassword(emailController.text);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    screenWidth: .7.sw,
                    screenHeight: .7.sh,
                    title: 'Sign in',
                    function: () {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      if (email.isEmpty || password.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Email or password cannot be empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else if (!isEmailValid(email)) {
                        Fluttertoast.showToast(
                          msg: "Please enter a valid email",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        print(email);
                        print(password);
                        auth.signInWithEmail(context, email, password);
                      }
                    },
                  ),
                  SizedBox(
                    height: .02.sh,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Text(
                      'Don\'t have an existing account? Register Now',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

bool isEmailValid(String email) {
  // Use regex pattern to validate email format
  String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  return RegExp(emailRegex).hasMatch(email);
}
