

import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocationModel {
  String? location;
  LatLng? latLng;

  String? state;


  UserLocationModel({this.location, this.latLng, this.state});

  UserLocationModel.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    latLng = LatLng.fromJson(json['latLng']);

    state = json['state'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['latLng'] = [this.latLng!.latitude, this.latLng!.longitude];
  
    data['state'] = this.state;
    return data;
  }
}
