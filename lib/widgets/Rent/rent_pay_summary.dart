// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/functions.dart';
// import 'package:letzrentnew/Utils/widgets.dart';
// import 'package:letzrentnew/Widgets/Rent/rent_pay_payment.dart';
// import 'package:letzrentnew/models/rent_pay_model.dart';

// class ConfirmPayRentScreen extends StatelessWidget {
//   final RentPayModel rentPayModel;

//   const ConfirmPayRentScreen({Key key, this.rentPayModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: const Text(
//           'Rent Pay',
//         )),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(children: <Widget>[
//               UserDetailsWidget(
//                 userModel: rentPayModel.userModel,
//               ),
//               const Divider(color: Colors.transparent),
//               Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Other Details', style: largeStyle),
//                       SizedBox(height: .01.sh, width: 1.sw),
//                       const Text(
//                         "Landlord Name",
//                         style: titleStyle,
//                       ),
//                       Text(rentPayModel.landlordname, style: contentStyle),
//                       SizedBox(height: 10),
//                       const Text(
//                         "Landlord Number",
//                         style: titleStyle,
//                       ),
//                       Text(rentPayModel.landlordnumber, style: contentStyle),
//                       SizedBox(height: 10),
//                       const Text(
//                         "Bank Account Number",
//                         style: titleStyle,
//                       ),
//                       Text(rentPayModel.accountNumber, style: contentStyle),
//                       SizedBox(height: 10),
//                       const Text(
//                         "IFSC Code",
//                         style: titleStyle,
//                       ),
//                       Text(rentPayModel.ifsccode, style: contentStyle),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Rent Details', style: largeStyle),
//                         SizedBox(height: .01.sh),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Rent for the month of", style: titleStyle),
//                             Text(rentPayModel.rentmonth, style: titleStyle),
//                           ],
//                         ),
//                         const Divider(color: Colors.transparent),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Rent Amount", style: titleStyle),
//                             Text(
//                                 "$rupeeSign${rentPayModel.rentamount.toStringAsFixed(0)}",
//                                 style: titleStyle),
//                           ],
//                         ),
//                         const Divider(color: Colors.transparent),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                                 "Processing Fees (${rentPayModel.processingCharge}%)",
//                                 style: titleStyle),
//                             Text(
//                                 "$rupeeSign${(rentPayModel.rentamount * rentPayModel.processingCharge).toStringAsFixed(0)}",
//                                 style: titleStyle),
//                           ],
//                         ),
//                         const Divider(color: Colors.black54),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Payable Amount", style: titleStyle),
//                             Text(
//                                 "$rupeeSign${rentPayModel.payableAmount.toStringAsFixed(0)}",
//                                 style: titleStyle),
//                           ],
//                         ),
//                       ]),
//                 ),
//               ),
//               SizedBox(height: 10),
//               RewardVoucherWidget(
//                   text:
//                       'On completion of this order, you will receive a voucher of $rupeeSign${CommonFunctions.getRewardVoucherAmountRentPay(rentPayModel.payableAmount.toInt()).toStringAsFixed(0)}'),
//               SizedBox(height: 10),
//               AppButton(
//                 screenHeight: 1.sh,
//                 screenWidth: 1.sw,
//                 function: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               RentPayPayment(rentPayModel: rentPayModel)));
//                 },
//                 title: 'PAY NOW',
//               ),
//               SizedBox(height: 10),
//             ]),
//           ),
//         ));
//   }
// }
