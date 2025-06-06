import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:letzrentnew/Screens/Rewards/vouchers_screen.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Services/car_functions.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/models/document_model.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:letzrentnew/screens/tabs_screen.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'location_picker.dart';
import 'widgets.dart';

const appColor = const Color(0xFFFFFA8D);

final gradientColors = [
  const Color(0xFFFFFA8D),
  const Color(0xFFFFFA8D),
  const Color(0xFFFFFA8D),
];

enum DriveTypes { WC, SD, SUB, RT, AT, OW }

enum AirportTransferTypes { pickup, drop }

enum DocumentEnum { AF, AB, LF, LB }

const String appName = 'Zymo';
const String mixedPanelToken = 'd7786806f19ca334ba91dc03790a0c81';
const List delhiNCR = [
  "gurugram",
  "gurgaon",
  "noida",
  "ghaziabad",
  "faridabad",
  "delhi"
];

final DateFormat dateFormatter = DateFormat('dd MMM, yyyy');
final DateFormat lowcarsDate = DateFormat('dd-MM-yyyy');
final DateFormat myChoizeDate = DateFormat('dd-MM-yyyy HH:mm');
final DateFormat lowcarsDate2 = DateFormat('yyyy-MM-dd');
// final DateFormat timeFormatter = DateFormat.jm();
const appStoreId = '1547829759';
const String oops = 'Oops!';
const String ContactNumber = '+919987933348';

final playStoreLink =
    'https://play.google.com/store/apps/details?id=com.letzrent.letzrentnew';
final appStoreLink =
    "https://apps.apple.com/in/app/letzrent-self-drive-car/id1547829759";
final platformStoreLink = Platform.isIOS ? appStoreLink : playStoreLink;

final String openWhatsApp = Platform.isIOS
    ? "https://wa.me/$ContactNumber"
    : "whatsapp://send?phone=$ContactNumber";
const String EmailContact = 'hello@zymo.app';
const bool zoomProd = true;
const String zoomCarApiKey = zoomProd
    ? 'b0Jhi0eTQg6SoHq9bcmLX6ldVlzM1OU9Wyuuurl3'
    : 'DqRzg8il66Qz7kXUzlHy3EyKejdfAdM12Rl7rNC2';
const String zoomCarId = zoomProd ? 'letzrent' : 'bw10lmnvbmmts56b29ty2fy';
const String zoomCarPassword =
    zoomProd ? 'd&8rv#G9o9pvZ8P>D}M9' : 'ZWIxZmQyNTIxN2Qx*YzkwNDc4Y2FjMzhh';
const String zoomProductionUrl = 'https://partner-api.zoomcar.com/';
const String zoomTestUrl = 'https://sandbox.zoomcartest.com/';
const String zoomUrl = zoomProd ? zoomProductionUrl : zoomTestUrl;
const myChoizeProd = true;
const String myChoizeTestUrl =
    'https://appuat.mychoize.com/OrixMobileAppThirdParty/';
const String myChoizeProdUrl = 'https://app.mychoize.com/Orix.ThirdPartyLive/';
const String myChoizeUrl = myChoizeProd ? myChoizeProdUrl : myChoizeTestUrl;
const String myChoizeUserName = 'LETZRENTTEST';
const String myChoizeKey = 'Letsrent@test123';

const int referralAmount = 200;
final DateFormat timeFormat = DateFormat("hh:mm a"); //"6:00 AM"

const String sadEmoji = '😔';
const String happyEmoji = '🥳';

const minTransactionValue = 750;

final deliveryWow = [
  PickupModel(pickupAddress: 'Self Pickup', deliveryCharges: 0),
  PickupModel(
      pickupAddress: '$homeDelivery (Upto 20 KMs)', deliveryCharges: 650),
  PickupModel(pickupAddress: 'Airport Pickup', deliveryCharges: 950),
];

final coR = [
  PickupModel(pickupAddress: 'Self Pickup: Free', deliveryCharges: 0),
  PickupModel(
      pickupAddress: '$homeDelivery (Upto 15 KMs from pickup point)',
      deliveryCharges: 500),
  PickupModel(
      pickupAddress: '$homeDelivery (Upto 25 KMs from pickup point)',
      deliveryCharges: 1000),
];
const cashFreeAppId = '1155688286b537d8778413e98b865511';

