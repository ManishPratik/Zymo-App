import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:letzrentnew/models/car_model.dart';

class WheelUpServices {
  static const String baseUrl = 'https://wheelup.in:8443/WheelUp/api/vehicles/';

  static Future<List<CarModel>> getWheelUpCarSD(DriveModel model,
      {Vendor? vendor}) async {
    final List<CarModel> carList = [];
    try {
      String formattedStartTime = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
          .format(model.startDateTime.toUtc());
      String formattedEndTime = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
          .format(model.endDateTime.toUtc());
      print(formattedEndTime);

      var headersList = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ3aGVlbHVwLmVudGVycHJpc2VAZ21haWwuY29tIiwiaWF0IjoxNzA3MjI3OTAwLCJleHAiOjE3MDcyMjg4MDAsImlkIjoxLCJtb2R1bGVBY2Nlc3NMaXN0IjpbXSwicm9sZXMiOiJST0xFX0FETUlOIn0.5AtNOY05mSTKywDWItglUaxXQhhTNJvuakrmPGkarQ0'
      };
      var url = Uri.parse('https://wheelup.in:8443/WheelUp/api/vehicles/');
      var body = {
        "startDateTime": formattedStartTime,
        "endDateTime": formattedEndTime,
        "pageSize": 6,
        "pageNumber": 0,
        "currentCity": model.city.toString(),
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      final data = jsonDecode(resBody);
      data['data'].forEach((element) {
        print(element);
        final price = element["baseKMPrice1"];
        final CarModel model = CarModel()
          ..isSoldOut =
              element['isDelete'] == 'Y'
          ..name = element['vehicleName']
          ..seats = element['seatingCapacity']['name']
          ..type = 'SUV'
          ..apiFlag = true
          ..transmission = element['transmissionType']['name']
          // ..imageUrl = vendor!.imageUrl
          // ..imageUrl = vendor
          ..finalPrice = price * vendor!.currentRate! * vendor.discountRate!
          ..finalDiscount = price * vendor.currentRate!
          ..finalPrice = price
          ..finalDiscount = price
          ..actualPrice = price
          ..freeKm = element['baseKM1']
          ..fuel = element['fuel']['name']
          ..pickUpAndDrop = element['address']
          ..vendor = vendor
          ..extraKmCharge = 10;
        carList.add(model);
        // }
        // }
      });
    } catch (e) {
    }
    print(carList.toString());
    return carList;
  }
}
