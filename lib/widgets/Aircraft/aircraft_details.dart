// import 'dart:async';
// import 'dart:math';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/Services/auth_services.dart';
// import 'package:letzrentnew/Services/firebase_services.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/widgets.dart';
// import 'package:letzrentnew/models/aircraft_model.dart';
// import 'package:letzrentnew/models/user_model.dart';
// import 'aircraft_summary.dart';

// class AircraftsBooking extends StatefulWidget {
//   static const routeName = '/Aircrafts-booking';
//   @override
//   _AircraftsBookingState createState() => _AircraftsBookingState();
// }

// class _AircraftsBookingState extends State<AircraftsBooking> {
//   final _form = GlobalKey<FormState>();
//   final fiveDaysLater = DateTime.now().add(Duration(days: 5));
//   DateTime _startDate;

//   Future<void> _presentDatePicker() async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: fiveDaysLater,
//       firstDate: fiveDaysLater,
//       lastDate: DateTime(2025),
//     );
//     if (picked != null) {
//       setState(() {
//         _startDate = picked;
//       });
//     }
//   }

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

//   @override
//   void initState() {
//     super.initState();
//     firebaseServices.getUserData().then((value) {
//       _startDate = fiveDaysLater;
//       if (value != null) {
//         street1Controller.text = value.street1;
//         street2Controller.text = value.street2;
//         cityController.text = value.city;
//         nameController.text = value.name;
//         emailController.text = value.email;
//         phoneNumberController.text = value.phoneNumber?.replaceAll('+91', '');
//         pinCodeController.text = value.zipcode;
//         aadhaarController.text = value.aadhaarNumber;
//       } else {
//         nameController.text = user.displayName;
//         emailController.text = user.email;
//         phoneNumberController.text = user.phoneNumber?.replaceAll('+91', '');
//       }
//     });
//   }

