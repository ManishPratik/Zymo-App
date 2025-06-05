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
  late DocumentModel documents;
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
  late DateTime startDateTime;
  late DateTime endDateTime;

  DriveModel(
      {this.drive,
      this.mapLatLng,
      this.distanceOs,
      this.hrs,
      this.startDate,
      this.endDate,
      this.city,
      this.starttime,
      this.endtime,
      this.mapLocation,
      this.remainingDuration,
      this.type,
      this.weekdays,
      this.terminalId,
      this.weekends,
      this.weekendhr,
      this.weekdayhr});

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
  String? name;
  String? imageUrl;
  List<String>? multiImages;
  var seats;
  int? rate;
  String? fuel;
  String? transmission;
  String? type;
  int? price;
  var freeKm;
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
  double? finalDiscount;
  double? finalPrice;
  double? actualPrice;  // Added this property
  String? drive;
  int? extraKmCharge;
  int? extraHrCharge;
  String? vendorName;
  String? pickUpAndDrop;
  String? locationId;
  List<PickupModel>? pickups;
  var toll;
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
  late String packageName;
  late MyChoizeModel myChoizeModel;
  late PickupModel selectedPickup;

  CarModel({
    this.name,
    this.fuel,
    this.transmission,
    this.apiFlag,
    this.seats,
    this.imageUrl,
    this.freeKm,
    this.finalPrice,
    this.finalDiscount,
    this.actualPrice,  // Added to constructor
    this.isSoldOut,
    this.extraKmCharge,
  });

  static String? getFreeKm(DriveModel model, CarModel carModel) {
    String? freekms;
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
            "${CarServices.getFreeKm(carModel.freeKm, model.weekdayhr, model.weekendhr, carModel.apiFlag!)} KMs FREE";
      }
    } else if (model.drive == DriveTypes.AT) {
      freekms = 'Includes ${carModel.freeKm} KMs';
    } else {
      if (freekms is String && freekms.toLowerCase().contains('free')) {
        freekms = '${carModel.freeKm}';
      } else {
        freekms = '${carModel.freeKm} Free KMs';
      }
    }
    return freekms;
  }

  CarModel.fromJson(
      Map<String, dynamic> json, Vendor? tempVendor, DriveTypes driveType,
      {DriveModel? driveModel, bool? isApi}) {
    try {
      if (driveType == DriveTypes.OW) {
        if (tempVendor!.advancePay == 0) {
          return;
        }
      }
      if (driveType == DriveTypes.SD) {
        final bool is24 = driveModel!.startDateTime
            .subtract(Duration(hours: 24))
            .isAfter(DateTime.now());
        final int tripDurationInHours =
            driveModel.endDateTime.difference(driveModel.startDateTime).inHours;
        if ((tempVendor!.name == myChoize || tempVendor.name == avis) &&
            ((tripDurationInHours < 24) || !is24)) {
          return;
        }
      }

      apiFlag = isApi ?? false;
      vendor = tempVendor;

      // Handle both original and new API response formats
      if (isApi == true) {
        // New API format
        name = json['BrandName'];
        transmission = json['TransMissionType'] ?? 'Manual';
        seats = json['SeatingCapacity'];
        fuel = json['FuelType'];
        price = (json['PerUnitCharges'] ?? 0).toInt();
        actualPrice = price?.toDouble();  // Set actualPrice from PerUnitCharges
        ratePerKm = (json['ExKMRate'] ?? 0).toInt();
        freeKm = json['RateBasisDesc']?.toString();
        type = json['GroupName'];
        vendorName = tempVendor?.name;
        locationId = json['LocationKey']?.toString();
        pickUpAndDrop = json['LocationName'];
        isSoldOut = (json['TotalAvailableVehicle'] ?? 0) == 0;
        extraKmCharge = (json['ExKMRate'] ?? 0).toInt();
        imageUrl = json['VehicleBrandImageName'];
      } else {
        // for other apis
        isSoldOut = json['isSoldOut'];
        name = json['name'];
        imageUrl = json['imageurl'] ?? json['imageUrl'];
        seats = json['seats'];
        fuel = json['fuel'];
        vendorName =
            json['vendor'] is String ? json['vendor'] : json['vendor']['name'];
        rate = json['rate'];
        transmission = json['transmission'] ?? 'Manual';
        price = json['price'] is double ? json['price'].toInt() : json['price'];
        actualPrice = json['actualPrice']?.toDouble() ?? price?.toDouble();  // Set actualPrice from JSON or price
        freeKm = json['Free Km'] ?? json['freeKm'];
        type = json['type'];
        ratePerKm = json['ratePerKm'];
        ratePerHr = json['rateperhr'];
        // locationId = json['LocationID']?.toString();
        // pickUpAndDrop = json['LocationName'];
        toll = json['toll'];
        weekdayperhr = double.tryParse(json['weekdayperhr'].toString()) ?? 0;
        weekendperhr = double.tryParse(json['weekendperhr'].toString()) ?? 0;
        weekdayprice = double.tryParse(json['weekdayprice'].toString()) ?? 0;
        weekendprice = double.tryParse(json['weekendprice'].toString()) ?? 0;
        extraKmCharge = json['Extra Km Charge'] ?? json['extraKmCharge'];
        pickUpAndDrop = json['Pick/Drop Location'] ?? json['pickupLocation'];
        driverCharges = json['driverCharges'];
        minHrs = json['minhrs'];
        drive = json['drive'];
        pickups = json['pickupLocations'] != null
            ? (json['pickupLocations'] as List)
                .map((k) => PickupModel.fromJson(k))
                .toList()
            : null;
      }

      // Handle pricing based on drive type
      switch (driveType) {
        case DriveTypes.WC:
          finalDiscount = CarLogic.getFinalDiscountCd(
              vendor!, price!, ratePerHr!, driveModel!.hrs!);
          finalPrice = CarLogic.getFinalPriceCd(
              vendor!, price!, ratePerHr!, driveModel.hrs!);
          break;
        case DriveTypes.SD:
          finalDiscount = CarLogic.getFinalDiscountSD(
              vendor,
              weekdayprice,
              weekendprice,
              driveModel!.weekendhr,
              driveModel.weekdayhr,
              weekendperhr,
              weekdayperhr,
              driveModel.weekdays,
              driveModel.weekends,
              apiFlag!,
              price);
          finalPrice = CarLogic.getFinalPriceSD(
            vendor,
            weekdayprice,
            weekendprice,
            driveModel.weekendhr,
            driveModel.weekdayhr,
            weekendperhr,
            weekdayperhr,
            driveModel.weekdays,
            driveModel.weekends,
            price,
            apiFlag!,
          );
          break;
        case DriveTypes.SUB:
          if (isApi == true) {
            finalDiscount = 0.0;
            finalPrice = json['TotalExpCharge']?.toDouble() ?? 0.0;
            actualPrice = price?.toDouble() ?? 0.0;  // Set actualPrice for SUB type
          } else {
            finalDiscount = CarLogic.getFinalDiscountSd(vendor!, price!);
            finalPrice = CarLogic.getFinalPriceSd(vendor!, price!);
          }
          break;
        case DriveTypes.RT:
          finalDiscount = CarLogic.getFinalDiscountOs(vendor!,
              distance: driveModel!.distanceOs!,
              hours: driveModel.hrs!,
              ratePerKm: ratePerKm!,
              driverCharges: driverCharges);
          finalPrice = CarLogic.getFinalPriceOs(vendor!, driveModel.hrs!,
              ratePerKm!, driveModel.distanceOs!, driverCharges);
          break;
        case DriveTypes.AT:
          finalDiscount = CarLogic.getFinalDiscountAt(vendor!, price!);
          finalPrice = CarLogic.getFinalPriceAt(vendor!, price!);
          break;
        case DriveTypes.OW:
          finalDiscount = CarLogic.getFinalDiscountOs(vendor!,
              distance: driveModel!.distanceOs!,
              hours: driveModel.hrs!,
              ratePerKm: ratePerKm!,
              driverCharges: driverCharges);
          finalPrice = CarLogic.getFinalPriceOs(vendor!, driveModel.hrs!,
              ratePerKm!, driveModel.distanceOs!, driverCharges);
          break;
      }
    } catch (e) {
      print('Error parsing car model: $e');
      rethrow;
    }
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
  late MinHrsTillBooking minHrsTillBooking;
  late bool isV6;
  Map? discountMap;
  Vendor(
      {this.name,
      this.imageUrl,
      this.currentRate,
      this.discountRate,
      this.securityDeposit,
      this.subSecurityDeposit,
      this.advancePay,
      this.plateColor,
      this.rating,
      this.offer,
      this.discountMap,
      this.api,
      this.taxRate});
  Vendor.fromJson(Map<String, dynamic> json, DriveTypes? type) {
    isV6 = json['isV6'] ?? false;
    final String drive = getDrive(type);
    discountMap = json['DiscountMap'] ?? {};
    api = Api.fromJson(json['Api']);
    offer = json['Offer'];
    name = json['vendor'] ?? json['name'];
    imageUrl = json['Imageurl'] ?? json['imageUrl'];
    plateColor = json['plateColor'];
    advancePay =
        json['advancePay'] ?? double.tryParse(json['BookingAmount'] ?? '') ?? 0;
    currentRate =
        json['currentRate'] ?? double.tryParse(json['Currentrate$drive'] ?? '');
    discountRate =
        json['discountRate'] ?? double.tryParse(json['Discount$drive'] ?? '');
    taxRate = json['taxRate'] ?? double.tryParse(json['Tax$drive'] ?? '');
    rating = double.tryParse(json['rating'].toString()) ?? 3;
    minHrsTillBooking = MinHrsTillBooking.fromJson(json['minHrsTillBooking']);
    promoCode = json['promoCode'];
    if (type == DriveTypes.SD || type == DriveTypes.SUB) {
      securityDeposit = double.tryParse(json['Securitydeposit'] ?? '') ?? 0;
      subSecurityDeposit = double.tryParse(json['subSecurityDeposit'] ?? '');
    } else {
      securityDeposit = 0;
    }
  }
  String getDrive(DriveTypes? type) {
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
    if (json != null) {
      pu = json['PU'];
      hd = json['HD'];
    } else {
      pu = true;
      hd = true;
    }
  }
}

class MinHrsTillBooking {
  late double sd;
  late double sub;

  MinHrsTillBooking.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      sd = getDouble(json['sd']) ?? 12;
      sub = getDouble(json['sub']) ?? 24;
    } else {
      sd = 12;
      sub = 24;
    }
  }
  double? getDouble(val) {
    if (val is double) {
      return val;
    } else if (val is int) {
      return val.toDouble();
    } else if (val is String) {
      return double.tryParse(val);
    } else {
      return null;
    }
  }
}

class PickupModel {
  String? pickupAddress;
  num? deliveryCharges;
  String? locationId;
  double? distanceFromUser;
  @override
  bool operator ==(Object other) {
    return (other is PickupModel) && other.pickupAddress == pickupAddress;
  }
  PickupModel({this.pickupAddress, this.deliveryCharges, this.locationId});

  PickupModel.fromJson(Map? json) {
    if (json != null) {
      pickupAddress = json['HubAddress'] ?? json['location'];
      deliveryCharges =
          json['price'] ?? int.tryParse(json['DeliveryCharge']) ?? 0;
      locationId = '${json['LocationKey']}';
    }
  }
}