const users = 'users';
const carsPaymentSuccessDetails = 'CarsPaymentSuccessDetails';
const bengaluru = 'Bengaluru';
const wowCarz = 'Wowcarz';
const WheelUp = 'WheelUp';
const lowCars = 'LowCars';
const zoomCar = 'ZoomCar';
const doorCar = 'DoorCar';
const karyana = 'Karyana';
const kyp = 'Kyp';
const kos = 'KOS';
const vuk = 'VUK';
const myChoize = 'mychoize';
const carOnRent = 'CarOnRent';
const avis = 'avis';
const ems = 'ems';
const eco = 'eco';
const cars24 = 'cars24';
const orix = 'orix';
const hrx = 'Hrx';
const wheelUp = 'WheelUp';
const zt = "Zt";
const Duration timeOutDuration = const Duration(seconds: 40);

const twoSeconds = const Duration(seconds: 2);
const sevenSeconds = const Duration(seconds: 7);

const greyColor = Color(0xffFDF9F9);
const whiteColor = Colors.black;
const blackColor = Colors.white;
Color? darkGrey = Colors.grey[900];

const String homeDelivery = 'Delivery & Pickup';
const String airportPickup = 'Airport Pickup';

const contentStyle =
    TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600);
const titleStyle =
    TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);
const whiteTitleStyle =
    TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);
const smallText =
    TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600);
const smallWhiteText =
    TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600);
const largeStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w800,
);
const semiBoldBlackTitleStyle =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black);
const smallBlackHeadingStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black);

const largeBlackStyle = TextStyle(
  fontSize: 17,
  color: Colors.white,
  fontWeight: FontWeight.w800,
);

const largeWhiteStyle = TextStyle(
  fontSize: 17,
  color: Colors.white70,
  fontWeight: FontWeight.w800,
);
const greenLargeStyle = TextStyle(
  fontSize: 18,
  color: Colors.green,
  fontWeight: FontWeight.w600,
);
const purpleLargeStyle = TextStyle(
  fontSize: 18,
  color: appColor,
  fontWeight: FontWeight.w600,
);
const greentitleStyle = TextStyle(
  fontSize: 14,
  color: Colors.green,
  fontWeight: FontWeight.w600,
);
const itleStyle = TextStyle(
  fontSize: 14,
  color: appColor,
  fontWeight: FontWeight.w600,
);
const headingStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
const bigHeadingStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);
const bigTitleStyle = TextStyle(
  fontSize: 30,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);
const bigWhiteTitleStyle = TextStyle(
  fontSize: 24,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
const biWhiteTitleStyle = TextStyle(
  fontSize: 35,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
String? contactNumber;

// Mixpanel? mixpanel;
// Future<void> initMixpanel() async {
//   try {
//     mixpanel = await Mixpanel.init(mixedPanelToken, trackAutomaticEvents: true);
//     final String? uid = Auth().getCurrentUser()?.uid;
//     if (uid != null) mixpanel!.identify(uid);
//   } catch (e) {}
// }

const String letzrentTandC = 'https://letzrent.com/terms-conditions/';
const String zymoTerms = 'https://zymo.app/terms';
const spinkit = SpinKitDoubleBounce(
  color: const Color(0xFFFFFA8D),
  size: 35.0,
);
const whiteSpinkit = SpinKitDoubleBounce(
  color: Colors.white,
  size: 35.0,
);
const placeHolder = const Center(
  child: Text(
    'ZYMO',
    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
  ),
);

const bookingFastList = ['Celerio', 'Tiago', 'XUV 500', 'Kwid', 'Brezza'];

Future buildShowDialog(BuildContext context, String title, String? body) {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      backgroundColor: Colors.black, // Set dialog background to black
      child: SizedBox(
        height: .35.sh,
        width: 1.sw,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: headingStyle.copyWith(
                  color: Colors.white, // Set title color to white
                ),
              ),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70, // Set body text to dark grey
                ),
              ),
              AppButton(
                title: 'Okay',
                function: () => Navigator.of(ctx).pop(),
                screenHeight: 1.sh,
                screenWidth: 1.sw,
                // buttonColor: Colors.grey[850], // Dark grey button
                // textColor: Colors.white, // White button text
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Future showVouchers(BuildContext context, String type) {
  return showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
            height: .8.sh,
            width: 1.sw,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.cancel,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Text(
                  'Vouchers',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const Divider(
                //   color: Colors.black54,
                // ),
                Expanded(
                  child: VoucherWidget(
                    type: type,
                  ),
                )
              ],
            ),
          ));
}

buildConfettiWidget(controller, Alignment alignment) {
  return Align(
    alignment: alignment,
    child: ConfettiWidget(
      numberOfParticles: 1,
      maximumSize: const Size(20, 20),

      confettiController: controller,
      // blastDirection: blastDirection,
      blastDirectionality: BlastDirectionality.explosive,
      maxBlastForce: 18, // set a lower max blast force
      minBlastForce: 8, // set a lower min blast force
      emissionFrequency: 1,
      colors: const [Colors.red, Colors.blue, Colors.yellow, Colors.green],
      // a lot of particles at once
    ),
  );
}

