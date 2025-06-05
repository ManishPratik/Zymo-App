// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:letzrentnew/Services/auth_services.dart';
// import 'package:letzrentnew/Services/firebase_services.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/models/rent_pay_model.dart';
// import 'package:letzrentnew/models/user_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../Utils/widgets.dart';
// import 'rent_pay_summary.dart';
// import 'rent_pay_faq.dart';

// class RentPay extends StatefulWidget {
//   static const routeNmae = 'Rent Pay';
//   @override
//   _RentPayState createState() => _RentPayState();
// }

// class _RentPayState extends State<RentPay> {
//   final _form = GlobalKey<FormState>();
//   File _imagedrivfp;

//   static const List<String> rentTypes = [
//     'House Rent',
//     'Office Rent',
//     'Deposit',
//     'Token'
//   ];
//   String type = '';
//   final FirebaseServices firebaseServices = FirebaseServices();
//   final user = Auth().getCurrentUser();
//   final TextEditingController street1Controller = TextEditingController();
//   final TextEditingController street2Controller = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController pinCodeController = TextEditingController();
//   final TextEditingController flightNumberController = TextEditingController();
//   final TextEditingController aadhaarController = TextEditingController();
//   final TextEditingController llnameController = TextEditingController();
//   final TextEditingController llNumberController = TextEditingController();
//   final TextEditingController llPanCardController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController ifscCodeController = TextEditingController();
//   final TextEditingController rentAmountController = TextEditingController();
//   final TextEditingController rentMonthController = TextEditingController();

//   @override
//   void initState() {
//     type = rentTypes[0];
//     super.initState();
//     firebaseServices.getRentPayDetails(user.uid).then((value) {
//       if (value != null) {
//         street1Controller.text = value.userModel?.street1;
//         street2Controller.text = value.userModel?.street2;
//         cityController.text = value.userModel?.city;
//         nameController.text = value.userModel?.name;
//         emailController.text = value.userModel?.email;
//         phoneNumberController.text =
//             value.userModel?.phoneNumber?.replaceAll('+91', '');
//         pinCodeController.text = value.userModel?.zipcode;
//         aadhaarController.text = value.userModel?.aadhaarNumber;
//         llnameController.text = value.landlordname;
//         llNumberController.text = value.landlordnumber;
//         llPanCardController.text = value.landLordPanCard;
//         rentAmountController.text = value.rentamount.toString();
//         rentMonthController.text = value.rentmonth;
//         accountNumberController.text = value.accountNumber;
//         ifscCodeController.text = value.ifsccode;
//       } else {
//         nameController.text = user.displayName;
//         emailController.text = user.email;
//         phoneNumberController.text = user.phoneNumber?.replaceAll('+91', '');
//       }
//     });

//     mixpanel.track('Rent pay page');
//   }

//   Future<void> _saveForm(double maxRent, double minRent, Map cityFee,
//       double processingCharge) async {
//     _form.currentState.save();

//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }

//     FocusScope.of(context).unfocus();
//     final UserModel submitModel = UserModel()
//       ..street1 = street1Controller.text.trim()
//       ..street2 = street2Controller.text.trim()
//       ..city = cityController.text.trim()
//       ..email = emailController.text.trim()
//       ..name = nameController.text.trim()
//       ..phoneNumber = phoneNumberController.text
//       ..uid = user.uid
//       ..zipcode = pinCodeController.text;
//     final RentPayModel model = RentPayModel()
//       ..type = type
//       ..maxRent = maxRent
//       ..minRent = minRent
//       ..rentamount = double.parse(rentAmountController.text)
//       ..processingCharge = processingCharge
//       ..landlordname = llnameController.text
//       ..landlordnumber = llNumberController.text
//       ..ifsccode = ifscCodeController.text
//       ..cityFee = cityFee
//       ..rentmonth = rentMonthController.text
//       ..landLordPanCard = llPanCardController.text
//       ..accountNumber = accountNumberController.text
//       ..userModel = submitModel;

//     try {
//       firebaseServices.setRentPayUserData(model.toJson());
//       parseRent(model);
//     } catch (error) {
//       await buildShowDialog(context, oops, 'Something went wrong. $error');
//     }
//   }

//   void parseRent(RentPayModel rentPayModel) {
//     final double pc = getProcessingCharge(rentPayModel);

