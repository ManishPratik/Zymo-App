import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/car_logic.dart';
import 'package:letzrentnew/models/document_model.dart';
import 'package:letzrentnew/models/mychoize_model.dart';

import '../Services/car_services.dart';

class DriveModel {
  double? balance;
  int? terminalId;
  String? driveString;
  DocumentModel? documents;
  String? bookingId;
  String? flightNumber;
  DriveTypes? drive;
  int? hrs;
  String? startDate;
  String? endDate;
  String? city;
  String? starttime;
  String? endtime;
  String? mapLocation;
  String? remainingDuration;
  double? distanceOs;
  LatLng? mapLatLng;
  int? weekdayhr;
  int? weekendhr;
  int? weekends;
  int? weekdays;
  String? type;
  List? carGrouping;
  DateTime? startDateTime;
  DateTime? endDateTime;

  DriveModel(
      {this.drive,
      required this.mapLatLng,
      required this.distanceOs,
      required this.hrs,
      required this.startDate,
      required this.endDate,
      required this.city,
      required this.starttime,
      required this.endtime,
      required this.mapLocation,
      required this.remainingDuration,
      required this.type,
      required this.weekdays,
      required this.terminalId,
      required this.weekends,
      required this.weekendhr,
      required this.weekdayhr});

  DriveModel.fromJson(Map<String, dynamic> json) {
    drive = json['drive'];
    mapLatLng = json['mapLatLng'];
    hrs = json['hrs'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    city = json['city'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    mapLocation = json['mapLocation'];
    remainingDuration = json['remainingDays'];
    distanceOs = json['distance'];
    weekdays = json['weekdays'];
    weekends = json['weekends'];
    weekdayhr = json['weekdayhr'] ?? 0;
    weekendhr = json['weekendhr'] ?? 0;
    type = json['type'];
  }
}

class CarModel {
  String name;
  String imageUrl;
  List<String>? multiImages;
  var seats;
  int? rate;
  String fuel;
  String transmission;
  String? type;
  int? price;
  dynamic freeKm;
  String? ratingText;
  String? kmsDriven;
  String? carRatingText;
  double? carRating;
  int? ratePerKm;
  int? ratePerHr;
  double? weekdayperhr;
  double? weekendperhr;
  double? weekdayprice;
  double? weekendprice;
  dynamic finalDiscount;
  double? actualPrice;
  var finalPrice;
  String? drive;
  dynamic extraKmCharge;
  int? extraHrCharge;
  String? vendorName;
  String? pickUpAndDrop;
  String? locationId;
  List<PickupModel>? pickups;
  dynamic toll;
  int? minHrs;
  int? driverCharges;
  Vendor? vendor;
  int? deliveryCharges;
  bool? apiFlag;
  String? pricingId;
  String? carId;
  String? carGroupId;
  String? package;
  bool? isSoldOut;
  String? packageName;
  MyChoizeModel? myChoizeModel;
  PickupModel? selectedPickup;

  CarModel({
    this.name = '',
    this.imageUrl = '',
    this.multiImages,
    this.seats = 0,
    this.rate,
    this.fuel = '',
    this.transmission = 'Manual',
    this.type,
    this.price,
    this.freeKm,
    this.ratingText,
    this.kmsDriven,
    this.carRatingText,
    this.carRating,
    this.ratePerKm,
    this.ratePerHr,
    this.weekdayperhr,
    this.weekendperhr,
    this.weekdayprice,
    this.weekendprice,
    this.finalDiscount,
    this.actualPrice,
    this.finalPrice,
    this.drive,
    this.extraKmCharge,
    this.extraHrCharge,
    this.vendorName,
    this.pickUpAndDrop,
    this.locationId,
    this.pickups,
    this.toll,
    this.minHrs,
    this.driverCharges,
    this.vendor,
    this.deliveryCharges,
    this.apiFlag,
    this.pricingId,
    this.carId,
    this.carGroupId,
    this.package,
    this.isSoldOut = false,
    this.packageName,
    this.myChoizeModel,
    this.selectedPickup,
  });

  static String getFreeKm(DriveModel model, CarModel carModel) {
    String freekms = '';
    if (model.drive == DriveTypes.WC) {
      freekms = "${model.hrs! * 10} KMs FREE";
    } else if (model.drive == DriveTypes.RT || model.drive == DriveTypes.OW) {
      freekms = "${model.distanceOs} KMs";
    } else if (model.drive == DriveTypes.SD) {
      if (carModel.freeKm == null) {
        freekms = "Unlimited KMs";
      } else if (carModel.freeKm is String &&
          carModel.freeKm.toLowerCase().contains('unlimited')) {
        freekms = "Unlimited KMs";
      } else {
        freekms =
            "${CarServices.getFreeKm(carModel.freeKm, model.weekdayhr!, model.weekendhr!, carModel.apiFlag!)} KMs FREE";
      }
    } else if (model.drive == DriveTypes.AT) {
      freekms = 'Includes ${carModel.freeKm} KMs';
    } else {
      if (freekms.toLowerCase().contains('free')) {
        freekms = '${carModel.freeKm}';
      } else
        freekms = '${carModel.freeKm} Free KMs';
    }

    return freekms;
  }



  factory CarModel.fromJson(
      Map<String, dynamic> json,
      Vendor tempVendor,
      DriveTypes driveType, {
        DriveModel? driveModel,
        bool isApi = false,
      }) {
    final model = CarModel(apiFlag: isApi);
    model.vendor = tempVendor;

    model.isSoldOut = json['isSoldOut'] as bool? ?? false;

    model.name = json['name'] as String? ?? '';

    model.imageUrl = json['imageurl'] as String? ?? json['imageUrl'] as String? ?? '';

    model.seats = json['seats'] as int? ?? 0;

    model.fuel = json['fuel'] as String? ?? '';

    model.vendorName = (json['vendor'] is String)
        ? json['vendor'] as String
        : (json['vendor']?['name'] as String?);

    model.rate = json['rate'] as int?;

    model.transmission = json['transmission'] as String? ?? 'Manual';

    model.price = (json['price'] is double)
        ? (json['price'] as double).toInt()
        : (json['price'] as int?);

    model.freeKm = json['Free Km'] ?? json['freeKm'];

    model.type = json['type'] as String?;

    model.ratePerKm = json['ratePerKm'] as int?;

    model.ratePerHr = json['rateperhr'] as int?;

    model.toll = json['toll'];

    model.weekdayperhr = double.tryParse(json['weekdayperhr'].toString());

    model.weekendperhr = double.tryParse(json['weekendperhr'].toString());

    model.weekdayprice = double.tryParse(json['weekdayprice'].toString());

    model.weekendprice = double.tryParse(json['weekendprice'].toString());

    model.extraKmCharge = json['Extra Km Charge'] ?? json['extraKmCharge'];

    model.pickUpAndDrop = json['Pick/Drop Location'] as String? ?? json['pickupLocation'] as String?;

    model.driverCharges = json['driverCharges'] as int?;

    model.minHrs = json['minhrs'] as int?;

    model.drive = json['drive'] as String?;

    if (json['pickupLocations'] != null) {
      model.pickups = (json['pickupLocations'] as List)
          .map((e) => PickupModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return model;
  }
}

class Vendor {
  String? name;
  String? promoCode;
  String? imageUrl;
  double? rating;
  num? currentRate;
  double? discountRate;
  num? taxRate;
  double? securityDeposit;
  double? subSecurityDeposit;
  double? advancePay;
  String? offer;
  Api? api;
  String? plateColor;
  MinHrsTillBooking? minHrsTillBooking;
  bool? isV6;
  Map? discountMap;

  Vendor(
      {required this.name,
      required this.imageUrl,
      required this.currentRate,
      required this.discountRate,
      required this.securityDeposit,
      required this.subSecurityDeposit,
      required this.advancePay,
      required this.plateColor,
      required this.rating,
      required this.offer,
      required this.discountMap,
      this.api,
      required this.taxRate});

  Vendor.fromJson(Map<String, dynamic> json, DriveTypes type) {
    isV6 = json['isV6'] is bool ? json['isV6'] : false;
    //print("v16 issue");
    final String drive = getDrive(type);

    discountMap = (json['DiscountMap'] is Map)
        ? Map<String, dynamic>.from(json['DiscountMap'])
        : {};

    api = Api.fromJson(json['Api'] as Map<String, dynamic>?);

    //print("Api parsing issue");

    offer = json['Offer']?.toString() ?? '';
    //print("Offer part $offer issue");

    name = json['vendor']?.toString() ?? json['name']?.toString() ?? '';
    imageUrl =
        json['Imageurl']?.toString() ?? json['imageUrl']?.toString() ?? '';
    plateColor = json['p Color']?.toString() ?? '';
    //print("Platecolor parsing issue");

    advancePay = _parseDouble(json['advancePay']) ??
        _parseDouble(json['BookingAmount']) ??
        0;

    currentRate = _parseNum(json['currentRate']) ??
        _parseNum(json['Currentrate$drive']) ??
        0;

    discountRate = _parseDouble(json['discountRate']) ??
        _parseDouble(json['Discount$drive']) ??
        0;

    taxRate = _parseNum(json['taxRate']) ?? _parseNum(json['Tax$drive']) ?? 0;
    //print("Tax rate issue");
    rating = double.tryParse(json['rating']?.toString() ?? '3') ?? 3.0;
    minHrsTillBooking =
        MinHrsTillBooking.fromJson(json['minHrsTillBooking'] ?? {});
    //print("minhrstill issue");
    promoCode = json['promoCode'] ?? "";
    //print("promo issue");
    if (type == DriveTypes.SD || type == DriveTypes.SUB) {
      securityDeposit = double.tryParse(json['Securitydeposit'] ?? '0');
      subSecurityDeposit =
          double.tryParse(json['subSecurityDeposit'] ?? '0');
    } else {
      securityDeposit = 0;
    }
  }

  double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  num? _parseNum(dynamic val) {
    if (val == null) return null;
    if (val is num) return val;
    if (val is String) return num.tryParse(val);
    return null;
  }

  String getDrive(DriveTypes type) {
    switch (type) {
      case DriveTypes.WC:
        return 'Cd';
      case DriveTypes.SD:
        return 'Sd';
      case DriveTypes.SUB:
        return 'subscription';
      case DriveTypes.RT:
        return 'Os';
      case DriveTypes.AT:
        return 'At';
      case DriveTypes.OW:
        return 'Ow';
      default:
        return '';
    }
  }
}

class Api {
  bool? pu;
  bool? hd;

  Api.fromJson(Map<String, dynamic>? json) {
    json ??= <String, dynamic>{};
    //print("inside API call");
    pu = json['PU'] ?? false;
    //print("inside API call pu is working fine = ${pu}");
    hd = json['HD'] ?? false;
    //print("inside API call hd is working fine = ${hd}");
  }
}

class MinHrsTillBooking {
  double? sd;
  double? sub;

  MinHrsTillBooking.fromJson(Map<String, dynamic> json) {
    sd = getDouble(json['sd']) ?? 12;
    sub = getDouble(json['sub']) ?? 24;
  }

  double? getDouble(val) {
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 12;
    return null;
  }
}

class PickupModel {
  String? pickupAddress;
  var deliveryCharges;
  var locationId;
  double? distanceFromUser;

  PickupModel(
      {required this.pickupAddress, this.deliveryCharges, this.locationId});

  PickupModel.fromJson(Map json) {
    pickupAddress = json['HubAddress'] ?? json['location'];
    deliveryCharges =
        json['price'] ?? int.tryParse(json['DeliveryCharge']) ?? 0;
    locationId = '${json['LocationKey']}';
  }
}
