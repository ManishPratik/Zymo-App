import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/user_location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  
  String? _location;
  String? get location => _location;
  String? _address;
  String? get address => _address;

  String _searchString = '';
  String get searchString => _searchString;

  LatLng? _locationLatLng;
  LatLng? get locationLatLng => _locationLatLng;

  bool _rewardIndicator = false;
  bool get rewardIndicator => _rewardIndicator;
  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;
  bool _isReferral = false;
  bool get isReferral => _isReferral;

  bool _isLocationLoading = false;
  bool get isLocationLoading => _isLocationLoading;

  File? aadhaarFront;
  File? aadhaarBack;
  File? licenseFront;
  File? licenseBack;

  SharedPreferences? _prefs;

  late int otpTimeout;
  int? resendToken;
  Timer? _timer;

  void otpInitTimer(int i, int? token) {
    resendToken = token;
    const oneSec = const Duration(seconds: 1);
    otpTimeout = i;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (otpTimeout == 0) {
        timer.cancel();
        notifyListeners();
      } else {
        otpTimeout--;
        notifyListeners();
      }
    });
  }

  cancelTimer() {
    _timer!.cancel();
  }

  // final List<Map<String, String>> onboardingPages = [
  //   {
  //     'image': 'assets/images/onboarding_images/search.jpeg',
  //     'title': 'SEARCH',
  //     'body': 'Search for the desired product.'
  //   },
  //   {
  //     'image': 'assets/images/onboarding_images/compare.png',
  //     'title': 'COMPARE',
  //     'body': 'Compare brands and prices to find the best deal.'
  //   },
  //   {
  //     'image': 'assets/images/onboarding_images/rent.jpeg',
  //     'title': 'RENT',
  //     'body': 'Rent your desired product.'
  //   },
  //   {
  //     'image': 'assets/images/onboarding_images/earn.jpeg',
  //     'title': 'EARN REWARDS & REDEEM',
  //     'body': 'Get rewarded for renting.'
  //   },
  // ];

  Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<DriveModel?> getRecentSearch() async {
    await initPrefs();
    final DriveModel driveModel = DriveModel()
      ..remainingDuration = _prefs!.getString('duration')
      ..startDate = _prefs!.getString('startDate')
      ..starttime = _prefs!.getString('startTime')
      ..endDate = _prefs!.getString('endDate')
      ..endtime = _prefs!.getString('endTime');

    if (driveModel.startDate != null &&
        driveModel.starttime != null &&
        driveModel.endDate != null &&
        driveModel.endtime != null) {
      return driveModel;
    } else {
      return null;
    }
  }

  Future<void> setRecentSearch(String duration, String startDate,
      String startTime, String endDate, String endTime) async {
    await initPrefs();
    await _prefs!.setString('duration', duration);
    await _prefs!.setString('startDate', startDate);
    await _prefs!.setString('startTime', startTime);
    await _prefs!.setString('endDate', endDate);
    await _prefs!.setString('endTime', endTime);
  }

  Future<void> setUserLocation(UserLocationModel userLocationModel) async {
    if (userLocationModel.location != null &&
        userLocationModel.latLng != null) {
      _location = userLocationModel.location!;
      _locationLatLng = userLocationModel.latLng;
      notifyListeners();
      await initPrefs();
      await _prefs!.setString('location', userLocationModel.location!);
      await _prefs!.setDouble('locationLat', _locationLatLng!.latitude);
      await _prefs!.setDouble('locationLng', _locationLatLng!.longitude);
      await _prefs!.setString(
          'userLocationModel', jsonEncode(userLocationModel.toJson()));
    }
  }

  Future<String?> getLocation() async {
    if (_location == null || _location!.isEmpty) {
      await initPrefs();
      _location = _prefs!.getString('location')!;
      final double? locationLat = _prefs!.getDouble('locationLat');
      final double? locationLng = _prefs!.getDouble('locationLng');
      if (locationLat != null && locationLng != null) {
        _locationLatLng = LatLng(locationLat, locationLng);
      }
    }
    return _location;
  }

  int selectedPageIndex = 0;
  // bool get isLastPage => selectedPageIndex == onboardingPages.length - 1;
  PageController pageController = PageController();
  void setPage(int page) {
    selectedPageIndex = page;
    notifyListeners();
  }

  // void forwardAction() {
  //   if (isLastPage) {
  //     //go to home page
  //   } else {
  //     pageController.nextPage(
  //         duration: const Duration(milliseconds: 300), curve: Curves.ease);
  //   }
  //   notifyListeners();
  // }

  void isNewUserFunction(bool value) {
    _isNewUser = value;
  }

  void isReferralFunction(bool value) {
    _isReferral = value;
  }

  void setImage(File? file, DocumentEnum documentsEnum) {
    if (file != null) {
      switch (documentsEnum) {
        case DocumentEnum.AF:
          aadhaarFront = file;
          break;
        case DocumentEnum.AB:
          aadhaarBack = file;
          break;
        case DocumentEnum.LF:
          licenseFront = file;
          break;
        case DocumentEnum.LB:
          licenseBack = file;
          break;
      }
      notifyListeners();
    }
  }

  void clearImage(DocumentEnum documentsEnum) {
    switch (documentsEnum) {
      case DocumentEnum.AF:
        aadhaarFront = null;
        break;
      case DocumentEnum.AB:
        aadhaarBack = null;
        break;
      case DocumentEnum.LF:
        licenseFront = null;
        break;
      case DocumentEnum.LB:
        licenseBack = null;
        break;
    }
    notifyListeners();
  }

  Future<void> setRewardIndicator(bool value) async {
    await Future.delayed(Duration.zero);
    _rewardIndicator = value;
    notifyListeners();
  }

  void setAddress(String? value) {
    _address = value;
    //  notifyListeners();
  }

  void setSearchString(String value) {
    _searchString = value;
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await initPrefs();
    await _prefs!.clear();
  }

  void toggleLocationLoading(bool value) {
    _isLocationLoading = value;
    notifyListeners();
  }
}
