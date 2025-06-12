import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/dimensions.dart';
import 'package:letzrentnew/Utils/location_picker.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:letzrentnew/screens/referral_screen.dart';
import 'package:letzrentnew/widgets/Cars/self_drive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/car_functions.dart';
import '../Utils/functions.dart';
import '../Utils/constants.dart';
import '../models/UImodel.dart';
import '../screens/user_profile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const List<Map<String, String>> items = [
    {
      'image': "assets/images/ZymoBenefits/carlogo.png",
      'text': "Wide Range of Cars",
    },
    {
      'image': "assets/images/ZymoBenefits/book.png",
      'text': "Quick and Easy Booking",
    },
    {
      'image': "assets/images/ZymoBenefits/bag_of_gold.png",
      'text': "Affordable Prices",
    },
    {
      'image': "assets/images/ZymoBenefits/handshake.png",
      'text': "Trusted by Thousands",
    },
  ];
  bool isSelfDrive = true;
  final ScrollController _controller = ScrollController();
  double indicatorPosition = 0;
    int index = 0;


  final steps = [
    StepModel(
      imagePath: 'assets/images/guide/image1.png',
      title: 'Getting Started',
      description:
          'The user logs into Zymo, enters source, and time. Zymo shows a list of rental cars, enabling easy comparison by price, type, and features.',
    ),
    StepModel(
      imagePath: 'assets/images/guide/image2.png',
      title: 'Choosing & Confirming Booking',
      description:
          'The user selects the best-fit car after comparing options. Key details are shown before confirming the booking.',
    ),
    StepModel(
      imagePath: 'assets/images/guide/image3.png',
      title: 'Payment & Confirmation',
      description:
          'Payment is completed securely. Booking confirmation is sent instantly via email and WhatsApp.',
    ),
    StepModel(
      imagePath: 'assets/images/guide/image4.png',
      title: 'Car Usage & Return',
      description:
          'The user picks up the car, uses it during the booked time, and returns it hassle-free.',
    ),
    StepModel(
      imagePath: 'assets/images/guide/image5.png',
      title: 'Providing Feedback',
      description:
          'After the trip, the user rates the service and shares feedback, helping others choose better.',
    ),
    // Add more steps similarly
  ];

  final List<Map<String, String>> _brandImages = [
    {'image': 'assets/images/brands/audi.png', 'carname': 'Audi'},
    {'image': 'assets/images/brands/bmw.png', 'carname': 'BMW'},
    {'image': 'assets/images/brands/honda.png', 'carname': 'Honda'},
    {'image': 'assets/images/brands/Kia.png', 'carname': 'Kia'},
    {'image': 'assets/images/brands/mahindraa.png', 'carname': 'Mahindra'},
    {'image': 'assets/images/brands/mbenz.png', 'carname': 'Mercedes-Benz'},
    {'image': 'assets/images/brands/mg.png', 'carname': 'MG'},
    {'image': 'assets/images/brands/suzuki.png', 'carname': 'Maruti'},
    //{'image': 'assets/images/brands/rnold.jpeg', 'carname': 'Renault'},
    {'image': 'assets/images/brands/tata.png', 'carname': 'Tata'},
    {'image': 'assets/images/brands/toyota.png', 'carname': 'Toyota'},
  ];

  final List<Map<String, String>> FeaturedInImages = [
    {'image': 'assets/images/fearturedin/ANI.png', 'carname': 'ANI News'},
    {
      'image': 'assets/images/fearturedin/BINN.png',
      'carname': 'British News Network'
    },
    {
      'image': 'assets/images/fearturedin/BNN.png',
      'carname': 'Big News Network'
    },
    {
      'image': 'assets/images/fearturedin/BS.png',
      'carname': 'Business Standards'
    },
    {
      'image': 'assets/images/fearturedin/FNT.png',
      'carname': 'France Network Times'
    },
    {
      'image': 'assets/images/fearturedin/INDNN.png',
      'carname': 'Indian News Network'
    },
    {'image': 'assets/images/fearturedin/LT.png', 'carname': 'Lokmat Times'},
    {'image': 'assets/images/fearturedin/MD.png', 'carname': 'MD'},
    {'image': 'assets/images/fearturedin/TP.png', 'carname': 'The Print'},
    {'image': 'assets/images/fearturedin/UPN.png', 'carname': 'UP42 News'},
    {
      'image': 'assets/images/fearturedin/WNN.png',
      'carname': 'World News Network'
    },
    {'image': 'assets/images/fearturedin/ZEE5.png', 'carname': 'ZEE5'},
  ];

  void _onScroll() {
    setState(() {
      indicatorPosition = _controller.offset;
    });
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  String selectedTab = 'Rent';

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          backgroundColor: darkBgColor,
          body: FutureBuilder<String>(
              future: value.getLocation(),
              builder: (context, snapshot) {
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: spinkit);
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    voucherFunction(value, context);
                  });
                  if (snapshot.data == null ||
                      snapshot.data!.isEmpty ||
                      snapshot.hasError) {
                    return NoLocationWidget();
                  }

                  //final list = [Colors.white, Colors.white];

                final list = [Color(0xff303030), Color(0xff303030)];

                  return DefaultTabController(
                    length: AppData.Categories.length,
                    child:  Scaffold(
                    backgroundColor: Colors.black,
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(80),
                      child: AppBar(
                        flexibleSpace: Container(
                          color: Colors.black,
                        ),
                        automaticallyImplyLeading: false,
                        titleSpacing: 0,
                        title: Row(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                height: 80,
                                width: 80,
                                'assets/images/guide/finallogo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                      endDrawer: Drawer(child: UserProfile()),

                      // Scaffold(
                    //   backgroundColor: Colors.black,
                    //   appBar: PreferredSize(
                    //     preferredSize: Size.fromHeight(80),
                    //     child: AppBar(
                    //       flexibleSpace: Container(
                    //         color: Colors.black,
                    //       ),
                    //       automaticallyImplyLeading: false,
                    //       titleSpacing: 0,
                    //       title: Row(
                    //         children: [
                    //           SizedBox(
                    //             height: 30,
                    //           ),
                    //           Container(
                    //             margin: const EdgeInsets.only(left: 20.0),
                    //             height: 100,
                    //             width: 100,
                    //             child: Image.asset(
                    //               height: 80,
                    //               width: 80,
                    //               'assets/images/guide/finallogo.png',
                    //               fit: BoxFit.contain,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    //   endDrawer: Drawer(child: UserProfile()),
                      body: SingleChildScrollView(
                        child: Container(
                          color: Colors.black,
                          child: Column(
                            children: [
//                               Container(
//                                 color: Colors.black,
//                                 child: Stack(
//                                   children: [
//                                     // ─── Background Video ─────────────────────────────────────────────
//                                     /*if (_videoController.value.isInitialized)
//                                                 SizedBox.expand(
//                                                   child: FittedBox(
//                                                     fit: BoxFit.cover,
//                                                     child: SizedBox(
//                                                       width: _videoController.value.size.width,
//                                                       height: _videoController.value.size.height,
//                                                       child: VideoPlayer(_videoController),
//                                                     ),
//                                                   ),
//                                                 )
//                                               else*/
//                                     Container(color: Colors.black),

//                                     SafeArea(
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 24, vertical: 16),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             // 1. Title + Subtitle
//                                             const Text('Your Ride. Your Way.',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 28,
//                                                   fontWeight: FontWeight.bold,
//                                                 )),
//                                             const SizedBox(height: 8),
//                                             const Text('Tap. Book. Drive.',
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 20,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             const SizedBox(height: 14),
//                                             const Text(
//                                                 'Self-drive rentals made seamless with Zymo.',
//                                                 style: TextStyle(
//                                                   color: Colors.white70,
//                                                   fontSize: 14,
//                                                 )),
//                                             const SizedBox(height: 36),

//                                             // 2. Smart badge
//                                             Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 6,
//                                                       horizontal: 12),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white24,
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: const Text(
//                                                   '✨ Smart rentals, easy driving ✨',
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w500)),
//                                             ),
//                                             const SizedBox(height: 24),

//                                             // 3. BOOK NOW tabs
//                                             const Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: 6, horizontal: 12),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceEvenly,
//                                                 children: [
//                                                   Text('────────',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold)),
//                                                   Text('BOOK NOW',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 18,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Colors.white,
//                                                           letterSpacing: 1.2)),
//                                                   Text('────────',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold)),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 'Rent',
//                                                 'Subscribe',
//                                                 'Buy'
//                                               ].map((label) {
//                                                 return GestureDetector(
//                                                   onTap: () {
//                                                     if (label == 'Rent') {
//                                                       setState(() {
//                                                         selectedTab = label;
//                                                         isSelfDrive = true;
//                                                       });
//                                                     } else if (label ==
//                                                         'Subscribe') {
//                                                       setState(() {
//                                                         selectedTab = label;
//                                                         isSelfDrive = false;
//                                                       });
//                                                     }
//                                                     // No action on 'Buy'
//                                                   },
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 12),
//                                                     child: Text(
//                                                       label,
//                                                       style: TextStyle(
//                                                         color: selectedTab ==
//                                                                 label
//                                                             ? Colors.white
//                                                             : Colors.white54,
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             selectedTab == label
//                                                                 ? FontWeight
//                                                                     .bold
//                                                                 : FontWeight
//                                                                     .normal,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                             const SizedBox(height: 24),
//                                             Container(
//                                               margin: EdgeInsets.symmetric(
//                                                   horizontal: 12),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.transparent,
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 border: Border.all(
//                                                     color: Colors.white54,
//                                                     width: 1.2),
//                                               ),
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 12,
//                                                       vertical: 14),
//                                               child: InkWell(
//                                                 child: Row(
//                                                   children: [
//                                                     Icon(
//                                                         Icons
//                                                             .location_on_outlined,
//                                                         color: Colors.white70),
//                                                     const SizedBox(width: 12),
//                                                     Expanded(
//                                                       child: Text(
//                                                           CommonFunctions
//                                                               .getLocation(
//                                                                   snapshot
//                                                                       .data!),
//                                                           style:
//                                                               const TextStyle(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize:
//                                                                       16)),
//                                                     ),
//                                                     const Icon(
//                                                         Icons.my_location),
//                                                   ],
//                                                 ),
//                                                 onTap: () async =>
//                                                     CommonFunctions.navigateTo(
//                                                         context,
//                                                         LocationPicker()),
//                                               ),
//                                             ),
//                                             /*Container(
//                                               color: Colors.white,
//                                               child: TextField(
//                                                 decoration: InputDecoration(
//                                                   iconColor: Colors.white,
//                                                   suffixIcon: Icon(Icons.location_on_outlined),
//                                                   hintText: CommonFunctions.getLocation(snapshot.data!),
//                                                 ),
//                                                 onTap: () async => CommonFunctions.navigateTo(context, LocationPicker()),
//                                               ),
//                                             )*/
// /*
//                                             // 4. Location field
//                                             /*_buildField(
//                                               icon: Icons.location_on_outlined,
//                                               hint: 'Enter a location',
//                                             ),
//                                             const SizedBox(height: 12),

//                                             // 5. Start date picker
//                                             _buildField(
//                                               icon: Icons.calendar_today_outlined,
//                                               hint: 'May 24, 2025, 12:30 PM',
//                                               filledColor: Colors.yellow.shade100,
//                                             ),
//                                             const SizedBox(height: 12),

//                                             // 6. End date picker
//                                             _buildField(
//                                               icon: Icons.calendar_today_outlined,
//                                               hint: 'Select End Date',
//                                             ),*/
//                                             const SizedBox(height: 12),

//                                             // 7. Trip Duration
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(horizontal: 12),
//                                               child: Container(
//                                                 width: double.infinity,
//                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey[800],
//                                                   borderRadius: BorderRadius.circular(12),
//                                                 ),
//                                                 child: const Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       'Trip Duration',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(fontSize: 16,color: Colors.white30, fontWeight: FontWeight.bold),
//                                                     ),
//                                                     Text(
//                                                       'Select both dates',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(fontSize: 20,color: Colors.white),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),

//                                             const SizedBox(height: 16),

//                                             // 8. SEARCH button
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(horizontal: 12),
//                                               child: SizedBox(
//                                                 width: double.infinity,
//                                                 child: ElevatedButton(
//                                                   style: ElevatedButton.styleFrom(
//                                                     foregroundColor: Colors.black,
//                                                     backgroundColor: Colors.yellow.shade100,
//                                                     padding: const EdgeInsets.symmetric(vertical: 16),
//                                                     textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                                   ),
//                                                   onPressed: () {
//                                                     // Your search logic
//                                                   },
//                                                   child: const Text('Search'),
//                                                 ),
//                                               ),
//                                             ),*/
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Stack(
//                                 children: [
//                                   /*Container(
//                                     height:
//                                     MediaQuery.of(context).size.height * .5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                             colors: gradientColors),
//                                         borderRadius: const BorderRadius.vertical(
//                                             bottom: Radius.circular(40))),
//                                   ),*/
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 20.0),
//                                     child: Column(
//                                       children: [
//                                         /*Padding(
//                                           padding: EdgeInsets.all(8),
//                                           child: bannerWidget(),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(12.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                             ),
//                                             padding: const EdgeInsets.all(8),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                                 15),
//                                                         gradient: LinearGradient(
//                                                             colors: isSelfDrive
//                                                                 ? gradientColors
//                                                                 : list)),
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         setState(() {
//                                                           isSelfDrive = true;
//                                                         });
//                                                       },
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets.all(
//                                                                 18.0),
//                                                         child: Text(
//                                                           'For Hours Or Days',
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: isSelfDrive
//                                                               ? whiteTitleStyle
//                                                               : titleStyle,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Expanded(
//                                                     child: Container(
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15),
//                                                       gradient: LinearGradient(
//                                                           colors: !isSelfDrive
//                                                               ? gradientColors
//                                                               : list)),
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         isSelfDrive = false;
//                                                       });
//                                                     },
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               18.0),
//                                                       child: Text(
//                                                         'Monthly Rental',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: !isSelfDrive
//                                                             ? whiteTitleStyle
//                                                             : titleStyle,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),*/
//                                         Consumer<CarProvider>(
//                                             builder: (BuildContext context,
//                                                     value, Widget? child) =>
//                                                 Column(children: [
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 0.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Card(
//                                                           color: Colors
//                                                               .transparent,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(0.0),
//                                                             child:
//                                                                 AnimatedSwitcher(
//                                                               duration:
//                                                                   const Duration(
//                                                                       milliseconds:
//                                                                           480),
//                                                               child:
//                                                                   KeyedSubtree(
//                                                                 key: ValueKey<
//                                                                         bool>(
//                                                                     isSelfDrive),
//                                                                 child: isSelfDrive
//                                                                     ? durationPicker(
//                                                                         context,
//                                                                         value)
//                                                                     : atDurationPicker(
//                                                                         context,
//                                                                         value),
//                                                               ),
//                                                               transitionBuilder:
//                                                                   (child,
//                                                                       animation) {
//                                                                 return FadeTransition(
//                                                                     opacity:
//                                                                         animation,
//                                                                     child:
//                                                                         child);
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           height: .01.sh,
//                                                         ),
//                                                         TripDurationWidget(
//                                                             duration: isSelfDrive
//                                                                 ? value
//                                                                     .getTripDuration()
//                                                                 : "30 Days"),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: .02.sh,
//                                                   ),
//                                                   SizedBox(
//                                                       height: .06.sh,
//                                                       child: value.isLoading
//                                                           ? spinkit
//                                                           : Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           8.0),
//                                                               child: AppButton(
//                                                                   color:
//                                                                       accentColor,
//                                                                   textSize: 20,
//                                                                   title: 'Search'
//                                                                       .toUpperCase(),
//                                                                   screenHeight:
//                                                                       1.sh,
//                                                                   function: () => isSelfDrive
//                                                                       ? CarFunctions()
//                                                                           .selfDriveNavigate(
//                                                                               context)
//                                                                       : CarFunctions()
//                                                                           .monthlyRentalNavigate(
//                                                                               context)),
//                                                             )),
//                                                   SizedBox(
//                                                     height: .01.sh,
//                                                   ),
//                                                   RecentSearches(
//                                                       provider: value)
//                                                 ])),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
                          Stack(
                            children: [
                              // Banner widget
                              Container(
                                height: Dimensions.screenHeight(context) * 0.5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/HeroImages/hero_car.jpg'),
                                      fit: BoxFit.cover
                                  ),
                                    // gradient:
                                    //     LinearGradient(colors: gradientColors),
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(40))),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      // child: bannerWidget(),
                                      child: Container(
                                        color: const Color.fromARGB(132, 0, 0, 0),
                                        height: Dimensions.screenHeight(context)* 0.3,
                                        width: Dimensions.screenWidth(context)* 0.8,
                                        child: Expanded(child:
                                        Center(
                                          child: Text(
                                            'Your Ride. Your Way. Tap. Book. Drive.',
                                            style: bigTitleStyle.copyWith(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: index == 0
                                                      ? accentColor
                                                      : list[0],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      index = 0;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      'Rent',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: index == 0
                                                          ? titleStyle
                                                          : whiteTitleStyle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: index == 1
                                                      ? accentColor
                                                      : list[0],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      index = 1;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: FittedBox(
                                                      child: Text(
                                                        'Subscribe',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: index == 1
                                                            // ? whiteTitleStyle
                                                            // : titleStyle,
                                                                                                                      ? titleStyle
                                                          : whiteTitleStyle,

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: index == 2
                                                          ? accentColor
                                                          : list[0],
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          index = 2;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            FittedBox(
                                                              child: Text(
                                                                'Buy',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: index ==
                                                                        2
                                                                    // ? whiteTitleStyle
                                                                    // : titleStyle,
                                                                                                                              ? titleStyle
                                                          : whiteTitleStyle,

                                                              ),
                                                            ),
                                                            // Positioned(
                                                            //   top: -10,
                                                            //   right: 0,
                                                            //   child: Container(
                                                            //     padding: EdgeInsets
                                                            //         .symmetric(
                                                            //       horizontal: 8,
                                                            //       vertical: 4,
                                                            //     ),
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //       color: Color
                                                            //           .fromARGB(
                                                            //               255,
                                                            //               230,
                                                            //               12,
                                                            //               12),
                                                            //       borderRadius:
                                                            //           BorderRadius
                                                            //               .circular(
                                                            //                   10),
                                                            //     ),
                                                            //     child: Text(
                                                            //       'Coming Soon',
                                                            //       style:
                                                            //           TextStyle(
                                                            //         fontSize: 8,
                                                            //         fontWeight:
                                                            //             FontWeight
                                                            //                 .w800,
                                                            //         color: Colors
                                                            //             .white,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Consumer<CarProvider>(
                                      builder: (BuildContext context, value,
                                              Widget? child) =>
                                          Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              children: [
                                                // SizedBox(
                                                //   height: .01.sh,
                                                // ),
                                                // PickLocationWidget(),
                                                Card(
                                                  color: const Color.fromARGB(255, 52, 52, 52),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: AnimatedSwitcher(
                                                      duration: Duration(
                                                          milliseconds: 480),
                                                      child: KeyedSubtree(
                                                        key: ValueKey<bool>(
                                                            index == 0),
                                                        child: index == 0
                                                            ? durationPicker(
                                                                context, value)
                                                            : index == 1
                                                                ? atDurationPicker(
                                                                    context,
                                                                    value)
                                                                : ShowBuyOption(),
                                                      ),
                                                      transitionBuilder:
                                                          (child, animation) {
                                                        return FadeTransition(
                                                            opacity: animation,
                                                            child: child);
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: .01.sh,
                                                ),
                                                index == 2
                                                    ? Container()
                                                    : TripDurationWidget(
                                                        duration: index == 0
                                                            ? value
                                                                .getTripDuration()
                                                            : "30 Days",
                                                      ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: .02.sh,
                                          ),
                                          index == 2
                                              ? Container()
                                              : SizedBox(
                                                  height: .06.sh,
                                                  child: value.isLoading
                                                      ? spinkit
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: AppButton(
                                                            color: accentColor,
                                                            textSize: 20,
                                                            title: 'Search'
                                                                .toUpperCase(),
                                                            // screenWidth: screenWidth * 1.8,
                                                            screenHeight: 1.sh,
                                                            function: () => index ==
                                                                    0
                                                                ? CarFunctions()
                                                                    .selfDriveNavigate(
                                                                    context,
                                                                  )
                                                                : CarFunctions()
                                                                    .monthlyRentalNavigate(
                                                                    context,
                                                                  ),
                                                          ),
                                                        ),
                                                ),
                                          index == 2
                                              ? Container()
                                              : SizedBox(
                                                  height: .01.sh,
                                                ),
                                          index == 2
                                              ? Container()
                                              : RecentSearches(provider: value)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                              SizedBox(
                                height: .01.sh,
                              ),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                /*
                                decoration: BoxDecoration(
                                    gradient:
                                    LinearGradient(colors: gradientColors)),*/
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 40),
                                      margin: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3A3A3A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            FeatureItem(
                                              icon: Icons.touch_app,
                                              text: 'Compare and Choose',
                                            ),
                                            SizedBox(height: 40),
                                            FeatureItem(
                                              icon: Icons.directions_car,
                                              text: 'Flexible Options',
                                            ),
                                            SizedBox(height: 40),
                                            FeatureItem(
                                              icon:
                                                  Icons.account_balance_wallet,
                                              text: 'Easy to Use',
                                            ),
                                            SizedBox(height: 40),
                                            FeatureItem(
                                                icon: Icons.local_shipping,
                                                text:
                                                    'Self PickUp Or Get it Delivered'),
                                            SizedBox(height: 40),
                                            FeatureItem(
                                                icon: Icons.location_on,
                                                text:
                                                    '2000+ Locations in 59 Cities'),
                                            SizedBox(height: 40),
                                            FeatureItem(
                                                icon: Icons.check_box_outlined,
                                                text:
                                                    'Select from Limited Or Unlimited Kms Packages'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: .01.sh,
                                    ),
                                    CarouselSlider(
                                        items: List.generate(
                                            2,
                                            (index) => Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  elevation: 5,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image.asset(
                                                      "assets/icons/HomeIcons/hero_img_${index + 1}.jpg",
                                                    ),
                                                  ),
                                                )),
                                        options: CarouselOptions(
                                          aspectRatio: 16 / 10,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          viewportFraction: 1,
                                          enlargeFactor: .5,
                                          enlargeCenterPage: true,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: .01.sh,
                              ),
                              /*InkWell(
                                onTap: () => CommonFunctions.navigateTo(
                                    context, ReferralScreen()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              "https://zymo.app/Imgs/img20.jpg"),
                                    ),
                                  ),
                                ),
                              ),*/
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        "Zymo Benefits".toUpperCase(),
                                        style: bigTitleStyle.copyWith(
                                            color: accentColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ...items
                                        .map((item) => Column(
                                              children: [
                                                BenefitBox(
                                                  imagePath: item['image']!,
                                                  text: item['text']!,
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ))
                                        .toList(),
                                    /*GridView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: .9,
                                              mainAxisSpacing: 1,
                                              crossAxisSpacing: 1),
                                      children: items.map((String imagePath) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Image.asset(
                                              imagePath,
                                              fit: BoxFit.contain,
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),*/
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 500,
                                    // Minimum height to prevent overflow
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.75, // Maximum height
                                    maxWidth: 350, //
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Left Timeline with Indicator
                                      SizedBox(
                                        height: double.infinity,
                                        // Take available height
                                        width: 60,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            // Full height grey background line
                                            Positioned.fill(
                                              child: Center(
                                                child: Container(
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[700],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Yellow progress line
                                            Positioned(
                                              top: 0,
                                              bottom: (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.75) -
                                                  (indicatorPosition / 3.15) -
                                                  6,
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: Container(
                                                  width: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(12),
                                                      bottom: Radius.zero,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Scroll dot with proper positioning
                                            Positioned(
                                              top: (indicatorPosition / 3.15) -
                                                  6,
                                              left: 24,
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    strokeAlign: BorderSide
                                                        .strokeAlignOutside,
                                                    color: Colors.yellow,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// Right Content
                                      Expanded(
                                        child: SizedBox(
                                          height: double.infinity,
                                          // Take available height
                                          child: SingleChildScrollView(
                                            controller: _controller,
                                            child: Column(
                                              children: steps.map((step) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 46.0,
                                                          right: 16.0,
                                                          left: 16.0,
                                                          bottom: 20.0),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                          step.imagePath),
                                                      const SizedBox(
                                                          height: 12),
                                                      Text(
                                                        step.title,
                                                        style: const TextStyle(
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        step.description,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 42,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Brands Available'.toUpperCase(),
                                  style: bigTitleStyle.copyWith(
                                      color: accentColor),
                                ),
                              ),
                              BrandImagesWidget(
                                brandImages: _brandImages,
                                reverse: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Featured In'.toUpperCase(),
                                  style: bigTitleStyle.copyWith(
                                      color: accentColor),
                                ),
                              ),
                              BrandImagesWidget(
                                brandImages: FeaturedInImages,
                                reverse: true,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                  child: Text("CONNECT WITH US",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: accentColor)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                      icon:
                                          const Icon(FontAwesomeIcons.facebook),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            'https://www.facebook.com/LetzRent.official/'));
                                      }),
                                  IconButton(
                                      icon: const Icon(
                                          FontAwesomeIcons.instagram),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            'https://www.instagram.com/zymo.app'));
                                      }),
                                  IconButton(
                                      icon:
                                          const Icon(FontAwesomeIcons.linkedin),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            'https://www.linkedin.com/company/letzrent/'));
                                      }),
                                  IconButton(
                                      icon:
                                          const Icon(FontAwesomeIcons.twitter),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            'https://twitter.com/zymoapp'));
                                      }),
                                  IconButton(
                                      icon:
                                          const Icon(FontAwesomeIcons.youtube),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            'https://www.youtube.com/channel/UCHUvrPwNYxw7bukWFjhNpag'));
                                      })
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
        );
      },
    );
  }
}

class BrandImagesWidget extends StatefulWidget {
  final List<Map<String, String>> brandImages;
  final bool reverse;

  const BrandImagesWidget(
      {Key? key, required this.brandImages, required this.reverse})
      : super(key: key);

  @override
  _BrandImagesWidgetState createState() => _BrandImagesWidgetState();
}

class _BrandImagesWidgetState extends State<BrandImagesWidget> {
  final ScrollController _scrollController = ScrollController();
  late Timer _autoScrollTimer;
  final double _scrollSpeed = 50.0; // pixels per second

  @override
  void initState() {
    super.initState();
    // start auto scrolling
    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        final delta = _scrollSpeed * 0.05;
        // direction: forward = positive, reverse = negative
        final direction = widget.reverse ? -1 : 1;
        double target = current + delta * direction;

        if (direction > 0 && target >= maxScroll) {
          target = 0;
        } else if (direction < 0 && target <= 0) {
          target = maxScroll;
        }

        _scrollController.jumpTo(target);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.reverse ? 200 : 150,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.brandImages.length,
        itemBuilder: (context, index) {
          final item = widget.brandImages[index];
          final imagePath = item['image']!;
          final titleText = item['carname']!;
          final imageWidget = Image.asset(
            imagePath,
            fit: BoxFit.contain,
          );

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: widget.reverse
                  ? Column(
                      children: [
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageWidget,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Text(
                            titleText,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageWidget,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Text(
                            titleText,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ));
        },
      ),
    );
  }
}

Future<void> voucherFunction(
  HomeProvider value,
  BuildContext context,
) async {
  await Future.delayed(twoSeconds);
  if (value.isReferral) {
    voucherPopUp(context, 'Congrats!',
        'You have won a voucher worth $rupeeSign$referralAmount!$happyEmoji$happyEmoji$happyEmoji Refer more to get more.');
    value.isReferralFunction(false);
  } else if (value.isNewUser) {
    voucherPopUp(context, 'Congrats!',
        'You have won a voucher!$happyEmoji$happyEmoji$happyEmoji Rent more to get more.');
    value.isNewUserFunction(false);
  }
}

/*Widget bannerWidget() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: SizedBox(
      height: 0.3.sh,
      width: 1.sw,
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseServices().getBanner(),
        builder: (context, futureSnapshot) {
          if (!futureSnapshot.hasData) {
            return const Center(child: spinkit);
          } else {
            try {
              // Fetch the dynamic list from Firebase
              final List<dynamic> dynamicList =
                  futureSnapshot.data!.data()?['imageList'];

              // Convert List<dynamic> to List<Map<String, String>>
              final List<Map<String, String>> imageList =
                  dynamicList.map((item) {
                // Cast each item to Map<String, dynamic> and convert values to String
                return (item as Map<String, dynamic>).map((key, value) {
                  return MapEntry(key, value.toString());
                });
              }).toList();

              // Pass the converted list to BannerWidget
              return BannerWidget(images: imageList);
            } catch (e) {
              // Handle errors gracefully
              return Center(child: Text('Error loading banner: $e'));
            }
          }
        },
      ),
    ),
  );
}*/

InkWell profilePictureWidget(BuildContext context, User user) {
  return InkWell(
    onTap: () =>
        //       Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserProfile())),
    child: CircleAvatar(
        backgroundColor: darkBgColor,
        child: user.photoURL != null
            ? CachedNetworkImage(
                imageUrl: user.photoURL.toString(),
              )
            : const Icon(
                Icons.person,
                color: accentColor,
              )),
  );
}

/*class GrowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  const GrowTile({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15),
            // gradient: LinearGradient(colors: gradientColors)
            ),
        child: Image.asset("assets/icons/HomeIcons/1.png"));
  }
}*/

class NoUserError extends StatelessWidget {
  final Function() onLogin;
  final String message;

  const NoUserError({
    super.key,
    required this.message,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: bigTitleStyle,
          ),
          SizedBox(
            height: 10,
          ),
          AppButton(
            screenWidth: .7.sw,
            screenHeight: .7.sh,
            title: 'Log in',
            function: () async {
              await CommonFunctions.navigateToSignIn(context);
              onLogin();
            },
            textSize: 20,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

class NoLocationWidget extends StatelessWidget {
  const NoLocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome, ${Auth().getCurrentUser()?.displayName ?? ''}',
              style: bigTitleStyle),
          const SizedBox(height: 15),
          const Text(
            'Please select your location to continue.',
            style: TextStyle(fontSize: 19),
          ),
          const SizedBox(height: 50),
          PickLocationWidget(),
          SizedBox(height: .1.sh),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseServices().getCategory(title),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return spinkit;
        } else {
          final Map<String, dynamic>? data = snapshot.data?.data();
          final List images = data?['images'] ?? [];
          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(context).pushNamed(title),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          // Add the borderRadius here if needed
                          // borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => spinkit,
                          width: 0.4.sw,
                          fit: BoxFit.contain,
                          imageUrl: images[index],
                        ),
                      ),
                    ),
                  ),
                  itemCount: images.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 24,
                  child: FloatingActionButton(
                    onPressed: () => Navigator.of(context).pushNamed(title),
                    child: const Icon(Icons.arrow_right_alt),
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
class ShowBuyOption extends StatefulWidget {
  const ShowBuyOption({Key? key}) : super(key: key);

  @override
  State<ShowBuyOption> createState() => _ShowBuyOptionState();
}

class _ShowBuyOptionState extends State<ShowBuyOption> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => TataNexonCars()),
              // );
            },
            // child: BuyOptionConatiner(
            //   desc: AppData.buyOptions[0]['description']!,
            //   imageUrl: AppData.buyOptions[0]['imageUrl']!,
            //   title: AppData.buyOptions[0]['title']!,
            // ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            // child: BuyOptionConatiner(
            //   desc: AppData.buyOptions[1]['description']!,
            //   imageUrl: AppData.buyOptions[1]['imageUrl']!,
            //   title: AppData.buyOptions[1]['title']!,
            // ),
          ),
        ),
      ],
    );
  }
}

