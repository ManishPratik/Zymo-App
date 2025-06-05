import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/models/coliving_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/car_model.dart';
import '../providers/home_provider.dart';
import 'app_data.dart';
import 'constants.dart';
import '../models/user_model.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({Key? key, this.userModel, this.showAddress = true})
      : super(key: key);

  final UserModel? userModel;
  final bool showAddress;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Details', style: largeStyle),
            SizedBox(height: .01.sh, width: 1.sw),
            const Text(
              "Name",
              style: titleStyle,
            ),
            Text("${userModel!.name}", style: contentStyle),
            SizedBox(height: 10),
            if (showAddress) ...[
              const Text(
                "Address",
                style: titleStyle,
              ),
              Text(
                  "${userModel!.street1}, ${userModel!.street2}, ${userModel!.city}, ${userModel!.zipcode}",
                  style: contentStyle),
              SizedBox(height: 10),
            ],
            const Text(
              "Mobile Number",
              style: titleStyle,
            ),
            Text(userModel!.phoneNumber!, style: contentStyle),
            SizedBox(height: 10),
            const Text(
              "Email",
              style: titleStyle,
            ),
            Text(userModel!.email!, style: contentStyle),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class TripDetailsWidget extends StatelessWidget {
  const TripDetailsWidget({
    Key? key,
    this.model,
    this.carModel,
  }) : super(key: key);

  final DriveModel? model;
  final CarModel? carModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((model!.drive == DriveTypes.SD ||
                    model!.drive == DriveTypes.SUB) &&
                carModel!.pickUpAndDrop!.contains(homeDelivery))
              const Text(homeDelivery, style: largeStyle)
            else if ((model!.drive == DriveTypes.SD ||
                    model!.drive == DriveTypes.SUB) &&
                carModel!.pickUpAndDrop!.contains(airportPickup))
              const Text(airportPickup, style: largeStyle)
            else if (carModel!.pickUpAndDrop != null) ...[
              Text('Pickup', style: largeStyle),
              SizedBox(height: .01.sh),
              Row(
                children: [
                  Text('Pickup location', style: titleStyle),
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                  ),
                ],
              ),
              Text('${carModel!.pickUpAndDrop}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: titleStyle),
              if (carModel!.vendor!.name == karyana ||
                  carModel!.vendor!.name == kyp)
                openInMapsButton(carModel!.pickUpAndDrop),
              // Card(
              //   color: Colors.blue[50],
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       'Exact car location will be shared 4 hours before trip start time.',
              //     ),
              //   ),
              // ),
            ],
            SizedBox(height: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Start Date", style: titleStyle),
              Text('${model!.startDate} ${model!.starttime}',
                  style: contentStyle),
            ]),
            const Divider(color: Colors.transparent),
            if (model!.endtime != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "End Date",
                    style: titleStyle,
                  ),
                  Text('${model!.endDate} ${model!.endtime}',
                      style: contentStyle),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

Widget openInMapsButton(String? address) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 30),
      ),
      onPressed: () async {
        final String urlString =
            'https://www.google.com/maps/search/?api=1&query=${address!.replaceAll(' ', '%20')}';
        print(urlString);
        await launchUrl(Uri.parse(urlString));
      },
      child: Text('Open in Maps'));
}
  carImage(String? _imageUrl, {double? width}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _imageUrl == null
          ? Icon(FontAwesomeIcons.carRear, size: .45.sw)
          : CachedNetworkImage(
              imageUrl: _imageUrl,
              height: .45.sw,
              width: width ?? .8.sw,
              fit: BoxFit.fitWidth,
              placeholder: (context, ok) =>
                  const Image(image: AssetImage('assets/images/finallogo.png')),
              //      ),
            ),
    );
  }

class CarDetailsWidget extends StatelessWidget {
  const CarDetailsWidget({
    Key? key,
    this.carModel,
    this.bookingId,
  }) : super(key: key);