//     if (rentPayModel.rentamount > rentPayModel.minRent &&
//         rentPayModel.rentamount < rentPayModel.maxRent) {
//       rentPayModel
//         ..payableAmount =
//             rentPayModel.rentamount * pc + rentPayModel.rentamount;
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ConfirmPayRentScreen(
//                 rentPayModel: rentPayModel,
//               )));
//     } else {
//       buildShowDialog(
//         context,
//         oops,
//         'Sorry, your rent is not in the range of $rupeeSign${rentPayModel.minRent} and $rupeeSign${rentPayModel.maxRent}. Currently we are accepting payments only in this range.',
//       );
//     }
//   }

//   //final RentPayModel rentPayModel = RentPayModel();
//   double getProcessingCharge(RentPayModel rentPayModel) {
//     double pc = rentPayModel.processingCharge;
//     rentPayModel.cityFee.forEach((key, value) {
//       if (rentPayModel.userModel.city.contains(key)) {
//         pc = double.tryParse(value);
//       }
//     });
//     return pc;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text('Pay Your Rent'),
//           actions: <Widget>[
//             ElevatedButton(
//                 onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const RentPayFaq())),
//                 child: const Text(
//                   'FAQs',
//                 )),
//           ],
//         ),
//         body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//             future: firebaseServices.getRentPayData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting &&
//                   !snapshot.hasData) {
//                 return const Center(child: spinkit);
//               } else {
//                 final data = snapshot.data.data();
//                 final isAadhaarRequired = data['aadhaarCard'];
//                 final isRentalAgreementRequired = data['UploadRentalAgreement'];
//                 final processingCharge = double.parse(data['processingcharge']);
//                 final minRent = data['Minimum'].toDouble();
//                 final maxRent = data['Maximum'].toDouble();
//                 final cityFee = data['cityFee'];

//                 return SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: .02.sh,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           RentPayTile(
//                               icon: Icons.house,
//                               isSelected: rentTypes[0] == type,
//                               title: rentTypes[0],
//                               function: () => setState(() {
//                                     type = rentTypes[0];
//                                   })),
//                           RentPayTile(
//                               icon: Icons.location_city,
//                               isSelected: rentTypes[1] == type,
//                               title: rentTypes[1],
//                               function: () => setState(() {
//                                     type = rentTypes[1];
//                                   })),
//                           RentPayTile(
//                               icon: FontAwesomeIcons.rupeeSign,
//                               size: .03.sh,
//                               isSelected: rentTypes[2] == type,
//                               title: rentTypes[2],
//                               function: () => setState(() {
//                                     type = rentTypes[2];
//                                   })),
//                           RentPayTile(
//                               icon: Icons.money,
//                               isSelected: rentTypes[3] == type,
//                               title: rentTypes[3],
//                               function: () => setState(() {
//                                     type = rentTypes[3];
//                                   })),
//                         ],
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Form(
//                               key: _form,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text(
//                                       'Enter your contact details',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18),
//                                     ),
//                                   ),
//                                   TextFormField(
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Name'),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.name,
//                                     controller: nameController,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter Name';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Email Address'),
//                                     controller: emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     textInputAction: TextInputAction.next,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter Email Address';
//                                       }
//                                       if (!value.contains('@')) {
//                                         return 'Invalid Email';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: phoneNumberController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Mobile Number (+91)',
//                                         helperText:
//                                             'For verfication, provide number which is linked with your aadhaar card',
//                                         helperMaxLines: 2),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value.length != 10) {
//                                         return 'Enter a valid Phone Number';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: aadhaarController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText:
//                                             'Aadhaar Number (dddddddddddd)'),
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (isAadhaarRequired &&
//                                           (value.isEmpty ||
//                                               value.length != 12)) {
//                                         return 'Enter correct Aadhaar Number';
//                                       }

//                                       return null;
//                                     },
//                                   ),
//                                   const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text(
//                                       'Enter property details',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18),
//                                     ),
//                                   ),
//                                   TextFormField(
//                                     controller: street1Controller,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Street (line 1)'),
//                                     keyboardType: TextInputType.multiline,
//                                     textInputAction: TextInputAction.next,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter Street (line 1)';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: street2Controller,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Street (line 2)'),
//                                     textInputAction: TextInputAction.next,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter Street (line 2)';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: cityController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'City'),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.streetAddress,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter City';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: pinCodeController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Pin Code'),
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter Pin Code';
//                                       } else if (value.length != 6) {
//                                         return 'Enter Correct pin code';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text(
//                                       'Enter landlord details',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18),
//                                     ),
//                                   ),
//                                   TextFormField(
//                                     controller: llnameController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText:
//                                             'Landlord Name (As per bank details)'),
//                                     keyboardType: TextInputType.multiline,
//                                     textInputAction: TextInputAction.next,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter landlord name';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: llNumberController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText:
//                                             'Landlord Number (10 digits)'),
//                                     textInputAction: TextInputAction.next,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter landlord number';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Bank Account Number'),
//                                     textInputAction: TextInputAction.next,
//                                     controller: accountNumberController,
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter bank account number';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'Confirm Account Number'),
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Re-Enter Account number';
//                                       }
//                                       if (value !=
//                                           accountNumberController.text) {
//                                         return 'Account number does not match.';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: ifscCodeController,
//                                     decoration: const InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         )),
//                                         labelText: 'IFSC code'),
//                                     keyboardType: TextInputType.text,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter IFSC code';
//                                       }

//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: llPanCardController,
//                                     decoration: const InputDecoration(
//                                       border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                         Radius.circular(10.0),
//                                       )),
//                                       labelText: 'Landlord Pan Number',
//                                     ),
//                                     keyboardType: TextInputType.text,
//                                     validator: (value) {
//                                       //Pan card only for Rs.50,000+
//                                       if ((int.tryParse(
//                                                   rentAmountController.text) ??
//                                               0) >=
//                                           50000) {
//                                         if (value.isEmpty)
//                                           return "Enter Landlord's pan number";
//                                       }

//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: rentAmountController,
//                                     decoration: const InputDecoration(
//                                       border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                         Radius.circular(10.0),
//                                       )),
//                                       labelText:
//                                           'Rent Amount (Only amount value)',
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     onFieldSubmitted: (_) {},
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter Rent amount';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: .02.sh),
//                                   TextFormField(
//                                     controller: rentMonthController,
//                                     decoration: const InputDecoration(
//                                       border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                         Radius.circular(10.0),
//                                       )),
//                                       labelText: 'Rent for the month of ',
//                                     ),
//                                     keyboardType: TextInputType.text,
//                                     onFieldSubmitted: (_) {},
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return 'Enter the month for the respective rent.';
//                                       }

//                                       return null;
//                                     },
//                                   ),
//                                   const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text(
//                                       'Upload image of Rental agreement',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       IconButton(
//                                           icon: const Icon(Icons.photo_camera),
//                                           onPressed: () async {
//                                             final File file = await pickImage(
//                                                 ImageSource.camera);
//                                             setState(() {
//                                               _imagedrivfp = File(file.path);
//                                             });
//                                           }),
//                                       IconButton(
//                                           icon: const Icon(Icons.photo_library),
//                                           onPressed: () async {
//                                             final File file = await pickImage(
//                                                 ImageSource.gallery);
//                                             setState(() {
//                                               _imagedrivfp = File(file.path);
//                                             });
//                                           }),
//                                     ],
//                                   ),
//                                   if (_imagedrivfp != null) ...[
//                                     Center(
//                                       child: Container(
//                                           margin: const EdgeInsets.all(4),
//                                           child: Image.file(
//                                             _imagedrivfp,
//                                             height: 200,
//                                           )),
//                                     ),
//                                     Row(
//                                       children: <Widget>[
//                                         TextButton(
//                                           onPressed: () {
//                                             setState(() => _imagedrivfp = null);
//                                           },
//                                           child: const Icon(Icons.refresh),
//                                         ),
//                                       ],
//                                     ),
//                                     Uploader(
//                                         file: _imagedrivfp,
//                                         cat: 'rentalAgreement'),
//                                   ],
//                                   RichText(
//                                       text: TextSpan(children: [
//                                     const TextSpan(
//                                       text:
//                                           'By clicking on proceed, I agree with ',
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     TextSpan(
//                                         text: 'Letzrent terms and conditions. ',
//                                         style:
//                                             const TextStyle(color: Colors.blue),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () {
//                                             launchUrl(Uri.parse(letzrentTandC));
//                                           }),
//                                     const TextSpan(
//                                       text:
//                                           'Thank you for trusting our service.',
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ])),
//                                   SizedBox(height: .02.sh),
//                                   Center(
//                                       child: ElevatedButton(
//                                     onPressed: () {
//                                       if (isRentalAgreementRequired //TODO &&_url == null
//                                           ) {
//                                         buildShowDialog(
//                                           context,
//                                           oops,
//                                           'Please upload your rental agreement',
//                                         );
//                                       } else {
//                                         _saveForm(maxRent, minRent, cityFee,
//                                             processingCharge);
//                                       }
//                                     },
//                                     child: const Text(
//                                       'PROCEED',
//                                     ),
//                                   ))
//                                 ],
//                               ))),
//                     ],
//                   ),
//                 );
//               }
//             }),
//       ),
//     );
//   }
// }

// class RentPayTile extends StatelessWidget {
//   const RentPayTile({
//     Key key,
//     this.icon,
//     this.title,
//     this.function,
//     this.size,
//     this.isSelected,
//   }) : super(key: key);

//   final double size;
//   final IconData icon;
//   final String title;
//   final bool isSelected;
//   final Function function;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: .1.sh,
//           width: .2.sw,
//           child: Card(
//             elevation: 3,
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             color: isSelected ? Colors.black : Colors.white,
//             child: InkWell(
//                 onTap: () => function(),
//                 child: Icon(
//                   icon,
//                   size: size ?? .04.sh,
//                   color: isSelected ? Colors.white : Colors.black,
//                 )),
//           ),
//         ),
//         Text(title)
//       ],
//     );
//   }
// }
