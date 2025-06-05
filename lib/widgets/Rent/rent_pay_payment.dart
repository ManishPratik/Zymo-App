// import 'package:cashfree_pg/cashfree_pg.dart';
// import 'package:flutter/material.dart';
// import 'package:letzrentnew/Services/firebase_services.dart';
// import 'package:letzrentnew/Services/http_services.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/models/rent_pay_model.dart';

// import '../../Utils/functions.dart';
// import '../Cars/payment_fail.dart';
// import '../Cars/payment_success.dart';

// class RentPayPayment extends StatelessWidget {
//   final RentPayModel rentPayModel;

//   RentPayPayment({Key key, this.rentPayModel}) : super(key: key);

//   final DateTime now = DateTime.now();

//   void _handlePaymentSuccess(String orderId, BuildContext context) async {
//     final FirebaseServices firebaseServices = FirebaseServices();

//     print("payment has succedded");
//     try {
//       rentPayModel..timeStamp = now.toString();
//       await firebaseServices.addRentPaySuccessData(rentPayModel.toJson());
//     } catch (error) {
//       print(error);
//       await warningPopUp(context, oops, error.toString());
//     } finally {

//       final int rewardAmount =
//          CommonFunctions. getRewardVoucherAmountRentPay(rentPayModel.payableAmount.toInt());

//       firebaseServices.addNewVoucher(rewardAmount, context,
//           validFromDateTime: now.add(const Duration(days: 7)));
//       Navigator.of(context)
//           .pushNamedAndRemoveUntil(SuccessPage.routeName, (r) => false);
//     }

//     // Do something when payment succeeds
//   }

//   void _handlePaymentError(BuildContext context) {
//     // Do something when payment fails
//     Navigator.of(context).pushNamed(FailedPage.routeName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//           future: cashFree(
//               rentPayModel.userModel.name,
//               rentPayModel.payableAmount.toInt(),
//               rentPayModel.userModel.phoneNumber,
//               rentPayModel.userModel.email,
//               now.microsecondsSinceEpoch,
//               context),
//           builder: (context, snapshot) {
//             return Container(
//               child: Center(
//                 child: Text(
//                   "Loading...",
//                   style: TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             );
//           }),
//     );
//   }

//   Future cashFree(String customerName, int totalAmount, String phoneNumber,
//       String email, int timeStamp, BuildContext context) async {
//     String orderId = 'RP$customerName${timeStamp.toString().substring(0, 6)}';
//     String stage = currentEnv == Environment.Prod ? "PROD" : "TEST";
//     String orderNote = "Rent pay";
//     String orderCurrency = "INR";
//     String notifyUrl = "https://test.gocashfree.com/notify";
//     final String token = await HttpServices.cashFree(orderId, totalAmount);
//     if (token == null) {
//       _handlePaymentError(context);
//     } else {
//       Map<String, dynamic> inputParams = {
//         "orderId": orderId,
//         "orderAmount": totalAmount,
//         "customerName": customerName,
//         "orderNote": orderNote,
//         "orderCurrency": orderCurrency,
//         "appId": cashFreeAppId,
//         "customerPhone": phoneNumber,
//         "customerEmail": email,
//         "stage": stage,
//         "tokenData": token,
//         "notifyUrl": notifyUrl
//       };

//       final Map response = await CashfreePGSDK.doPayment(inputParams);
//       print(response);
//       if (response['txStatus'] == 'SUCCESS') {
//         _handlePaymentSuccess(orderId, context);
//       } else {
//         mixpanel.track('CashFree Error', properties: {'Response': response});
//         _handlePaymentError(context);
//       }
//     }
//   }
// }