  final CarModel? carModel;
  final String? bookingId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: carImage(carModel?.imageUrl, width: .4.sw)),
              ),
            ),
            Text(
              carModel!.name!.toUpperCase(),
              style: largeStyle,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(carModel!.transmission!, style: titleStyle),
                Text(
                  carModel!.package!,
                  style: titleStyle,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                const Text('Fulfilled by ', style: titleStyle),
                CachedNetworkImage(
                  imageUrl: carModel!.vendor!.imageUrl!,
                  width: 0.14.sw,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

InkWell callUsWidget() {
  return InkWell(
    onTap: CommonFunctions.callUsFunction,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "WhatsApp",
          style: TextStyle(
              fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 2),
        Icon(
          Icons.open_in_new,
          color: Colors.blue,
          size: 18,
        )
      ],
    ),
  );
}

class FAQTile extends StatelessWidget {
  const FAQTile(
    this.title,
    this.body, {
    Key? key,
  }) : super(key: key);

  final String? title;
  final String? body;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        iconColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '$title',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              iconColor: Colors.white,
              title: Text(
                body!,
                style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),
              ),
            ),
          )
        ],
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }
}

class TripDurationWidget extends StatelessWidget {
  const TripDurationWidget({Key? key, required this.duration})
      : super(key: key);
  final String? duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      width: 1.sw,
      decoration: BoxDecoration(
          color: Color(0xff303030),
          border: Border.all(color: appColor, width: .6),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: duration != null && duration!.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Trip Duration',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  Text(
                    duration!,
                    style: const TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? prefix;
  const TextFieldWidget({
    Key? key,
    this.label,
    this.controller,
    this.validator,
    this.obscureText,
    this.keyboardType,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType ?? TextInputType.text,
          maxLength: 10,
          decoration: InputDecoration(
              counterText: "",
              prefix: prefix,
              suffixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              ),
              contentPadding: const EdgeInsets.all(12),
              border: InputBorder.none,
              labelStyle: const TextStyle(color: Colors.black38),
              labelText: label),
          validator: (value) => validator!(value),
        ));
  }
}

class VoucherIndicator extends StatelessWidget {
  const VoucherIndicator({
    Key? key,
    required this.isApplied,
    this.function,
  }) : super(key: key);

  final bool isApplied;
  final void Function()? function;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: .4)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: appColor,
          child: CircleAvatar(
              backgroundImage: AssetImage('dev_assets/new_logo.jpeg')),
        ),
        title: const Text('Select a voucher',style: TextStyle(color: Colors.white),),
        trailing: InkWell(
          onTap: isApplied ? null : function,
          child: Text(
            isApplied ? 'Applied!' : 'View Vouchers',
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class AllCategoryWidget extends StatelessWidget {
  final String title;
  final String? image;
  final Function? function;
  const AllCategoryWidget({
    Key? key,
    required this.title,
    this.image,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: InkWell(
          onTap: function as void Function()?,
          child: SizedBox(
            width: 0.44.sw,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                color: Colors.black12,
                child: Image.asset(
                  image!,
                  fit: BoxFit.fitWidth,
                  //     height: .15.sh,
                  width: 0.45.sw,
                  //imageUrl: '$image'
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoLivingImages extends StatelessWidget {
  const CoLivingImages({
    Key? key,
    required this.coLivingModel,
  }) : super(key: key);

  final CoLivingModel? coLivingModel;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      // radius: const Radius.circular(10),
      // autoplayDuration: sevenSeconds,
      // borderRadius: true,
      // dotPosition: DotPosition.topCenter,
      // dotSize: 3,
      items: coLivingModel!.imageUrl!
          .map(
            (e) => CachedNetworkImage(
                imageUrl: '$e',
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, ok) => placeHolder),
          )
          .toList(),
      options: CarouselOptions(autoPlayAnimationDuration: sevenSeconds),
      // dotBgColor: Colors.transparent,
    );
  }
}

class RewardVoucherWidget extends StatelessWidget {
  const RewardVoucherWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              FontAwesomeIcons.gift,
              color: appColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text.rich(TextSpan(
                children: [
                  TextSpan(text: '$text', style: TextStyle(fontSize: 18)),
                ],
                style: headingStyle,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class CancellationRateWidget extends StatelessWidget {
  const CancellationRateWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Map?>(
          future: FirebaseServices().getCancellationData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return spinkit;
            }
            return snapshot.data!['cancellationText'] != null
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                        child: Text(
                            '${snapshot.data!['cancellationText'].replaceAll('. ', '\n\n')}',style: TextStyle(color: Colors.white),),),
                  )
                : Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Cancellation Charges',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          ListTile(
                            title: Text("Before 24 Hours of Trip",
                                style: TextStyle(color: Colors.white),),
                            subtitle: Text(snapshot.data!['before24Hours'],style: TextStyle(color: Colors.white),),
                          ),
                          ListTile(
                            title: Text("Within 48 Hours of Trip",
                                style: TextStyle(color: Colors.white),),
                            subtitle: Text(snapshot.data!['before48Hours'],style: TextStyle(color: Colors.white),),
                          ),
                          ListTile(
                            title: Text("After Trip Starts", style: titleStyle),
                            subtitle: Text(snapshot.data!['afterTripStarts'],style: TextStyle(color: Colors.white),),
                          ),
                        ]));
          }),
    );
  }
}

