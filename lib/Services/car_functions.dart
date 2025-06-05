import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:letzrentnew/Services/http_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:letzrentnew/widgets/Cars/car_view.dart';
import 'package:provider/provider.dart';

import 'firebase_services.dart';

class CarFunctions {
  DateTime? _selectedDate;

  TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 00);

  DateTime? _endDate;

  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 00);

  void onSelectedStartDate(DateTime? args) {
    if (args is DateTime) {
      _selectedDate = args;
    }
  }

  void onSelectedEndDate(DateTime? args) {
    if (args is DateTime) {
      _endDate = args;
    }
  }

  void startTimePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      builder: (context) => Container(
        height: 0.4.sh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Start time',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      // Set the text color to grey
                      pickerTextStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime:
                        DateTime.fromMillisecondsSinceEpoch(1616826600000),
                    minuteInterval: 30,
                    onDateTimeChanged: (val) {
                      _startTime =
                          TimeOfDay(hour: val.hour, minute: val.minute);
                    },
                  ),
                ),
              ),
              AppButton(
                screenWidth: 1.sw,
                screenHeight: 1.sh,
                title: 'Done',
                function: () {
                  Provider.of<CarProvider>(context, listen: false)
                      .setStartTime(_startTime);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void endTimePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      builder: (context) => Container(
        height: 0.4.sh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('End time',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      // Set the text color to grey
                      pickerTextStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime:
                        DateTime.fromMillisecondsSinceEpoch(1616826600000),
                    minuteInterval: 30,
                    onDateTimeChanged: (val) {
                      _startTime =
                          TimeOfDay(hour: val.hour, minute: val.minute);
                    },
                  ),
                ),
              ),
              AppButton(
                screenWidth: 1.sw,
                screenHeight: 1.sh,
                title: 'Done',
                function: () {
                  Provider.of<CarProvider>(context, listen: false)
                      .setStartTime(_startTime);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future datePickerWidget(
  //     BuildContext context, double screenHeight, double screenWidth) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //           insetPadding: EdgeInsets.all(30.0),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text('Start and end date',
  //                         style: TextStyle(
  //                             fontSize: 20, fontWeight: FontWeight.bold)),
  //                     InkWell(
  //                         onTap: () => Navigator.pop(context),
  //                         child: Icon(FontAwesomeIcons.times))
  //                   ],
  //                 ),
  //               ),
  //               SfDateRangePicker(
  //                 onSelectionChanged: _onSelectionChanged,
  //                 selectionMode: DateRangePickerSelectionMode.range,
  //                 initialSelectedRange:
  //                     PickerDateRange(_selectedDate, _endDate),
  //               ),
  //               ElevatedButton(
  //                   onPressed: () {
  //                     Provider.of<CarProvider>(context, listen: false)
  //                         .setStartAndEndDate(_selectedDate, _endDate);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Next'))
  //             ],
  //           )));
  // }

  Future startDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      // builder: (context, child) => child!,
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: oneYearFromNow,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFFFFFA8D),
              onPrimary: Colors.black,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme
                  .primary, // Ensures that buttons use the theme's primary color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.grey, // Changes the text color of the buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    onSelectedStartDate(picked);
    if (_selectedDate != null) {
      Provider.of<CarProvider>(context, listen: false)
          .setStartAndEndDate(_selectedDate, null);
    }
    // return showDialog(
    //     context: context,
    //     builder: (context) => Dialog(
    //         insetPadding: const EdgeInsets.all(30.0),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(15),
    //         ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Text('Start date',
    //                       style: TextStyle(
    //                           fontSize: 20, fontWeight: FontWeight.bold)),
    //                   InkWell(
    //                       onTap: () => Navigator.pop(context),
    //                       child: const Icon(FontAwesomeIcons.xmark))
    //                 ],
    //               ),
    //             ),
    //             // SfDateRangePicker(
    //             //   minDate: DateTime.now(),
    //             //   onSelectionChanged: onSelectedStartDate,
    //             //   initialSelectedRange:
    //             //       PickerDateRange(_selectedDate, _endDate),
    //             // ),
    //             ElevatedButton(
    //                 onPressed: () {
    //                   if (_selectedDate != null) {
    //                     Provider.of<CarProvider>(context, listen: false)
    //                         .setStartAndEndDate(_selectedDate, null);
    //                   }
    //                   Navigator.pop(context);
    //                 },
    //                 child: const Text('Next'))
    //           ],
    //         )));
  }

  final oneYearFromNow = DateTime.now().add(Duration(days: 365));
  final now = DateTime.now();
  Future endDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      // builder: (context, child) => child!,
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: _selectedDate ?? now,
      lastDate: oneYearFromNow,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFFFFFA8D),
              onPrimary: Colors.black,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme
                  .primary, // Ensures that buttons use the theme's primary color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.grey, // Changes the text color of the buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    onSelectedEndDate(picked);
    if (_endDate != null) {
      Provider.of<CarProvider>(context, listen: false)
          .setStartAndEndDate(null, _endDate);
    }
    // return CupertinoDatePicker(
    //     mode: CupertinoDatePickerMode.time,
    //     initialDateTime: DateTime.fromMillisecondsSinceEpoch(1616826600000),
    //     minuteInterval: 30,
    //     onDateTimeChanged: (val) {
    //       _startTime = TimeOfDay(hour: val.hour, minute: val.minute);
    //     });
    // return DatePickerDialog(
    //     initialDate: _selectedDate ?? DateTime.now(),
    //     firstDate: _selectedDate ?? DateTime.now(),
    //     lastDate: DateTime.now().add(Duration(days: 365)));

    return;
    // return DateRangePickerDialog(
    //   firstDate: _selectedDate ?? DateTime.now(),
    //   lastDate: DateTime.now().add(duration),
    // );
    // return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Dialog(
    //           insetPadding: const EdgeInsets.all(30.0),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           child: true
    //               ? DatePickerDialog(
    //                   firstDate: _selectedDate ?? DateTime.now(),
    //                   initialDate: _selectedDate ?? DateTime.now(),
    //                   lastDate: DateTime.now().add(duration),
    //                 )
    //               : Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           const Text('End date',
    //                               style: TextStyle(
    //                                   fontSize: 20,
    //                                   fontWeight: FontWeight.bold)),
    //                           InkWell(
    //                               onTap: () => Navigator.pop(context),
    //                               child: const Icon(FontAwesomeIcons.xmark))
    //                         ],
    //                       ),
    //                     ),
    //                     Expanded(
    //                         child: DateRangePickerDialog(
    //                       firstDate: _selectedDate ?? DateTime.now(),
    //                       lastDate: DateTime.now().add(duration),
    //                     )),
    //                     // SfDateRangePicker(
    //                     //   minDate: _selectedDate ?? DateTime.now(),
    //                     //   onSelectionChanged: onSelectedEndDate,
    //                     //   initialSelectedRange:
    //                     //       PickerDateRange(_selectedDate, _endDate),
    //                     // ),
    //                     ElevatedButton(
    //                         onPressed: () {
    //                           if (_endDate != null) {
    //                             Provider.of<CarProvider>(context, listen: false)
    //                                 .setStartAndEndDate(null, _endDate);
    //                           }
    //                           Navigator.pop(context);
    //                         },
    //                         child: const Text('Next'))
    //                   ],
    //                 ));
    //     });
  }

  bool validateMonthlyRental(BuildContext context, CarProvider provider,
      {int? minimumBookingDuration}) {
    bool isValid = false;
    const hours2 = 8;
    if (provider.startDate == null) {
      warningPopUp(context, oops, 'Please select a start date');
    } else if (provider.startTime == null) {
      warningPopUp(context, oops, 'Please select an start time');
    } else if (provider.startDateTime
        .isBefore(DateTime.now().add(const Duration(hours: hours2)))) {
      warningPopUp(
          context, oops, 'Bookings only available $hours2 hours in advance.');
    } else {
      isValid = true;
    }
    return isValid;
  }

  static bool validateSelfDrive(BuildContext context, CarProvider provider,
      {int? minimumBookingDuration}) {
    const int advanceHours = 2;
    bool isValid = false;
    if (provider.startDate == null) {
      warningPopUp(context, oops, 'Please select a start date');
    } else if (provider.startTime == null) {
      warningPopUp(context, oops, 'Please select an start time');
    } else if (provider.endTime == null) {
      warningPopUp(context, oops, 'Please select an end time');
    } else if (provider.endDate == null) {
      warningPopUp(context, oops, 'Please select an end date');
    } else if (provider.startDateTime.isAfter(provider.endDateTime)) {
      warningPopUp(context, oops, 'Start date cannot be after end date');
    } else if (provider.startDateTime
        .isBefore(DateTime.now().add(const Duration(hours: advanceHours)))) {
      warningPopUp(context, oops,
          'Bookings only available $advanceHours hours in advance.');
    } else if (provider.startDateTime
        .add(Duration(hours: minimumBookingDuration ?? 8))
        .isAfter(provider.endDateTime)) {
      warningPopUp(context, oops,
          'Minimum booking duration of ${minimumBookingDuration ?? 8} hours');
    } else {
      isValid = true;
    }
    return isValid;
  }

  static Future<String> getCity(String type, String? location) async {
    List cities = [];
    String city = '';
    if (location != null) {
      await FirebaseServices()
          .getCarCity(type)
          .then((value) => cities = value['cities']);
      if (location.contains('Maharashtra')) {
        city = 'Mumbai';
      } else if (location.contains('Bangalore')) {
        city = bengaluru;
      } else if (location.contains('Mysuru')) {
        city = 'Mysore';
      } else if (city == 'Telangana') {
        city = 'Hyderabad';
      } else if (location.contains('Ghaziabad') ||
          location.contains('Noida') ||
          location.contains('Gurugram')) {
        city = 'Delhi';
      }
      cities.forEach((element) {
        if (location.contains(element)) {
          city = element ?? '';
        }
        ;
      });
    } else {
      throw Exception('Please re-select your location from the Home page.');
    }
    return city;
  }

  static Future<void> selfDriveNavigate(BuildContext context) async {
    final CarProvider provider =
        Provider.of<CarProvider>(context, listen: false);
    provider.startLoading();

    try {
      final bool isValid = validateSelfDrive(context, provider);
      if (!isValid) {
        return;
      }
      final HomeProvider locationProvider =
          Provider.of<HomeProvider>(context, listen: false);
      final String city = await getCity('sd', locationProvider.location)
          .timeout(timeOutDuration);
      final List carGrouping = await getCarGroups().timeout(timeOutDuration);
      final String duration = provider.getTripDuration();
      final DriveModel model = DriveModel()
        ..drive = DriveTypes.SD
        ..startDate = dateFormatter.format(provider.startDateTime)
        ..endDate = dateFormatter.format(provider.endDateTime)
        ..endtime = provider.endTime!.format(context)
        ..starttime = provider.startTime!.format(context)
        ..weekdays = provider.getWeekdays()
        ..weekends = provider.getWeekends()
        ..weekdayhr = provider.getWeekDayHours()
        ..weekendhr = provider.getWeekendHours()
        ..mapLocation = locationProvider.location
        ..mapLatLng = locationProvider.locationLatLng
        ..remainingDuration = duration
        ..city = city
        ..startDateTime = provider.startDateTime
        ..endDateTime = provider.endDateTime
        ..carGrouping = carGrouping;
      await locationProvider.setRecentSearch(duration, model.startDate!,
          model.starttime!, model.endDate!, model.endtime!);
      await CommonFunctions.navigateTo(context, CarsView(model: model));
    } catch (e) {
      print(e);
      warningPopUp(
          context, 'Oops!', 'Something went wrong. Please tryyy again. $e');
    } finally {
      provider.stopLoading();
    }
  }

  Future<void> monthlyRentalNavigate(BuildContext context) async {
    final CarProvider provider =
        Provider.of<CarProvider>(context, listen: false);
    provider.startLoading();
    final HomeProvider locationProvider =
        Provider.of<HomeProvider>(context, listen: false);

    final bool isValid = validateMonthlyRental(context, provider);

    try {
      if (!isValid) {
        return;
      }
      provider.setEndTime(provider.startTime!);
      provider.setStartAndEndDate(
          null, provider.startDateTime.add(const Duration(days: 30)));
      final List carGrouping = await getCarGroups();
      final String city =
          await getCity('subscription', locationProvider.location);
      final DriveModel model = DriveModel()
        ..drive = DriveTypes.SUB
        ..carGrouping = carGrouping
        ..startDate = dateFormatter.format(provider.startDateTime)
        ..endDate = dateFormatter.format(provider.endDateTime)
        ..startDateTime = provider.startDateTime
        ..endDateTime = provider.endDateTime
        ..starttime = provider.startTime!.format(context)
        ..weekdays = provider.getWeekdays()
        ..weekends = provider.getWeekends()
        ..weekdayhr = provider.getWeekDayHours()
        ..weekendhr = provider.getWeekendHours()
        ..mapLocation = locationProvider.location
        ..mapLatLng = locationProvider.locationLatLng
        ..remainingDuration = '30 Days'
        ..city = city
        ..endtime = provider.endTime!.format(context);
      await CommonFunctions.navigateTo(context, CarsView(model: model));
    } catch (e) {
      warningPopUp(
          context, 'Oops!', 'Something went wrong. Please tryy again. $e');
    } finally {
      provider.stopLoading();
    }
  }

  void chauffeurDriveNavigate(BuildContext context) async {
    {
      final CarProvider provider =
          Provider.of<CarProvider>(context, listen: false);
      provider.startLoading();
      final HomeProvider locationProvider =
          Provider.of<HomeProvider>(context, listen: false);

      try {
        await cdType(provider, locationProvider, context);
      } catch (e) {
        warningPopUp(
            context, 'Oops!', 'Something went wrong. Please try again. $e');
      } finally {
        provider.stopLoading();
      }
    }
  }

  Future<void> outstationFunction(HomeProvider locationProvider,
      CarProvider provider, BuildContext context) async {
    final bool isValid = validateSelfDrive(context, provider);
    if (!isValid) {
      return;
    }
    if (provider.destinationLocation == null) {
      warningPopUp(context, oops, 'Please select a destination.');
      return;
    }
    final String city = await getCity('os', locationProvider.location);
    final List carGrouping = await getCarGroups();
    final double distance = await getDistance(locationProvider.locationLatLng!,
        provider.destinationLatLng!, provider.cdType);
    final int hrs =
        provider.endDateTime.difference(provider.startDateTime).inHours;
    final DriveModel model = DriveModel()
      ..drive = provider.cdType
      ..carGrouping = carGrouping
      ..city = city
      ..startDate = dateFormatter.format(provider.startDateTime)
      ..endDate = dateFormatter.format(provider.endDateTime)
      ..starttime = provider.startTime!.format(context).toString()
      ..endtime = provider.endTime!.format(context).toString()
      ..mapLocation = locationProvider.location
      ..mapLatLng = locationProvider.locationLatLng
      ..remainingDuration = provider.getTripDuration()
      ..hrs = hrs
      ..distanceOs = distance;
    await CommonFunctions.navigateTo(context, CarsView(model: model));
  }

  Future<void> airportTransferFunction(HomeProvider locationProvider,
      CarProvider provider, BuildContext context) async {
    provider.setStartAndEndDate(
        null, provider.startDateTime.add(const Duration(hours: 4)));
    provider.setEndTime(TimeOfDay(
        hour: provider.endDate!.hour, minute: provider.endDate!.minute));
    final bool isValid =
        validateSelfDrive(context, provider, minimumBookingDuration: 4);
    if (!isValid) {
      return;
    }
    final String city = await getCity('at', locationProvider.location);
    final List carGrouping = await getCarGroups();
    final DriveModel model = DriveModel()
      ..drive = DriveTypes.AT
      ..city = city
      ..carGrouping = carGrouping
      ..type = provider.atType == AirportTransferTypes.drop
          ? 'Airport Drop off'
          : 'Airport Pick Up'
      ..startDate = dateFormatter.format(provider.startDateTime)
      ..endDate = dateFormatter.format(provider.endDateTime)
      ..starttime = provider.startTime!.format(context).toString()
      ..endtime = provider.endTime!.format(context).toString()
      ..mapLocation = locationProvider.location
      ..mapLatLng = locationProvider.locationLatLng
      ..remainingDuration = provider.getTripDuration();

    await CommonFunctions.navigateTo(context, CarsView(model: model));
  }

  static Future<void> withinCityFunction(HomeProvider locationProvider,
      CarProvider provider, BuildContext context) async {
    final bool isValid =
        validateSelfDrive(context, provider, minimumBookingDuration: 4);
    if (!isValid) {
      return;
    }
    final int hrs =
        provider.endDateTime.difference(provider.startDateTime).inHours;
    final String city = await getCity('cd', locationProvider.location);
    final List carGrouping = await getCarGroups();
    final DriveModel model = DriveModel()
      ..drive = DriveTypes.WC
      ..city = city
      ..carGrouping = carGrouping
      ..startDate = dateFormatter.format(provider.startDateTime)
      ..endDate = dateFormatter.format(provider.endDateTime)
      ..starttime = provider.startTime!.format(context).toString()
      ..endtime = provider.endTime!.format(context).toString()
      ..mapLocation = locationProvider.location
      ..mapLatLng = locationProvider.locationLatLng
      ..hrs = hrs
      ..remainingDuration = provider.getTripDuration();

    await CommonFunctions.navigateTo(context, CarsView(model: model));
  }

  Future cdType(CarProvider provider, HomeProvider locationProvider,
      BuildContext context) async {
    switch (provider.cdType) {
      case DriveTypes.RT:
        await outstationFunction(locationProvider, provider, context);
        break;
      case DriveTypes.OW:
        await outstationFunction(locationProvider, provider, context);
        break;
      case DriveTypes.AT:
        await airportTransferFunction(locationProvider, provider, context);
        break;

      case DriveTypes.WC:
        await withinCityFunction(locationProvider, provider, context);
        break;
      case DriveTypes.SD:
        break;
      case DriveTypes.SUB:
        break;
    }
  }

  Future<String> getTripDetails(LatLng user, LatLng destination) {
    return HttpServices.getDistance(user, destination)
        .then((Response response) {
      String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        res =
            "{\"status\":$statusCode,\"message\":\"error\",\"response\":$res}";
        throw Exception(res);
      }
      try {
        final String _distance = const JsonDecoder()
            .convert(res)["routes"][0]["legs"][0]["distance"]['text']
            .toString();

        return _distance;
      } catch (e) {
        throw Exception(res);
      }
    });
  }

  Future<double> getDistance(
      LatLng user, LatLng destination, DriveTypes type) async {
    final String _distance = await getTripDetails(user, destination);
    final double minDistance = type == DriveTypes.RT ? 250 : 150;
    final int times = type == DriveTypes.RT ? 2 : 1;
    final int length = _distance.toString().length;
    double distance = double.parse(
            _distance.toString().substring(0, length - 2).replaceAll(',', '')) *
        times;
    if (distance < minDistance) {
      distance = minDistance;
    }
    return distance;
  }

  // static Future<List> getCarGroups() async {
  //   final DocumentSnapshot<Map> doc =
  //       await (FirebaseServices().getCarGroupingNames()
  //           as FutureOr<DocumentSnapshot<Map<dynamic, dynamic>>>);
  //   final List carData = doc.data()!['Keyword'];
  //   return carData;
  // }
  static Future<List> getCarGroups() async {
    final doc = await FirebaseServices().getCarGroupingNames();
    final List carData = doc['Keyword'];
    return carData;
  }
}
