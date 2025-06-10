import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: .01.sh,
                    ),
                    Text(
                      "What's your number?",
                      style: TextStyle(
                        fontSize: 28,
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter your phone number to start!",
                      style: TextStyle(
                        color: accentColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: .03.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: .2.sw,
                          child: Card(
                            color: accentColor,
                              elevation: 3,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 8),
                                  child: Text(
                                    'IN +91',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: .68.sw,
                          child: TextField(
                            controller: phone,
                            keyboardType: TextInputType.number,
                            cursorColor: accentColor,
                            style: TextStyle(color: accentColor), // Text color
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                              ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: // Assuming TapDebouncer and necessary variables are already imported and set

                  TapDebouncer(
                    cooldown: Duration(seconds: 5),
                    waitBuilder: (context, w) => whiteSpinkit, // Loading spinner while waiting
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final phoneNumber = '+91${phone.text}';
                      if (phoneNumber.length != 13) {
                        CommonFunctions.showSnackbar(context, 'Invalid phone number. Please enter a 10 digit number.');
                      } else {
                        await Auth().sendOTP(phoneNumber, context, false);
                      }
                    },
                    builder: (BuildContext context, TapDebouncerFunc? debouncer) {
                      return CupertinoButton(
                        color: accentColor,
                        onPressed: debouncer, // ✅ Correct way to call debouncer
                        child: Text(
                          'SEND OTP',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
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
