// import 'package:flutter/material.dart';
// import 'package:letzrentnew/models/mychoize_vehicle.dart';


// class VehicleCard extends StatelessWidget {
//   final MyChoizeVehicle vehicle;

//   const VehicleCard({Key? key, required this.vehicle}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: vehicle.imageUrl != null
//             ? Image.network(vehicle.imageUrl!, width: 50, height: 50)
//             : const Icon(Icons.car_rental),
//         title: Text(vehicle.brandName ?? 'Unknown Brand'),
//         subtitle: Text(
//             '${vehicle.fuelType}, ${vehicle.transmissionType}, Seats: ${vehicle.seatingCapacity}'),
//         trailing: Text('₹${vehicle.price?.toStringAsFixed(2) ?? 'N/A'}'),
//       ),
//     );
//   }
// }
