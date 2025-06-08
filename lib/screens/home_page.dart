// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider_plus/carousel_slider_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:letzrentnew/Services/auth_services.dart';
// import 'package:letzrentnew/Services/firebase_services.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/location_picker.dart';
// import 'package:letzrentnew/Utils/widgets.dart';
// import 'package:letzrentnew/models/brand_model.dart';
// import 'package:letzrentnew/models/topcars_model.dart';
// import 'package:letzrentnew/providers/car_provider.dart';
// import 'package:letzrentnew/providers/home_provider.dart';
// import 'package:letzrentnew/screens/NewCars/new_cars_buy.dart';
// import 'package:letzrentnew/screens/referral_screen.dart';
// import 'package:letzrentnew/screens/view_more_brands.dart';
// import 'package:letzrentnew/widgets/Cars/self_drive.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../Services/car_functions.dart';
// import '../Utils/functions.dart';
// import '../Utils/constants.dart';
// import '../screens/user_profile.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   static const itemss = [
//     "assets/images/ZymoBenefits/Convenience.jpg",
//     "assets/images/ZymoBenefits/CostEffective.jpg",
//     "assets/images/ZymoBenefits/Flexibility.jpg",
//     "assets/images/ZymoBenefits/GreatPrices.jpg",
//   ];
//   List<TopCarsModel> topcars = [
//     TopCarsModel(
//         imageUrl: 'assets/images/NewCars/sedan.png',
//         title: 'Top Sedans in India',
//         description: 'Hyundai Verna, Volkswagen Virtus'),
//     TopCarsModel(
//         imageUrl: 'assets/images/NewCars/suv.png',
//         title: 'Top SUVs in India',
//         description: 'Toyota Urban, Cruiser Taisor, Mahindra Scorpion'),
//     TopCarsModel(
//         imageUrl: 'assets/images/NewCars/hatchback.png',
//         title: 'Top Hatchbacks in India',
//         description: 'Tata Altroz, Maruti Suzuki Baleno'),
//     TopCarsModel(
//         imageUrl: 'assets/images/NewCars/luxury.png',
//         title: 'Top Luxury Cars in India',
//         description: 'Mercedes-Benz A-Class, Limousine, Skoda Superb'),
//   ];

//   int index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeProvider>(
//         builder: (BuildContext context, value, Widget? child) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: FutureBuilder<String?>(
//             future: value.getLocation(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData &&
//                   snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: spinkit);
//               } else {
//                 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                   voucherFunction(value, context);
//                 });
//                 if (snapshot.data == null ||
//                     snapshot.data!.isEmpty ||
//                     snapshot.hasError) {
//                   return NoLocationWidget();
//                 }

//                 final list = [Color(0xff303030), Color(0xff303030)];
//                 return DefaultTabController(
//                   length: AppData.Categories.length,
//                   child: Scaffold(
//                     backgroundColor: Colors.black,
//                     appBar: AppBar(
//                       toolbarHeight: 67.5,
//                       // bottom: PreferredSize.,
//                       flexibleSpace: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[850],
//                           // gradient: LinearGradient(colors: gradientColors),
//                         ),
//                       ),
//                       leading: Builder(
//                         builder: (context) => GestureDetector(
//                           onTap: () {
//                             Scaffold.of(context)
//                                 .openDrawer(); // Opens the drawer
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.fromLTRB(
//                                 6, 12, 6, 12), // Adjust spacing
//                             decoration: BoxDecoration(
//                               color: Colors.grey[900],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(Icons.menu,
//                                 color: Colors.white), // Drawer icon
//                           ),
//                         ),
//                       ),
//                       actions: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 6, 16, 0),
//                           child: InkWell(
//                             onTap: () async => CommonFunctions.navigateTo(
//                                 context, LocationPicker()),
//                             child: SizedBox(
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[900],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.location_pin,
//                                           color: Color(0xFFDEFF63),
//                                           size: 18,
//                                         ),
//                                         Text(
//                                           'Location',
//                                           maxLines: 1,
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 3,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         CommonFunctions.getCityFromLocation(
//                                             snapshot.data!),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     drawer: Drawer(child: UserProfile()),
//                     body: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 26,
//                             decoration: BoxDecoration(
//                               // gradient: LinearGradient(colors: gradientColors),
//                               color: Colors.grey[850],
//                             ),
//                           ),

//                           // const Padding(
//                           //   padding: EdgeInsets.all(12.0),
//                           //   child: Text('Trending Rentals', style: headingStyle),
//                           // ),
//                           // TabBar(
//                           //     indicatorColor: Colors.black,
//                           //     indicatorSize: TabBarIndicatorSize.label,
//                           //     isScrollable: true,
//                           //     tabs: AppData.Categories.map((e) => Tab(
//                           //           text: e,
//                           //         )).toList()),
//                           // SizedBox(
//                           //   width: 1.sw,
//                           //   height: .28.sh,
//                           //   child: TabBarView(
//                           //       children:
//                           //           AppData.Categories.map((e) => CategoryWidget(
//                           //                 title: e,
//                           //               )).toList()),
//                           // ),
//                           Stack(
//                             children: [
//                               // Banner widget
//                               Container(
//                                 height: MediaQuery.of(context).size.height * .5,
//                                 decoration: BoxDecoration(
//                                     // gradient:
//                                     //     LinearGradient(colors: gradientColors),
//                                     color: Colors.grey[850],
//                                     borderRadius: BorderRadius.vertical(
//                                         bottom: Radius.circular(40))),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20.0),
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.all(8),
//                                       child: bannerWidget(),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(12.0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.black,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ),
//                                         padding: EdgeInsets.all(8),
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                   color: index == 0
//                                                       ? appColor
//                                                       : list[0],
//                                                 ),
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       index = 0;
//                                                     });
//                                                   },
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             12.0),
//                                                     child: Text(
//                                                       'Rent',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: index == 0
//                                                           ? whiteTitleStyle
//                                                           : titleStyle,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Expanded(
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                   color: index == 1
//                                                       ? appColor
//                                                       : list[0],
//                                                 ),
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       index = 1;
//                                                     });
//                                                   },
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             12.0),
//                                                     child: FittedBox(
//                                                       child: Text(
//                                                         'Subscribe',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: index == 1
//                                                             ? whiteTitleStyle
//                                                             : titleStyle,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Expanded(
//                                               child: Stack(
//                                                 children: [
//                                                   Container(
//                                                     width: 150,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15),
//                                                       color: index == 2
//                                                           ? appColor
//                                                           : list[0],
//                                                     ),
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         setState(() {
//                                                           index = 2;
//                                                         });
//                                                       },
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(12.0),
//                                                         child: Stack(
//                                                           alignment:
//                                                               Alignment.center,
//                                                           children: [
//                                                             FittedBox(
//                                                               child: Text(
//                                                                 'Buy',
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                                 style: index ==
//                                                                         2
//                                                                     ? whiteTitleStyle
//                                                                     : titleStyle,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Consumer<CarProvider>(
//                                       builder: (BuildContext context, value,
//                                               Widget? child) =>
//                                           Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             child: Column(
//                                               children: [
//                                                 Card(
//                                                   color: darkGrey,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                   ),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: AnimatedSwitcher(
//                                                       duration: Duration(
//                                                           milliseconds: 480),
//                                                       child: KeyedSubtree(
//                                                         key: ValueKey<bool>(
//                                                             index == 0),
//                                                         child: index == 0
//                                                             ? durationPicker(
//                                                                 context, value)
//                                                             : index == 1
//                                                                 ? atDurationPicker(
//                                                                     context,
//                                                                     value)
//                                                                 : ShowBuyOption(),
//                                                       ),
//                                                       transitionBuilder:
//                                                           (child, animation) {
//                                                         return FadeTransition(
//                                                             opacity: animation,
//                                                             child: child);
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ),

//                                                 SizedBox(
//                                                   height: .01.sh,
//                                                 ),
//                                                 index == 2
//                                                     ? Container()
//                                                     : TripDurationWidget(
//                                                         duration: index == 0
//                                                             ? value
//                                                                 .getTripDuration()
//                                                             : "30 Days",
//                                                       ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: .02.sh,
//                                           ),
//                                           index == 2
//                                               ? Container()
//                                               : SizedBox(
//                                                   height: .06.sh,
//                                                   child: value.isLoading
//                                                       ? spinkit
//                                                       : Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                       8.0),
//                                                           child: AppButton(
//                                                             color: appColor,
//                                                             textSize: 20,
//                                                             title: 'Search'
//                                                                 .toUpperCase(),
//                                                             // screenWidth: screenWidth * 1.8,
//                                                             screenHeight: 1.sh,
//                                                             function: () => index ==
//                                                                     0
//                                                                 ? CarFunctions
//                                                                     .selfDriveNavigate(
//                                                                     context,
//                                                                   )
//                                                                 : CarFunctions()
//                                                                     .monthlyRentalNavigate(
//                                                                     context,
//                                                                   ),
//                                                           ),
//                                                         ),
//                                                 ),
//                                           index == 2
//                                               ? Container()
//                                               : SizedBox(
//                                                   height: .01.sh,
//                                                 ),
//                                           index == 2
//                                               ? Container()
//                                               : RecentSearches(provider: value)
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: .01.sh,
//                           ),
//                           Text(
//                             'Brands Available',
//                             style: bigWhiteTitleStyle.copyWith(
//                               color: appColor,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(
//                             height: .01.sh,
//                           ),
//                           ShowBrands(),
//                           SizedBox(
//                             height: .005.sh,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showModalBottomSheet(
//                                 backgroundColor: Colors.black,
//                                 context: context,
//                                 isScrollControlled: true,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.vertical(
//                                     top: Radius.circular(
//                                         0), // Remove rounded corners (optional)
//                                   ),
//                                 ),
//                                 elevation: 0, // Remove shadow elevation
//                                 barrierColor: Colors.black.withOpacity(0.7),
//                                 builder: (BuildContext context) {
//                                   return SingleChildScrollView(
//                                     child: Container(
//                                       color: Colors.black,
//                                       padding: EdgeInsets.all(0),
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.7,
//                                       child: ViewMoreBrands(),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             child: Container(
//                               margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
//                               alignment: Alignment.bottomRight,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     'View More',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w800,
//                                       color: appColor,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 2,
//                                   ),
//                                   Icon(
//                                     Icons.arrow_forward,
//                                     color: appColor,
//                                     size: 16,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: .02.sh,
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(12.0),
//                             decoration: BoxDecoration(
//                               color: appColor, // Outer container color
//                             ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: double.infinity / 8,

//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[850],
//                                     borderRadius: BorderRadius.vertical(
//                                       top: Radius.circular(15),
//                                       bottom: Radius.circular(15),
//                                     ),
//                                   ), // Inner grey container
//                                   padding: EdgeInsets.all(12.0),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         'Why $appName?',
//                                         style: bigTitleStyle.copyWith(
//                                             color: Colors.white),
//                                       ),
//                                       SizedBox(height: .01.sh),
//                                       CarouselSlider(
//                                         items: List.generate(
//                                           4,
//                                           (index) => Card(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                             ),
//                                             elevation: 5,
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                               child: Image.asset(
//                                                 "assets/icons/HomeIcons/${index + 1}.png",
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         options: CarouselOptions(
//                                           aspectRatio: 16 / 10,
//                                           autoPlay: true,
//                                           viewportFraction: 1,
//                                           enlargeFactor: .5,
//                                           enlargeCenterPage: true,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 12,
//                           ),
//                           Text(
//                             'Top Cars in India',
//                             style: bigTitleStyle.copyWith(
//                               color: appColor,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(
//                             height: 12,
//                           ),
//                           CarouselSlider(
//                             items: List.generate(
//                               topcars.length,
//                               (index) => Card(
//                                 elevation: 5,
//                                 child: Container(
//                                   height: 400, // Increased height
//                                   width: 370,
//                                   decoration: BoxDecoration(
//                                     color: darkGrey,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(16.0),
//                                         child: Container(
//                                           height:
//                                               230, // Adjusted image container height
//                                           width: 370,
//                                           decoration: BoxDecoration(
//                                             color: appColor,
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(10),
//                                               topRight: Radius.circular(10),
//                                             ),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(10),
//                                               topRight: Radius.circular(10),
//                                             ),
//                                             child: Image.asset(
//                                               topcars[index].imageUrl,
//                                               fit: BoxFit.fill,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           width: 370,
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 16, vertical: 12),
//                                           child: SingleChildScrollView(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   topcars[index].title,
//                                                   style: contentStyle.copyWith(
//                                                     color: Colors.white,
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 8),
//                                                 Text(
//                                                   topcars[index].description,
//                                                   style: contentStyle.copyWith(
//                                                     color: Colors.white,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             options: CarouselOptions(
//                               autoPlay: true,
//                               viewportFraction: 1,
//                               height:
//                                   360, // Added explicit height for CarouselSlider
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             color: Colors.black,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 12.0),
//                                   child: Text(
//                                     "Zymo Benefits",
//                                     style:
//                                         bigTitleStyle.copyWith(color: appColor),
//                                   ),
//                                 ),
//                                 GridView(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2,
//                                           childAspectRatio: .9,
//                                           mainAxisSpacing: 1,
//                                           crossAxisSpacing: 1),
//                                   children: itemss.map((String imagePath) {
//                                     return Builder(
//                                       builder: (BuildContext context) {
//                                         return Image.asset(
//                                           imagePath,
//                                           fit: BoxFit.contain,
//                                         );
//                                       },
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 12,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(12.0),
//                             child: Text(
//                               'Service Providers',
//                               style: bigTitleStyle.copyWith(
//                                 color: appColor,
//                                 fontSize: 28,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           BrandImagesWidget(),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8.0),
//                             child: Center(
//                               child: Text("Connect with us",
//                                   style:
//                                       bigTitleStyle.copyWith(color: appColor)),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               IconButton(
//                                   icon: const Icon(FontAwesomeIcons.facebook),
//                                   onPressed: () {
//                                     launchUrl(Uri.parse(
//                                         'https://www.facebook.com/LetzRent.official/'));
//                                   }),
//                               IconButton(
//                                   icon: const Icon(FontAwesomeIcons.instagram),
//                                   onPressed: () {
//                                     launchUrl(Uri.parse(
//                                         'https://www.instagram.com/zymo.app'));
//                                   }),
//                               IconButton(
//                                   icon: const Icon(FontAwesomeIcons.linkedin),
//                                   onPressed: () {
//                                     launchUrl(Uri.parse(
//                                         'https://www.linkedin.com/company/letzrent/'));
//                                   }),
//                               IconButton(
//                                   icon: const Icon(FontAwesomeIcons.twitter),
//                                   onPressed: () {
//                                     launchUrl(Uri.parse(
//                                         'https://twitter.com/zymoapp'));
//                                   }),
//                               IconButton(
//                                   icon: const Icon(FontAwesomeIcons.youtube),
//                                   onPressed: () {
//                                     launchUrl(Uri.parse(
//                                         'https://www.youtube.com/channel/UCHUvrPwNYxw7bukWFjhNpag'));
//                                   })
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 12,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             }),
//       );
//     });
//   }

//   Future<void> voucherFunction(
//     HomeProvider value,
//     BuildContext context,
//   ) async {
//     await Future.delayed(twoSeconds);
//     if (value.isReferral) {
//       voucherPopUp(context, 'Congrats!',
//           'You have won a voucher worth $rupeeSign$referralAmount!$happyEmoji$happyEmoji$happyEmoji Refer more to get more.');
//       value.isReferralFunction(false);
//     } else if (value.isNewUser) {
//       voucherPopUp(context, 'Congrats!',
//           'You have won a voucher!$happyEmoji$happyEmoji$happyEmoji Rent more to get more.');
//       value.isNewUserFunction(false);
//     }
//   }

//   Widget bannerWidget() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(15),
//       child: SizedBox(
//           height: 0.3.sh,
//           width: 1.sw,
//           child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//               future: FirebaseServices().getBanner(),
//               builder: (context, futureSnapshot) {
//                 if (!futureSnapshot.hasData) {
//                   return const Center(child: spinkit);
//                 } else {
//                   return BannerWidget(
//                       images: futureSnapshot.data!.data()!['imageList']);
//                 }
//               })),
//     );
//   }

//   InkWell profilePictureWidget(BuildContext context, User user) {
//     return InkWell(
//       onTap: () =>
//           //       Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
//           Navigator.of(context)
//               .push(MaterialPageRoute(builder: (context) => UserProfile())),
//       child: CircleAvatar(
//         backgroundColor: greyColor,
//         child: user.photoURL != null
//             ? CachedNetworkImage(
//                 imageUrl: user.photoURL!,
//               )
//             : const Icon(
//                 Icons.person,
//                 color: appColor,
//               ),
//       ),
//     );
//   }
// }

// class GrowTile extends StatelessWidget {
//   final IconData? icon;
//   final String? title;
//   final String? body;
//   final Color? color;
//   const GrowTile({
//     Key? key,
//     this.icon,
//     this.title,
//     this.body,
//     this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             ),
//         child: Image.asset("assets/icons/HomeIcons/1.png"));
//   }
// }

// class NoUserError extends StatelessWidget {
//   final Function() onLogin;
//   final String message;
//   const NoUserError({
//     Key? key,
//     required this.message,
//     required this.onLogin,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             message,
//             style: bigTitleStyle,
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           AppButton(
//             screenWidth: .7.sw,
//             screenHeight: .7.sh,
//             title: 'Log in',
//             function: () async {
//               await CommonFunctions.navigateToSignIn(context);
//               onLogin();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// class ShowBrands extends StatefulWidget {
//   const ShowBrands({Key? key}) : super(key: key);

//   @override
//   State<ShowBrands> createState() => _ShowBrandsState();
// }

// class _ShowBrandsState extends State<ShowBrands> {
//   List<Brand> brands = [
//     Brand(name: 'Audi', imageUrl: 'assets/images/brands/audi-logo.jpg'),
//     Brand(name: 'Kia', imageUrl: 'assets/images/brands/kia.png'),
//     Brand(name: 'BMW', imageUrl: 'assets/images/brands/bmw-logo.jpg'),
//     Brand(name: 'Mahindra', imageUrl: 'assets/images/brands/mahindra.png'),
//     Brand(name: 'Mercedes', imageUrl: 'assets/images/brands/mercedes.png'),
//     Brand(
//         name: 'Morris Garages',
//         imageUrl: 'assets/images/brands/morris-garage.jpg'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       child: Wrap(
//         spacing: 13.0,
//         runSpacing: 10.0,
//         children: List.generate(
//           brands.length,
//           (index) {
//             return Card(
//               color: Colors.grey[850],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 side: BorderSide(color: Color(0xff424242)),
//               ),
//               elevation: 4,
//               child: Container(
//                 height: 140,
//                 width: 120,
//                 padding: EdgeInsets.all(8),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(15)),
//                           image: DecorationImage(
//                             image: AssetImage(brands[index].imageUrl),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8.0),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Text(
//                           brands[index].name,
//                           style: titleStyle.copyWith(fontSize: 13),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/location_picker.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/models/brand_model.dart';
import 'package:letzrentnew/models/topcars_model.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:letzrentnew/screens/NewCars/new_cars_buy.dart';
import 'package:letzrentnew/screens/referral_screen.dart';
import 'package:letzrentnew/screens/view_more_brands.dart';
import 'package:letzrentnew/widgets/Cars/self_drive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/car_functions.dart';
import '../Utils/functions.dart';
import '../Utils/constants.dart';
import '../screens/user_profile.dart';

class HomePage extends StatefulWidget {
  // Added optional parameters for flexibility
  final bool showWelcomeMessage;
  final String? customTitle;

  const HomePage({
    Key? key,
    this.showWelcomeMessage = false,
    this.customTitle,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const itemss = [
    "assets/images/ZymoBenefits/Convenience.jpg",
    "assets/images/ZymoBenefits/CostEffective.jpg",
    "assets/images/ZymoBenefits/Flexibility.jpg",
    "assets/images/ZymoBenefits/GreatPrices.jpg",
  ];

  List<TopCarsModel> topcars = [
    TopCarsModel(
        imageUrl: 'assets/images/NewCars/sedan.png',
        title: 'Top Sedans in India',
        description: 'Hyundai Verna, Volkswagen Virtus'),
    TopCarsModel(
        imageUrl: 'assets/images/NewCars/suv.png',
        title: 'Top SUVs in India',
        description: 'Toyota Urban, Cruiser Taisor, Mahindra Scorpion'),
    TopCarsModel(
        imageUrl: 'assets/images/NewCars/hatchback.png',
        title: 'Top Hatchbacks in India',
        description: 'Tata Altroz, Maruti Suzuki Baleno'),
    TopCarsModel(
        imageUrl: 'assets/images/NewCars/luxury.png',
        title: 'Top Luxury Cars in India',
        description: 'Mercedes-Benz A-Class, Limousine, Skoda Superb'),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<String?>(
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

                final list = [Color(0xff303030), Color(0xff303030)];
                return DefaultTabController(
                  length: AppData.Categories.length,
                  child: Scaffold(
                    backgroundColor: Colors.black,
                    appBar: _buildAppBar(context, snapshot),
                    drawer: Drawer(child: UserProfile()),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Add welcome message if enabled
                          if (widget.showWelcomeMessage) _buildWelcomeSection(),
                          
                          Container(
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                            ),
                          ),

                          Stack(
                            children: [
                              // Banner widget
                              Container(
                                height: MediaQuery.of(context).size.height * .5,
                                decoration: BoxDecoration(
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
                                      child: bannerWidget(),
                                    ),
                                    _buildTabSelector(list),
                                    Consumer<CarProvider>(
                                      builder: (BuildContext context, value,
                                              Widget? child) =>
                                          _buildCarProviderSection(value),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: .01.sh),
                          _buildBrandsSection(),
                          _buildWhySection(),
                          _buildTopCarsSection(),
                          _buildBenefitsSection(),
                          _buildServiceProvidersSection(),
                          _buildSocialMediaSection(),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      );
    });
  }

  // New method to build welcome section
  Widget _buildWelcomeSection() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (widget.customTitle != null)
            Text(
              widget.customTitle!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appColor,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            user != null
                ? 'Welcome back, ${user.displayName ?? 'User'}!'
                : 'Welcome! You have successfully logged in.',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Ready to find your perfect ride?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Extracted AppBar building logic
  AppBar _buildAppBar(BuildContext context, AsyncSnapshot<String?> snapshot) {
    return AppBar(
      toolbarHeight: 67.5,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
      ),
      leading: Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(6, 12, 6, 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.menu, color: Colors.white),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 6, 16, 0),
          child: InkWell(
            onTap: () async =>
                CommonFunctions.navigateTo(context, LocationPicker()),
            child: SizedBox(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Color(0xFFDEFF63),
                          size: 18,
                        ),
                        Text(
                          'Location',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Expanded(
                      child: Text(
                        CommonFunctions.getCityFromLocation(snapshot.data!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Extracted tab selector logic
  Widget _buildTabSelector(List<Color> list) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: index == 0 ? appColor : list[0],
                ),
                child: InkWell(
                  onTap: () => setState(() => index = 0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Rent',
                      textAlign: TextAlign.center,
                      style: index == 0 ? whiteTitleStyle : titleStyle,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: index == 1 ? appColor : list[0],
                ),
                child: InkWell(
                  onTap: () => setState(() => index = 1),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FittedBox(
                      child: Text(
                        'Subscribe',
                        textAlign: TextAlign.center,
                        style: index == 1 ? whiteTitleStyle : titleStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: index == 2 ? appColor : list[0],
                ),
                child: InkWell(
                  onTap: () => setState(() => index = 2),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FittedBox(
                      child: Text(
                        'Buy',
                        textAlign: TextAlign.center,
                        style: index == 2 ? whiteTitleStyle : titleStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted car provider section
  Widget _buildCarProviderSection(CarProvider value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Card(
                color: darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 480),
                    child: KeyedSubtree(
                      key: ValueKey<bool>(index == 0),
                      child: index == 0
                          ? durationPicker(context, value)
                          : index == 1
                              ? atDurationPicker(context, value)
                              : ShowBuyOption(),
                    ),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
              ),
              SizedBox(height: .01.sh),
              index == 2
                  ? Container()
                  : TripDurationWidget(
                      duration: index == 0 ? value.getTripDuration() : "30 Days",
                    ),
            ],
          ),
        ),
        SizedBox(height: .02.sh),
        index == 2
            ? Container()
            : SizedBox(
                height: .06.sh,
                child: value.isLoading
                    ? spinkit
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AppButton(
                          color: appColor,
                          textSize: 20,
                          title: 'Search'.toUpperCase(),
                          screenHeight: 1.sh,
                          function: () => index == 0
                              ? CarFunctions.selfDriveNavigate(context)
                              : CarFunctions().monthlyRentalNavigate(context),
                        ),
                      ),
              ),
        index == 2 ? Container() : SizedBox(height: .01.sh),
        index == 2 ? Container() : RecentSearches(provider: value)
      ],
    );
  }

  // Extracted brands section
  Widget _buildBrandsSection() {
    return Column(
      children: [
        Text(
          'Brands Available',
          style: bigWhiteTitleStyle.copyWith(color: appColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: .01.sh),
        ShowBrands(),
        SizedBox(height: .005.sh),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.black,
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              elevation: 0,
              barrierColor: Colors.black.withOpacity(0.7),
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ViewMoreBrands(),
                  ),
                );
              },
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
            alignment: Alignment.bottomRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View More',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: appColor,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward, color: appColor, size: 16)
              ],
            ),
          ),
        ),
        SizedBox(height: .02.sh),
      ],
    );
  }

  // Extracted "Why" section
  Widget _buildWhySection() {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: appColor),
      child: Column(
        children: [
          Container(
            width: double.infinity / 8,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
                bottom: Radius.circular(15),
              ),
            ),
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  'Why $appName?',
                  style: bigTitleStyle.copyWith(color: Colors.white),
                ),
                SizedBox(height: .01.sh),
                CarouselSlider(
                  items: List.generate(
                    4,
                    (index) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "assets/icons/HomeIcons/${index + 1}.png",
                        ),
                      ),
                    ),
                  ),
                  options: CarouselOptions(
                    aspectRatio: 16 / 10,
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeFactor: .5,
                    enlargeCenterPage: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Extracted top cars section
  Widget _buildTopCarsSection() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          'Top Cars in India',
          style: bigTitleStyle.copyWith(color: appColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        CarouselSlider(
          items: List.generate(
            topcars.length,
            (index) => Card(
              elevation: 5,
              child: Container(
                height: 400,
                width: 370,
                decoration: BoxDecoration(
                  color: darkGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 230,
                        width: 370,
                        decoration: BoxDecoration(
                          color: appColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.asset(
                            topcars[index].imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 370,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topcars[index].title,
                                style: contentStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                topcars[index].description,
                                style: contentStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            height: 360,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Extracted benefits section
  Widget _buildBenefitsSection() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "Zymo Benefits",
              style: bigTitleStyle.copyWith(color: appColor),
            ),
          ),
          GridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .9,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1),
            children: itemss.map((String imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Image.asset(imagePath, fit: BoxFit.contain);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Extracted service providers section
  Widget _buildServiceProvidersSection() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Service Providers',
            style: bigTitleStyle.copyWith(color: appColor, fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
        BrandImagesWidget(),
      ],
    );
  }

  // Extracted social media section
  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(
              "Connect with us",
              style: bigTitleStyle.copyWith(color: appColor),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                icon: const Icon(FontAwesomeIcons.facebook),
                onPressed: () {
                  launchUrl(Uri.parse(
                      'https://www.facebook.com/LetzRent.official/'));
                }),
            IconButton(
                icon: const Icon(FontAwesomeIcons.instagram),
                onPressed: () {
                  launchUrl(Uri.parse('https://www.instagram.com/zymo.app'));
                }),
            IconButton(
                icon: const Icon(FontAwesomeIcons.linkedin),
                onPressed: () {
                  launchUrl(Uri.parse(
                      'https://www.linkedin.com/company/letzrent/'));
                }),
            IconButton(
                icon: const Icon(FontAwesomeIcons.twitter),
                onPressed: () {
                  launchUrl(Uri.parse('https://twitter.com/zymoapp'));
                }),
            IconButton(
                icon: const Icon(FontAwesomeIcons.youtube),
                onPressed: () {
                  launchUrl(Uri.parse(
                      'https://www.youtube.com/channel/UCHUvrPwNYxw7bukWFjhNpag'));
                })
          ],
        ),
      ],
    );
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

  Widget bannerWidget() {
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
                  return BannerWidget(
                      images: futureSnapshot.data!.data()!['imageList']);
                }
              })),
    );
  }

  InkWell profilePictureWidget(BuildContext context, User user) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserProfile())),
      child: CircleAvatar(
        backgroundColor: greyColor,
        child: user.photoURL != null
            ? CachedNetworkImage(imageUrl: user.photoURL!)
            : const Icon(Icons.person, color: appColor),
      ),
    );
  }
}

// Rest of the classes remain the same...
class GrowTile extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? body;
  final Color? color;
  const GrowTile({
    Key? key,
    this.icon,
    this.title,
    this.body,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        child: Image.asset("assets/icons/HomeIcons/1.png"));
  }
}

class NoUserError extends StatelessWidget {
  final Function() onLogin;
  final String message;
  const NoUserError({
    Key? key,
    required this.message,
    required this.onLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: bigTitleStyle),
          SizedBox(height: 10),
          AppButton(
            screenWidth: .7.sw,
            screenHeight: .7.sh,
            title: 'Log in',
            function: () async {
              await CommonFunctions.navigateToSignIn(context);
              onLogin();
            },
          )
        ],
      ),
    );
  }
}

class ShowBrands extends StatefulWidget {
  const ShowBrands({Key? key}) : super(key: key);

  @override
  State<ShowBrands> createState() => _ShowBrandsState();
}

class _ShowBrandsState extends State<ShowBrands> {
  List<Brand> brands = [
    Brand(name: 'Audi', imageUrl: 'assets/images/brands/audi-logo.jpg'),
    Brand(name: 'Kia', imageUrl: 'assets/images/brands/kia.png'),
    Brand(name: 'BMW', imageUrl: 'assets/images/brands/bmw-logo.jpg'),
    Brand(name: 'Mahindra', imageUrl: 'assets/images/brands/mahindra.png'),
    Brand(name: 'Mercedes', imageUrl: 'assets/images/brands/mercedes.png'),
    Brand(
        name: 'Morris Garages',
        imageUrl: 'assets/images/brands/morris-garage.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Wrap(
        spacing: 13.0,
        runSpacing: 10.0,
        children: List.generate(
          brands.length,
          (index) {
            return Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xff424242)),
              ),
              elevation: 4,
              child: Container(
                height: 140,
                width: 120,
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                          image: DecorationImage(
                            image: AssetImage(brands[index].imageUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          brands[index].name,
                          style: titleStyle.copyWith(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TataNexonCars()),
              );
            },
            child: BuyOptionConatiner(
              desc: AppData.buyOptions[0]['description']!,
              imageUrl: AppData.buyOptions[0]['imageUrl']!,
              title: AppData.buyOptions[0]['title']!,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            child: BuyOptionConatiner(
              desc: AppData.buyOptions[1]['description']!,
              imageUrl: AppData.buyOptions[1]['imageUrl']!,
              title: AppData.buyOptions[1]['title']!,
            ),
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
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: appColor,
                    size: 20,
                  )
                ],
              ),
            ),
            Center(
              child: Text(
                'Coming Soon!',
                style: contentStyle.copyWith(fontSize: 12, color: appColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoLocationWidget extends StatelessWidget {
  const NoLocationWidget({
    Key? key,
  }) : super(key: key);

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
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseServices().getCategory(title),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return spinkit;
          } else {
            final List images = snapshot.data != null
                //////////////////////
                ? (snapshot.data as DocumentSnapshot)['images']
                : [];
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
                          decoration: BoxDecoration(border: Border.all()),
                          // borderRadius:
                          //     const BorderRadius.all(Radius.circular(20))),
                          child: CachedNetworkImage(
                              placeholder: (context, url) => spinkit,
                              width: .4.sw,
                              fit: BoxFit.contain,
                              imageUrl: images[index]),
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
        });
  }
}

