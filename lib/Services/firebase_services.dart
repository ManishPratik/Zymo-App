import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/aircraft_model.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/models/rent_pay_model.dart';
import 'package:letzrentnew/models/user_model.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:provider/provider.dart';

import 'auth_services.dart';

class FirebaseServices {
  User? get user => Auth().getCurrentUser();
  final FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<bool> addReferralVouchers(
      String referralUid, String? uid, int amount) async {
    final String date = dateFormatter.format(DateTime.now());
    // mixpanel!.track('Referral Complete', properties: {'uid': uid});
    final Map<String, dynamic> voucherData = {
      'validFor': 'any',
      'amount': amount,
      'validFrom': date
    };
    await firebase
        .collection(users)
        .doc(uid)
        .collection('vouchers')
        .doc(referralUid)
        .set(voucherData);
    await firebase
        .collection(users)
        .doc(referralUid)
        .collection('vouchers')
        .doc(uid)
        .set(voucherData);
    return true;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBanner() async {
    return firebase.collection('ZymoBannerImages').doc('images').get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCategory(
      String title) async {
    return firebase.collection('CategoriesImages').doc(title).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBrands() async {
    return firebase.collection('BrandImages').doc('images').get();
  }

  Future<Map<String, dynamic>?> getVoucherAmount() async {
    final data = await firebase.collection('BrandImages').doc('voucher').get();
    return data.data();
  }

  Future<void> setUserDetails(String uid, String? name, String? email,
      {String? phone}) async {
    await firebase
        .collection(users)
        .doc(uid)
        .set({'name': name, 'email': email, 'phone': phone});
  }

  // Future<void> updatelUserDetails(Map map) async {
  //   await firebase
  //       .collection(users)
  //       .doc(user!.uid)
  //       .update(map as Map<Object, Object?>);
  // }

  Future<UserModel?> getUserDetails(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> data =
        await firebase.collection('carsuserData').doc(uid).get();
    if (data.exists && data.data() != null) {
      final UserModel user = UserModel.fromJson(data.data());
      return user;
    } else {
      return null;
    }
  }

  Future<String?> getCoLivingText() async {
    final DocumentSnapshot response = await firebase
        .collection('colivingvendors')
        .doc('textDataCoLivingTile')
        .get();
    final Map data = response.data() as Map<dynamic, dynamic>;
    final String? text = data['text'];
    return text;
  }

  Future addNewVoucher(int amount, BuildContext context,
      {DateTime? validFromDateTime,
      bool? indicator,
      DateTime? validTillDateTime}) async {
    final String uid = user!.uid;
    final DateTime time = DateTime.now();
    final String voucherId = uid + time.toString();
    final String validFrom = dateFormatter.format(validFromDateTime ?? time);
    final String? validTill = validTillDateTime != null
        ? dateFormatter.format(validTillDateTime)
        : null;

    const String validFor = 'any';
    final Map<String, dynamic> data = {
      'validTill': validTill,
      'amount': amount,
      'validFrom': validFrom,
      'id': voucherId,
      'validFor': validFor
    };
    await firebase
        .collection(users)
        .doc(uid)
        .collection('vouchers')
        .doc(voucherId)
        .set(data);
    if (indicator == null) {
      final HomeProvider locationProvider =
          Provider.of<HomeProvider>(context, listen: false);
      locationProvider.setRewardIndicator(true);
    }
  }

  Future<void> addUserDocument(String documentName, String? url) async {
    await firebase.collection(users).doc(user!.uid).set({
      documentName: url,
    }, SetOptions(merge: true));
  }

  Future<RentPayModel> getRentPayDetails(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> data =
        await firebase.collection('payrentuserData').doc(uid).get();
    return RentPayModel.fromJson(data.data());
  }

  Future<void> setUserFCMToken(String? fcmToken) async {
    if (user?.uid != null && fcmToken != null) {
      final Map<String, dynamic> data = {
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await firebase
          .collection(users)
          .doc(user!.uid)
          .collection('tokens')
          .doc(user!.uid)
          .set(data);
    }
  }

  Future<bool> cancelOrder(String? documentId) async {
    // mixpanel!.track('Order cancelled by user',
    //     properties: {'User': user.toString()});
    try {
      await firebase
          .collection(carsPaymentSuccessDetails)
          .doc(documentId)
          .update({'Cancelled': true, 'CancellationDate': DateTime.now()});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> carAddPaymentSuccessData(Map<String, dynamic> data) async {
    await firebase.collection(carsPaymentSuccessDetails).add(data);
  }

  Future<QuerySnapshot> getOffers() async {
    return firebase.collection('Offers').get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserVouchers() async {
    return firebase
        .collection(users)
        .doc(user!.uid)
        .collection('vouchers')
        .get();
  }

  Future<void> addDataToFirestore(Map<String, dynamic> data) async {
    await firebase.collection('carsuserData').doc(user!.uid).set(data);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocuments() {
    return firebase.collection(users).doc(user!.uid).snapshots();
  }

  Future<void> updatePromoCode(String? promoCode) async {
    if (promoCode != null && promoCode.isNotEmpty) {
      await firebase.collection('promocode').doc(promoCode).update({
        '${user!.uid}': 'used',
      });
    }
  }

  Future updateUserVoucher(String? voucherId) async {
    if (voucherId != null && voucherId.isNotEmpty) {
      await firebase
          .collection(users)
          .doc(user!.uid)
          .collection('vouchers')
          .doc(voucherId)
          .delete();
    }
  }

  Future<UserModel> getUserData() async {
    final data = await firebase.collection(users).doc(user!.uid).get();
    return UserModel.fromJson(data.data());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCarCity(String type) async {
    return await firebase.collection('CarCities').doc(type).get();
  }

  Future<DocumentSnapshot> getCarGroupingNames() async {
    return await firebase.collection('CarClubbing').doc('Car Keyword').get();
  }

  Future<void> rateVendor(String? vendor, String? carname, int rating,
      String comment, String? bookingId) async {
    final data = {
      'Vendor': vendor,
      'Car': carname,
      'Rating': rating,
      'Comment': comment,
      'User ID': user!.uid
    };
    await firebase.collection('User Ratings').doc(bookingId).set(data);
  }

  Future<Map?> getCancellationData() async {
    final doc =
        await firebase.collection('CarClubbing').doc('cancellationtext').get();
    return doc.data();
  }

  Future<bool> submitCancellationRequest(
      String? bookingId,
      String? screenshotLink,
      String additionalInfo,
      String email,
      String? documentId) async {
    try {
      final data = {
        'Booking ID': bookingId,
        'User ID': user!.uid,
        'Screenshot Link': screenshotLink,
        'Additional Information': additionalInfo,
        'Email': email,
        'Timestamp': DateTime.now()
      };
      await firebase.collection('Cancellation Requests').add(data);
      await cancelOrder(documentId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitRefundRequest(String? bookingId, String? screenshotLink,
      String additionalInfo, String? email, String? documentId) async {
    try {
      final data = {
        'Booking ID': bookingId,
        'User ID': user!.uid,
        'Screenshot Link': screenshotLink,
        'Additional Information': additionalInfo,
        'Email': email,
        'Timestamp': DateTime.now()
      };
      await firebase.collection('Refund Requests').add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRentPayData() async {
    const String s = '0';
    return firebase.collection('RentPay').doc(s).get();
  }

  Future<void> setRentPayUserData(Map data) async {
    await firebase
        .collection('payrentuserData')
        .doc(user!.uid)
        .set(data as Map<String, dynamic>);
  }

  Future<void> addRentPaySuccessData(Map data) async {
    await firebase
        .collection('RentPayPaymentSuccessDetails')
        .add(data as Map<String, dynamic>);
  }

  Future<List<AircraftModel>> getAircrafts(String city) async {
    final List<AircraftModel> aircraftList = [];
    final QuerySnapshot<Map<String, dynamic>> aircrafts =
        await firebase.collection('aircrafts${city}').get();
    aircrafts.docs
        .forEach((doc) => aircraftList.add(AircraftModel.fromJson(doc.data())));
    return aircraftList;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPromoAmount(
      String? promoCode) async {
    final DocumentSnapshot<Map<String, dynamic>> couponData =
        await firebase.collection('promocode').doc(promoCode).get();
    return couponData;
  }

  Future getCities() async {
    return await firebase.collection('CarCities').doc('sd').get();
  }

  static Future<List<CarModel>> getCarOnRent(
      DriveModel model, int tripDurationInHours, Vendor? vendor) async {
    final firebaseCars = await FirebaseFirestore.instance
        .collection('testCollection')
        .where('vendor', isEqualTo: 'carOnRent')
        .get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final unlimitedKms = data['Unlimited KM'];
      final price = unlimitedKms ?? data['price'];
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['extraKmCharge']
        ..extraHrCharge = data['rateperhr']
        ..freeKm = unlimitedKms == null
            ? (250 / 24 * tripDurationInHours).toInt()
            : null
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['fuel']
        ..pickUpAndDrop = data['pickupLocation']
        ..pickups = coR
        ..imageUrl = data['imageUrl']
        ..name = data['name']
        ..transmission = data['Transmission']
        ..seats = data['seats']
        ..vendor = vendor
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor!.currentRate
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getKyp(
      DriveModel model, int tripDurationInHours, Vendor? vendor) async {
    final firebaseCars = await FirebaseFirestore.instance
        .collection('testKyp')
        // .where('vendor', isEqualTo: kyp)
        .get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final unlimitedKms = num.tryParse(data['Unlimited kM ']);
      final price = unlimitedKms ?? data['Price (Package1)'];
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr Rate']
        ..freeKm = unlimitedKms ?? (250 / 24 * tripDurationInHours).toInt()
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel Type']
        ..pickUpAndDrop = data['Pick-Up location']
        ..pickups = [
          PickupModel(
              pickupAddress: data['Pick-Up location'],
              deliveryCharges: 0,
              locationId: ''),
          PickupModel(
              pickupAddress: homeDelivery,
              deliveryCharges: data['Home Delivery Charges'],
              locationId: ''),
        ]
        ..imageUrl = data['imageUrl'] ??
            'https://cdn.dribbble.com/users/372814/screenshots/14189965/car-loading-animation.gif'
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..seats = data['seats']
        ..vendor = vendor
        ..apiFlag = true
        ..selectedPickup
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor!.currentRate
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getHrx(
      DriveModel model, int tripDurationInHours, Vendor? vendor) async {
    final firebaseCars =
        await FirebaseFirestore.instance.collection('testHrxCars').get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final unlimitedKms = data['Unlimited KM'];
      final price = unlimitedKms ?? data['price'];
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['extraKmCharge']
        ..extraHrCharge = data['rateperhr']
        ..freeKm = (250 / 24 * tripDurationInHours).toInt()
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['fuel']
        ..pickUpAndDrop = data['pickup/ drop location']
        ..imageUrl = data['imageUrl']
        ..name = data['name']
        ..transmission = data['Transmission']
        ..seats = data['seats']
        ..vendor = vendor
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor!.currentRate
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getWheelUp(
      DriveModel model, int tripDurationInHours, Vendor vendor) async {
    final firebaseCars = await FirebaseFirestore.instance
        .collection('testWheelsUp')
        .doc(model.city)
        .collection("Cars")
        .get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final price = data['price'];
      vendor.securityDeposit = (data["Security Deposit"] as int).toDouble();
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr Rate']
        ..freeKm = data["Free Kms"]
        ..pickups = [
          PickupModel(
              pickupAddress: data["Pick-Up location"], deliveryCharges: 0),
          PickupModel(
              pickupAddress: "$homeDelivery (Upto 20KMs, 8AM-8PM)",
              deliveryCharges: 700),
          PickupModel(pickupAddress: homeDelivery, deliveryCharges: 1100)
        ]
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel Type']
        ..pickUpAndDrop = data['Pick-Up location']
        ..imageUrl = data['imageUrl']
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..seats = data['seats'] ?? 4
        ..vendor = vendor
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor.currentRate
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getKos(
      DriveModel model, Vendor vendor, int tripDurationInHours) async {
    final firebaseCars = await FirebaseFirestore.instance
        .collection('testKos')
        .doc("Delhi NCR")
        .collection("Cars")
        .get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final price = data['Price (Package1)'];
      vendor.securityDeposit = (data["Security Deposit"] as int).toDouble();
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr Rate']
        ..freeKm = data["KM  (Package1)"]
        ..pickups = [
          PickupModel(
              pickupAddress: data["Pick-Up location"], deliveryCharges: 0),
          PickupModel(pickupAddress: homeDelivery, deliveryCharges: 600)
        ]
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel Type']
        ..pickUpAndDrop = data['Pick-Up location']
        ..imageUrl = data['imageUrl']
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..seats = data['seats'] ?? 4
        ..vendor = vendor
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor.currentRate
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getVuk(
    DriveModel model,
    Vendor vendor,
    int tripDurationInHours,
  ) async {
    final firebaseCars = await FirebaseFirestore.instance
        .collection('testKos')
        .doc("Delhi NCR")
        .collection("Cars")
        .get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final price = data['Price (Package1)'];
      vendor.securityDeposit = (data["Security Deposit"] as int).toDouble();
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr Rate']
        ..freeKm = data["KM  (Package1)"]
        ..pickups = [
          PickupModel(
              pickupAddress: data["Pick-Up location"], deliveryCharges: 0),
          PickupModel(pickupAddress: homeDelivery, deliveryCharges: 1000)
        ]
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel Type']
        ..pickUpAndDrop = data['Pick-Up location']
        ..imageUrl = data['imageUrl']
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..seats = data['seats'] ?? 4
        ..vendor = vendor
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor.currentRate
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getZt(
      DriveModel model, Vendor vendor, int tripDurationInHours) async {
    final firebaseCars = await FirebaseFirestore.instance
        .collection('testZt')
        .doc(model.city)
        .collection("Cars")
        .get();
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      // final unlimitedKms = data['Unlimited kM'];
      final String priceString = data['Price (Package1)'];
      final List<String> priceParts = priceString.split(' ');
      final price = int.tryParse(priceParts[0]) ?? 0;
      vendor.securityDeposit = (data["Security Deposit"]).toDouble();
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr Rate']
        //..freeKm = (250 / 24 * tripDurationInHours).toInt()
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel Type']
        ..pickUpAndDrop = data['Pick-Up location']
        ..deliveryCharges = data['Home Delivery Charges']
        ..freeKm = data['KM Limit']
        ..imageUrl = data['imageUrl']
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..vendor = vendor
        ..finalDiscount =
            (price / 24) * tripDurationInHours * vendor.currentRate!
        ..finalPrice = (price / 24) *
            tripDurationInHours *
            vendor.currentRate! *
            vendor.discountRate!;
      return carModel;
    }).toList();
  }

  static Future<List<CarModel>> getKaryana(
      DriveModel model,
      int tripDurationInHours,
      Vendor? vendor,
      String city,
      bool isAbove24Hours) async {
    QuerySnapshot<Map<String, dynamic>> firebaseCars;
    if (isAbove24Hours) {
      firebaseCars = await FirebaseFirestore.instance
          .collection('testKaaryana')
          .doc(city)
          .collection("Cars")
          .get();
    } else {
      firebaseCars = await FirebaseFirestore.instance
          .collection('testKaaryana')
          .doc(city)
          .collection("CarsBelow24")
          .get();
    }
    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      try {
        /////Her is fetching the Karyana
        if (data['isSoldOut'] == true) {
          DateTime now = DateTime.now();

          String formattedDate =
              '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          String originalTimeString =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
          String? originalDateString = data['soldOutTillDate'];
          if (originalDateString != null) {
            DateTime originalDate = DateTime.parse(originalDateString);

            List<String> parts = originalTimeString.split(':');
            int hour = int.parse(parts[0]);
            int minute = int.parse(parts[1]);

            String period = 'AM';
            if (hour >= 12) {
              period = 'PM';
              if (hour > 12) {
                hour -= 12;
              }
            }
            if (hour == 0) {
              hour = 12;
            }
            String formattedTime =
                '$hour:${minute.toString().padLeft(2, '0')} $period';
            String formattedEndDate =
                '${originalDate.year}-${originalDate.month.toString().padLeft(2, '0')}-${originalDate.day.toString().padLeft(2, '0')}';
            DateTime date1 = DateTime.parse(formattedDate);
            DateTime date2 = DateTime.parse(formattedEndDate);
            if (date1.isAfter(date2)) {
              e.reference.update({'isSoldTrue': true});
            }
          }
        }
      } catch (e) {
        print('not soldout feild found');
      }
      final perHourRate =
          isAbove24Hours ? (data['price'] / 24) : data["below24HourRate"];
      vendor!.securityDeposit =
          data["Security Deposit"] ?? vendor.securityDeposit;
      final deliveryCharges = data["Home Delivery Charges"];
      final pickups = [
        PickupModel()
          ..pickupAddress =
              data['pickup/ drop location'] ?? data["Pick-up location"]
          ..deliveryCharges = 0,
        PickupModel()
          ..pickupAddress = "Delivery & Pickup"
          ..deliveryCharges = getRate(model),
      ];
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr rate']
        ..freeKm = isAbove24Hours
            ? (data["freeKms"] / 24 * tripDurationInHours).toInt()
            : 6 * tripDurationInHours
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel Type']
        ..pickUpAndDrop =
            data['pickup/ drop location'] ?? data["Pick-up location"]
        ..imageUrl = data["imageUrl"] ?? data['ImageUrl']
        ..type = data["Type"]
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..deliveryCharges = deliveryCharges
        ..pickups = pickups
        ..seats = data['seats']
        ..vendor = vendor
        ..finalDiscount = perHourRate * tripDurationInHours * vendor.currentRate
        ..finalPrice = perHourRate *
            tripDurationInHours *
            vendor.currentRate *
            vendor.discountRate;
      return carModel;
    }).toList();
  }
  //Taufique

  static Future<List<CarModel>> getKaryanaMonthly(
      DriveModel model, Vendor? vendor, String city) async {
    QuerySnapshot<Map<String, dynamic>> firebaseCars = await FirebaseFirestore
        .instance
        .collection('testKaaryana')
        .doc(city)
        .collection("Monthly")
        .get();

    return firebaseCars.docs.map((e) {
      final Map data = e.data();
      final monthlyRate = data["Monthly Rates"];
      vendor!.securityDeposit =
          data["Security Deposit"] ?? vendor.securityDeposit;
      final deliveryCharges = data["Home Delivery Charges"];
      final pickups = [
        PickupModel()
          ..pickupAddress = data['Pick up']
          ..deliveryCharges = 0,
        PickupModel()
          ..pickupAddress = "Delivery & Pickup"
          ..deliveryCharges = getRate(model),
      ];
      final CarModel carModel = CarModel(apiFlag: true)
        ..extraKmCharge = data['Extra Km Rate']
        ..extraHrCharge = data['Extra Hr rate']
        ..freeKm = data["Monthly KM"]
        ..isSoldOut = data['isSoldOut']
        ..fuel = data['Fuel']
        ..pickUpAndDrop = data['Pick up'] ?? data["Pick-up location"]
        ..imageUrl = data["imageUrl"] ?? data['ImageUrl']
        ..type = data["Type"]
        ..name = data['Car Name']
        ..transmission = data['Transmission']
        ..deliveryCharges = deliveryCharges
        ..pickups = pickups
        ..seats = data['seats']
        ..vendor = vendor
        ..finalDiscount = monthlyRate * vendor.currentRate
        ..finalPrice = monthlyRate * vendor.currentRate * vendor.discountRate;
      return carModel;
    }).toList();
  }

  Future<Map?> getUpdateInfo() async {
    final doc =
        await firebase.collection('UpdateInformation').doc('updateInfo').get();
    return doc.data();
  }

  Future<void> addUserData(Map<String, dynamic> json) async {
    await firebase
        .collection(users)
        .doc(user!.uid)
        .set(json, SetOptions(merge: true));
  }

  static num getRate(DriveModel model) {
    int rate = 0;
    if (model.endDateTime.hour > 6 && model.endDateTime.hour < 22) {
      rate += 750;
    } else {
      rate += 1000;
    }
    if (model.endDateTime.hour > 6 && model.startDateTime.hour < 22) {
      rate += 750;
    } else {
      rate += 1000;
    }
    return rate;
  }

// Partner App Code
  static Future<List<CarModel>> getPartnerAppCars(
      DriveModel model, int tripDurationInHours, Vendor? vendor) async {
    if (vendor == null) return [];
    // fetch the list of Partner App Vendors
    final partnerVendorList =
        await FirebaseFirestore.instance.collection('partnerAppVendors').get();
    List<CarModel> carList = [];

    for (var doc in partnerVendorList.docs) {
      final String vendorId = doc.id;
      final Map<String, dynamic> data = doc.data();
      final String brandName = data['brandName'];
      // Map the vendor in Partner Vendor List and the vendor passed in this function
      if (brandName == vendor.name) {
        if (await checkCity(vendorId, model)) {
          final firebaseCars = await FirebaseFirestore.instance
              .collection('partnerAppVendors')
              .doc(vendorId)
              .collection('Cars')
              .get();

          for (var doc in firebaseCars.docs) {
            final Map<String, dynamic> data = doc.data();
            final List<dynamic> packages = data['packages'] ?? [];
            dynamic price = 0;

            // Fetch price dynamically from the packages array
            for (var package in packages) {
              if (package is Map<String, dynamic> &&
                  package.containsKey('price')) {
                price = package['price'];
                break; 
              }
            }
            final CarModel carModel = CarModel(apiFlag: true)
              ..extraKmCharge = data['extra_km_rate'] ?? 0
              ..extraHrCharge = data['extra_hr_rate'] ?? 0
              ..freeKm = (250 / 24 * tripDurationInHours).toInt()
              ..isSoldOut = data['isSoldOut'] ?? false
              ..fuel = data['fuel'] ?? ''
              ..pickUpAndDrop = data['pick_up_location'] ?? ''
              ..imageUrl = (data['image_urls'] as List<dynamic>).join(', ')
              ..name = data['car_name'] ?? ''
              ..transmission = data['transmission'] ?? ''
              ..seats = data['seats'] ?? 5
              ..vendor = vendor
              ..finalDiscount =
                  (price / 24) * tripDurationInHours * vendor.currentRate
              ..finalPrice = (price / 24) *
                  tripDurationInHours *
                  vendor.currentRate *
                  vendor.discountRate;
            carList.add(carModel);
          }
          //print("City Matched");
        } else {
          print("Not Available in this City");
        }
      }
    }
    return carList;
  }

  // returning the list of partnervendors
  Future<List<String>> partnerVendorList() async {
    final vendorListSnapshot = await FirebaseFirestore.instance
        .collection('carvendors')
        .doc('partnerApp')
        .collection('partnerAppVendors')
        .get();

    List<String> vendorIds =
        vendorListSnapshot.docs.map((doc) => doc.id).toList();
    return vendorIds;
  }

  static Future<bool> checkCity(vendorId, DriveModel model) async {
    try {
      List<String> cities = await getVendorCities(vendorId);
      HashSet<String> citiesSet = HashSet<String>.from(cities);

      if (citiesSet.contains(model.city!)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error in checkCity: $e");
      return false;
    }
  }

  static Future<List<String>> getVendorCities(String vendorId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('partnerAppVendors')
          .doc(vendorId)
          .get();

      if (documentSnapshot.exists) {
        List<dynamic> citiesOperated = documentSnapshot['citiesOperated'];
        List<String> cities = List<String>.from(citiesOperated);
        return cities;
      } else {
        print("Document does not exist.");
        return [];
      }
    } catch (e) {
      print("Error fetching vendor cities: $e");
      return [];
    }
  }

  Future<Vendor?> fetchVendorDetails(String vendorId) async {
    try {
      final vendorSnapshot = await FirebaseFirestore.instance
          .collection('carvendors')
          .doc('partnerApp')
          .collection('partnerAppVendors')
          .doc(vendorId)
          .get();

      if (vendorSnapshot.exists) {
        final vendorData = vendorSnapshot.data() as Map<String, dynamic>;
        return Vendor.fromJson(vendorData, DriveTypes.SD);
      } else {
        print("Vendor document does not exist for ID: $vendorId");
        return null;
      }
    } catch (e) {
      print("Error fetching vendor details: $e");
      return null;
    }
  }
static Future<List<CarModel>> getMonthlyPartnerAppCars(
    DriveModel model, int tripDurationInHours, Vendor? vendor) async {
  if (vendor == null) return [];

  // Fetch the list of Partner App Vendors
  final partnerVendorList =
      await FirebaseFirestore.instance.collection('partnerAppVendors').get();
  List<CarModel> carList = [];

  for (var doc in partnerVendorList.docs) {
    final String vendorId = doc.id;
    final Map<String, dynamic> data = doc.data();
    final String brandName = data['brandName'];

    // Map the vendor in Partner Vendor List and the vendor passed in this function
    if (brandName == vendor.name) {
      if (await checkCity(vendorId, model)) {
        final firebaseCars = await FirebaseFirestore.instance
            .collection('partnerAppVendors')
            .doc(vendorId)
            .collection('Cars')
            .get();

        for (var doc in firebaseCars.docs) {
          final Map<String, dynamic> data = doc.data();
          final Map<String, dynamic> monthlyRental = data['monthly_rental'] ?? {};

          // Check conditions for adding the car
          if (monthlyRental['is_available'] == true &&
              monthlyRental['monthly_package_price'] != null &&
              monthlyRental['monthly_rate'] != null) {
            
            dynamic price = (monthlyRental['monthly_rate'] as num).toDouble();

            final CarModel carModel = CarModel(apiFlag: true)
              ..extraKmCharge = data['extra_km_rate'] ?? 0
              ..extraHrCharge = data['extra_hr_rate'] ?? 0
              ..freeKm = (250 / 24 * tripDurationInHours).toInt()
              ..isSoldOut = data['isSoldOut'] ?? false
              ..fuel = data['fuel'] ?? ''
              ..pickUpAndDrop = data['pick_up_location'] ?? ''
              ..imageUrl = (data['image_urls'] as List<dynamic>).join(', ')
              ..name = data['car_name'] ?? ''
              ..transmission = data['transmission'] ?? ''
              ..seats = data['seats'] ?? 5
              ..vendor = vendor
              ..finalDiscount = (price / 91) * 100
              ..finalPrice = price;

            carList.add(carModel);
          }
        }
      } else {
        print("Not Available in this City");
      }
    }
  }
  return carList;
}
}