class BuyOptionConatiner extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String desc;
  const BuyOptionConatiner(
      {required this.desc,
        required this.imageUrl,
        required this.title,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 200,
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 160,
              child: Image(
                image: AssetImage(imageUrl),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: contentStyle.copyWith(fontSize: 12),
                        ),
                        // Text(
                        //   desc,
                        //   style: contentStyle.copyWith(fontSize: 9),
                        // )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: accentColor,
                    size: 20,
                  )
                ],
              ),
            ),
            Center(
              child: Text(
                'Coming Soon!',
                style: contentStyle.copyWith(fontSize: 12, color: accentColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
class BrandImagesWidget extends StatelessWidget {
  const BrandImagesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .19.sh,
      width: 1.sw,
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: gradientColors)),
      child: FutureBuilder(
          future: FirebaseServices().getBrands(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return spinkit;
            } else {
              final List images = snapshot.data?['images'] ?? [];

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
                  child: Container(
                    width: .14.sh,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(imageUrl: images[index]),
                    ),
                  ),
                ),
                itemCount: images.length,
              );
            }
          }),
    );
  }
}
*/

/*
class BannerWidget extends StatelessWidget {
  final List<Map<String, String>> images;

  const BannerWidget({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        // Full width
        enableInfiniteScroll: true,
      ),
      items: images.map((e) {
        return InkWell(
          onTap: () {
            final path = e['path'] ?? '';
            if (path.isNotEmpty) {
              switch (path) {
                case '/at':
                  Navigator.pushNamed(context, '/cd', arguments: {'mode': 0});
                  break;
                case '/os':
                  Navigator.pushNamed(context, '/cd');
                  break;
                case '/wc':
                  Navigator.pushNamed(context, '/cd', arguments: {'mode': 2});
                  break;
                default:
                  Navigator.pushNamed(context, path);
                  break;
              }
            }
          },
          child: CachedNetworkImage(
            imageUrl: e['imageUrl'] ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      }).toList(),
    );
  }
}
*/
