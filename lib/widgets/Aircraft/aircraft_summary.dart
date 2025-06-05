// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/widgets.dart';
// import 'package:letzrentnew/models/aircraft_model.dart';

// import 'aircraft_payment.dart';

// class ConfirmAircraftsBooking extends StatefulWidget {
//   static const routeName = '/Aircrafts-booking-confirm';

//   @override
//   _ConfirmAircraftsBookingState createState() =>
//       _ConfirmAircraftsBookingState();
// }

// class _ConfirmAircraftsBookingState extends State<ConfirmAircraftsBooking> {
//   AircraftBookingModel aircraftBookingModel;
//   final _form = GlobalKey<FormState>();
//   final TextEditingController promoCodeController = TextEditingController();
//   bool _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     aircraftBookingModel =
//         ModalRoute.of(context).settings.arguments as AircraftBookingModel;

//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Confirm Booking'),
//         ),
//         body: SafeArea(
//             child: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondary,
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(8),
//                         bottomRight: Radius.circular(8))),
//                 width: 1.sw,
//                 height: .15.sh,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       UserDetailsWidget(
//                         userModel: aircraftBookingModel.userModel,
//                       ),
//                       Card(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                         elevation: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(aircraftBookingModel.aircraftModel.title,
//                                   style: largeStyle),
//                               SizedBox(height: .01.sh, width: 1.sw),
//                               Row(
//                                 children: [
//                                   Text('Altitude', style: titleStyle),
//                                   Spacer(),
//                                   Text(
//                                     '500-700 ft',
//                                     style: titleStyle,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Icon(Icons.flight_takeoff),
//                                 ],
//                               ),
//                               Divider(
//                                 color: Colors.transparent,
//                               ),
//                               Row(
//                                 children: [
//                                   Text('Number of people', style: titleStyle),
//                                   Spacer(),
//                                   Text(
//                                     '${aircraftBookingModel.aircraftModel.numberOfPeople}',
//                                     style: titleStyle,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Icon(Icons.person),
//                                 ],
//                               ),
//                               Divider(
//                                 color: Colors.transparent,
//                               ),
//                               Row(
//                                 children: [
//                                   Text('Duration', style: titleStyle),
//                                   Spacer(),
//                                   Text(
//                                     '${aircraftBookingModel.aircraftModel.time}',
//                                     style: titleStyle,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Icon(Icons.timer),
//                                 ],
//                               ),
//                               Divider(
//                                 color: Colors.transparent,
//                               ),
//                               Row(
//                                 children: [
//                                   Text('City', style: titleStyle),
//                                   Spacer(),
//                                   Text(
//                                     '${aircraftBookingModel.aircraftModel.city}',
//                                     style: titleStyle,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Icon(Icons.location_city),
//                                 ],
//                               ),
//                               Divider(
//                                 color: Colors.transparent,
//                               ),
//                               Row(
//                                 children: [
//                                   Text('Date', style: titleStyle),
//                                   Spacer(),
//                                   Text(
//                                     aircraftBookingModel.startDate,
//                                     style: titleStyle,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Icon(Icons.calendar_today),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (aircraftBookingModel.discountApplied != null) ...[
//                         Divider(),
//                         Text('Promo Code Discount', style: titleStyle),
//                         Text(
//                             "- $rupeeSign${aircraftBookingModel.discountApplied.toStringAsFixed(0)}",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.green,
//                               fontWeight: FontWeight.w600,
//                             )),
//                       ],
//                       Divider(),
//                       Text('Total Rent', style: titleStyle),
//                       Text(
//                           "$rupeeSign${aircraftBookingModel.aircraftModel.price.toStringAsFixed(0)}",
//                           style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.w600,
//                               decoration: TextDecoration.lineThrough)),
//                       Text(
//                           "$rupeeSign${aircraftBookingModel.aircraftModel.finalPrice.toStringAsFixed(0)}",
//                           style: greenLargeStyle),
//                       Divider(
//                         color: Colors.black54,
//                       ),
//                       Text('APPLY PROMO CODE',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           )),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Form(
//                               key: _form,
//                               child: TextFormField(
//                                 textCapitalization:
//                                     TextCapitalization.characters,
//                                 controller: promoCodeController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Enter Promo Code',
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(25.0)),
//                                 ),
//                                 validator: (value) {
//                                   if (value.isEmpty) {
//                                     return 'Enter Promo Code';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           if (_isLoading)
//                             spinkit
//                           else
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(25),
//                               child: AppButton(
//                                 textSize: 16,
//                                 title: 'Apply',
//                                 screenHeight: .8.sh,
//                                 screenWidth: .7.sw,
//                                 function: () => applyPromoCode(),
//                               ),
//                             )
//                         ],
//                       ),
//                       Divider(
//                         color: Colors.black54,
//                       ),
//                       Center(
//                         child: AppButton(
//                           screenHeight: 1.sh,
//                           function: () => Navigator.of(context).pushNamed(
//                               AircraftPaymentPage.routeName,
//                               arguments: aircraftBookingModel),
//                           title: 'Proceed',
//                         ),
//                       ),
//                     ]),
//               ),
//             ],
//           ),
//         )));
//   }

//   Future<void> applyPromoCode() async {
//     if (aircraftBookingModel.discountApplied != null) {
//       buildShowDialog(
//           context, oops, 'Only one promo code can be applied at a time');
//     } else {
//       final bool isValid = _form.currentState.validate();
//       if (!isValid) {
//         return;
//       }
//       setState(() {
//         _isLoading = true;
//       });
//       _form.currentState.save();
//       FocusScope.of(context).unfocus();

//       try {
//         final double promoAmount = 0;
//         // await FirebaseServices().getPromoAmount(promoCodeController.text);
//         if (promoAmount == 0) {
//           buildShowDialog(context, oops,
//               'This promo code has already been used by you! Book more to get new vouchers :)');
//         } else {
//           setState(() {
//             aircraftBookingModel.aircraftModel.finalPrice =
//                 (aircraftBookingModel.aircraftModel.finalPrice - promoAmount);
//             aircraftBookingModel.discountApplied = promoAmount;
//             aircraftBookingModel.promoCode = promoCodeController.text;
//             _isLoading = false;
//           });
//           voucherPopUp(context, 'Promo code applied successfully!',
//               'You saved $rupeeSign $promoAmount!');
//         }
//       } catch (error) {
//         buildShowDialog(context, oops, 'Something went wrong');
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }
