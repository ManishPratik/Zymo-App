// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/Services/firebase_services.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/widgets.dart';
// import 'package:letzrentnew/models/aircraft_model.dart';

// import 'aircraft_details.dart';

// class AircraftsGrid extends StatelessWidget {
//   static const routeName = '/aircrafts-screen';

//   @override
//   Widget build(BuildContext context) {
//     final routeArgs =
//         ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
//     final _city = routeArgs['city'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Aircrafts'),
//       ),
//       body: FutureBuilder<List<AircraftModel>>(
//         future: FirebaseServices().getAircrafts(_city),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting &&
//               !snapshot.hasData) {
//             return Center(child: spinkit);
//           }
//           final List<AircraftModel> aircrafts = snapshot.data;
//           if (aircrafts.isEmpty) {
//             return Center(
//               child: Text('Something went wrong :('),
//             );
//           }
//           aircrafts.sort((a, b) => (((a.price)).compareTo(((b.price)))));

//           return ListView.builder(
//               physics: BouncingScrollPhysics(),
//               itemCount: aircrafts.length,
//               itemBuilder: (ctx, index) {
//                 return AircraftTile(aircraftModel: aircrafts[index]);
//               });
//         },
//       ),
//     );
//   }
// }

// class AircraftTile extends StatelessWidget {
//   const AircraftTile({
//     Key key,
//     @required this.aircraftModel,
//   }) : super(key: key);

//   final AircraftModel aircraftModel;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: .9.sw,
//         height: .42.sh,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: InkWell(
//             onTap: () => Navigator.of(context).pushNamed(
//                 AircraftsBooking.routeName,
//                 arguments: aircraftModel),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         width: 1.sw,
//                         height: .31.sh,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: CachedNetworkImage(
//                             imageUrl: aircraftModel.image,
//                             fit: BoxFit.fitWidth,
//                             placeholder: (context, ok) => const Center(
//                               child: Text(
//                                 'LR',
//                                 style: TextStyle(
//                                     color: Colors.black54,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             errorWidget: (c, s, w) => Icon(Icons.error_outline),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                           top: 1,
//                           right: 5,
//                           child: Chip(
//                               label: Row(
//                             children: [
//                               Icon(Icons.timer),
//                               Text(' ${aircraftModel.time}'),
//                             ],
//                           ))),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(aircraftModel.title, style: bigHeadingStyle),
//                       Column(
//                         children: <Widget>[
//                           Text(
//                             '$rupeeSign${aircraftModel.price}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                           Text(
//                             '$rupeeSign${(aircraftModel.finalPrice).toStringAsFixed(0)}',
//                             style: headingStyle,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       if (aircraftModel.numberOfPeople != null) ...[
//                         Icon(Icons.person),
//                         Text(aircraftModel.numberOfPeople == 1
//                             ? '${aircraftModel.numberOfPeople} Person'
//                             : '${aircraftModel.numberOfPeople} Persons')
//                       ],
//                       Spacer(),
//                       // FulfilledByWidget(
//                       //   imageUrl:
//                       //       'https://letzrentimages.s3.ap-south-1.amazonaws.com/Aircrafts/ACCRETION+logo.png',
//                       // )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
