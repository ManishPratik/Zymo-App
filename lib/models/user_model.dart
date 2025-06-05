import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String? name;
  String? username;
  String? prefix;
  String? email;
  String? phoneNumber;
  String? uid;
  String? panNumber;
  String? street1;
  String? street2;
  String? city;
  String? zipcode;
  String? dob;
  String? aadhaarNumber;
  String? frontLicense;
  String? backLicense;
  String? frontAadhaar;
  String? backAadhaar;
  

  UserModel(
      {this.name,
      this.email,
      this.phoneNumber,
      this.prefix,
      this.username,
      this.dob,
      this.aadhaarNumber,
      this.street1,
      this.street2,
      this.city,
      this.zipcode,
      this.frontLicense,
      this.backLicense,
      this.frontAadhaar,
      this.backAadhaar});

  UserModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      name = json['firstname'] ??
          json['FirstName'] ??
          json['name'] ??
          json['username'];
      prefix = json['prefix'];
      email = json['email'] ?? json['Email'];
      username = json['username'];
      phoneNumber = json['mobileNumber'] ?? json['PhoneNumber'];
      street1 = json['street1'] ?? json['Street1'];
      street2 = json['street2'] ?? json['Street2'];
      city = json['city'] ?? json['City'];
      zipcode = json['zipcode'] ?? json['Zipcode'];
      dob = json['DateOfBirth'];
      frontLicense = json['front_page_driving_license'];
      backLicense = json['back_page_driving_license'];
      aadhaarNumber = json['aadhaarNumber'];
      panNumber = json['panNumber'];
      frontAadhaar = json['front_page_aadhaar_card'];
      backAadhaar = json['back_page_aadhaar_card'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = name;
    data['aadhaarNumber'] = aadhaarNumber;
    data['panNumber'] = panNumber;
    data['email'] = email;
    data['mobileNumber'] = phoneNumber;
    data['street1'] = street1;
    data['street2'] = street2;
    data['city'] = city;
    data['zipcode'] = zipcode;
    data['DateOfBirth'] = dob;
    return data;
  }
}
