import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letzrentnew/Services/vendor_services/zoomcar_model.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:letzrentnew/providers/home_provider.dart';

import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:provider/provider.dart';

import '../auth_services.dart';
import '../car_services.dart';

class ZoomCarServicesV6 {
  static const isV2 = true;
  static const String ver = isV2 ? 'v2' : 'v1';
  static String zoomCarUrl = '${zoomUrl}$ver/search?';
  static String getZoomTokenUrl = '${zoomUrl}authenticate/token';
  static String getZoomBookingDetailsUrl = '${zoomUrl}$ver/bookings/';
  static String zoomCarUserTokenUrl = '${zoomUrl}$ver/users/auth';
  static String bookingCreation = '${zoomUrl}$ver/bookings';
  static String cityList = '${zoomUrl}$ver/cities';
  static String zoomCarPaymentCreation = '${zoomUrl}$ver/payments';
  static String zoomCarTerminalsUrl = '${zoomUrl}$ver/airport_terminals';
  static const zoomBookingInfoUrl =
      'https://us-central1-letzrent-5f5a3.cloudfunctions.net/httpFunctions/getBookingDetails';

  // static List<CarModel> getCarModelFromApi(
  //     List cars, Vendor vendor, Map allLocations, List filters) {
  //   final List<CarModel> carList = [];
  //   cars.forEach((element) {
  //     if (element['name'] != null) {
  //       final List carKms = element['pricing'];
  //       final String type = _getCarType(filters, element);
  //       carKms.forEach((carkms) {
  //         final double price = double.parse(carkms['amount'].toString());
  //         final CarModel model = CarModel()
  //           ..name = element['name']
  //           ..seats = element['seater']
  //           ..type = type
  //           ..apiFlag = true
  //           ..transmission = element['manual'] ? 'Manual' : 'Automatic'
  //           ..imageUrl = element['url_large']
  //           ..finalPrice = price * vendor.currentRate * vendor.discountRate
  //           ..finalDiscount = price * vendor.currentRate
  //           ..actualPrice = price
  //           ..freeKm = carkms['kms']
  //           ..fuel = CarServices.getFuel(element['name'])
  //           ..carId = "${element['id']}"
  //           ..pickups = _getPickups(element, allLocations)
  //           ..vendor = vendor
  //           ..pricingId = "${carkms['id']}"
  //           ..extraKmCharge = carkms['excess_kms'];
  //         carList.add(model);
  //       });
  //     }
  //   });
  //   return carList;
  // }

  static List<PickupModel> newGetpickup(
      String locationId, String? location, String distance,
      {int deliveryCharge = 0}) {
    final List<PickupModel> pickUps = [];

    final PickupModel pickUpModel = PickupModel()
      ..deliveryCharges = 0
      ..locationId = locationId
      ..distanceFromUser = double.parse(distance)
      ..pickupAddress = location;
    pickUps.add(pickUpModel);

    return pickUps;
  }

  // static List<PickupModel> _getPickups(
  //     element, Map<dynamic, dynamic> allLocations) {
  //   final List<PickupModel> pickUps = [];
  //   element['locations'].forEach((location) {
  //     final String locationId = location['id'];
  //     final locationDistance = allLocations[locationId];
  //     if (locationDistance != null) {
  //       final PickupModel pickUpModel = PickupModel()
  //         ..deliveryCharges = 0
  //         ..locationId = locationId
  //         ..distanceFromUser = locationDistance['distance_to_sort']
  //         ..pickupAddress = locationDistance['address'];
  //       pickUps.add(pickUpModel);
  //     }
  //   });
  //   return pickUps;
  // }

  // static String _getCarType(List<dynamic> filters, element) {
  //   try {
  //     final String type = filters[element['filter'] - 1];
  //     return type.trim();
  //   } catch (e) {
  //     return '';
  //   }
  // }