class FulfilledByWidget extends StatelessWidget {
  final Vendor? vendor;

  const FulfilledByWidget({
    Key? key,
    required this.vendor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Fulfilled by ', style: titleStyle),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: vendor!.imageUrl!,
              width: 0.14.sw,
            ),
            if (vendor!.name == "Karyana")
              Text(
                vendor!.name!,
                style: titleStyle,
              )
          ],
        ),
      ],
    );
  }
}

class Uploader extends StatefulWidget {
  final File? file;
  final String? cat;
  const Uploader({Key? key, this.file, this.cat}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  UploadTask? _uploadTask;
  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask!.snapshotEvents,
          builder: (_, snapshot) {
            final TaskSnapshot? event = snapshot.data;
            final double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;

            return Column(
              children: [
                if (_uploadTask!.snapshot.state == TaskState.success)
                  const Text(
                    'Successfully Uploaded',
                    style: smallText,
                  ),

                if (_uploadTask!.snapshot.state == TaskState.paused)
                  TextButton(
                    onPressed: _uploadTask!.resume,
                    child: const Icon(Icons.play_arrow),
                  ),

                if (_uploadTask!.snapshot.state == TaskState.running)
                  TextButton(
                    onPressed: _uploadTask!.pause,
                    child: const Icon(Icons.pause),
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text(
                  '${(progressPercent * 100).toStringAsFixed(2)} % ',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            );
          });
    } else {
      return TextButton.icon(
          label: const Text('Upload'),
          icon: const Icon(Icons.cloud_upload),
          onPressed: () async => uploadFunction());
    }
  }

  Future<void> uploadFunction() async {
    {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final User user = Auth().getCurrentUser()!;
      final String filePath = 'userImages/${user.uid}/${widget.cat}.png';
      final Reference storageReference = storage.ref(filePath);
      try {
        setState(() {
          _uploadTask = storageReference.putFile(widget.file!);
        });
        String? url;
        await _uploadTask!.whenComplete(
            () async => url = await storageReference.getDownloadURL());
        await FirebaseServices().addUserDocument(widget.cat!, url);
      } catch (e) {
        warningPopUp(
            context, oops, 'Something went wrong. Please try again. $e');
      }
    }
  }
}

class DocumentsUploader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseServices().getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: spinkit);
          }
          final UserModel userData = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>?);
          return Consumer<HomeProvider>(
              builder: (BuildContext context, value, Widget? child) => Column(
                    children: <Widget>[
                      DocumentWidget(
                          title: 'front_page_driving_license',
                          description: 'Uploaded Driving License Front Page',
                          link: userData.frontLicense,
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
                          link: userData.backLicense,
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
                          link: userData.frontAadhaar,
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
                          link: userData.backAadhaar,
                          image: value.aadhaarBack,
                          function: (x) async {
                            final File? file = await pickImage(x);
                            value.setImage(file, DocumentEnum.AB);
                          },
                          clearImage: () => value.clearImage(DocumentEnum.AB)),
                    ],
                  ));
        });
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget(
      {Key? key,
      required this.link,
      required this.image,
      this.function,
      this.clearImage,
      this.title,
      this.description})
      : super(key: key);
  final String? title;
  final String? description;
  final String? link;
  final File? image;
  final Future<void> Function(ImageSource)? function;

  final Function? clearImage;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: <Widget>[
        Checkbox(
          onChanged: (val) {},
          checkColor: Colors.white,
          hoverColor: appColor,
          value: link != null,
          //onChanged: (_){},
        ),
        Text(description!,style: TextStyle(
          color: Colors.grey,
        ),)
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: () => function!(ImageSource.camera),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => function!(ImageSource.gallery),
          ),
        ],
      ),
      if (image != null) ...[
        Container(
            margin: const EdgeInsets.all(4),
            child: Image.file(
              image!,
              height: 200,
            )),
        Row(
          children: <Widget>[
            TextButton(
                onPressed: clearImage as void Function()?,
                child: const Icon(Icons.refresh)),
          ],
        ),
        Uploader(file: image, cat: title),
      ] else if (link != null)
        CachedNetworkImage(
          imageUrl: link!,
          height: 200,
          placeholder: (context, ok) {
            return placeHolder;
          },
        ),
    ]);
  }
}

