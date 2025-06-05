import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letzrentnew/Services/place_picker.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/location_picker.dart';

class LocationService {
  Future<LocationResult?> pickLocation(BuildContext context) async {
    LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker(GoogleApiKey)));
    return result;
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
class AutoCompleteItem {
  /// The id of the place. This helps to fetch the lat,lng of the place.
  String? id;

  /// The text (name of place) displayed in the autocomplete suggestions list.
  String? text;

  /// Assistive index to begin highlight of matched part of the [text] with
  /// the original query
  int? offset;

  /// Length of matched part of the [text]
  int? length;
}


class RichSuggestion extends StatelessWidget {
  final VoidCallback onTap;
  final AutoCompleteItem autoCompleteItem;

  RichSuggestion(this.autoCompleteItem, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: RichText(text: TextSpan(children: getStyledTexts(context))),
        ),
        onTap: onTap,
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final List<TextSpan> result = [];
    final style = TextStyle(color: Colors.grey, fontSize: 15);

    final startText = autoCompleteItem.text?.substring(0, autoCompleteItem.offset);
    if (startText?.isNotEmpty == true) {
      result.add(TextSpan(text: startText, style: style));
    }

    final boldText =
        autoCompleteItem.text?.substring(autoCompleteItem.offset!, autoCompleteItem.offset! + autoCompleteItem.length!);
    result.add(
      TextSpan(text: boldText, style: style.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color)),
    );

    final remainingText = autoCompleteItem.text?.substring(autoCompleteItem.offset! + autoCompleteItem.length!);
    result.add(TextSpan(text: remainingText, style: style));

    return result;
  }
}
class LocalizationItem {
  String languageCode;
  String nearBy;
  String findingPlace;
  String noResultsFound;
  String unnamedLocation;
  String tapToSelectLocation;


  LocalizationItem({
    this.languageCode = 'en_us',
    this.nearBy = 'Nearby Places',
    this.findingPlace = 'Finding place...',
    this.noResultsFound = 'No results found',
    this.unnamedLocation = 'Unnamed location',
    this.tapToSelectLocation = 'Tap to select this location',
  });
}