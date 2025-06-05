// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/screens/NewCars/car_slider.dart';
// import 'package:letzrentnew/screens/NewCars/price_category.dart';
// import 'package:letzrentnew/screens/NewCars/recommended_cars.dart';

// class NewBuyCars extends StatefulWidget {
//   const NewBuyCars({Key? key}) : super(key: key);

//   @override
//   State<NewBuyCars> createState() => _NewBuyCarsState();
// }

// class _NewBuyCarsState extends State<NewBuyCars> {
//   int index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 60,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: gradientColors),
//           ),
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
//             padding: EdgeInsets.all(5),
//             height: 45,
//             width: 180,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       index = 0;
//                     });
//                   },
//                   child: Container(
//                     width: 80,
//                     padding: EdgeInsets.all(5),
//                     decoration: index == 0
//                         ? BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             gradient: LinearGradient(colors: gradientColors),
//                           )
//                         : BoxDecoration(),
//                     child: Center(
//                       child: Text(
//                         'Book',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: index == 0 ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       index = 1;
//                     });
//                   },
//                   child: Container(
//                     width: 80,
//                     padding: EdgeInsets.all(5),
//                     decoration: index == 1
//                         ? BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             gradient: LinearGradient(colors: gradientColors),
//                           )
//                         : BoxDecoration(),
//                     child: Center(
//                       child: Text(
//                         'Explore',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: index == 1 ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//                 height: 202,
//                 width: 1.sw,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: gradientColors),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Book your test drive',
//                       style: bigWhiteTitleStyle.copyWith(
//                         fontWeight: FontWeight.w800,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       child: SizedBox(
//                         height: 50,
//                         child: TextField(
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Search for car model',
//                             prefixIcon: Icon(Icons.search),
//                             contentPadding: EdgeInsets.symmetric(vertical: 10),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(color: Colors.purple),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       alignment: Alignment.bottomCenter,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               width: 180,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                                 color: const Color.fromARGB(172, 255, 255, 255),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Icon(
//                                     Icons.call,
//                                     size: 20,
//                                     color: Colors.black54,
//                                   ),
//                                   Text(
//                                     'Get Assistance',
//                                     style: titleStyle.copyWith(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               width: 180,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                                 color: const Color.fromARGB(172, 255, 255, 255),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Icon(
//                                     Icons.shopping_bag_outlined,
//                                     size: 20,
//                                     color: Colors.black54,
//                                   ),
//                                   Text(
//                                     'My Bookings',
//                                     style: titleStyle.copyWith(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Explore by budget',
//                       style: whiteTitleStyle.copyWith(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         gradient: LinearGradient(
//                           colors: gradientColors,
//                         ),
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: Center(
//                         child: Text(
//                           'See all',
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               PriceCategory(),
//               SizedBox(
//                 height: 15,
//               ),
//               CarsCardSlider(),
//               SizedBox(
//                 height: 30,
//               ),
//               RecommendedCars(),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/screens/NewCars/new_cars_buy_2.dart';

// class TataNexonCars extends StatefulWidget {
//   const TataNexonCars({Key? key}) : super(key: key);

//   @override
//   State<TataNexonCars> createState() => _TataNexonCarsState();
// }

// class _TataNexonCarsState extends State<TataNexonCars> {
//   int index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 60,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: gradientColors),
//           ),
//         ),
//         title: Text(
//           'Tata Nexon Cars',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
//             padding: EdgeInsets.all(5),
//             height: 45,
//             width: 180,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       index = 0;
//                     });
//                   },
//                   child: Container(
//                     width: 80,
//                     padding: EdgeInsets.all(5),
//                     decoration: index == 0
//                         ? BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             gradient: LinearGradient(colors: gradientColors),
//                           )
//                         : BoxDecoration(),
//                     child: Center(
//                       child: Text(
//                         'Book',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: index == 0 ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       index = 1;
//                     });
//                   },
//                   child: Container(
//                     width: 80,
//                     padding: EdgeInsets.all(5),
//                     decoration: index == 1
//                         ? BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             gradient: LinearGradient(colors: gradientColors),
//                           )
//                         : BoxDecoration(),
//                     child: Center(
//                       child: Text(
//                         'Explore',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: index == 1 ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//                 height: 232,
//                 width: 1.sw,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: gradientColors),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Book Your Tata Nexon Test Drive',
//                       style: bigWhiteTitleStyle.copyWith(
//                         fontWeight: FontWeight.w800,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       child: SizedBox(
//                         height: 50,
//                         child: TextField(
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Search Tata Nexon Variant',
//                             prefixIcon: Icon(Icons.search),
//                             contentPadding: EdgeInsets.symmetric(vertical: 10),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(color: Colors.purple),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       alignment: Alignment.bottomCenter,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               width: 180,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                                 color: const Color.fromARGB(172, 255, 255, 255),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Icon(
//                                     Icons.call,
//                                     size: 20,
//                                     color: Colors.black54,
//                                   ),
//                                   Text(
//                                     'Nexon Support',
//                                     style: titleStyle.copyWith(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               width: 180,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                                 color: const Color.fromARGB(172, 255, 255, 255),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Icon(
//                                     Icons.shopping_bag_outlined,
//                                     size: 20,
//                                     color: Colors.black54,
//                                   ),
//                                   Text(
//                                     'Nexon Bookings',
//                                     style: titleStyle.copyWith(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Tata Nexon Variants',
//                       style: whiteTitleStyle.copyWith(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         gradient: LinearGradient(
//                           colors: gradientColors,
//                         ),
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: Center(
//                         child: Text(
//                           'See all',
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               // You would replace these with Tata Nexon specific widgets
//               // NexonPriceCategory(),
//               // SizedBox(
//               //   height: 15,
//               // ),
//               NexonCarsCardSlider(),
//               SizedBox(
//                 height: 30,
//               ),
//               NexonRecommendedCars(),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NexonPriceCategory extends StatelessWidget {
//   final List<Map<String, dynamic>> priceCategories = [
//     {
//       'title': 'Under ₹10 Lakh',
//       'icon': Icons.attach_money,
//       'color': Colors.green,
//     },
//     {
//       'title': '₹10-15 Lakh',
//       'icon': Icons.money_outlined,
//       'color': Colors.blue,
//     },
//     {
//       'title': '₹15-20 Lakh',
//       'icon': Icons.monetization_on,
//       'color': Colors.orange,
//     },
//     {
//       'title': 'Above ₹20 Lakh',
//       'icon': Icons.account_balance_wallet,
//       'color': Colors.purple,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: priceCategories.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 120,
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: priceCategories[index]['color'].withOpacity(0.1),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   priceCategories[index]['icon'],
//                   color: priceCategories[index]['color'],
//                   size: 30,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   priceCategories[index]['title'],
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class NexonCarsCardSlider extends StatelessWidget {
//   final List<Map<String, dynamic>> nexonCars = [
//     {
//       'name': 'Nexon XE',
//       'price': '₹7.49 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//       'fuelType': 'Petrol',
//     },
//     {
//       'name': 'Nexon XM',
//       'price': '₹8.99 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//       'fuelType': 'Diesel',
//     },
//     {
//       'name': 'Nexon XT',
//       'price': '₹10.49 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//       'fuelType': 'Petrol',
//     },
//     {
//       'name': 'Nexon XZ+',
//       'price': '₹12.99 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//       'fuelType': 'Electric',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 250,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: nexonCars.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 250,
//             height: 200,
//             margin: EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//                   child: Image.asset(
//                     nexonCars[index]['image'],
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         nexonCars[index]['name'],
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             nexonCars[index]['price'],
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.green,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               nexonCars[index]['fuelType'],
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class NexonRecommendedCars extends StatelessWidget {
//   final List<Map<String, dynamic>> recommendedCars = [
//     {
//       'name': 'Nexon EV Max',
//       'description': 'Long Range Electric SUV',
//       'price': '₹14.99 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//     },
//     {
//       'name': 'Nexon Dark Edition',
//       'description': 'Stylish Dark Themed Variant',
//       'price': '₹12.49 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//     },
//     {
//       'name': 'Nexon Creative',
//       'description': 'Fully Loaded Variant',
//       'price': '₹15.49 Lakh',
//       'image': 'assets/images/NewCars/tata-nexon.jpg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           child: Text(
//             'Recommended Nexon Cars',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         SizedBox(height: 15),
//         Container(
//           height: 270,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: recommendedCars.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 300,
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//                       child: Image.asset(
//                         recommendedCars[index]['image'],
//                         height: 160,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             recommendedCars[index]['name'],
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             recommendedCars[index]['description'],
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             recommendedCars[index]['price'],
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.green,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class TataNexonCars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container with Image and Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 35, 20),
              child: Stack(
                children: [
                  // Custom Painted Containers
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: CustomPaint(
                      painter: OverlappingContainersPainter(),
                    ),
                  ),

                  // Car Image
                  Positioned(
                    top: 40,
                    left: 30,
                    right: 30,
                    child: SizedBox(
                      height: 320,
                      width: 300,
                      child: Image.asset(
                        'assets/images/NewCars/nexon.png',
                        // height: 320,
                        // width: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 20,
                    left: 20,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  // Drive Your Way Button
                  Positioned(
                    bottom: 10,
                    right: 30,
                    child: Container(
                      height: 45,
                      width: 200,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Drive Your Way',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Main Text Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: 'Explore, book for a test drive and Buy ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Easily',
                      style: TextStyle(
                        color: Color(0xFFedff8d),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Get a car wherever and whenever you need it',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ),

            Spacer(),

            // Bottom Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarSelectionScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, color: Color(0xFFDEFF63)),
                    SizedBox(width: 10),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 145, 144, 144),
                        size: 16),
                    Icon(Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 192, 191, 191),
                        size: 16),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverlappingContainersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFFedff8d)
      ..style = PaintingStyle.fill;

    const double cornerRadius = 25;

    // Draw bottom container
    final Rect bottomRect =
        Rect.fromLTWH(60, 55, size.width - 40, size.height - 40);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bottomRect, const Radius.circular(cornerRadius)),
      paint,
    );

    // Draw top container
    final Rect topRect = Rect.fromLTWH(0, 0, size.width - 80, size.height - 40);
    canvas.drawRRect(
      RRect.fromRectAndRadius(topRect, const Radius.circular(cornerRadius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// Keep your existing OverlappingContainersPainter class unchanged

// class OverlappingContainersPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Color(0xFFedff8d)
//       ..style = PaintingStyle.fill;

//     // Define corner radius
//     const double cornerRadius = 25;

//     // Draw bottom container
//     final Rect bottomRect =
//         Rect.fromLTWH(60, 55, size.width - 40, size.height - 40);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             bottomRect, const Radius.circular(cornerRadius)),
//         paint);

//     // // Draw middle container
//     // final Rect middleRect = Rect.fromLTWH(20, 20, size.width - 40, size.height - 40);
//     // canvas.drawRRect(RRect.fromRectAndRadius(middleRect, const Radius.circular(cornerRadius)), paint);

//     // Draw top container
//     final Rect topRect = Rect.fromLTWH(0, 0, size.width - 80, size.height - 40);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(topRect, const Radius.circular(cornerRadius)),
//         paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

class CustomContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Set the color of the container
      ..style = PaintingStyle.fill;

    final double cornerRadius = 20.0; // Rounded corner radius
    final double cutoutHeight = 30.0; // Height of the bottom cutout
    final double cutoutWidth = 50.0; // Width of the bottom cutout

    Path path = Path()
      // Start at top-left corner
      ..moveTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0) // Top-left rounded corner
      ..lineTo(size.width, 0) // Top edge
      ..lineTo(size.width, size.height - cornerRadius) // Right edge
      ..quadraticBezierTo(size.width, size.height, size.width - cornerRadius,
          size.height) // Bottom-right rounded corner
      ..lineTo(
          cutoutWidth + cornerRadius, size.height) // Move to start of cutout
      ..lineTo(cutoutWidth, size.height - cutoutHeight) // Top-left of cutout
      ..lineTo(0, size.height - cutoutHeight) // Left of cutout
      ..lineTo(0, cornerRadius) // Connect back to start
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No repainting required
  }
}
