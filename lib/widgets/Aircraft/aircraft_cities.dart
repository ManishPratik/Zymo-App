// import 'package:flutter/material.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Widgets/CoLiving/co_living_cities.dart';
// import 'package:letzrentnew/models/city_model.dart';

// import 'aircraft_listing.dart';

// class AircraftsFilterScreen extends StatefulWidget {
//   static const routeNmae = 'Aircrafts';
//   @override
//   _AircraftsFilterScreenState createState() => _AircraftsFilterScreenState();
// }

// class _AircraftsFilterScreenState extends State<AircraftsFilterScreen> {
//   @override
//   Widget build(BuildContext context) {
//     mixpanel.track('Aircrafts page opened');

//     return Scaffold(
//       appBar: AppBar(title: Text('Select your city')),
//       body: Center(
//         child: Wrap(
//             children: aircraftCities
//                 .map((e) => InkWell(
//                       onTap: () => Navigator.of(context).pushNamed(
//                           AircraftsGrid.routeName,
//                           arguments: {'city': e.name.toLowerCase()}),
//                       child: CityTile(
//                         e: e,
//                       ),
//                     ))
//                 .toList()),
//       ),
//     );
//   }
// }
