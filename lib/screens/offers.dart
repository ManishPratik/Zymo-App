import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Widgets/Cars/car_view.dart';

class OfferPage extends StatelessWidget {
  static const routeName = '/Offers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Offers',style: TextStyle(color:Colors.black),),
        ),
        body: true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "No Offers right now...",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "New Offers Coming Soon!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),

                    // style: bigTitleStyle,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  SizedBox(
                    height: .01.sh,
                  ),
                  Container(
                      height: .4.sh,
                      width: 1.sh,
                      child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$appName Offers', style: bigTitleStyle),
                              Image.asset(
                                'assets/images/onboarding_images/search.jpeg',
                                height: .3.sh,
                              ),
                            ],
                          ))),
                  SizedBox(
                    height: .01.sh,
                  ),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseServices().getOffers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(child: spinkit);
                        }
                        final List? data = snapshot.data?.docs.first['images'];
                        if (data == null || data.isEmpty) {
                          return AppErrorWidget(
                              error:
                                  "No offers available right now, please check back in some time :)");
                        } else {
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => spinkit,
                                      imageUrl: data[index],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ]),
              ));
  }
}
