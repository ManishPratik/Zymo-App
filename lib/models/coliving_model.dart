class CoLivingModel {
  String? name;
  int? hikedRent;
  int? currentRent;
  int? displayPrice;
  int? displayPrice1;
  int? communityFund;
  int? laundry2Loads12kgs;
  int? securityDeposit;
  String? percentageDiscount;
  List? imageUrl;
  String? location;
  String? vendorName;
  String? gender;
  String? details;
  late CoLivingVendor vendor;

  CoLivingModel(
      {this.name,
      this.hikedRent,
      this.currentRent,
      this.details,
      this.gender,
      this.displayPrice,
      this.displayPrice1,
      this.communityFund,
      this.laundry2Loads12kgs,
      this.securityDeposit,
      this.percentageDiscount,
      this.imageUrl,
      this.location});

  CoLivingModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hikedRent = json['Hiked Rent'];
    details = json['details'];
    currentRent = json['Current Rent'];
    displayPrice = json['Display Price'];
    displayPrice1 = json['Display Price__1'];
    communityFund = json['Community Fund'];
    laundry2Loads12kgs = json['Laundry(2 Loads - 12kgs)'];
    securityDeposit = json['securityDeposit'];
    percentageDiscount = json['Percentage Discount'];
    imageUrl = json['imageUrl'];
    location = json['location'];
    gender = json['Boys or Girls'];
    vendorName = json['vendor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['Hiked Rent'] = hikedRent;
    data['Current Rent'] = currentRent;
    data['Display Price'] = displayPrice;
    data['Display Price__1'] = displayPrice1;

    data['Community Fund'] = communityFund;
    data['Laundry(2 Loads - 12kgs)'] = laundry2Loads12kgs;
    data['securityDeposit'] = securityDeposit;
    data['Percentage Discount'] = percentageDiscount;
    data['imageUrl'] = imageUrl;
    data['location'] = location;
    return data;
  }
}

class CoLivingVendor {
  String? name;
  String? imageUrl;

  CoLivingVendor(this.name, this.imageUrl);
  CoLivingVendor.fromJson(Map<String, dynamic> json) {
    name = json['vendor'];
    imageUrl = json['image'];
  }
}
