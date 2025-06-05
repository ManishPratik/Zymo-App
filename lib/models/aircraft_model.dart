import 'package:letzrentnew/models/user_model.dart';

class AircraftModel {
  int? price;
  late double finalPrice;
  String? vendor;
  String? time;
  String? city;
  int? numberOfPeople;
  String? title;
  String? image;

  AircraftModel(
      {this.price,
      this.vendor,
      this.time,
      this.city,
      this.numberOfPeople,
      this.title,
      this.image});

  AircraftModel.fromJson(Map<String, dynamic> json) {
    price = json['Price'];
    finalPrice = price! * .95;
    vendor = json['vendor'];
    time = json['Time'];
    city = json['City'];
    numberOfPeople = json['Number of people'];
    title = json['title'];
    image = json['image1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Price'] = this.price;
    data['vendor'] = this.vendor;
    data['Time'] = this.time;
    data['City'] = this.city;
    data['Number of people'] = this.numberOfPeople;
    data['title'] = this.title;
    data['image1'] = this.image;
    return data;
  }
}

class AircraftBookingModel {
  late AircraftModel aircraftModel;
  late UserModel userModel;
  String? startDate;
  String? bookingId;
  String? promoCode;
  double? discountApplied;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Aircraft'] = this.aircraftModel.toJson();
    data['User'] = this.userModel.toJson();
    data['Start Date'] = this.startDate;
    data['Booking Id'] = this.bookingId;
    data['PromoCode'] = this.promoCode;
    data['Discount Applied'] = this.discountApplied;
    return data;
  }
}
