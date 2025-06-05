import 'package:flutter/material.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/aircraft_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Cars/payment_fail.dart';
import '../Cars/payment_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AircraftPaymentPage extends StatefulWidget {
  static const routeName = '/Aircrafts-check';
  @override
  _AircraftPaymentPageState createState() => _AircraftPaymentPageState();
}

class _AircraftPaymentPageState extends State<AircraftPaymentPage> {
  Razorpay _razorpay = Razorpay();
  late var options;
  AircraftBookingModel? aircraftBookingModel;
  void didChangeDependencies() {
    aircraftBookingModel =
        ModalRoute.of(context)!.settings.arguments as AircraftBookingModel?;

    super.didChangeDependencies();
  }

  Future payData() async {
    options = {
      'key': RazorPayKey,
      'amount': aircraftBookingModel!.aircraftModel.finalPrice * 100,
      'name': appName,
      'description': 'Payment',
      'prefill': {
        'contact': aircraftBookingModel!.userModel.phoneNumber,
        'email': aircraftBookingModel!.userModel.email
      },
      'external': {
        'wallets': 'paytm',
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {}

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = Auth().getCurrentUser()!;
    try {
      final Map data = aircraftBookingModel!.toJson();
      data.addAll({
        'userid': user.uid,
        'orderId': response.orderId,
        'paymentId': response.paymentId,
        'signature': response.signature,
      });
      FirebaseFirestore.instance
          .collection('AircraftsPaymentSuccessDetails')
          .add(data as Map<String, dynamic>);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            error.toString(),
            maxLines: 3,
          ),
          content: Text('Something went Wrong!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('okay'))
          ],
        ),
      );
    } finally {
      await FirebaseServices().updatePromoCode(aircraftBookingModel!.promoCode);

      Navigator.of(context)
          .pushReplacementNamed(SuccessPage.routeName, arguments: {
        'response': response,
      });
    }

    _razorpay.clear();
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment has error00000000000000000000000000000000000000");
    // Do something when payment fails
    Navigator.of(context)
        .pushReplacementNamed(FailedPage.routeName, arguments: {
      'response': response,
    });
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet33333333333333333333333333");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: payData(),
          builder: (context, snapshot) {
            return Container(
              child: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