Future voucherPopUp(BuildContext context, String title, String body) {
  final ConfettiController controller =
      ConfettiController(duration: twoSeconds);
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    controller.play();
  });
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: SizedBox(
        height: .4.sh,
        width: 1.sw,
        child: Stack(
          children: [
            SizedBox(
                height: .5.sh,
                width: 1.sw,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(
                      //   width: 0.8.sw,
                      //   child: Image.asset(
                      //     'assets/images/reward_image.png',
                      //   ),
                      // ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: biWhiteTitleStyle,
                      ),
                      Text(
                        body,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      AppButton(
                        title: 'Okay',
                        function: () => Navigator.of(context).pop(),
                        screenHeight: 1.sh,
                        screenWidth: 1.sw,
                      )
                    ],
                  ),
                )),
            buildConfettiWidget(controller, Alignment.topLeft),
            buildConfettiWidget(controller, Alignment.topRight),
          ],
        ),
      ),
    ),
  );
}

Widget atDurationPicker(BuildContext context, CarProvider value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => CarFunctions().startDatePicker(context),
          child: DurationTile(
            title: 'Start date',
            body: value.startDate != null
                ? dateFormatter.format(value.startDate!)
                : 'Select date',
            textColor: Colors.grey,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: appColor,
        ),
        Spacer(),
        Icon(
          Icons.arrow_drop_down,
          color: appColor,
        ),
        InkWell(
          onTap: () => CarFunctions().startTimePicker(context),
          child: DurationTile(
            title: 'Start time',
            body: value.startTime != null
                ? value.startTime!.format(context)
                : 'Select time',
            textColor: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.screenWidth = double.infinity,
    required this.screenHeight,
    this.function,
    required this.title,
    this.textSize,
    this.color,
  }) : super(key: key);

  final double screenWidth;
  final double screenHeight;
  final String title;
  final Function? function;
  final double? textSize;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appColor,
        ),
        width: screenWidth * .33,
        // height: screenHeight * .06,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                  fontSize: textSize ?? 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

