class LowCarsModel {
  String? carName;
  String? carPic;
  String? carType;
  String? seats;
  String? fuelType;
  String? gasVolume;
  String? carId;
  String? offer;
  int? offerPrice;
  String? weekdayCharge;
  String? weekendCharge;
  String? peakCharge;
  int? fare;
  int? kmFree;
  String? freeKmHr;
  String? excessCharge;
  int? hrs;
  List<Fleets>? fleets;
  String? available;

  LowCarsModel(
      {this.carName,
      this.carPic,
      this.carType,
      this.seats,
      this.fuelType,
      this.gasVolume,
      this.carId,
      this.offer,
      this.offerPrice,
      this.weekdayCharge,
      this.weekendCharge,
      this.peakCharge,
      this.fare,
      this.kmFree,
      this.freeKmHr,
      this.excessCharge,
      this.hrs,
      this.fleets,
      this.available});

  LowCarsModel.fromJson(Map<String, dynamic> json) {
    carName = json['car_name'];
    carPic = json['car_pic'];
    carType = json['car_type'];
    seats = json['seats'];
    fuelType = json['fuel_type'];
    gasVolume = json['gas_volume'];
    carId = json['car_id'];
    offer = json['offer'];
    offerPrice = json['offer_price'];
    weekdayCharge = json['weekday_charge'];
    weekendCharge = json['weekend_charge'];
    peakCharge = json['peak_charge'];
    fare = json['fare'];
    kmFree = json['km_free'];
    freeKmHr = json['free_km_hr'];
    excessCharge = json['excess_charge'];
    hrs = json['hrs'];
    if (json['fleets'] != null) {
      fleets = <Fleets>[];
      json['fleets'].forEach((v) {
        fleets!.add(new Fleets.fromJson(v));
      });
    }
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_name'] = this.carName;
    data['car_pic'] = this.carPic;
    data['car_type'] = this.carType;
    data['seats'] = this.seats;
    data['fuel_type'] = this.fuelType;
    data['gas_volume'] = this.gasVolume;
    data['car_id'] = this.carId;
    data['offer'] = this.offer;
    data['offer_price'] = this.offerPrice;
    data['weekday_charge'] = this.weekdayCharge;
    data['weekend_charge'] = this.weekendCharge;
    data['peak_charge'] = this.peakCharge;
    data['fare'] = this.fare;
    data['km_free'] = this.kmFree;
    data['free_km_hr'] = this.freeKmHr;
    data['excess_charge'] = this.excessCharge;
    data['hrs'] = this.hrs;
    if (this.fleets != null) {
      data['fleets'] = this.fleets!.map((v) => v.toJson()).toList();
    }
    data['available'] = this.available;
    return data;
  }
}

class Fleets {
  String? fleetName;
  String? fleetId;

  Fleets({this.fleetName, this.fleetId});

  Fleets.fromJson(Map<String, dynamic> json) {
    fleetName = json['fleet_name'];
    fleetId = json['fleet_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fleet_name'] = this.fleetName;
    data['fleet_id'] = this.fleetId;
    return data;
  }
}

class LowCarsCityModel {
  String? id;
  String? cityName;
  String? stateId;
  String? status;
  String? cityLogo;
  String? cityBanner;
  String? url;
  String? security;
  String? base;
  String? medium;
  String? large;
  String? unlimited;

  LowCarsCityModel(
      {this.id,
      this.cityName,
      this.stateId,
      this.status,
      this.cityLogo,
      this.cityBanner,
      this.url,
      this.security,
      this.base,
      this.medium,
      this.large,
      this.unlimited});

  LowCarsCityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['city_name'];
    stateId = json['state_id'];
    status = json['status'];
    cityLogo = json['city_logo'];
    cityBanner = json['city_banner'];
    url = json['url'];
    security = json['security'];
    base = json['base'];
    medium = json['medium'];
    large = json['large'];
    unlimited = json['unlimited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_name'] = this.cityName;
    data['state_id'] = this.stateId;
    data['status'] = this.status;
    data['city_logo'] = this.cityLogo;
    data['city_banner'] = this.cityBanner;
    data['url'] = this.url;
    data['security'] = this.security;
    data['base'] = this.base;
    data['medium'] = this.medium;
    data['large'] = this.large;
    data['unlimited'] = this.unlimited;
    return data;
  }
}
