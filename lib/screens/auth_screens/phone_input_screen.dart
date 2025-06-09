import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:letzrentnew/Screens/auth_screens/otp_screen.dart';
import 'package:letzrentnew/Services/auth_services.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({Key? key}) : super(key: key);

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool isLoading = false;

  void _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      Fluttertoast.showToast(
        msg: "Please enter a valid phone number",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await Auth().sendOTP(
        phoneNumber: "+91$phone",
        context: context,
        isResend: false,
      );

      // Navigation will be handled inside sendOTP after code is sent.
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error sending OTP: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Login with Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   "Enter your phone number",
            //   style: TextStyle(fontSize: 18),
            // ),
            GestureDetector(
              onTap: () => _phoneFocus.requestFocus(),
              child: const Text(
                "Enter your phone number",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'e.g. 9876543210',
                border: OutlineInputBorder(),
                prefixText: '+91 ',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _sendOTP,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Text('Send OTP'),
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
