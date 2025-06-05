import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Screens/cancelled_by_vendor.dart';
import 'package:letzrentnew/Screens/refund_request_page.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Services/vendor_services/zoomCar_v6.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/models/booking_model.dart';

import '../Services/http_services.dart';

class OrderTile extends StatefulWidget {
  final String documentId;
  final BookingModel bookingModel;

  OrderTile({required this.documentId, required this.bookingModel});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final bool hasTripStarted = hasTripStartedFunction(
        widget.bookingModel.startDate!, widget.bookingModel.startTime!);

    // final bool hasTripStartedBefore6Hours = hasTripStartedFunction6hours(
    //     widget.bookingModel.startDate, widget.bookingModel.startTime);

    final isAlreadyCancelled = widget.bookingModel.isCancelled ?? false;

    final bool isCancellationAvailable =
        !(isAlreadyCancelled) && !hasTripStarted;

    return Card(
      color: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? SizedBox(height: .48.sh, child: Center(child: spinkit))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                      SizedBox(
                          height: .15.sh,
                          width: 1.sw,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: CachedNetworkImage(
                                    placeholder: (context, ok) => placeHolder,
                                    imageUrl: widget.bookingModel.carImage!)),
                          )),
                      Text(widget.bookingModel.carName!, style: largeStyle),
                      if (widget.bookingModel.vendor == zoomCar) ...[
                        SizedBox(height: .01.sh),
                        ElevatedButton(
                          child: Text("Check Details"),
                          onPressed: showZoomDetails,
                          // color: Colors.blue,
                        ),
                        SizedBox(height: .01.sh),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.bookingModel.startDate!,
                                style: contentStyle,
                              ),
                              Text(
                                widget.bookingModel.startTime!,
                                style: titleStyle,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(widget.bookingModel.endDate!,
                                  style: contentStyle),
                              Text(widget.bookingModel.endTime!,
                                  style: titleStyle)
                            ],
                          )
                        ],
                      ),
                      Divider(color: Colors.white,),
                      orderRow(
                          "Booking Id: ", widget.bookingModel.bookingId, 1.sw),
                      orderRow("Package Selected: ",
                          widget.bookingModel.packageSelected, 1.sw),
                      // orderRow(
                      //     "Payment Id: ", widget.bookingModel.paymentId, 1.sw),
                      // orderRow(
                      //     "Drive Type : ", widget.bookingModel.drive, 1.sw),
                      if (widget.bookingModel.deliveryType != null)
                        orderRow("Delivery Type : ",
                            widget.bookingModel.deliveryType, 1.sw),
                      if ((widget.bookingModel.pickupLocation != null) &&
                          widget.bookingModel.deliveryType ==
                              'Pickup') ...<Widget>[
                        Text(
                          "Pickup Location: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(widget.bookingModel.pickupLocation!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        openInMapsButton(widget.bookingModel.pickupLocation),
                        Divider(color: Colors.white,),
                      ],
                      ListTile(
                        title: Text(
                          'Amount paid: $rupeeSign${widget.bookingModel.price}',
                          style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                        trailing: AppButton(
                            screenWidth: .8.sw,
                            screenHeight: .8.sh,
                            textSize: 16,
                            color: isCancellationAvailable
                                ? Colors.red
                                : Colors.grey,
                            title: (widget.bookingModel.isCancelled ?? false)
                                ? 'Cancelled'
                                : 'Cancel',
                            function: () => isCancellationAvailable
                                ? cancelOrderFunction(
                                    widget.documentId,
                                    widget.bookingModel.price,
                                    widget.bookingModel.startDate,
                                    widget.bookingModel.startTime,
                                    context)
                                : null),
                      ),
                      if (hasTripStarted)
                        MyOrdersOptions(
                            title: 'Rate Trip',
                            function: () => rateVendorSheet(context)),
                      if (widget.bookingModel.refundData != null)
                        MyOrdersOptions(
                            title: 'Refund Details',
                            function: () => refundDetailsSheet(context)),
                      if (widget.bookingModel.refundData == null &&
                          hasTripStarted)
                        MyOrdersOptions(
                            title: 'Submit Fuel/Other Refund Request',
                            function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RefundRequestPage(
                                          email: widget.bookingModel.email!,
                                          vendor: widget.bookingModel.vendor!,
                                          bookingId:
                                              widget.bookingModel.bookingId!,
                                          documentId: widget.documentId,
                                        )))),
                      if (widget.bookingModel.refundData == null &&
                          hasTripStarted)
                        MyOrdersOptions(
                            title: 'If Cancelled by vendor',
                            function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CancelledByVendorScreen(
                                          email: widget.bookingModel.email!,
                                          vendor: widget.bookingModel.vendor!,
                                          bookingId:
                                              widget.bookingModel.bookingId!,
                                          documentId: widget.documentId,
                                        )))),
                    ]),
        ));
  }

  showZoomDetails() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SizedBox(
            height: .8.sh,
            width: 1.sw,
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Booking Details', style: largeStyle),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.cancel_outlined))
                        ],
                      ),
                      SizedBox(height: .02.sh),
                      Expanded(
                          child: FutureBuilder(
                        future: ZoomCarServicesV6.getBookingInfo(
                            widget.bookingModel.bookingId!,
                            widget.bookingModel.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return spinkit;
                          } else {
                            final data = snapshot.data as Map;
                            if (data["Error"] != null) {
                              return Center(
                                child: Text(
                                    "Something went wrong. ${data["Error"]}"),
                              );
                            }
                            return ListView.separated(
                              itemCount: data.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (context, index) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text("${data.keys.toList()[index]}",
                                        style: largeBlackStyle),
                                  ),
                                  Expanded(
                                    child: Text(
                                        '${data.values.toList()[index]}',
                                        style: largeStyle),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ))
                    ]))));
  }

  Future<dynamic> refundDetailsSheet(BuildContext context) {
    final List keys = widget.bookingModel.refundData!.keys.toList();
    const refundAmount = 'Refund Amount';
    keys.removeWhere((element) => element == refundAmount);

    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SizedBox(
            height: .4.sh,
            width: 1.sw,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Refund Breakup', style: largeStyle),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.cancel_outlined))
                      ],
                    ),
                    SizedBox(height: .02.sh),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Paid", style: largeStyle),
                        Text('${rupeeSign}${widget.bookingModel.price}',
                            style: largeStyle),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: keys.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            const Divider(color: Colors.black54),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(keys[index], style: greentitleStyle),
                                Text(
                                    '- ${rupeeSign}${widget.bookingModel.refundData![keys[index]]}',
                                    style: greentitleStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black54),
                    if (widget.bookingModel.refundData![refundAmount] != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your Refund", style: greenLargeStyle),
                          Text(
                              '${rupeeSign}${widget.bookingModel.refundData![refundAmount]}',
                              style: greenLargeStyle),
                        ],
                      ),
                  ]),
            )));
  }

  Future<dynamic> rateVendorSheet(BuildContext context) {
    int stars = 0;
    bool rated = false;
    String comment = '';
    const List ratingText = [
      '',
      'Poor $sadEmoji',
      'Bad :/',
      'Good :)',
      'Great :D',
      'Amazing $happyEmoji'
    ];
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: SizedBox(
                    height: .45.sh,
                    width: 1.sw,
                    child: StatefulBuilder(
                      builder: (BuildContext context,
                              void Function(void Function()) setState) =>
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: rated
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(
                                          radius: 40,
                                          child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              child: Icon(
                                                Icons.check,
                                                size: 30,
                                              )),
                                        ),
                                        SizedBox(
                                          height: .01.sh,
                                        ),
                                        Text(
                                          'Thank you for rating ${widget.bookingModel.vendor}!',
                                          style: largeStyle,
                                        ),
                                        SizedBox(
                                          height: .03.sh,
                                        ),
                                        AppButton(
                                            screenWidth: 1.sw,
                                            screenHeight: .8.sh,
                                            title: 'Okay',
                                            function: () =>
                                                Navigator.pop(context)),
                                      ],
                                    )
                                  : Column(children: [
                                      Text(
                                        'Rate your trip',
                                        style: largeStyle,
                                      ),
                                      Text(
                                        "How would you rate your experience with ${widget.bookingModel.vendor}?",
                                        style: titleStyle,
                                      ),
                                      SizedBox(height: .01.sh),
                                      Text('${ratingText[stars]}',
                                          style: largeStyle),
                                      SizedBox(
                                        width: 1.sw,
                                        height: .05.sh,
                                        child: Center(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              itemBuilder: (ctx, index) =>
                                                  IconButton(
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        setState(() {
                                                          stars = index + 1;
                                                        });
                                                      },
                                                      icon: index < stars
                                                          ? Icon(
                                                              FontAwesomeIcons
                                                                  .solidStar)
                                                          : Icon(
                                                              FontAwesomeIcons
                                                                  .star))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: .04.sh,
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Anything you'd like to share (Optional)",
                                            style: titleStyle,
                                          )),
                                      SizedBox(
                                        height: .01.sh,
                                      ),
                                      TextField(
                                        maxLines: 3,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                            const Radius.circular(20.0),
                                          )),
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onChanged: (val) => comment = val,
                                      ),
                                      SizedBox(height: .02.sh),
                                      AppButton(
                                          screenWidth: 1.sw,
                                          screenHeight: .8.sh,
                                          function: () {
                                            if (stars != 0) {
                                              FirebaseServices().rateVendor(
                                                  widget.bookingModel.vendor,
                                                  widget.bookingModel.carName,
                                                  stars,
                                                  comment,
                                                  widget
                                                      .bookingModel.bookingId);

                                              setState(() {
                                                rated = true;
                                              });
                                            }
                                          },
                                          title: 'Submit')
                                    ])),
                    )),
              ),
            ));
  }

  Widget orderRow(String title, String? body, double screenWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: screenWidth * .38,
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
              ),
            ),
            SizedBox(
                width: screenWidth * .5,
                child: Text(body ?? '',
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                    ))),
          ],
        ),
        Divider(color: Colors.white,),
      ],
    );
  }

  void cancelOrderFunction(String documentId, String? price, String? startdate,
      String? startTime, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final String trip =
        'Your trip starts on $startdate ${widget.bookingModel.startTime}.';

    await cancelPopUp(context, trip);
    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> cancelPopUp(BuildContext context, String tripTimings) {
    bool? val = false;
    //TODO
    // const List<String> reasonList = [
    //   'Change of plans',
    //   'Found better option outside $appName',
    //   'Other'
    // ];
    // String selectedValue = reasonList.first;
    // return showModalBottomSheet(
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    //     ),
    //     context: context,
    //     isScrollControlled: true,
    //     builder: (context) => SizedBox(
    //         height: .4.sh,
    //         width: 1.sw,
    //         child: Padding(
    //           padding: const EdgeInsets.all(18.0),
    //           child: StatefulBuilder(
    //             builder: (BuildContext context,
    //                 void Function(void Function()) setState) {
    //               return Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text("Select a reason for cancellation"),
    //                     ...reasonList.map((reason) {
    //                       return RadioListTile<String>(
    //                           value: selectedValue,
    //                           onChanged: (v) {
    //                             selectedValue = v;
    //                           },
    //                           groupValue: selectedValue);
    //                     }).toList(),
    //                     AppButton(
    //                       screenHeight: MediaQuery.of(context).size.height,
    //                       title: 'Cancel Booking',
    //                       color: Colors.red,
    //                     )
    //                   ]);
    //             },
    //           ),
    //         )));
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.42,
            width: 1.sw,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StatefulBuilder(builder: (context, setsta) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Are you sure?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(tripTimings,style: TextStyle(color: Colors.white),),
                    CancellationRateWidget(),
                    CheckboxListTile(
                        title: Text(
                            "I have read the terms and agree to the same.",style: TextStyle(color: Colors.white),),
                        value: val,
                        onChanged: (value) => setsta(() {
                              val = value;
                            })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppButton(
                            screenWidth:
                                MediaQuery.of(context).size.height * 0.3,
                            screenHeight:
                                MediaQuery.of(context).size.height * 0.05,
                            textSize: 16,
                            color: Colors.green,
                            title: 'No $happyEmoji',
                            function: () async => Navigator.pop(context)),
                        AppButton(
                            screenWidth:
                                MediaQuery.of(context).size.height * 0.65,
                            screenHeight:
                                MediaQuery.of(context).size.height * 0.05,
                            textSize: 16,
                            color: Colors.red,
                            title: 'Cancel booking $sadEmoji',
                            function: () async => val!
                                ? await cancelFunction(ctx, context)
                                : null),
                      ],
                    ),
                  ],
                );
              }),
            )),
      ),
    );
  }

  Future<void> cancelFunction(
      BuildContext context, BuildContext context2) async {
    Navigator.pop(context);
    final bool response =
        await FirebaseServices().cancelOrder(widget.documentId);
    if (widget.bookingModel.vendor == zoomCar) {
      await HttpServices.cancelBooking(
          widget.bookingModel.bookingId, widget.bookingModel.userId);
    }
    // Check if the booking belongs to partnerAppVendors
    List<String> partnerVendorIds =
        await FirebaseServices().partnerVendorList();
    for (String vendorId in partnerVendorIds) {
      // vendorId = vendorId + ' Partner App';
      // print(vendorId); // yeh kal dekhna hai bhai

      widget.bookingModel.vendor = widget.bookingModel.vendor?.replaceFirst(" Partner App", "");
      print('Now te vendor name : ${widget.bookingModel.vendor}');
      if (widget.bookingModel.vendor == vendorId + ' Partner App') {
        final QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
            .collection('partnerAppVendors')
            .where('brandName', isEqualTo: widget.bookingModel.vendor)
            .get();
        print("reached here ");
        print(vendorSnapshot);
        if (vendorSnapshot.docs.isNotEmpty) {
          final DocumentSnapshot vendorDoc = vendorSnapshot.docs.first;
          final String vendorId = vendorDoc.id;
        print("vendor Id is : ${vendorId}");
          // Reference to the specific car document
          final DocumentReference carDocRef = FirebaseFirestore.instance
              .collection('partnerAppVendors')
              .doc(vendorId)
              .collection('Cars')
              .doc(widget
                  .bookingModel.carName); // Assuming carName is the document ID

          // Fetch the car document
          final DocumentSnapshot carDocSnapshot = await carDocRef.get();

          if (carDocSnapshot.exists) {
            // Update the car document to mark it as available again
            await carDocRef.update({
              'isSoldOut': false,
              'soldOutTillDate': 0,
              'soldOutTillTime': 0,
            });

            print('Car document updated: Car is now available.');
          } else {
            print('No car found with the name ${widget.bookingModel.carName}');
          }
        } else {
          print(
              'No vendor found with the brand name ${widget.bookingModel.vendor}');
        }
      }
    }

    if (response) {
      buildShowDialog(context2, 'Success!',
          'Your booking has been cancelled. We acknowledge the request. We will keep you updated.');
    } else {
      buildShowDialog(
          context2, 'Oops!', 'Something went wrong. Please try again.');
    }
  }

  bool hasTripStartedFunction(String startdate, String starttime) {
    try {
      final DateTime date = dateFormatter.parse(startdate);

      final TimeOfDay time =
          TimeOfDay.fromDateTime(timeFormat.parse(starttime));
      final DateTime finalStartDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      return finalStartDate.isBefore(DateTime.now());
    } catch (e) {
      return true;
    }
  }

  bool hasTripStartedFunction6hours(String startdate, String starttime) {
    try {
      final DateTime date = dateFormatter.parse(startdate);

      final TimeOfDay time =
          TimeOfDay.fromDateTime(timeFormat.parse(starttime));
      final DateTime finalStartDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      return DateTime.now()
          .isBefore(finalStartDate.subtract(Duration(hours: 6)));
    } catch (e) {
      return true;
    }
  }
}

class MyOrdersOptions extends StatelessWidget {
  final String? title;
  final Function? function;
  const MyOrdersOptions({
    Key? key,
    this.title,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: function as void Function()?,
        title: Text(
          title!,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Icon(
          Icons.chevron_right_outlined,
          color: Colors.blue,
        ),
      ),
    );
  }
}
