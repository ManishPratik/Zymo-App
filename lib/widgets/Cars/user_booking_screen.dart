// UserBookingScreen

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Services/car_services.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Services/vendor_services/lowcars_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/extensions.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/Widgets/Cars/summary_page.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/models/document_model.dart';
import 'package:letzrentnew/models/user_model.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserBookingScreen extends StatefulWidget {
  final DriveModel model;
  final CarModel carModel;
  final List<String>? details;
  static const routeName = '/User-booking';

  const UserBookingScreen(
      {Key? key, required this.model, required this.carModel, this.details})
      : super(key: key);
  @override
  _UserBookingScreenState createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  int pickupIndex = 0;
  bool isLoading = false;
  final DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    autoFillData(FirebaseAuth.instance.currentUser);
    //    mixpanel!.track('Car form page', properties: {
    //   'Duration selected': widget.model.remainingDuration,
    //   'City': widget.model.city,
    //   'Car': widget.carModel.name,
    //   'Vendor': widget.carModel.vendor!.name,
    //   'Payable amount':  widget.carModel.finalPrice,
    //   'Security Deposit': widget.carModel.vendor!.securityDeposit,
    //   'Type': widget.model.drive.toString(),
    //   'Start time': '${widget.model.starttime} ${widget.model.startDate}',
    //   'End time': '${widget.model.endtime} ${widget.model.endDate}',
    // });

    if (widget.carModel.vendor!.advancePay == 0.0) {
      isAdvancePay = false;
    }
  }

  autoFillData(User? user) {
    if (user == null) {
      return;
    }
    firebaseServices.getUserDetails(user.uid).then(
      (value) {
        if (value != null) {
          street1Controller.text = value.street1!;
          street2Controller.text = value.street2!;
          cityController.text = value.city!;
          nameController.text = value.name!;
          emailController.text = value.email!;
          phoneNumberController.text = value.phoneNumber!;
          pinCodeController.text = value.zipcode!;
          _dob = DateTime.tryParse(value.dob ?? '') ?? now;
        } else {
          nameController.text = user.displayName!;
          emailController.text = user.email!;
          phoneNumberController.text = user.phoneNumber!.replaceAll('+91', '');
        }
      },
    );
  }

  final TextEditingController street1Controller = TextEditingController();
  final TextEditingController street2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController flightNumberController = TextEditingController();
  final _form = GlobalKey<FormState>();
  DateTime? _dob;
  bool isAdvancePay = true;
  int selected = 0;
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final bool isChauffeur = widget.model.drive == DriveTypes.WC ||
        widget.model.drive == DriveTypes.RT ||
        widget.model.drive == DriveTypes.OW ||
        widget.model.drive == DriveTypes.AT;
    final CarouselControllerPlus carouselController = CarouselControllerPlus();
    final String advancePayPrice = CarServices.advancePayFunction(
        (widget.carModel.finalDiscount! +
                (widget.carModel.vendor!.securityDeposit ?? 0))
            .toStringAsFixed(0),
        widget.carModel.vendor!.advancePay!);
    final double payableAmount =
        widget.carModel.finalPrice! - double.parse(advancePayPrice);

    final bool isZoomCar = widget.carModel.vendor!.name == zoomCar;

    final selectedPickup = widget.carModel.pickups?.isNotEmpty ?? false
        ? widget.carModel.pickups![selected]
        : null;

    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (ctx, snapshot) {
                final user = snapshot.data;
                // autoFillData(user);
                return ListView(children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  if (widget.carModel.multiImages?.isEmpty ?? true)
                    carImage(widget.carModel.imageUrl)
                  else
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        CarouselSlider(
                          controller: carouselController,
                          items: widget.carModel.multiImages!
                              .map(
                                (e) => CachedNetworkImage(
                                  imageUrl: e,

                                  fit: BoxFit.fitWidth,
                                  placeholder: (context, ok) => const Image(
                                      image: AssetImage(
                                          'assets/app_logo/zymo_logo.jpg')),
                                  //      ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white54,
                              ),
                              child: IconButton(
                                  onPressed: () =>
                                      carouselController.previousPage(),
                                  icon: Icon(
                                    Icons.chevron_left,
                                  )),
                            ),
                            IconButton(
                                onPressed: () => carouselController.nextPage(),
                                icon: Icon(
                                  Icons.chevron_right,
                                ))
                          ],
                        )
                      ],
                    ),
                  carDetails(
                    widget.carModel,
                    widget.model,
                    context,
                    widget.details!,
                  ),
                  if (widget.carModel.pickups?.isNotEmpty ?? false) ...[
                    SizedBox(height: .01.sh),
                    Container(
                        color: Colors.grey[900],
                        child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Click here for car locations (${widget.carModel.pickups!.length})',
                                      style: largeBlackStyle),
                                  ListTile(
                                    onTap: () async {
                                      final lo = await openLocationSelector(
                                          widget.carModel.pickups, isZoomCar);
                                      if (lo != null)
                                        setState(() {
                                          widget.carModel.pickUpAndDrop = lo;
                                        });
                                    },
                                    title: Text(
                                        isZoomCar
                                            ? "The pickup location can be found on the following page."
                                            : '${selectedPickup!.pickupAddress}',
                                        style: contentStyle),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (widget.carModel.pickups![selected]
                                                .distanceFromUser !=
                                            null)
                                          Text(
                                              '${selectedPickup!.distanceFromUser} KMs away',
                                              style: itleStyle),
                                        Text(
                                            selectedPickup!.deliveryCharges == 0
                                                ? 'Free'
                                                : '$rupeeSign${selectedPickup.deliveryCharges}',
                                            style: titleStyle),
                                      ],
                                    ),
                                    trailing:
                                        Icon(Icons.chevron_right_outlined),
                                  ),
                                  if (widget.carModel.vendor?.name == wheelUp &&
                                      selectedPickup.pickupAddress!
                                          .contains("Delivery"))
                                    Text(
                                        "Delivery is available only at railway station and airport")
                                ]))),
                  ],
                  if (isChauffeur &&
                      !(widget.carModel.vendor!.name == cars24 ||
                          widget.carModel.vendor!.name == ems))
                    uniformChauffeur(),
                  advancePayWidget(
                    isChauffeur,
                    widget.carModel.vendor!.advancePay,
                    widget.carModel.finalPrice,
                    widget.carModel.finalDiscount,
                    payableAmount,
                    advancePayPrice,
                  ),
                  SizedBox(
                    height: .01.sh,
                  ),
                  if (!isAdvancePay) rentBreakdown(context, widget.carModel),
                  SizedBox(
                    height: .01.sh,
                  ),
                  !snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: ElevatedButton.icon(
                            label: Text(
                              "Proceed",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            icon: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              await CommonFunctions.navigateToSignIn(context);
                              setState(() {});
                            },
                          ),
                        )
                      : form(
                          context,
                          isAdvancePay
                              ? double.parse(advancePayPrice)
                              : payableAmount,
                          widget.carModel,
                          widget.model,
                          isChauffeur,
                          isZoomCar,
                          selectedPickup,
                          user)
                ]);
              })),
    );
  }

  Future<void> _saveForm(
      CarModel carModel,
      DriveModel model,
      UserModel userModel,
      double balance,
      String flightNumber,
      DocumentModel documents) async {
    _form.currentState!.save();

    final bool isValid = _form.currentState!.validate();

    if (!isValid) {
      buildShowDialog(context, 'Oops!', 'Please fill in all the details');
      return;
    }

    if ((model.drive == DriveTypes.SD || model.drive == DriveTypes.SUB)) {
      final int minAge =
          carModel.vendor!.name == wowCarz || carModel.vendor!.name == myChoize
              ? 21
              : 18;
      final plusMinAge = DateTime(_dob!.year + minAge, _dob!.month, _dob!.day);
      if (plusMinAge.isAfter(now)) {
        buildShowDialog(context, 'Oops!',
            "Driver's age should be above $minAge years for ${carModel.vendor!.name} bookings");
        return;
      }
    }
    addUserDataToFirestore(userModel, carModel, model);

    if (carModel.pickups?.isNotEmpty ?? false) {
      if (model.drive == DriveTypes.SUB) {
        carModel.pickUpAndDrop = carModel.pickups![selected].pickupAddress;
      } else if (carModel.vendor!.name == wowCarz) {
        if (selected != 0) {
          carModel.pickUpAndDrop = carModel.pickups![selected].pickupAddress;
        }
      }
      carModel.deliveryCharges =
          (carModel.pickups![selected].deliveryCharges! * 1.28).toInt();
      carModel.selectedPickup = carModel.pickups![selected];
      if (selected != 0) {
        carModel.pickUpAndDrop = carModel.pickups![selected].pickupAddress;
      }
    }
    final bool isZoomLocationsAvailable = carModel.vendor!.name == zoomCar &&
        (carModel.pickups?.isNotEmpty ?? false);
    if (isZoomLocationsAvailable) {
      carModel.pickUpAndDrop = carModel.pickups![selected].pickupAddress;
      carModel.locationId = carModel.pickups![selected].locationId;
    }
    final double finalPrice = carModel.finalPrice! +
        (carModel.vendor!.securityDeposit ?? 0) +
        (carModel.deliveryCharges ?? 0);
    final CarProvider promoprovider =
        Provider.of<CarProvider>(context, listen: false);
    promoprovider.setInitialPrice(
        isAdvancePay ? balance : double.parse(finalPrice.toStringAsFixed(2)));
    final double balanceAmount = isAdvancePay
        ? double.parse((finalPrice - balance).toStringAsFixed(0))
        : 0.0;
    final DriveModel tempModel = CarServices.getDriveModel(
        model, flightNumber, balanceAmount, documents, carModel);

    navigateToPromo(
      carModel,
      userModel,
      tempModel,
    );
  }

  void navigateToPromo(
    CarModel carModel,
    UserModel userModel,
    DriveModel model,
  ) async {
    setState(() {
      isLoading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(Duration(milliseconds: 1500), () async {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SummaryPage(
              carModel: carModel, model: model, userModel: userModel)));
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> addUserDataToFirestore(
      UserModel userModel, CarModel carModel, DriveModel model) async {
    final Map<String, dynamic> data = {
      'FirstName': userModel.name,
      'Email': userModel.email,
      'PhoneNumber': userModel.phoneNumber!.replaceFirst('+91', ''),
      'DateOfBirth': _dob?.toString().substring(0, 10),
      'UserId': userModel.uid,
      'Vendor': carModel.vendor!.name,
      'StartDate': model.startDate,
      'EndDate': model.endDate,
      'Pickup location': carModel.pickUpAndDrop,
      'MapLocation': model.mapLocation,
      'StartTime': model.starttime,
      'EndTime': model.endtime,
      'Package Selected': carModel.package,
      'DateOfBooking': now.millisecondsSinceEpoch,
      'CarName': carModel.name!.toUpperCase(),
      'price': carModel.finalPrice,
      'Street1': userModel.street1,
      'Street2': userModel.street2,
      'City': userModel.city,
      'Zipcode': userModel.zipcode,
    };
    await firebaseServices.addUserData(userModel.toJson());
    await firebaseServices.addDataToFirestore(data);
  }

  Future<void> dateofBirthPicker() async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) => child!,
      context: context,
      initialDate: _dob ?? now,
      firstDate: DateTime(1930),
      lastDate: now,
    );

    setState(() {
      _dob = picked;
    });
  }

  Widget uniformChauffeur() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Spacer(),
          Image.asset(
            'assets/icons/cd.jpeg',
            height: 35,
            width: 35,
          ),
          const Text(
            'Uniformed Chauffeur',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  rentBreakdown(BuildContext context, CarModel carModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
          color: appColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            width: 1.sw,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  if (!isAdvancePay) ...[
                    Text(
                      'Base Fare',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    if (carModel.finalDiscount! > carModel.finalPrice!)
                      Text(
                          '$rupeeSign${carModel.finalDiscount!.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough)),
                    Text('$rupeeSign${carModel.finalPrice!.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          )),
    );
  }

  Widget advancePayWidget(
    bool isChauffeur,
    double? _advancePayPercentage,
    double? _discountprice,
    double? _price,
    double payableAmount,
    String advancePayPrice,
  ) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isChauffeur)
              if (_advancePayPercentage != 0.0)
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    CheckboxListTile(
                      activeColor: Colors.black,
                      title: Text(
                          'Pay $rupeeSign$advancePayPrice now and Balance to Driver'),
                      onChanged: (bool? value) {
                        setState(() {
                          isAdvancePay = !isAdvancePay;
                        });
                      },
                      value: isAdvancePay,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.black,
                      title: const Text('Pay total amount now'),
                      onChanged: (bool? value) {
                        setState(() {
                          isAdvancePay = !isAdvancePay;
                        });
                      },
                      value: !isAdvancePay,
                    ),
                  ],
                ),
            if (isAdvancePay) ...[
              Text(
                  'Paying now: $rupeeSign$advancePayPrice Balance: $rupeeSign${payableAmount.toStringAsFixed(0)}',
                  style: contentStyle),
            ]
          ],
        ),
      ),
    );
  }

  Widget form(
      BuildContext context,
      double payableAmount,
      CarModel carModel,
      DriveModel model,
      bool isChauffeur,
      bool isZoom,
      PickupModel? selectedPickup,
      User? user) {
    return Form(
        key: _form,
        child: StreamBuilder<DocumentSnapshot>(
            stream: firebaseServices.getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: spinkit);
              }
              final DocumentModel documents = DocumentModel.fromJson(
                  snapshot.data?.data() as Map<String, dynamic>? ?? {});

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if ((selectedPickup?.pickupAddress
                                ?.contains(homeDelivery) ??
                            true) ||
                        carModel.vendor!.name == myChoize) ...[
                      const Center(
                          child: Text("Enter Details", style: largeBlackStyle)),
                      const Text(
                        "Address",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextFieldBooking(
                        controller: street1Controller,
                        validatorFunction: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Street (line 1)';
                          }
                          return null;
                        },
                        title: 'Street (line 1)',
                      ),
                      TextFieldBooking(
                        controller: street2Controller,
                        validatorFunction: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Street (line 2)';
                          }
                          return null;
                        },
                        title: 'Street (line 2)',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: .44.sw,
                            height: .1.sh,
                            child: TextFieldBooking(
                              controller: cityController,
                              validatorFunction: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter City';
                                }
                                return null;
                              },
                              title: 'City',
                            ),
                          ),
                          SizedBox(
                            width: .44.sw,
                            //   height: .1.sh,
                            child: TextFieldBooking(
                              controller: pinCodeController,
                              keyboardType: TextInputType.number,
                              validatorFunction: (value) {
                                if (value!.length < 6) {
                                  return 'Pin Code';
                                }
                                return null;
                              },
                              title: 'Pin Code',
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                    const Center(
                        child: Text("Enter Contact Details",
                            style: largeBlackStyle)),
                    TextFieldBooking(
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      validatorFunction: (value) {
                        if (value!.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      title: 'Name',
                    ),
                    Text("(*As it appears on driving licence)"),
                    TextFieldBooking(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      smallCase: true,
                      validatorFunction: (value) {
                        if (value!.isEmpty) {
                          return 'Email cannot be empty';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      title: 'Email',
                    ),
                    TextFieldBooking(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      validatorFunction: (value) {
                        if (value!.length != 10) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                      title: 'Phone +91',
                    ),
                    // if (carModel.vendor.name == myChoize)
                    //   TextFieldBooking(
                    //     controller: panNumberController,
                    //     //      keyboardType: TextInputType.number,
                    //     validatorFunction: (value) {
                    //       if (value.length != 10) {
                    //         return 'Invalid pan number';
                    //       }
                    //       return null;
                    //     },
                    //     title: 'Pan Number',
                    //   ),
                    if (model.drive == DriveTypes.AT)
                      TextFieldBooking(
                        controller: flightNumberController,
                        title: 'Flight Number (Optional)',
                      ),
                    if (!isChauffeur) dateWidget(context),
                    // if (carModel.vendor!.name == myChoize)
                    //   NoteWidget(
                    //     text:
                    //         'Note - \nMyChoize insists on local city documents.',
                    //   ),
                    const Divider(color: Colors.transparent),
                    if (carModel.vendor!.name == wowCarz ||
                        carModel.vendor!.name == myChoize ||
                        carModel.vendor!.name == lowCars)
                      NoteWidget(
                          text:
                              'Please Note: Driving License Should Be Atleast 1 Year Old.'),
                    if (!isChauffeur && !isZoom)
                      AllDocumentsWidget(documents: documents),
                    const Divider(color: Colors.transparent),
                    Container(
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                children: [
                          const TextSpan(
                            text: 'By clicking on proceed, I agree with ',
                          ),
                          TextSpan(
                              text: '$appName terms and conditions ',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(zymoTerms));
                                }),
                          const TextSpan(text: ' and '),
                          TextSpan(
                              text:
                                  '${carModel.vendor!.name!.toUpperCase()} terms and conditions. ',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(
                                      CarServices.termsAndConditions(
                                          carModel.vendor!.name)));
                                }),
                          const TextSpan(
                              text: 'Thank you for trusting our service.'),
                        ]))),
                    SizedBox(
                      height: .02.sh,
                    ),
                    Center(
                        child: isLoading
                            ? spinkit
                            : AppButton(
                                screenHeight: 1.sh,
                                function: () => proceedToPromoPage(
                                    model,
                                    context,
                                    carModel,
                                    payableAmount,
                                    documents,
                                    !isChauffeur && !isZoom,
                                    user),
                                title: 'Proceed',
                              ))
                  ],
                ),
              );
            }));
  }

  InkWell dateWidget(BuildContext context) {
    return InkWell(
      onTap: () => dateofBirthPicker(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[850], // Dark grey background
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                  color: Colors.white
                      .withOpacity(0.5)), // Semi-transparent white border
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                  color: Colors.white), // Solid white border on focus
            ),
            labelText: 'Date Of Birth',
            labelStyle:
                const TextStyle(color: Colors.white70), // Dark grey label text
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _dob == null ? 'Select a date' : dateFormatter.format(_dob!),
                style: const TextStyle(
                    color: Colors.white), // Typed text color white
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white70, // Dropdown icon color white
              ),
            ],
          ),
        ),
      ),
    );
  }

  void proceedToPromoPage(
      DriveModel model,
      BuildContext context,
      CarModel carModel,
      double payableAmount,
      DocumentModel documents,
      bool isDocumentsRequired,
      User? user) {
    if (_dob == null &&
        (model.drive == DriveTypes.SD || model.drive == DriveTypes.SUB)) {
      buildShowDialog(context, 'No date of birth selected',
          'Please select a date before proceeding');
      return;
    }
    if (isDocumentsRequired) {
      if (documents.aadhaarFront == null ||
          documents.aadhaarBack == null ||
          documents.licenseFront == null ||
          documents.licenseBack == null) {
        buildShowDialog(context, 'Missing documents',
            'Please upload all documents before proceeding');
        return;
      }
    }
    final UserModel submitModel = getUserModel(model, user!.uid);
    _saveForm(carModel, model, submitModel, payableAmount,
        flightNumberController.text, documents);
  }

  UserModel getUserModel(DriveModel model, String uid) {
    final String phoneNumber = '+91${phoneNumberController.text}';
    final UserModel submitModel = UserModel()
      ..street1 = street1Controller.text.trim()
      ..street2 = street2Controller.text.trim()
      ..city = model.city ?? cityController.text.trim()
      ..dob = dateFormatter.format(_dob!)
      ..email = emailController.text.trim()
      ..name = nameController.text.trim()
      ..phoneNumber = phoneNumber
      ..uid = uid
      ..zipcode = pinCodeController.text;
    if (submitModel.city!.isEmpty) {
      submitModel.city = model.city;
    }
    return submitModel;
  }

  Widget carDetails(
    CarModel carModel,
    DriveModel model,
    BuildContext context,
    List<String> details,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          carModel.name!.toUpperCase(),
                          style: largeBlackStyle,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      if (carModel.vendor!.name == zoomCar &&
                          carModel.carRating != null) ...[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${carModel.carRatingText ?? ''}',
                                style: smallText,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              RatingWidget(totalStars: carModel.carRating),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                  SizedBox(height: .01.sh),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.carRear,
                            size: .04.sw,
                            color: appColor,
                          ),
                          SizedBox(
                            width: .02.sw,
                          ),
                          Text(carModel.transmission!, style: contentStyle),
                        ],
                      ),
                      Row(children: [
                        Icon(
                          FontAwesomeIcons.gasPump,
                          color: appColor,
                          size: .04.sw,
                        ),
                        SizedBox(
                          width: .02.sw,
                        ),
                        Text(carModel.fuel!, style: contentStyle),
                      ]),
                    ],
                  ),
                  SizedBox(height: .01.sh),
                  FulfilledByWidget(
                    vendor: carModel.vendor,
                  ),
                  Divider(
                    color: appColor,
                  ),
                  const Text("Start Date", style: largeBlackStyle),
                  Text('${model.startDate} ${model.starttime}',
                      style: contentStyle),
                  if (model.endtime != null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  if (model.endDate != null)
                    const Text(
                      "End Date",
                      style: largeBlackStyle,
                    ),
                  Text(
                    '${model.endDate} ${model.endtime}',
                    style: contentStyle,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  if (model.distanceOs != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: distanceWidget(model.distanceOs),
                    ),
                  const Text("Drive Type", style: largeBlackStyle),
                  Text(
                      model.drive == DriveTypes.SD
                          ? "Self Drive"
                          : model.drive == DriveTypes.SUB
                              ? "Monthly Rental"
                              : "Chauffeur",
                      style: contentStyle),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  if (model.drive == DriveTypes.WC ||
                      model.drive == DriveTypes.RT ||
                      model.drive == DriveTypes.OW ||
                      model.drive == DriveTypes.AT) ...[
                    const Text(
                      "Booking Type",
                      style: largeBlackStyle,
                    ),
                    Text(
                        model.drive == DriveTypes.WC
                            ? "Within City"
                            : model.drive == DriveTypes.AT
                                ? 'Airport Transfer'
                                : model.drive == DriveTypes.OW
                                    ? 'OutStation (One-way)'
                                    : 'OutStation',
                        style: contentStyle),
                  ]
                ],
              )),
        ),
        SizedBox(
          height: .01.sh,
        ),
        extraDetails(context, details),
        if (carModel.vendor!.name == lowCars)
          Container(
            // height: .1.sh,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<PickupModel>>(
                      future: LowCarServices.getPickUpLocation(model, carModel),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return spinkit;
                        }
                        if (data!.isEmpty) {
                          return Container();
                        }
                        carModel.pickups = data;
                        return Text(
                            'Pickup location: ${data[selected].pickupAddress}',
                            style: titleStyle);
                      },
                    ),
                  ),
                )),
          ),
        SizedBox(height: .01.sh),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            color: Colors.grey[900],
            // elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
                title: Text(
                  'Cancellation Policy',
                  style: TextStyle(
                    color: appColor,
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: appColor,
                    ),
                    onPressed: () {
                      cancellationPolicyWidget(context);
                    })),
          ),
        ), //
      ],
    );
  }

  Future<dynamic> cancellationPolicyWidget(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: SizedBox(
                height: .4.sh,
                width: 1.sw,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Cancellation Policy',
                        textAlign: TextAlign.center,
                        style: headingStyle,
                      ),
                    ),
                    CancellationRateWidget(),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppButton(
                        title: 'Okay',
                        function: () => Navigator.of(ctx).pop(),
                        screenHeight: 1.sh,
                        screenWidth: 1.sw,
                      ),
                    )
                  ],
                ))));
  }

  Widget extraDetails(BuildContext context, List<String> details) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          color: Colors.grey[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: largeBlackStyle,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${details[index]}', style: titleStyle),
                      );
                    },
                  ),
                ],
              )),
        ));
  }

  Column distanceWidget(double? distance) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Distance:",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '$distance Km',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  openLocationSelector(List<PickupModel>? pickups, bool isZoomCar) {
    pickups?.sort(
        (a, b) => a.deliveryCharges?.compareTo(b.deliveryCharges ?? 0) ?? 0);
    return showModalBottomSheet<String>(
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pickup/Drop Locations',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  'Showing ${pickups!.showOptionsText()}',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: .7.sh),
                  child: Scrollbar(
                    interactive: true,
                    child: ListView.builder(
                        itemCount: pickups.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final int? deliveryCharge =
                              pickups[index].deliveryCharges as int?;
                          return Card(
                            color: Colors.grey[900],
                            child: CheckboxListTile(
                                title: Text(
                                  isZoomCar
                                      ? "The pickup location can be found on the following page."
                                      : '${pickups[index].pickupAddress}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (pickups[index].distanceFromUser != null)
                                      Text(
                                          '${pickups[index].distanceFromUser} KMs away',
                                          style: itleStyle),
                                    Text(
                                      deliveryCharge == 0
                                          ? 'Free'
                                          : '$rupeeSign${deliveryCharge}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                value: selected == index,
                                onChanged: (val) {
                                  setState(() {
                                    selected = index;
                                  });
                                  Navigator.pop(
                                      context, pickups[index].pickupAddress);
                                }),
                          );
                        }),
                  ),
                ),
              ],
            )));
  }
}

class TextFieldBooking extends StatelessWidget {
  const TextFieldBooking({
    Key? key,
    this.function,
    this.title,
    this.validatorFunction,
    this.controller,
    this.keyboardType,
    this.smallCase,
  }) : super(key: key);

  final bool? smallCase;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? title;
  final String? Function(String?)? validatorFunction;
  final Function? function;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        textCapitalization: smallCase != null
            ? TextCapitalization.none
            : TextCapitalization.words,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              Colors.grey[850], // Dark grey background for the text field
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
                color: Colors.white.withOpacity(0.5)), // White border
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
                color: Colors.white), // Solid white border when focused
          ),
          labelText: title,
          labelStyle:
              const TextStyle(color: Colors.white70), // Dark grey label text
          hintText: title,
          hintStyle:
              const TextStyle(color: Colors.white38), // Light grey hint text
        ),
        style: const TextStyle(color: Colors.white), // Typed text color white
        cursorColor: Colors.white, // Cursor color white
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: validatorFunction,
        onSaved: function as void Function(String?)?,
      ),
    );
  }
}