Padding durationPicker(BuildContext context, CarProvider value) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        //   child: Row(
        //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       // Start Date Picker
        //       InkWell(
        //         onTap: () => CarFunctions().startDatePicker(context),
        //         child: DurationTile(
        //             title: 'Start Date',
        //             body: value.startDate != null
        //                 ? dateFormatter.format(value.startDate!)
        //                 : 'Select Date',
        //             textColor: Colors.grey),
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Icon(
        //         Icons.arrow_drop_down,
        //         color: appColor,
        //       ),
        //       Spacer(),
        //       Icon(
        //         Icons.arrow_drop_down,
        //         color: appColor,
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       InkWell(
        //         onTap: () => CarFunctions().startTimePicker(context),
        //         child: DurationTile(
        //           title: 'Start Time',
        //           body: value.startTime != null
        //               ? value.startTime!.format(context).toString()
        //               : 'Select Time',
        //           textColor: Colors.grey, // Text color set to grey
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              // Start Date Picker
              Expanded(
                child: InkWell(
                  onTap: () => CarFunctions().startDatePicker(context),
                  child: DurationTile(
                    title: 'Start Date',
                    body: value.startDate != null
                        ? dateFormatter.format(value.startDate!)
                        : 'Select Date',
                    textColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.arrow_drop_down,
                color: appColor,
              ),
              const SizedBox(width: 10), // Added spacing between sections
              Icon(
                Icons.arrow_drop_down,
                color: appColor,
              ),
              const SizedBox(width: 5),
              // Start Time Picker
              Expanded(
                child: InkWell(
                  onTap: () => CarFunctions().startTimePicker(context),
                  child: DurationTile(
                    title: 'Start Time',
                    body: value.startTime != null
                        ? value.startTime!.format(context).toString()
                        : 'Select Time',
                    textColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // End Date Picker
              InkWell(
                onTap: () => CarFunctions().endDatePicker(context),
                child: DurationTile(
                    title: 'End Date',
                    body: value.endDate != null
                        ? dateFormatter.format(value.endDate!)
                        : 'Select Date',
                    textColor: Colors.grey), // Text color set to grey
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: appColor,
              ),
              Spacer(),
              Icon(
                Icons.arrow_drop_down,
                color: appColor,
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () => CarFunctions().endTimePicker(context),
                child: DurationTile(
                  title: 'End Time',
                  body: value.endTime != null
                      ? value.endTime!.format(context).toString()
                      : 'Select Time',
                  textColor: Colors.grey, // Text color set to grey
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Future<dynamic> warningPopUp(BuildContext context, String title, String body) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            child: SizedBox(
              height: .4.sh,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.bell,
                    size: .1.sh,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      title,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      body,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  AppButton(
                    title: 'Okay',
                    function: () => Navigator.of(context).pop(),
                    screenHeight: 1.sh,
                    screenWidth: 1.sw,
                  )
                ],
              ),
            ),
          ));
}

Future<void> navigateToHome(BuildContext context) async {
  if (Auth().getCurrentUser()?.uid != null) {
    // await initMixpanel();
    await Navigator.of(context)
        .pushNamedAndRemoveUntil(TabScreen.routeName, (r) => false);
  } else {
    warningPopUp(context, oops, 'Please try again!');
  }
}

class PickLocationWidget extends StatelessWidget {
  const PickLocationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
        builder: (BuildContext context, value, Widget? child) =>
            FutureBuilder<String?>(
                future: value.getLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return spinkit;
                  } else {
                    return Card(
                      color: appColor,
                      elevation: 5,
                      child: InkWell(
                        onTap: () async => CommonFunctions.navigateTo(
                            context, LocationPicker()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Your Location',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  // Text(
                                  //     CommonFunctions.getCityFromLocation(
                                  //         snapshot.data!),
                                  //     maxLines: 1,
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: bigWhiteTitleStyle),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }));
  }
}

class AllDocumentsWidget extends StatelessWidget {
  final DocumentModel? documents;
  const AllDocumentsWidget({Key? key, this.documents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
        builder: (BuildContext context, value, Widget? child) => Column(
              children: <Widget>[
                DocumentWidget(
                    title: 'front_page_driving_license',
                    description: 'Uploaded Driving License Front Page',
                    link: documents!.licenseFront,
                    image: value.licenseFront,
                    function: (x) async {
                      final File? file = await pickImage(x);
                      value.setImage(file, DocumentEnum.LF);
                    },
                    clearImage: () => value.clearImage(DocumentEnum.LF)),
                const Divider(),
                const Divider(),
                DocumentWidget(
                    title: 'back_page_driving_license',
                    description: 'Uploaded Driving License Back Page',
                    link: documents!.licenseBack,
                    image: value.licenseBack,
                    function: (x) async {
                      final File? file = await pickImage(x);
                      value.setImage(file, DocumentEnum.LB);
                    },
                    clearImage: () => value.clearImage(DocumentEnum.LB)),
                const Divider(),
                const Divider(),
                DocumentWidget(
                    title: 'front_page_aadhaar_card',
                    description: 'Uploaded Aadhaar card Front Page',
                    link: documents!.aadhaarFront,
                    image: value.aadhaarFront,
                    function: (x) async {
                      final File? file = await pickImage(x);
                      value.setImage(file, DocumentEnum.AF);
                    },
                    clearImage: () => value.clearImage(DocumentEnum.AF)),
                const Divider(),
                const Divider(),
                DocumentWidget(
                    title: 'back_page_aadhaar_card',
                    description: 'Uploaded Aadhaar card back page',
                    link: documents!.aadhaarBack,
                    image: value.aadhaarBack,
                    function: (x) async {
                      final File? file = await pickImage(x);
                      value.setImage(file, DocumentEnum.AB);
                    },
                    clearImage: () => value.clearImage(DocumentEnum.AB)),
              ],
            ));
  }
}

Future<File?> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final selected =
      await picker.pickImage(source: source, maxHeight: 900, maxWidth: 900);
  if (selected?.path != null) {
    return File(selected!.path);
  } else {
    return null;
  }
}

Future<String?> uploadFunction(
    File file, String name, BuildContext context) async {
  {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final User user = Auth().getCurrentUser()!;
    final String filePath = 'userImages/${user.uid}/${name}.png';
    final Reference storageReference = storage.ref(filePath);
    try {
      UploadTask _uploadTask;
      _uploadTask = storageReference.putFile(file);

      String? url;
      await _uploadTask.whenComplete(
          () async => url = await storageReference.getDownloadURL());
      return url;
    } catch (e) {
      await warningPopUp(
          context, oops, 'Something went wrong. Please try again. $e');
      return null;
    }
  }
}

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    Key? key,
    this.text,
  }) : super(key: key);
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

final appBarGradient = Container(
    decoration:
        BoxDecoration(gradient: LinearGradient(colors: gradientColors)));
