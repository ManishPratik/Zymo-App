import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:letzrentnew/Screens/auth_screens/login_screen.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import '../../Utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: SingleChildScrollView(
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
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: SizedBox(
                          width: .9.sw,
                          height: .06.sh,
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter your Name',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
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
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter your email',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
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
                            textAlignVertical: TextAlignVertical.center,
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  10), // Limiting to 10 digits
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter your Mobile No',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(Icons.phone, color: Colors.black),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '+91',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 10) {
                                Fluttertoast.showToast(msg: "msg");
                              }
                              // Additional password validation if needed
                              return null;
                            },
                            onChanged: (value) {},
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Create password',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isObscure =
                                        !_isObscure; // Toggle password visibility
                                  });
                                },
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
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
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: SizedBox(
                          width: .9.sw,
                          height: .06.sh,
                          child: TextFormField(
                            controller: confirmpasswordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Confirm password',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isObscure =
                                        !_isObscure; // Toggle password visibility
                                  });
                                },
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
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
                      AppButton(
                        screenWidth: 1.5.sw,
                        screenHeight: .7.sh,
                        title: 'Create Account',
                        function: () {
                          if (!isEmailValid(emailController.text.trim())) {
                            Fluttertoast.showToast(
                              msg: "Please enter a valid email",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (passwordController.text !=
                              confirmpasswordController.text) {
                            Fluttertoast.showToast(
                              msg: "Check your password again",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (passwordController.text.length < 6) {
                            Fluttertoast.showToast(
                              msg:
                                  "Password length must be at least 6 characters.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (!isPhoneNumberValid(
                              phoneController.text.trim())) {
                            Fluttertoast.showToast(
                              msg: "Please enter a valid phone number",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            auth.signUpWithEmail(
                                context,
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                phoneController.text);
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
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: Text(
                          'Already an existing user? SignIn Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: SizedBox(
                      height: 1.sh, child: const Center(child: spinkit)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool isEmailValid(String email) {
  String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  return RegExp(emailRegex).hasMatch(email);
}

bool isPhoneNumberValid(String phoneNumber) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}