Widget shimmerLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 80.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    
                  ),
                  width: .4.sw,
                  height: .4.sw,
                  
                ),
              ),
            ],
          ),
        ),
        itemCount: 6,
      ),
    ),
  );
}

class DurationTile extends StatelessWidget {
  final String title;
  final String body;
  final Color textColor;  

  const DurationTile({
    required this.title,
    required this.body,
    required this.textColor,  
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey, // Use the passed textColor
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        Text(
          body,
          style: TextStyle(
            color: textColor, // Use the passed textColor
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}


class FilterItem extends StatelessWidget {
  final String? title;
  final bool? isSelected;
  final Function? function;
  final double? width;
  const FilterItem({
    Key? key,
    this.title,
    this.isSelected,
    this.function,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.grey[700],
      highlightColor: Colors.grey[700],
      splashColor: Colors.grey[700],
      onTap: () => function!(),
      child: Chip(
        padding: const EdgeInsets.symmetric(vertical: 12),
        label: SizedBox(
          width: width,
          child: Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isSelected!
                    ? Colors.white
                    : Colors.black),
          ),
        ),
        backgroundColor: isSelected!
            ? Colors.black
            : Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class TrendingRentalTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imageUrl;
  final int? price;
  final Function? function;

  const TrendingRentalTile({
    Key? key,
    this.title,
    this.price,
    this.subTitle,
    this.imageUrl,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListTile(
        onTap: () => function,
        isThreeLine: true,
        tileColor: Colors.white,
        //       minVerticalPadding: 10,
        leading: SizedBox(
          width: 80,
          child: CachedNetworkImage(
            fit: BoxFit.fitHeight,
            imageUrl: imageUrl!,
          ),
        ),
        title: Text(
          '$title\n$subTitle',
          style: const TextStyle(),
        ),
        subtitle: Text(
          '$rupeeSign$price',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    Key? key,
    required this.totalStars,
  }) : super(key: key);

  final double? totalStars;

  @override
  Widget build(BuildContext context) {
    final containsHalf = (totalStars! % 1 != 0);
    final int stars = totalStars!.ceil();
    const starColor = Colors.white;

    return SizedBox(
      width: .23.sw,
      height: .05.sh,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            if (index + 1 > stars) {
              return const Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Icon(FontAwesomeIcons.star, size: 15, color: starColor),
              );
            } else if (containsHalf && ((index + 1) == stars)) {
              return const Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Icon(FontAwesomeIcons.starHalfStroke,
                    size: 15, color: starColor),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Icon(FontAwesomeIcons.solidStar,
                    size: 15, color: starColor),
              );
            }
          }),
    );
  }
}
