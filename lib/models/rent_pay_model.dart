import 'package:letzrentnew/models/user_model.dart';

class RentPayModel {
  UserModel? userModel;
  String? landlordname;
  String? landlordnumber;
  String? accountNumber;
  String? ifsccode;
  double? rentamount;
  String? rentmonth;
  String? landLordPanCard;
  String? type;
  String? url;
  double? processingCharge;
  double? minRent;
  double? maxRent;
  double? payableAmount;
  Map? cityFee;
  String? timeStamp;

  RentPayModel(
      {this.processingCharge,
      this.minRent,
      this.maxRent,
      this.payableAmount,
      this.cityFee,
      this.timeStamp,
      this.userModel,
      this.landlordname,
      this.landlordnumber,
      this.accountNumber,
      this.ifsccode,
      this.rentamount,
      this.rentmonth,
      this.landLordPanCard,
      this.type,
      this.url});

  RentPayModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      userModel = UserModel.fromJson(json['User']);
      landlordname = json['landlordname'];
      landlordnumber = json['landlordnumber'];
      accountNumber = json['bankaccountnumber'];
      ifsccode = json['ifsccode'];
      rentmonth = json['rentmonth'];
      landLordPanCard = json['pancard'];
      type = json['type'];
      url = json['url'];
      processingCharge = json['processingCharge'];
      minRent = json['minRent'];
      maxRent = json['maxRent'];
      payableAmount = json['payableAmount'];
      cityFee = json['cityFee'];
      timeStamp = json['timeStamp'];
      rentamount = json['rentamount'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['User'] = this.userModel!.toJson();
    data['landlordname'] = this.landlordname;
    data['landlordnumber'] = this.landlordnumber;
    data['bankaccountnumber'] = this.accountNumber;
    data['ifsccode'] = this.ifsccode;
    data['rentamount'] = this.rentamount;
    data['rentmonth'] = this.rentmonth;
    data['pancard'] = this.landLordPanCard;
    data['type'] = this.type;
    data['url'] = this.url;
    data['processingCharge'] = this.processingCharge;
    data['payableAmount'] = this.payableAmount;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}
