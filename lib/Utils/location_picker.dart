import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letzrentnew/Services/location_services.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/models/user_location_model.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Services/http_services.dart';
import '../providers/home_provider.dart';
import 'constants.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LocationResult? locationResult;
  List<RichSuggestion> suggestions = [];

  Timer? debouncer;

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<HomeProvider>(
      builder: (BuildContext context, value, Widget? child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(14.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Title
              Text(
                'Select your location',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 0.03.sh),

              TextField(
                decoration: InputDecoration(
                  fillColor: const Color(0xff323232),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  labelText: 'Search',
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                style: const TextStyle(
                  color: Colors.grey,
                ),
                cursorColor: Colors.grey,
                onChanged: (val) {
                  value.setSearchString(val);
                  onSearchInputChange(val, value);
                },
              ),

              SizedBox(
                height: 10,
              ),
              value.isLocationLoading
                  ? Container()
                  : InkWell(
                      onTap: () async {
                        value.toggleLocationLoading(true);
                        try {
                          final position =
                              await LocationService.determinePosition();
                          reverseGeocode(
                              LatLng(position.latitude, position.longitude));
                        } catch (e) {
                          CommonFunctions.showSnackbar(context, e.toString());
                        }
                        value.toggleLocationLoading(false);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.my_location_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          Text('Select current location',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
              Expanded(child: responseWidget(value))
            ])),
      ),
    );
  }

  Widget responseWidget(value) {
    if (value.isLocationLoading)
      return Center(child: spinkit);
    else if (suggestions.isNotEmpty &&
        suggestions.first.autoCompleteItem.text!.isEmpty &&
        hasSearchTerm)
      return Center(
          child: Text(
        'No results found',
        style: contentStyle,
      ));
    else
      return value.isLocationLoading
          ? spinkit
          : ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: ((context, index) => suggestions[index]));
  }

  Future<void> setLocation(HomeProvider value, BuildContext context) async {
    if (value.address != null) {
      try {
        value.toggleLocationLoading(true);
        final String location = '${value.address}';
        final LatLng? latLng = await HttpServices.getLatLng(location);

        if (latLng != null) {
          final UserLocationModel userLocationModel = UserLocationModel()
            ..location = location
            ..latLng = latLng;

          await value.setUserLocation(userLocationModel);
          Navigator.pop(context);
        }
      } catch (e) {
        await warningPopUp(context, oops, 'Something went wrong. $e');
      }
      value.toggleLocationLoading(false);
    }
  }

  Future autoCompleteSearch(String place, HomeProvider value) async {
    try {
      place = place.replaceAll(" ", "+");

      String endpoint =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
          "key=$GoogleApiKey&"
          "input={$place}"
          "&components=country:in"
          //"&types=sublocality"
          ;

      if (this.locationResult != null) {
        endpoint += "&location=${this.locationResult!.latLng!.latitude}," +
            "${this.locationResult!.latLng!.longitude}";
      }

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['predictions'] == null) {
        throw Error();
      }

      List<dynamic> predictions = responseJson['predictions'];

      if (predictions.isEmpty) {
        AutoCompleteItem aci = AutoCompleteItem()
          ..offset = 0
          ..text = ''
          ..length = 0;

        suggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (dynamic t in predictions) {
          final aci = AutoCompleteItem()
            ..id = t['place_id']
            ..text = t['description']
            ..offset = t['matched_substrings'][0]['offset']
            ..length = t['matched_substrings'][0]['length'];

          suggestions.add(RichSuggestion(aci, () {
            setLocationFunction(aci.text);
            //  decodeAndSelectPlace(aci);
          }));
        }
      }
      value.toggleLocationLoading(false);
      return suggestions;
      // displayAutoCompleteSuggestions(suggestions);
    } catch (e) {
      print(e);
    }
  }

  void setLocationFunction(String? aci) {
    FocusScope.of(context).requestFocus(FocusNode());
    final HomeProvider value =
        Provider.of<HomeProvider>(context, listen: false);
    value.setAddress(aci);
    setLocation(value, context);
  }

  void searchPlace(String place, HomeProvider value) {
    // on keyboard dismissal, the search was being triggered again
    // this is to cap that.
    if (place == this.previousSearchTerm) {
      return;
    }

    previousSearchTerm = place;

    value.toggleLocationLoading(true);
    suggestions = [];
    hasSearchTerm = place.length > 0;

    if (place.length < 1) {
      return;
    }

    autoCompleteSearch(place, value);
  }

  void onSearchInputChange(String val, value) {
    if (val.isEmpty) {
      this.debouncer?.cancel();
      searchPlace(val, value);
      return;
    }

    if (this.debouncer?.isActive ?? false) {
      this.debouncer!.cancel();
    }

    this.debouncer = Timer(Duration(milliseconds: 500), () {
      searchPlace(val, value);
    });
  }

  void reverseGeocode(LatLng latLng) async {
    try {
      final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?"
          "latlng=${latLng.latitude},${latLng.longitude}&"
          //      "language=${widget.localizationItem.languageCode}&"
          "key=$GoogleApiKey");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      final result = responseJson['results'][0];
      setLocationFunction(result['formatted_address']);
    } catch (e) {
      print(e);
    }
  }
}

// class FavouriteLocationsWidget extends StatelessWidget {
//   const FavouriteLocationsWidget({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final HomeProvider value =
//         Provider.of<HomeProvider>(context, listen: false);
//     return FutureBuilder<UserLocationModel>(
//         future: value.getRecentLocation(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData &&
//               snapshot.connectionState == ConnectionState.waiting) {
//             return Container();
//           }

//           return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(children: [
//                 Text('Recent search', style: const TextStyle(fontSize: 17)),
//                 Card(
//                   elevation: 5,
//                   child: ListTile(
//                       onTap: () => value.setUserLocation(snapshot.data),
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//                       title: Text('${value.city}, ${value.state}'),
//                       subtitle: Text(snapshot.data.country),
//                       trailing: Icon(Icons.arrow_right)),
//                 ),
//               ]));
//         });
//   }
// }
class LocationResult {
  /// The human readable name of the location. This is primarily the
  /// name of the road. But in cases where the place was selected from Nearby
  /// places list, we use the <b>name</b> provided on the list item.
  String? name; // or road

  /// The human readable locality of the location.
  String? locality;

  /// Latitude/Longitude of the selected location.
  LatLng? latLng;

  /// Formatted address suggested by Google
  String? formattedAddress;

  AddressComponent? country;

  AddressComponent? city;

  AddressComponent? administrativeAreaLevel1;

  AddressComponent? administrativeAreaLevel2;

  AddressComponent? subLocalityLevel1;

  AddressComponent? subLocalityLevel2;

  String? postalCode;

  String? placeId;
}

class AddressComponent {
  String? name;
  String? shortName;

  AddressComponent({this.name, this.shortName});

  static AddressComponent fromJson(dynamic json) {
    return AddressComponent(
        name: json['long_name'], shortName: json['short_name']);
  }
}