class BrandImagesWidget extends StatelessWidget {
  const BrandImagesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .19.sh,
      width: 1.sw,
      decoration: BoxDecoration(color: Colors.grey[850]),
      child: FutureBuilder(
          future: FirebaseServices().getBrands(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return spinkit;
            } else {
              // final snapshotData = snapshot.data!;
              final List images =
                  (snapshot.data as DocumentSnapshot)['images'] ?? [];

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
                  child: Container(
                    //changed the width
                    width: .13.sh,
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

class BannerWidget extends StatelessWidget {
  final List? images;
  const BannerWidget({
    Key? key,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(autoPlayAnimationDuration: sevenSeconds),
        // showIndicator: false,
        // overlayShadowColors: Colors.transparent,
        // autoplayDuration: const Duration(seconds: 5),
        // animationDuration: const Duration(seconds: 1),
        items: images!.map((e) {
          return InkWell(
            onTap: () {
              if (e['path'] != '') {
                switch (e['path']) {
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
                    Navigator.pushNamed(context, e['path']);
                    break;
                }
              }
            },
            child: CachedNetworkImage(
              imageUrl: e['imageUrl'] ?? '',
              fit: BoxFit.fitWidth,
              placeholder: (c, s) => spinkit,
            ),
          );
        }).toList());
  }
}
