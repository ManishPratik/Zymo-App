import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Services/car_services.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Services/vendor_services/lowcars_services.dart';
import 'package:letzrentnew/Services/vendor_services/mychoize_services.dart';
import 'package:letzrentnew/Services/vendor_services/zoomCar_v6.dart';

import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/extensions.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/models/user_model.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'payment_fail.dart';
import 'payment_success.dart';

class SummaryPage extends StatefulWidget {
  final CarModel? carModel;
  final DriveModel? model;
  final UserModel? userModel;

  const SummaryPage({Key? key, this.carModel, this.model, this.userModel})
      : super(key: key);
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final TextEditingController promoCodeController = TextEditingController();
  final _form = GlobalKey<FormState>();
  late Razorpay _razorpay;
  late var options;
  final FirebaseServices firebaseServices = FirebaseServices();

  Future payData(String totalAmount) async {
    options = {
      'key': RazorPayKey,
      'amount': double.parse(totalAmount) * 100,
      'name': appName,
      'description': 'Payment',
      'prefill': {
        'contact': widget.userModel!.phoneNumber,
        'email': widget.userModel!.email
      },
      'external': {
        'wallets': 'paytm',
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      // mixpanel!.track('Payment error', properties: {'error': e});
      print('Payment error:$e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final DateTime now = DateTime.now();
    final int dateNow = now.millisecondsSinceEpoch;
    final promoprovider = Provider.of<CarProvider>(context, listen: false);
    final String price = promoprovider.initialPrice!.toInt().toStringAsFixed(2);

    // final id = '${widget.userModel.name}${now.month}${now.day}${now.hour}';
    // creta121510
    final pickUpAndDrop2 = getLocation();
    final Map<String, dynamic> data = {
      'price': price,
      'actualPrice': widget.carModel!.actualPrice,
      'paymentId': response.paymentId,
      'Street1': widget.userModel!.street1,
      'Street2': widget.userModel!.street2,
      'City': widget.userModel!.city,
      'Zipcode': widget.userModel!.zipcode,
      'FirstName': widget.userModel!.name,
      'Email': widget.userModel!.email!.trim(),
      'PhoneNumber': widget.userModel!.phoneNumber,
      'DateOfBirth': widget.userModel!.dob,
      'UserId': widget.userModel!.uid,
      'Vendor': widget.carModel!.vendor!.name,
      'StartDate': widget.model!.startDate,
      'EndDate': widget.model!.endDate,
      'MapLocation': widget.model!.mapLocation,
      'StartTime': widget.model!.starttime,
      'EndTime': widget.model!.endtime,
      'CarName': widget.carModel!.name,
      'Drive': widget.model!.driveString,
      'bookingId': bookingId ?? 'Z${now.millisecondsSinceEpoch}',
      'Balance': widget.model!.balance!.toStringAsFixed(0),
      'CarImage': widget.carModel!.imageUrl,
      'DateOfBooking': dateNow,
      'deliveryType': pickUpAndDrop2,
      'Discount applied by user': promoprovider.discountPrice,
      'Package Selected': widget.carModel!.package,
      'Pickup Location': widget.carModel!.pickUpAndDrop,
      'Promo Code Used': promoCodeController.text,
      'Transmission': widget.carModel!.transmission,
      'TimeStamp': dateFormatter.format(now),
      'SecurityDeposit': securityDeposit ?? 0,
      'Documents': widget.model!.documents.toJson()
    };

    try {
      // to check if the vendor is from Partner App
      List<String> partnerVendorIds =
          await FirebaseServices().partnerVendorList();
      if (partnerVendorIds.contains(widget.carModel!.vendor!.name)) {
        // Update the Vendor field to include "Partner App"
        data['Vendor'] = '${widget.carModel!.vendor!.name} Partner App';
      }

      await uploadBooking(data);
      if (widget.carModel!.vendor!.name == 'Karyana') {
        ///hereeeeee Karyana store
        // if()
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Karyana')
            .doc('Delhi')
            .collection('Cars')
            .where('Car Name', isEqualTo: widget.carModel!.name)
            .get();

        final List<DocumentSnapshot> documents = snapshot.docs;

        for (var doc in documents) {
          await doc.reference.update({'isSoldTrue': true});
          await doc.reference
              .update({'soldOutTillDate': widget.model!.endDate});
          await doc.reference
              .update({'soldOutTillTime': widget.model!.endtime});
        }
      }
// Partner App logic
      // List<String> partnerVendorIds =
      //     await FirebaseServices().partnerVendorList();
      for (String vendorId in partnerVendorIds) {
        if (widget.carModel!.vendor!.name == vendorId) {
          final QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
              .collection('partnerAppVendors')
              .where('brandName', isEqualTo: widget.carModel!.vendor!.name)
              .get();

          if (vendorSnapshot.docs.isNotEmpty) {
            final DocumentSnapshot vendorDoc = vendorSnapshot.docs.first;
            final String vendorId = vendorDoc.id;

            // Construct the path to the car document
            final DocumentReference carDocRef = FirebaseFirestore.instance
                .collection('partnerAppVendors')
                .doc(vendorId)
                .collection('Cars')
                .doc(widget
                    .carModel!.name); // As car name is used as the document ID

            // Fetch the specific car details
            final DocumentSnapshot carDocSnapshot = await carDocRef.get();

            if (carDocSnapshot.exists) {
              // Update fields in the car document
              await carDocRef.update({
                'isSoldOut': true,
                'soldOutTillDate': widget.model!.endDate,
                'soldOutTillTime': widget.model!.endtime,
              });

              print('Car document updated successfully.');

              // Add booking data to the "bookings" collection
              final CollectionReference bookingsRef =
                  carDocRef.collection('bookings');

              await bookingsRef
                  .add(data); // Add the booking data as a new document

              print('Booking data added to the "bookings" collection.');
            } else {
              print('No car found with the name ${widget.carModel!.name}');
            }
          } else {
            print(
                'No vendor found with the brand name ${widget.carModel!.vendor!.name}');
          }
        }
      }
    } catch (error) {
      print(error.toString());
      // mixpanel!.track('Error on payment page',
      // properties: {'data': data, 'error': error.toString()});
      buildShowDialog(context, 'Booking Unsuccessful',
          'We apologize, but it appears your booking was unsuccessful. If any payment was deducted, rest assured it will be refunded within 0-3 working days. Feel free to try booking again. Thank you for your understanding!');
    }
    final int rewardAmount = CarServices.getRewardVoucherAmountCars(
        (double.parse(data['price']) - securityDeposit!).toInt());
    postPaymentFunction(now, data, promoprovider, rewardAmount);
    Navigator.of(context).pushNamedAndRemoveUntil(
        SuccessPage.routeName, (r) => false,
        arguments: rewardAmount);
    promoprovider.endPayment();
    _razorpay.clear();
    // Do something when payment succeeds
  }

  String getLocation() {
    final lowerCase = widget.carModel!.pickUpAndDrop!.toLowerCase();
    if (lowerCase.contains('delivery') || lowerCase.contains('airport')) {
      return 'Delivery';
    } else {
      return 'Self-Pickup';
    }
  }

  void postPaymentFunction(DateTime now, Map<String, dynamic> data,
      CarProvider promoprovider, int rewardAmount) {
    try {
      // mixpanel!.track('${data['Drive']} Payment confirmed', properties: data);
      firebaseServices.updateUserVoucher(promoprovider.voucherId);
      firebaseServices.updatePromoCode(promoCodeController.text);

      promoprovider.resetDiscountApplied();

      if (rewardAmount > 0) {
        firebaseServices.addNewVoucher(rewardAmount, context,
            validFromDateTime: now.add(const Duration(days: 7)),
            validTillDateTime: now.add(const Duration(days: 90)),
            indicator: false);
      }
      FirebaseAnalytics.instance.logPurchase(
          transactionId: data['paymentId'],
          currency: 'INR',
          value: double.parse(data['price']));
      // mixpanel!
      //     .getPeople()
      //     .trackCharge(double.parse(data['price']), properties: {
      //   'Voucher Amount Rewarded': rewardAmount,
      //   'Name': '${widget.userModel!.name}',
      //   'Phone': widget.userModel!.phoneNumber
      // });
      // mixpanel!.flush();
    } catch (e) {
      // mixpanel!.track('Cancelled on payment page',
      //     properties: {'data': data, 'error': e});
    }
  }

  Future<void> uploadBooking(Map<String, dynamic> data) async {
    try {
      await firebaseServices.carAddPaymentSuccessData(data);

      if (widget.carModel!.vendor!.name == lowCars) {
        await LowCarServices.createBooking(
            widget.carModel!, widget.userModel!, widget.model!);
      } else if (widget.carModel!.vendor!.name == zoomCar) {
        if (widget.carModel!.vendor!.isV6) {
          final bool res = await CarServices.zoomPaymentApiCallsV6(
              bookingId,
              '${widget.userModel!.name}',
              '${widget.userModel!.phoneNumber}',
              (widget.carModel!.actualPrice! + (deliveryCharges ?? 0)).toInt());
          if (!res) {
            // mixpanel!.track('Zoom payment api failed (V6)', properties: {});
            //    throw Exception('Zoom payment API call failed');
          }
        }
        // else if (myChoize == widget.carModel.vendor.name) {
        //   // await MyChoizeServices.createMyChoizeBooking(
        //   //     widget.carModel, widget.model, widget.userModel);
        // }
      }
    } catch (error) {
      print('Error during booking upload: $error');
      // throw error;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment has error00000000000000000000000000000000000000");
    // Do something when payment fails
    final CarProvider promoprovider =
        Provider.of<CarProvider>(context, listen: false);
    promoprovider.resetDiscountApplied();
    promoprovider.endPayment();
    Navigator.of(context).pushNamed(FailedPage.routeName, arguments: {
      'response': response,
    });
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet33333333333333333333333333");
    //_razorpay.clear();
    // Do something when an external wallet is selected
  }

  @override
  void initState() {
    super.initState();
    if (widget.carModel!.vendor!.name != zoomCar) trackEvent();
  }

  String? bookingId;
  double? securityDeposit;
  int? deliveryCharges;
  bool promoLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isZoomCar = widget.carModel!.vendor!.name == zoomCar;
    return Consumer<CarProvider>(
        builder: (BuildContext contex, value, Widget? child) => PopScope(
              canPop: false,
              onPopInvoked: (v) async {
                if (v) {
                  return;
                }
                await exitConfirmationPopUp(contex, value, () {
                  Navigator.pop(context);
                });
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Confirm Booking',
                    style: TextStyle(color: Colors.black),
                  ),
                  // flexibleSpace: appBarGradient,
                  backgroundColor: appColor,
                ),
                body: value.isPaymentLoading
                    ? loadingWidget()
                    : summaryWidget(isZoomCar, contex, value),
              ),
            ));
  }

  Column loadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        spinkit,
        SizedBox(height: .01.sh),
        Text('Please wait. Do not close this page.', style: largeStyle)
      ],
    );
  }

  Widget summaryWidget(
      bool isZoomCar, BuildContext contex, CarProvider promoprovider) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getZoomCharges(isZoomCar, contex),
        builder: (context, snapshot) {
          if (isZoomCar && !snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please wait",
                  style: titleStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                spinkit,
              ],
            );
          }
          securityDeposit = widget.carModel!.vendor!.securityDeposit;
          if (isZoomCar) {
            setZoomCharges(snapshot, promoprovider);
            if (bookingId == null) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Something went wrong. Please try again.\nMessage: ${snapshot.data!['error']}',style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go back'),
                    )
                  ],
                ),
              );
            }
          }
          final rewardVoucherAmountCars =
              CarServices.getRewardVoucherAmountCars(
                  promoprovider.initialPrice!.toInt() -
                      securityDeposit!.toInt());
          if (!promoprovider.codeApplied) {
            Future.delayed(Duration(milliseconds: 500), () {
              if (widget.carModel!.vendor!.promoCode!.isTrulyNotEmpty())
                promoMain(widget.carModel!.vendor!.promoCode,
                    dontShowError: true);
            });
          }
          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradientColors),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  width: 1.sw,
                  height: .15.sh,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Column(children: <Widget>[
                      CarDetailsWidget(
                        bookingId: bookingId,
                        carModel: widget.carModel,
                      ),
                      SizedBox(height: .01.sh),
                      TripDetailsWidget(
                          model: widget.model, carModel: widget.carModel),
                      SizedBox(height: .01.sh),
                      UserDetailsWidget(
                        showAddress: (widget.model!.drive == DriveTypes.SD ||
                                widget.model!.drive == DriveTypes.SUB)
                            ? (widget.carModel!.pickUpAndDrop
                                    ?.contains(homeDelivery) ??
                                false)
                            : false,
                        userModel: widget.userModel,
                      ),
                      if (isZoomCar)
                        Card(
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: .03.sh,
                                      child: CachedNetworkImage(
                                          imageUrl: widget
                                              .carModel!.vendor!.imageUrl!)),
                                  SizedBox(
                                    height: .02.sh,
                                  ),
                                  Text(
                                      'Sign into ZoomCar using your number ${widget.userModel!.phoneNumber} to view your booking.',
                                      style: titleStyle),
                                ],
                              ),
                            )),
                      SizedBox(
                        height: .02.sh,
                      ),
                      if (widget.carModel!.vendor!.name == zoomCar) ...[
                        Card(
                            color:Colors.grey[900],
                            elevation: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text("Please Note",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          'As per ZoomCar policy you will have to upload your driving license and Aadhaar card on the ZoomCar app. \n\nIf you already have a ZoomCar profile use the same mobile number registered with Zoomcar. \n(Creation of second profile is not allowed by Zoomcar).',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ))),
                        SizedBox(
                          height: .02.sh,
                        ),
                      ],
                      FareWidget(
                        securityDeposit: securityDeposit,
                        deliveryCharges:
                            deliveryCharges ?? widget.carModel!.deliveryCharges,
                        carModel: widget.carModel,
                        promoprovider: promoprovider,
                        advancePayBalance: widget.model!.balance,
                      ),
                      RewardVoucherWidget(
                          text: rewardVoucherAmountCars > 0
                              ? 'On completion of this order, you will receive a voucher of $rupeeSign${rewardVoucherAmountCars.toStringAsFixed(0)}'
                              : 'Have an order value of ${rupeeSign}750 and above to get free vouchers!'),
                      const Divider(color: appColor),
                      if (promoprovider.initialPrice! < minTransactionValue)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              'Promo codes applicable for bookings above ${rupeeSign}$minTransactionValueß'),
                        )
                      else
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: const Text(
                                'APPLY PROMO CODE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Form(
                                  key: _form,
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors
                                          .grey[850], // Dark grey background
                                      labelText: 'Enter Promo Code',
                                      labelStyle: const TextStyle(
                                          color: Colors
                                              .white70), // Label text color
                                      hintText: 'Enter Promo Code',
                                      hintStyle: const TextStyle(
                                          color: Colors
                                              .white38), // Hint text color
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                                0.5)), // Semi-transparent white border
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Solid white border on focus
                                      ),
                                    ),
                                    style: const TextStyle(
                                        color:
                                            Colors.white), // Typed text color
                                    cursorColor: Colors.white, // Cursor color
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Promo Code';
                                      }
                                      return null;
                                    },
                                    controller: promoCodeController,
                                  )),
                            ),
                            if (promoLoading)
                              spinkit
                            else
                              AppButton(
                                screenHeight: .8.sh,
                                screenWidth: .7.sw,
                                function: promoprovider.codeApplied
                                    ? () => buildShowDialog(context, oops,
                                        'Only one promo code or voucher can be applied at a time.')
                                    : () => promoCodeFunction(
                                          promoCodeController.text,
                                        ),
                                textSize: 16,
                                title: 'Apply',
                              ),
                            const Divider(
                              color: appColor,
                            ),
                            VoucherIndicator(
                              function: () =>
                                  showVouchers(context, 'cars').then(
                                (value) => setState(() {}),
                              ),
                              isApplied: promoprovider.codeApplied,
                            )
                          ],
                        ),
                      SizedBox(
                        height: .02.sh,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AppButton(
                          screenHeight: 1.sh,
                          function: () async {
                            try {
                              // First create the booking
                              await MyChoizeServices.createBooking(
                                  widget.carModel!,
                                  widget.model!,
                                  widget.userModel!,
                                  promoprovider.initialPrice!
                                      .toInt()
                                      .toStringAsFixed(2));

                              // Then handle the payment
                              paymentMethod(promoprovider, context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error creating booking: ${e.toString()}')),
                              );
                            }
                          },
                          title: 'Book & Pay',
                        ),
                      ),
                    ])),
              ],
            ),
          );
        });
  }

  void paymentMethod(CarProvider promoprovider, BuildContext context) async {
    promoprovider.startPayment();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final String price = promoprovider.initialPrice!.toInt().toStringAsFixed(2);
    await payData(price);
  }

  void setZoomCharges(
      AsyncSnapshot<Map<String, dynamic>> snapshot, CarProvider promoprovider) {
    securityDeposit = snapshot.data!['securityDeposit'] ??
        widget.carModel!.vendor!.securityDeposit;
    deliveryCharges = snapshot.data!['hd_fee'] ?? 0;
    bookingId = snapshot.data!['booking_id'];
    widget.carModel!.pickUpAndDrop = snapshot.data!['location'];
    widget.carModel!.actualPrice = snapshot.data!['actualPrice'];
    promoprovider.setInitialPrice(deliveryCharges! +
        securityDeposit! +
        widget.carModel!.finalPrice! -
        (promoprovider.discountPrice));
    trackEvent();
  }

  Future<Map<String, dynamic>>? getZoomCharges(
      bool isZoomCar, BuildContext contex) {
    if (isZoomCar && bookingId == null) {
      if (securityDeposit == 5) {
        return null;
      }
      this.securityDeposit = 5;
      return ZoomCarServicesV6.getSecurityDeposit(
          context,
          widget.model!.city!,
          widget.carModel!.carId,
          widget.carModel!.pricingId!,
          widget.carModel!.locationId!,
          widget.carModel!.carGroupId);
    } else {
      return null;
    }
  }

  Future<void> exitConfirmationPopUp(BuildContext otherContext,
      CarProvider promoProvider, Function() popFunc) async {
    await showModalBottomSheet<bool>(
      backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) => SizedBox(
              height: .28.sh,
              width: 1.sw,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Are you sure you want to cancel?',
                        style: headingStyle),
                    Text(
                      "We may not be able to hold this booking.",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Prices are dynamic and may increase. ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: .25.sw,
                            height: .05.sh,
                            child: FloatingActionButton.extended(
                                backgroundColor: greyColor,
                                label: const Text(
                                  'Go back',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                                onPressed: () =>
                                    goBackFunction(context, promoProvider))),
                        AppButton(
                          screenWidth: 1.48.sw,
                          screenHeight: 1.sh,
                          textSize: 16,
                          title: 'Continue booking',
                          function: () => Navigator.pop(context),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  void goBackFunction(BuildContext context, CarProvider promoprovider) {
    promoprovider.resetDiscountApplied();
    Navigator.pop(context, true);
    Navigator.pop(context, true);

    promoprovider.endPayment();
  }

  void trackEvent() async {
    final Map<String, dynamic> data = {
      'Duration selected': widget.model!.remainingDuration,
      'City': widget.model!.city,
      'Car': widget.carModel!.name,
      'Vendor': widget.carModel!.vendor!.name,
      'Package': widget.carModel!.package,
      'Payable amount': widget.carModel!.finalPrice,
      'Pickup location': widget.carModel!.pickUpAndDrop,
      'Security Deposit': widget.carModel!.vendor!.securityDeposit,
      'Type': widget.model!.drive.toString(),
      'Start time': '${widget.model!.starttime} ${widget.model!.startDate}',
      'End time': '${widget.model!.endtime} ${widget.model!.endDate}',
      'BookingId': bookingId
    };
    data.addAll(widget.userModel!.toJson());
    // mixpanel!.track('Car promo page', properties: data);
  }

  Future<void> promoCodeFunction(String promoCode) async {
    final bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      promoLoading = true;
    });
    _form.currentState!.save();
    FocusScope.of(context).unfocus();
    try {
      await promoMain(promoCode);
    } catch (error) {
      buildShowDialog(context, 'Error!', error.toString());
    } finally {
      setState(() {
        promoLoading = false;
      });
    }
  }

  Future<void> promoMain(String? promoCode, {bool? dontShowError}) async {
    final promoprovider = Provider.of<CarProvider>(context, listen: false);
    if (promoprovider.initialPrice! < minTransactionValue) {
      return;
    }
    int? promoAmount = 0;
    final coupon = await firebaseServices.getPromoAmount(promoCode);
    if (coupon.data() == null) {
      promoAmount = -1;
    } else {
      final isUsed = coupon.data()![widget.userModel!.uid];
      if (isUsed == null) {
        final int? discount = int.tryParse(coupon.data()!['amount'].toString());
        promoAmount = discount;
      } else {
        promoAmount = 0;
      }
    }
    if (promoAmount! > 0) {
      // mixpanel!.track('Promo code applied', properties: {'Code': promoCode});
      promoprovider.promoCodeApply(promoAmount.toDouble());
      voucherPopUp(context, 'Promo code applied successfully!',
          'You saved $rupeeSign ${promoprovider.discountPrice}!');
    } else if (dontShowError ?? false) {
      return;
    } else if (promoAmount == 0) {
      buildShowDialog(context, 'Already used!',
          'This promo code has already been used by you.');
    } else if (promoAmount == -1) {
      buildShowDialog(
          context, 'Incorrect promo code', 'Please use a valid promo code.');
    }
  }
}

