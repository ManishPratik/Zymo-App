import 'package:flutter/material.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;

  const OtpInputField({Key? key, required this.controller}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 6,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        counterText: "",
        border: OutlineInputBorder(),
        hintText: 'Enter OTP',
      ),
    );
  }
}
