import 'package:flutter/material.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/user_model.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({Key? key}) : super(key: key);
  static const routeName = 'pdet';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile Details",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: FutureBuilder<UserModel>(
          future: FirebaseServices().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return spinkit;
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    details('Name', snapshot.data!.name),
                    details('Phone', snapshot.data!.phoneNumber),
                    details('Email', snapshot.data!.email),
                    details('Date Of Birth', snapshot.data!.dob),
                    Spacer(),
                    // CupertinoButton(
                    //   child: Text("Update"),
                    //   onPressed: () {},
                    //   color: appColor,
                    // )
                  ],
                ),
              );
            }
          },
        ));
  }

  Column details(String title, String? body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bigHeadingStyle,
        ),
        TextFormField(
          enabled: false,
          initialValue: body,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[850], // Dark grey background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: Colors.white), // Border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                  color: Colors.grey), // Border color for enabled state
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                  color: Colors.white), // Border color for disabled state
            ),
            hintStyle: TextStyle(color: Colors.white70), // Hint text color
            labelStyle: TextStyle(color: Colors.white), // Label text color
          ),
          style: TextStyle(
            color: Colors.white, // Text color
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
