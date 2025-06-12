class UserModel {
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
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.prefix,
      required this.username,
      required this.dob,
      required this.aadhaarNumber,
      required this.street1,
      this.street2 = '',
      required this.city,
      required this.zipcode,
      required this.frontLicense,
      required this.backLicense,
      required this.frontAadhaar,
      required this.backAadhaar});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['firstname'] ?? json['FirstName'] ?? json['name'] ?? json['username'] ?? '';
    prefix= json['prefix'] ?? '';
    email= json['email'] ?? json['Email'] ?? '';
    username= json['username'] ?? '';
    phoneNumber= json['mobileNumber'] ?? json['PhoneNumber'] ?? '';
    uid= json['uid'] ?? '';
    panNumber= json['panNumber'];
    street1= json['street1'] ?? json['Street1'] ?? '';
    street2= json['street2'] ?? json['Street2'] ?? '';
    city= json['city'] ?? json['City'] ?? '';
    zipcode= json['zipcode'] ?? json['Zipcode'] ?? '';
    dob= json['DateOfBirth'] ?? '';
    aadhaarNumber= json['aadhaarNumber'] ?? '';
    frontLicense= json['front_page_driving_license'] ?? '';
    backLicense= json['back_page_driving_license'] ?? '';
    frontAadhaar= json['front_page_aadhaar_card'] ?? '';
    backAadhaar= json['back_page_aadhaar_card'] ?? '';
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