class FareWidget extends StatelessWidget {
  const FareWidget({
    Key? key,
    required this.promoprovider,
    this.carModel,
    this.securityDeposit,
    this.deliveryCharges,
    this.advancePayBalance,
  }) : super(key: key);

  final CarProvider promoprovider;
  final CarModel? carModel;
  final double? advancePayBalance;
  final double? securityDeposit;
  final int? deliveryCharges;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Fare Breakup', style: largeStyle),
          SizedBox(height: .01.sh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Base Fare", style: titleStyle),
              Text("$rupeeSign${carModel!.finalDiscount!.toStringAsFixed(0)}",
                  style: titleStyle),
            ],
          ),
          const Divider(color: Colors.transparent),
          if (promoprovider.discountPrice != 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Voucher Applied", style: greentitleStyle),
                Text(
                    "- $rupeeSign${promoprovider.discountPrice.toStringAsFixed(0)}",
                    style: greentitleStyle),
              ],
            ),
            const Divider(color: Colors.transparent),
          ],
          if (advancePayBalance != null && advancePayBalance != 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pay Later", style: greentitleStyle),
                Text("- $rupeeSign${advancePayBalance!.toStringAsFixed(0)}",
                    style: greentitleStyle),
              ],
            ),
            const Divider(color: Colors.transparent),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount", style: itleStyle),
              Text(
                  "- $rupeeSign${(carModel!.finalDiscount! - carModel!.finalPrice!).toStringAsFixed(0)}",
                  style: itleStyle),
            ],
          ),
          const Divider(color: Colors.transparent),
          if (deliveryCharges != null && deliveryCharges! > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Charges', style: titleStyle),
                Text("$rupeeSign${deliveryCharges!.toStringAsFixed(0)}",
                    style: titleStyle),
              ],
            ),
            const Divider(color: Colors.transparent),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Refundable Deposit", style: titleStyle),
              Text("$rupeeSign${securityDeposit!.toStringAsFixed(0)}",
                  style: titleStyle),
            ],
          ),
          const Divider(color: Colors.black54),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: titleStyle),
              Text(
                  "$rupeeSign${promoprovider.initialPrice!.toStringAsFixed(0)}",
                  style: titleStyle),
            ],
          ),
          Text("(GST Incl.)", style: smallText),
        ]),
      ),
    );
  }
}
