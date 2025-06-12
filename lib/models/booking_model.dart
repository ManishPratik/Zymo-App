import 'package:letzrentnew/models/document_model.dart';

class BookingModel {
  final String promoCodeUsed;
  final String email;
  final String endTime;
  final String transmission;
  final String packageSelected;
  final String pickupLocation;
  final double discountAppliedByUser;
  final String flightNumber;
  final String startDate;
  final String price;
  final String paymentId;
  final String zipcode;
  final String drive;
  final String dateOfBirth;
  final String street2;
  final String street1;
  final String firstName;
  final String startTime;
  final String deliveryType;
  final String mapLocation;
  final String vendor;
  final String city;
  final String carImage;
  final String carName;
  final String endDate;
  final Map<String, dynamic>? refundData;
  final bool isCancelled;
  final String bookingId;
  final String timeStamp;
  final int dateOfBooking;
  final String userId;
  final DocumentModel documents;
  final String phoneNumber;
  final String lastName;
  final dynamic balance;

  BookingModel({
    required this.promoCodeUsed,
    required this.email,
    required this.endTime,
    required this.transmission,
    required this.packageSelected,
    required this.pickupLocation,
    required this.discountAppliedByUser,
    required this.flightNumber,
    required this.startDate,
    required this.price,
    required this.paymentId,
    required this.zipcode,
    required this.drive,
    required this.dateOfBirth,
    required this.street2,
    this.street1 = '',
    required this.firstName,
    required this.startTime,
    required this.deliveryType,
    required this.mapLocation,
    required this.vendor,
    required this.city,
    required this.carImage,
    required this.carName,
    required this.endDate,
    this.refundData,
    required this.isCancelled,
    required this.bookingId,
    required this.timeStamp,
    required this.dateOfBooking,
    required this.userId,
    required this.documents,
    required this.phoneNumber,
    required this.lastName,
    this.balance,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      promoCodeUsed: json['Promo Code Used'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      endTime: json['EndTime'] as String? ?? '',
      transmission: json['Transmission'] as String? ?? '',
      packageSelected: json['Package Selected'] as String? ?? '',
      pickupLocation: json['Pickup Location'] as String? ?? '',
      discountAppliedByUser: (json['Discount applied by user'] as num?)?.toDouble() ?? 0.0,
      flightNumber: json['Flight number'] as String? ?? '',
      startDate: json['StartDate'] as String? ?? '',
      price: json['price'] as String? ?? '',
      paymentId: json['paymentId'] as String? ?? '',
      zipcode: json['Zipcode'] as String? ?? '',
      drive: json['Drive'] as String? ?? '',
      dateOfBirth: json['DateOfBirth'] as String? ?? '',
      street2: json['Street2'] as String? ?? '',
      street1: json['Street1'] as String? ?? '',
      firstName: json['FirstName'] as String? ?? '',
      startTime: json['StartTime'] as String? ?? '',
      deliveryType: json['deliveryType'] as String? ?? '',
      mapLocation: json['MapLocation'] as String? ?? '',
      vendor: json['Vendor'] as String? ?? '',
      city: json['City'] as String? ?? '',
      carImage: json['CarImage'] as String? ?? '',
      carName: json['CarName'] as String? ?? '',
      endDate: json['EndDate'] as String? ?? '',
      refundData: json['RefundData'] as Map<String, dynamic>?,
      isCancelled: json['Cancelled'] as bool? ?? false,
      bookingId: json['bookingId'] as String? ?? '',
      timeStamp: json['TimeStamp'] as String? ?? '',
      dateOfBooking: json['DateOfBooking'] as int? ?? 0,
      userId: json['UserId'] as String? ?? '',
      documents: json['Documents'] != null
          ? DocumentModel.fromJson(json['Documents'] as Map<String, dynamic>)
          : DocumentModel.empty(),
      phoneNumber: json['PhoneNumber'] as String? ?? '',
      lastName: json['LastName'] as String? ?? '',
      balance: json['Balance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Promo Code Used': promoCodeUsed,
    'Email': email,
    'EndTime': endTime,
    'Transmission': transmission,
    'Package Selected': packageSelected,
    'Pickup Location': pickupLocation,
    'Discount applied by user': discountAppliedByUser,
    'Flight number': flightNumber,
    'StartDate': startDate,
    'price': price,
    'paymentId': paymentId,
    'Zipcode': zipcode,
    'Drive': drive,
    'DateOfBirth': dateOfBirth,
    'Street2': street2,
    'Street1': street1,
    'FirstName': firstName,
    'StartTime': startTime,
    'deliveryType': deliveryType,
    'MapLocation': mapLocation,
    'Vendor': vendor,
    'City': city,
    'CarImage': carImage,
    'CarName': carName,
    'EndDate': endDate,
    'RefundData': refundData,
    'Cancelled': isCancelled,
    'bookingId': bookingId,
    'TimeStamp': timeStamp,
    'DateOfBooking': dateOfBooking,
    'UserId': userId,
    'Documents': documents.toJson(),
    'PhoneNumber': phoneNumber,
    'LastName': lastName,
    'Balance': balance,
  };
}