//   Future<void> _saveForm(UserModel _userModel, AircraftModel _aircraftModel,
//       BuildContext context) async {
//     var otp = 10000 + Random().nextInt(99999 - 10000);
//     final _bookingid = 'LRAAV' + otp.toString();
//     final isValid = _form.currentState.validate();
//     if (fiveDaysLater.isAfter(_startDate.add(Duration(days: 5)))) {
//       buildShowDialog(context, oops,
//           'Aircraft bookings can only be booked atleast 5 days in advance.');
//       return;
//     }
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     firebaseServices.updatelUserDetails(_userModel.toJson());
//     final AircraftBookingModel aircraftBookingModel = AircraftBookingModel()
//       ..startDate = dateFormatter.format(_startDate)
//       ..bookingId = _bookingid
//       ..aircraftModel = _aircraftModel
//       ..userModel = _userModel;
//     Navigator.of(context).pushNamed(ConfirmAircraftsBooking.routeName,
//         arguments: aircraftBookingModel);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final aircraftModel =
//         ModalRoute.of(context).settings.arguments as AircraftModel;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Stack(
//                 children: [
//                   CachedNetworkImage(
//                     height: .3.sh,
//                     width: 1.sw,
//                     fit: BoxFit.fitWidth,
//                     imageUrl: aircraftModel.image,
//                     placeholder: (context, ok) => const Center(
//                       child: Text(
//                         'LR',
//                         style: TextStyle(
//                             color: Colors.black54, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     errorWidget: (c, s, w) => Icon(Icons.error_outline),
//                   ),
//                   Align(
//                       alignment: Alignment.topLeft,
//                       child: CircleAvatar(
//                         child: IconButton(
//                           icon: Icon(Icons.keyboard_arrow_left_rounded),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ))
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(aircraftModel.title,
//                         textAlign: TextAlign.left, style: bigHeadingStyle),
//                     Divider(color: Colors.transparent),
//                     Text(
//                         '$rupeeSign${aircraftModel.finalPrice.toStringAsFixed(0)}',
//                         textAlign: TextAlign.left,
//                         style: bigHeadingStyle),
//                     Divider(color: Colors.transparent),
//                     // FulfilledByWidget(
//                     //     imageUrl:
//                     //         'https://letzrentimages.s3.ap-south-1.amazonaws.com/Aircrafts/ACCRETION+logo.png'),
//                     Divider(
//                       color: Colors.black54,
//                     ),
//                     Row(
//                       children: [
//                         Text('Altitude', style: titleStyle),
//                         Spacer(),
//                         Text(
//                           '500-700 ft',
//                           style: titleStyle,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Icon(Icons.flight_takeoff),
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.transparent,
//                     ),
//                     Row(
//                       children: [
//                         Text('Number of people', style: titleStyle),
//                         Spacer(),
//                         Text(
//                           '${aircraftModel.numberOfPeople}',
//                           style: titleStyle,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Icon(Icons.person),
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.transparent,
//                     ),
//                     Row(
//                       children: [
//                         Text('Duration', style: titleStyle),
//                         Spacer(),
//                         Text(
//                           '${aircraftModel.time}',
//                           style: titleStyle,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Icon(Icons.timer),
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.transparent,
//                     ),
//                     Row(
//                       children: [
//                         Text('City', style: titleStyle),
//                         Spacer(),
//                         Text(
//                           '${aircraftModel.city}',
//                           style: titleStyle,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Icon(Icons.location_city),
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.black54,
//                     ),
//                     Text(
//                       '• Slots available between 11:00 am to 4:00 pm on all days of the week',
//                     ),
//                     Divider(),
//                     Text(
//                       '• Kids allowed above 2 years and will be counted as an adult',
//                     ),
//                     Divider(),
//                     Text(
//                       '• Pictures can only be taken from mobile camera, camera is not allowed',
//                     ),
//                     Divider(
//                       color: Colors.black54,
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Form(
//                       key: _form,
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             const Center(
//                                 child: Text("Enter Contact Details",
//                                     style: contentStyle)),
//                             TextFormField(
//                               decoration: InputDecoration(labelText: 'Name'),
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter Name';
//                                 }
//                                 return null;
//                               },
//                               controller: nameController,
//                             ),
//                             TextFormField(
//                               decoration:
//                                   InputDecoration(labelText: 'Email Address'),
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter Email Address';
//                                 }
//                                 if (!value.contains('@')) {
//                                   return 'Invalid Email';
//                                 }
//                                 return null;
//                               },
//                               controller: emailController,
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                   labelText: 'Aadhaar Number (dddddddddddd)'),
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value.length != 12) {
//                                   return 'Enter correct Aadhaar Number';
//                                 }

//                                 return null;
//                               },
//                               controller: aadhaarController,
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                   labelText: 'Mobile Number (10 digits)',
//                                   helperText:
//                                       'For verfication, provide number which is linked with your aadhaar card',
//                                   helperMaxLines: 2),
//                               textInputAction: TextInputAction.next,
//                               keyboardType: TextInputType.number,
//                               controller: phoneNumberController,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter Phone Number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             Divider(
//                               color: Colors.transparent,
//                             ),
//                             const Center(
//                                 child:
//                                     Text("Enter Address", style: contentStyle)),
//                             TextFormField(
//                               decoration:
//                                   InputDecoration(labelText: 'Street (line 1)'),
//                               keyboardType: TextInputType.multiline,
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter Street (line 1)';
//                                 }
//                                 return null;
//                               },
//                               controller: street1Controller,
//                             ),
//                             TextFormField(
//                               decoration:
//                                   InputDecoration(labelText: 'Street (line 2)'),
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter Street (line 2)';
//                                 }
//                                 return null;
//                               },
//                               controller: street2Controller,
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(labelText: 'City'),
//                               textInputAction: TextInputAction.next,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter City';
//                                 }
//                                 return null;
//                               },
//                               controller: cityController,
//                             ),
//                             TextFormField(
//                               decoration:
//                                   InputDecoration(labelText: 'Pin Code'),
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Enter Pin Code';
//                                 }
//                                 if (value.length != 6) {
//                                   return 'Enter Correct pin code';
//                                 }
//                                 return null;
//                               },
//                               controller: pinCodeController,
//                             ),
//                             Divider(),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 Expanded(
//                                   flex: 4,
//                                   child: InkWell(
//                                     onTap: () => _presentDatePicker(),
//                                     child: InputDecorator(
//                                       decoration: InputDecoration(
//                                         labelText: 'Booking Date',
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           Text(_startDate == null
//                                               ? 'No Date Chosen'
//                                               : dateFormatter
//                                                   .format(_startDate)),
//                                           Icon(Icons.arrow_drop_down,
//                                               color: Theme.of(context)
//                                                           .brightness ==
//                                                       Brightness.light
//                                                   ? Colors.grey.shade700
//                                                   : Colors.white70),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: AppButton(
//                                   screenHeight: 1.sh,
//                                   function: () {
//                                     final String phoneNumber =
//                                         '+91${phoneNumberController.text}';

//                                     final UserModel userModel = UserModel()
//                                       ..street1 = street1Controller.text.trim()
//                                       ..street2 = street2Controller.text.trim()
//                                       ..city = cityController.text.trim()
//                                       ..email = emailController.text.trim()
//                                       ..name = nameController.text.trim()
//                                       ..phoneNumber = phoneNumber
//                                       ..uid = user.uid
//                                       ..aadhaarNumber =
//                                           aadhaarController.text.trim()
//                                       ..zipcode = pinCodeController.text;
//                                     _saveForm(
//                                         userModel, aircraftModel, context);
//                                   },
//                                   title: 'Proceed',
//                                 ),
//                               ),
//                             ),
//                           ])))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