  static Future<Map<String, dynamic>> getSecurityDeposit(
      BuildContext context,
      String city,
      String? carId,
      String pricingId,
      String locationId,
      String? carGroupId) async {
    log("HITTT");

    final CarProvider provider =
        Provider.of<CarProvider>(context, listen: false);
    final HomeProvider location =
        Provider.of<HomeProvider>(context, listen: false);
    final int startDate = provider.startDateTime.millisecondsSinceEpoch;
    final int endDate = provider.endDateTime.millisecondsSinceEpoch;
    final String? token = await getTokenHttps();
    if (token == null) {
      throw "Unable to fetch token";
    }
    final String? userToken = await getUserToken(token);
    final String platform = Platform.isIOS ? 'IOS' : 'android';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'USER-TOKEN': userToken!,
      'platform': platform,
      'x-api-key': zoomCarApiKey,
      'Authorization': 'Bearer $token',
    };
    if (city.contains('Bengaluru')) {
      city = 'Bangalore';
    } else if (city == 'Dombivli' || city == 'Thane') {
      city = 'Mumbai';
    } else if (delhiNCR.contains(city.toLowerCase())) {
      city = 'Delhi';
    }
    var object = {
      "booking_params": {
        "type": "normal",
        "cargroup_id": carGroupId,
        "car_id": carId,
        "city": city,
        "ends": endDate,
        "fuel_included": false,
        "lat": location.locationLatLng!.latitude,
        "lng": location.locationLatLng!.longitude,
        "pricing_id": int.parse(pricingId),
        "starts": startDate,
        "location_id": int.parse(locationId)
      }
    };
    final String body = jsonEncode(object);
    String? error;
    // mixpanel!.track('Zoom Booking API',
    //     properties: {'body': object, "headers": headers});
    try {
      final http.Response response = await http
          .post(Uri.parse(bookingCreation), body: body, headers: headers)
          .timeout(
            timeOutDuration,
          );
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        error = data['msg'];
        throw error!;
      }
      final Map bookingData = data['booking'];
      error = data['error_title'];
      final breakup = bookingData['fare']['break_up'];
      final actualPrice = bookingData['fare']['total_amount'];
      final locationData = bookingData['pickup_location'] ?? {};
      final location = locationData['address'] + ', ' + locationData['city'];
      final double? securityDeposit =
          breakup.length > 1 ? breakup[1]['amount'] : 0;
      final String? bookingId = bookingData['confirmation_key'];
      final Map<String, dynamic> responseData = {
        'securityDeposit': securityDeposit,
        'booking_id': bookingId,
        'location': location,
        'actualPrice': actualPrice
      };
      return responseData;
    } catch (e) {
      // mixpanel!.track('Booking error',
          // properties: {'response': error, 'error': e.toString()});
      return {'error': error};
    }
  }

  static Future<Map<String, dynamic>> homeDeliveryBookingCreation(
      BuildContext context,
      String city,
      String carId,
      String pricingId,
      String street1,
      String street2,
      String pinCode) async {
    final CarProvider provider =
        Provider.of<CarProvider>(context, listen: false);
    final HomeProvider location =
        Provider.of<HomeProvider>(context, listen: false);
    final int startDate = provider.startDateTime.millisecondsSinceEpoch;
    final int endDate = provider.endDateTime.millisecondsSinceEpoch;
    final String? token = await getTokenHttps();
    if (token == null) {
      throw "Unable to fetch token";
    }
    final String userToken = (await getUserToken(token))!;
    final String platform = Platform.isIOS ? 'IOS' : 'android';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'USER-TOKEN': userToken,
      'platform': platform,
      'x-api-key': zoomCarApiKey,
      'Authorization': 'Bearer $token',
    };
    if (city.contains('Bengaluru')) {
      city = 'Bangalore';
    }
    final String body = json.encode({
      "booking_params": {
        "type": "hd",
        "cargroup_id": carId,
        //    "location_id": locationId,
        "city": city,
        "ends": endDate,
        "fuel_included": false,
        "hd_params": {
          "address_lines": street1,
          "landmark": street2,
          "locality": street2,
          "zipcode": pinCode
        },
        "lat": location.locationLatLng!.latitude,
        "lng": location.locationLatLng!.longitude,
        // "pricing_id": pricingId,
        "starts": startDate,
      }
    });
    String? error;
    try {
      final http.Response response = await http
          .post(Uri.parse(bookingCreation), body: body, headers: headers)
          .timeout(
            timeOutDuration,
          );
      final data = jsonDecode(response.body);
      final Map bookingData = data['booking'];
      error = data['error_title'];
      final double? securityDeposit =
          bookingData['fare']['break_up'][1]['amount'];
      final double? hd_fee = bookingData['fare']['break_up'][2]['amount'];
      final String? bookingId = bookingData['confirmation_key'];
      final Map<String, dynamic> responseData = {
        'securityDeposit': securityDeposit,
        'booking_id': bookingId,
        'hd_fee': hd_fee
      };
      return responseData;
    } catch (e) {
      return {'error': error};
    }
  }

  static Future<String?> getUserToken(String token, {bool? isRetry}) async {
    try {
      final User user = Auth().getCurrentUser()!;
      final String uid = user.uid;
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'x-api-key': zoomCarApiKey,
        'Authorization': 'Bearer $token',
      };
      final Map body = {"user_hash_id": 'dsf$uid'};
      final http.Response response = await http
          .post(Uri.parse(zoomCarUserTokenUrl),
              headers: headers, body: jsonEncode(body))
          .timeout(
            timeOutDuration,
          );

      final Map data = jsonDecode(response.body);
      final String? userToken = data['user_token'];
      if (userToken == null && (isRetry ?? true)) {
        final x = await retryUserTokenFunction(token, 5);
        return x;
      } else
        return userToken;
    } catch (e) {
      print(e);
      final x = await retryUserTokenFunction(token, 5);
      return x;
    }
  }

  static Future<Map?> paymentCreationZoomCar(
      String? bookingId, int amount, String name, String phone) async {
    try {
      final Map<String, dynamic> body = {
        'booking_id': bookingId,
        'amount': amount,
        'status': 1,
        "user": {'name': name, 'phone': '$phone'}
      };
      final String? token = await getTokenHttps();
      if (token == null) {
        throw "Unable to fetch token";
      }
      final String? userToken = await getUserToken(token);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-api-key': zoomCarApiKey,
        'USER-TOKEN': userToken!,
        'Authorization': 'Bearer $token',
      };

      final http.Response response = await http.post(
          Uri.parse(zoomCarPaymentCreation),
          headers: headers,
          body: json.encode(body));
      final Map? data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future zoomCarUserDetails(String? bookingId, String? orderId,
      String? paymentCreationId, String name, String phone) async {
    try {
      final String body = json.encode({
        'booking_id': bookingId,
        'order_id': orderId,
        'status': 1,
        'user_details': {'name': name, 'phone': '$phone'}
      });
      final String? token = await getTokenHttps();
      if (token == null) {
        throw "Unable to fetch token";
      }
      final String? userToken = await getUserToken(token);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-api-key': zoomCarApiKey,
        'USER-TOKEN': userToken!,
        'Authorization': 'Bearer $token',
      };
      final String uri = '$zoomCarPaymentCreation/$paymentCreationId';
      final http.Response response =
          await http.put(Uri.parse(uri), headers: headers, body: body);
      final Map data = jsonDecode(response.body);
      if (data['booking_status'] == 'CANCELLED') {
        throw {'Response': data, 'Request': body};
      }
      return data['status'] == 1;
    } catch (e) {
      final Map errorMap = {
        'Error': e.toString(),
        'BookingId': bookingId,
        'Name': name,
        'Phone': phone
      };
      log(errorMap.toString());
      return errorMap;
    }
  }

  static Future<List<CarModel?>> zoomCar(
      DriveModel model, String typeZoom, Vendor vendor,
      {bool? isRetry}) async {
    try {
      // getCities();
      // final String startDate =
      //     dateFormatter.parse(model.startDate).toString().substring(0, 10);
      // final String endDate =
      //     dateFormatter.parse(model.endDate).toString().substring(0, 10);
      // final String startTime =
      //     TimeOfDay.fromDateTime(timeFormatter.parse(model.starttime))
      //         .toString()
      //         .replaceAll(RegExp("[(a-z, A-Z)]"), '');
      // final String endTime =
      //     TimeOfDay.fromDateTime(timeFormatter.parse(model.endtime))
      //         .toString()
      //         .replaceAll(RegExp("[(a-z, A-Z)]"), '');
      final int from = model.startDateTime.millisecondsSinceEpoch;
      final int to = model.endDateTime.millisecondsSinceEpoch;
      final String parameters = 'starts_epoch=$from&ends_epoch=$to';
      final String lat = 'lat=${model.mapLatLng!.latitude}';
      final String lng = 'lng=${model.mapLatLng!.longitude}';
      final String latLng = '$lat&$lng';
      final String type = 'type=$typeZoom';
      // const String fuel = 'fuel_bracket=no_fuel';
      final String? token = await getTokenHttps();
      String city = model.city ?? "";
      if (city == bengaluru) {
        city = 'Bangalore';
      } else if (city == 'Dombivli' || city == 'Thane') {
        city = 'Mumbai';
      } else if (delhiNCR.contains(city.toLowerCase())) {
        city = 'Delhi';
      }
      print(city);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'x-api-key': zoomCarApiKey,
        'Authorization': 'Bearer $token',
      };
      const country = 'country_code=IND';
      final String url =
          '${zoomCarUrl}$latLng&city=$city&$country&$parameters&$type';
      final http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(
                timeOutDuration,
              );

      if (response.body.isEmpty && (isRetry ?? true)) {
        return retryZoomCar(4, model, typeZoom, vendor);
      } else {
        final data = jsonDecode(response.body);
        print(data);
        final zoomdata = ZoomCarModel.fromJson(data);
        return zoomdata.sections?.first.cards?.map((value) {
              final element = value.carData;
              if (element != null) {
                final price = element.pricing!.revenue!;
                final location = element.location!;
                final text2 = element.rating?.text;
                List<String>? split = text2?.split('Â·');
                if (text2?.contains('â¢') ?? false) {
                  split = text2!.split('â¢');
                }
                final _finalPrice =
                    price * vendor.currentRate! * vendor.discountRate!;
                return CarModel()
                  ..name = element.name
                  ..type = value.type
                  ..apiFlag = true
                  ..transmission = element.accessories![0]
                  ..fuel = CarServices.getFuel(element.accessories![1])
                  ..seats = element.accessories![2].replaceAll(' Seats', '')
                  ..imageUrl = element.urlLarge
                  ..multiImages =
                      element.isOriginalCarImages! ? element.imageUrls : []
                  ..finalPrice = _finalPrice - getDiscount(price, vendor)
                  ..finalDiscount = (price * vendor.currentRate!).toDouble()
                  ..actualPrice = price.toDouble()
                  ..freeKm = 'Unlimited'
                  ..ratingText = element.rating?.text
                  ..kmsDriven = (split?.isNotEmpty ?? false) ? split?.last : ""
                  ..carRatingText = split?.first ?? ''
                  ..carRating = double.tryParse(
                          element.rating?.text?.split(' (').first ?? '') ??
                      5
                  ..carId = '${element.carId}'
                  ..pricingId = element.pricing!.id
                  ..carGroupId = '${element.cargroupId}'
                  ..pickups = newGetpickup('${location.id}', location.text,
                      location.distance!.toStringAsFixed(2))
                  ..vendor = vendor;
              }
            }).toList() ??
            [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static int getDiscount(int price, Vendor vendor) {
    final Map? map = vendor.discountMap;
    for (final amount in map!.entries) {
      if (int.parse(amount.key) > price) {
        return amount.value;
      }
    }
    return 0;
  }

  // static List<CarModel> getZoomCarFromType(
  //     String typeZoom, data, Vendor vendor) {
  //   final Map locations = data['locations_map'];
  //   final String filters = data['alert']['filter_text'];
  //   final List filterText = filters.split(',');
  //   if (typeZoom == 'hd') {
  //     final List cars = data['cars'];
  //     return getZoomCarHomeDelivery(cars, vendor, filterText);
  //   } else {
  //     final List cars = data['result'][0]['cars'];
  //     return getCarModelFromApi(cars, vendor, locations, filterText);
  //   }
  // }
  // static getCities() async {
  //   final String token = await getTokenHttps();
  //   final url = "https://partner-api.zoomcar.com/v2/cities";
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Accept': '*/*',
  //     'x-api-key': zoomCarApiKey,
  //     'Authorization': 'Bearer $token',
  //   };
  //   final http.Response response = await http
  //       .get(Uri.parse(url), headers: headers)
  //       .timeout(timeOutDuration, onTimeout: () => null);
  //   log(response.body);
  // }

  static Future<String?> getTokenHttps({bool? isRetry}) async {
    try {
      final Map<String, String> body = {"grant_type": "client_credentials"};
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$zoomCarId:$zoomCarPassword'))}';
      final Map<String, String> headers = {
        'authorization': basicAuth,
        'Content-Type': 'application/json'
      };
      final http.Response response = await http
          .post(Uri.parse(getZoomTokenUrl),
              headers: headers, body: jsonEncode(body))
          .timeout(
            timeOutDuration,
          );

      final Map data = jsonDecode(response.body);
      final String? token = data['access_token'];
      if (token == null && (isRetry ?? true)) {
        final x = await retryFunction(10);
        return x;
      } else
        return token;
    } catch (e) {
      return null;
    }
  }

  static Future getBookingInfo(String bookingId, String userId) async {
    const headers = {'Content-Type': 'application/json'};

    final body = json.encode({"bookingId": bookingId, "uid": "dsf${userId}"});

    final response = await http
        .post(Uri.parse(zoomBookingInfoUrl), body: body, headers: headers)
        .timeout(timeOutDuration, onTimeout: () => throw 'Timed Out');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["error"] != null) {
        return {"Error": '${data["error"]}'};
      }
    } else {
      print(response.reasonPhrase);
      return {"Error": '${response.reasonPhrase}'};
    }
  }

  static Future<String?> retryFunction(int retry) async {
    for (int i = 0; i < retry; i++) {
      print('cars retry function $i');
      await Future.delayed(Duration(milliseconds: 500));
      final token = await getTokenHttps(isRetry: false);
      if (token != null) {
        return token;
      }
    }
    return null;
  }

  static Future<String?> retryUserTokenFunction(
      String tokenn, int retry) async {
    for (int i = 0; i < retry; i++) {
      print('User Token retry function $i');
      final token = await getUserToken(tokenn, isRetry: false);
      if (token != null) {
        return token;
      }
    }
    return null;
  }

  static Future<List<CarModel?>> retryZoomCar(
      int retry, DriveModel model, String typeZoom, Vendor vendor) async {
    for (int i = 0; i < retry; i++) {
      print('retry function $i');
      final token = await zoomCar(model, typeZoom, vendor, isRetry: false);
      return token;
    }
    return [];
  }

//   static List<CarModel> getZoomCarHomeDelivery(
//       List cars, Vendor vendor, List filters) {
//     final List<CarModel> carList = [];
//     cars.forEach((element) {
//       if (element['name'] != null) {
//         final List carKms = element['pricings'] ?? [];
//         final String type = _getCarType(filters, element);
//         final List element2 = element['location_id'];

//         final int locationId = element2.isNotEmpty ? element2[0] : 0;
//         carKms.forEach((carkms) {
//           final double price = double.parse(carkms['amount'].toString());
//           final CarModel model = CarModel()
//             ..name = element['name']
//             ..seats = element['seater']
//             ..type = type
//             ..apiFlag = true
//             ..transmission = element['manual'] ? 'Manual' : 'Automatic'
//             ..imageUrl = element['url_large']
//             ..finalPrice = price * vendor.currentRate * vendor.discountRate
//             ..finalDiscount = price * vendor.currentRate
//             ..actualPrice = price
//             ..freeKm = carkms['kms']
//             ..fuel = CarServices.getFuel(element['name'])
//             ..carId = "${element['id']}"
//             ..pickUpAndDrop = homeDelivery
//             ..locationId = '$locationId'
//             ..vendor = vendor
//             ..pricingId = "${carkms['id']}"
//             ..extraKmCharge = carkms['excess_kms'];
//           carList.add(model);
//         });
//       }
//     });
//     return carList;
//   }
}
