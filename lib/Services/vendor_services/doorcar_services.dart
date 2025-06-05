import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/extensions.dart';
import 'package:letzrentnew/models/car_model.dart';

class DoorCarServices {
  static const doorCarUrl = "https://doorcars.com/admin/API/Price.php?";
  static Future<List<CarModel>> getSd(DriveModel model, int tripDuration,
      {Vendor? vendor}) async {
    final List<CarModel> list = [];
    try {
      // Format DateTime and TimeOfDay values
      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(model.startDateTime);
      String formattedStartTime =
          '${model.startDateTime.hour}%3A${model.startDateTime.minute}';

      String formattedEndDate =
          DateFormat('yyyy-MM-dd').format(model.endDateTime);
      String formattedEndTime =
          '${model.endDateTime.hour}%3A${model.endDateTime.minute}';

      // Construct the final string
      final String queryString =
          's=$formattedStartDate$formattedStartTime&e=$formattedEndDate$formattedEndTime';
      final http.Response response =
          await http.get(Uri.parse(doorCarUrl + queryString)).timeout(
                timeOutDuration,
              );
      final List data =
          jsonDecode(response.body.replaceAll("Booking Hours: $tripDuration hours<br>", ""));
      data.forEach((element) {
        vendor!.securityDeposit ??=
            double.tryParse(element['securityDeposit'].toString());
        final CarModel carModel = CarModel()
          ..name = '${element["VehiclesTitle"]}'
          ..seats = element["SeatingCapacity"]
          ..multiImages = getMultiImages(element)
          ..type = element['type']
          ..apiFlag = true
          ..transmission = element['transmission'] ?? "Manual"
          ..imageUrl = element['Images1']
          ..finalPrice =
              element['Booking Price'] * vendor.currentRate * vendor.discountRate
          ..finalDiscount = element['Booking Price'] * vendor.currentRate
          ..actualPrice = (element['Booking Price'] as int).toDouble()
          ..freeKm = element['freeKm']
          ..fuel = (element['FuelType'] as String?)?.firstLetterUpper()
          // ..pickups = deliveryWow
          ..pickUpAndDrop = "Jaipur Railway station"
          ..vendor = vendor
          ..extraKmCharge = element['extraKmCharge'];
        list.add(carModel);
      });
    } catch (e) {
      print(e);
    }
    return list;
  }
  
  static List<String>? getMultiImages(element) {
    List<String> images = [];
    int index = 1;
    while (true){
      final link = element["Images$index"];
      if (link != null && link is String){
        images.add(link);
        index++;
      } else {
        break;
      }
    }
    return images;
  }
}
