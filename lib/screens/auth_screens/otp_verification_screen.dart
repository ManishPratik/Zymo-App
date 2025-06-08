import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:letzrentnew/Screens/tabs_screen.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/widgets/otp_input_field.dart';

class Otp extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const Otp({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  void _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 6-digit OTP",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool result = await Auth().signInWithOTP(
      verificationId: widget.verificationId,
      smsCode: otp,
      context: context,
    );

    setState(() {
      isLoading = false;
    });

    if (result) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => TabScreen()),
        (route) => false,
      );
    } else {
      Fluttertoast.showToast(
        msg: "OTP verification failed",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter OTP sent to",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.phoneNumber,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            OtpInputField(controller: _otpController),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _verifyOTP,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Text('Verify'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.8, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
