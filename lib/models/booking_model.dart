import 'package:letzrentnew/models/document_model.dart';

class BookingModel {
  String? promoCodeUsed;
  String? email;
  String? endTime;
  String? transmission;
  String? packageSelected;
  String? pickupLocation;
  double? discountAppliedByUser;
  String? flightNumber;
  String? startDate;
  String? price;
  String? paymentId;
  String? zipcode;
  String? drive;
  String? dateOfBirth;
  String? street2;
  String? street1;
  String? firstName;
  String? startTime;
  String? deliveryType;
  String? mapLocation;
  String? vendor;
  String? city;
  String? carImage;
  String? carName;
  String? endDate;
  Map? refundData;
  bool? isCancelled;
  String? bookingId;
  String? timeStamp;
  int? dateOfBooking;
  String? userId;
  DocumentModel? documents;
  String? phoneNumber;
  String? lastName;
  var balance;

  BookingModel(
      {this.promoCodeUsed,
      this.email,
      this.endTime,
      this.transmission,
      this.packageSelected,
      this.pickupLocation,
      this.discountAppliedByUser,
      this.flightNumber,
      this.startDate,
      this.price,
      this.paymentId,
      this.zipcode,
      this.drive,
      this.dateOfBirth,
      this.street2,
      this.street1,
      this.firstName,
      this.startTime,
      this.deliveryType,
      this.mapLocation,
      this.vendor,
      this.city,
      this.carImage,
      this.carName,
      this.endDate,
      this.bookingId,
      this.timeStamp,
      this.dateOfBooking,
      this.userId,
      this.documents,
      this.phoneNumber,
      this.lastName,
      this.balance});

  BookingModel.fromJson(Map<String, dynamic> json) {
    promoCodeUsed = json['Promo Code Used'];
    email = json['Email'];
    endTime = json['EndTime'];
    transmission = json['Transmission'];
    packageSelected = json['Package Selected'];
    pickupLocation = json['Pickup Location'];
    discountAppliedByUser = json['Discount applied by user'];
    flightNumber = json['Flight number'];
    startDate = json['StartDate'];
    price = json['price'];
    paymentId = json['paymentId'];
    zipcode = json['Zipcode'];
    drive = json['Drive'];
    dateOfBirth = json['DateOfBirth'];
    street2 = json['Street2'];
    street1 = json['Street1'];
    firstName = json['FirstName'];
    startTime = json['StartTime'];
    deliveryType = json['deliveryType'];
    mapLocation = json['MapLocation'];
    vendor = json['Vendor'];
    city = json['City'];
    carImage = json['CarImage'];
    carName = json['CarName'];
    endDate = json['EndDate'];
    bookingId = json['bookingId'];
    timeStamp = json['TimeStamp'];
    dateOfBooking = json['DateOfBooking'];
    isCancelled = json['Cancelled'];
    userId = json['UserId'];
    documents = DocumentModel.fromJson(json['Documents']);
    phoneNumber = json['PhoneNumber'];
    lastName = json['LastName'];
    balance = json['Balance'];
    refundData = json['RefundData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Promo Code Used'] = this.promoCodeUsed;
    data['Email'] = this.email;
    data['EndTime'] = this.endTime;
    data['Transmission'] = this.transmission;
    data['Package Selected'] = this.packageSelected;
    data['Pickup Location'] = this.pickupLocation;
    data['Discount applied by user'] = this.discountAppliedByUser;
    data['Flight number'] = this.flightNumber;
    data['StartDate'] = this.startDate;
    data['price'] = this.price;
    data['paymentId'] = this.paymentId;
    data['Zipcode'] = this.zipcode;
    data['Drive'] = this.drive;
    data['DateOfBirth'] = this.dateOfBirth;
    data['Street2'] = this.street2;
    data['Street1'] = this.street1;
    data['FirstName'] = this.firstName;
    data['StartTime'] = this.startTime;
    data['deliveryType'] = this.deliveryType;
    data['MapLocation'] = this.mapLocation;
    data['Vendor'] = this.vendor;
    data['City'] = this.city;
    data['CarImage'] = this.carImage;
    data['CarName'] = this.carName;
    data['EndDate'] = this.endDate;
    data['bookingId'] = this.bookingId;
    data['TimeStamp'] = this.timeStamp;
    data['DateOfBooking'] = this.dateOfBooking;
    data['UserId'] = this.userId;
    data['Documents'] = this.documents;
    data['PhoneNumber'] = this.phoneNumber;
    data['LastName'] = this.lastName;
    data['Balance'] = this.balance;
    return data;
  }
}
