class MyChoizeModel {
  var brandGroundLength;
  int? brandKey;
  num? brandLength;
  bool? isSoldOut;
  String? brandName;
  String? calcTypeDesc;
  String? couponCode;
  int? couponDiscount;
  Null doorType;
  int? exKMRate;
  String? flex5;
  String? flex6;
  String? fuelType;
  String? fuelTypeCode;
  int? groupKey;
  String? groupName;
  int? locationKey;
  String? locationName;
  int? luggageCapacity;
  int? modelYear;
  int? perUnitCharges;
  int? rFTEngineCapacity;
  String? rFTEngineCapacityName;
  String? rateBasis;
  String? rateBasisDesc;
  String? rateTypeFlag;
  int? seatingCapacity;
  int? sortOrder;
  String? sortOrderFlag;
  bool? speedGoveronorFixed;
  int? tariffKey;
  int? totalAvailableVehicle;
  int? totalBookinCount;
  int? totalBookingHours;
  int? totalExpCharge;
  String? transMissionType;
  String? transMissionTypeCode;
  String? unitType;
  String? unitTypeDesc;
  String? vTRHybridFlag;
  String? vTRSUVFlag;
  String? vehicleBase64Image;
  String? vehicleBrandImageName;
  Null vehicleImage;
  int? vehicleTypeKey;
  String? vehicleTypeName;
  bool? wiFiEnabled;

  MyChoizeModel(
      {this.brandGroundLength,
      this.brandKey,
      this.brandLength,
      this.isSoldOut,
      this.brandName,
      this.calcTypeDesc,
      this.couponCode,
      this.couponDiscount,
      this.doorType,
      this.exKMRate,
      this.flex5,
      this.flex6,
      this.fuelType,
      this.fuelTypeCode,
      this.groupKey,
      this.groupName,
      this.locationKey,
      this.locationName,
      this.luggageCapacity,
      this.modelYear,
      this.perUnitCharges,
      this.rFTEngineCapacity,
      this.rFTEngineCapacityName,
      this.rateBasis,
      this.rateBasisDesc,
      this.rateTypeFlag,
      this.seatingCapacity,
      this.sortOrder,
      this.sortOrderFlag,
      this.speedGoveronorFixed,
      this.tariffKey,
      this.totalAvailableVehicle,
      this.totalBookinCount,
      this.totalBookingHours,
      this.totalExpCharge,
      this.transMissionType,
      this.transMissionTypeCode,
      this.unitType,
      this.unitTypeDesc,
      this.vTRHybridFlag,
      this.vTRSUVFlag,
      this.vehicleBase64Image,
      this.vehicleBrandImageName,
      this.vehicleImage,
      this.vehicleTypeKey,
      this.vehicleTypeName,
      this.wiFiEnabled});

  MyChoizeModel.fromJson(Map<String, dynamic> json) {
    brandGroundLength = json['BrandGroundLength'];
    brandKey = json['BrandKey'];
    brandLength = json['BrandLength'];
    brandName = json['BrandName'];
    calcTypeDesc = json['CalcTypeDesc'];
    couponCode = json['CouponCode'];
    couponDiscount = json['CouponDiscount'];
    doorType = json['DoorType'];
    exKMRate = json['ExKMRate'];
    flex5 = json['Flex_5'];
    flex6 = json['Flex_6'];
    fuelType = json['FuelType'];
    fuelTypeCode = json['FuelTypeCode'];
    groupKey = json['GroupKey'];
    groupName = json['GroupName'];
    locationKey = json['LocationKey'];
    locationName = json['LocationName'];
    luggageCapacity = json['LuggageCapacity'];
    modelYear = json['ModelYear'];
    perUnitCharges = json['PerUnitCharges'];
    rFTEngineCapacity = json['RFTEngineCapacity'];
    rFTEngineCapacityName = json['RFTEngineCapacityName'];
    rateBasis = json['RateBasis'];
    rateBasisDesc = json['RateBasisDesc'];
    rateTypeFlag = json['RateTypeFlag'];
    seatingCapacity = json['SeatingCapacity'];
    sortOrder = json['SortOrder'];
    sortOrderFlag = json['SortOrderFlag'];
    speedGoveronorFixed = json['SpeedGoveronorFixed'];
    tariffKey = json['TariffKey'];
    totalAvailableVehicle = json['TotalAvailableVehicle'];
    totalBookinCount = json['TotalBookinCount'];
    totalBookingHours = json['TotalBookingHours'];
    totalExpCharge = json['TotalExpCharge'];
    transMissionType = json['TransMissionType'];
    transMissionTypeCode = json['TransMissionTypeCode'];
    unitType = json['UnitType'];
    unitTypeDesc = json['UnitTypeDesc'];
    vTRHybridFlag = json['VTRHybridFlag'];
    vTRSUVFlag = json['VTRSUVFlag'];
    vehicleBase64Image = json['VehicleBase64Image'];
    vehicleBrandImageName = json['VehicleBrandImageName'];
    vehicleImage = json['VehicleImage'];
    vehicleTypeKey = json['VehicleTypeKey'];
    vehicleTypeName = json['VehicleTypeName'];
    wiFiEnabled = json['WiFiEnabled'];
    isSoldOut = (totalAvailableVehicle ?? 0) < 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['BrandGroundLength'] = this.brandGroundLength;
    data['BrandKey'] = this.brandKey;
    data['BrandLength'] = this.brandLength;
    data['BrandName'] = this.brandName;
    data['CalcTypeDesc'] = this.calcTypeDesc;
    data['CouponCode'] = this.couponCode;
    data['CouponDiscount'] = this.couponDiscount;
    data['DoorType'] = this.doorType;
    data['ExKMRate'] = this.exKMRate;
    data['Flex_5'] = this.flex5;
    data['Flex_6'] = this.flex6;
    data['FuelType'] = this.fuelType;
    data['FuelTypeCode'] = this.fuelTypeCode;
    data['GroupKey'] = this.groupKey;
    data['GroupName'] = this.groupName;
    data['LocationKey'] = this.locationKey;
    data['LocationName'] = this.locationName;
    data['LuggageCapacity'] = this.luggageCapacity;
    data['ModelYear'] = this.modelYear;
    data['PerUnitCharges'] = this.perUnitCharges;
    data['RFTEngineCapacity'] = this.rFTEngineCapacity;
    data['RFTEngineCapacityName'] = this.rFTEngineCapacityName;
    data['RateBasis'] = this.rateBasis;
    data['RateBasisDesc'] = this.rateBasisDesc;
    data['RateTypeFlag'] = this.rateTypeFlag;
    data['SeatingCapacity'] = this.seatingCapacity;
    data['SortOrder'] = this.sortOrder;
    data['SortOrderFlag'] = this.sortOrderFlag;
    data['SpeedGoveronorFixed'] = this.speedGoveronorFixed;
    data['TariffKey'] = this.tariffKey;
    data['TotalAvailableVehicle'] = this.totalAvailableVehicle;
    data['TotalBookinCount'] = this.totalBookinCount;
    data['TotalBookingHours'] = this.totalBookingHours;
    data['TotalExpCharge'] = this.totalExpCharge;
    data['TransMissionType'] = this.transMissionType;
    data['TransMissionTypeCode'] = this.transMissionTypeCode;
    data['UnitType'] = this.unitType;
    data['UnitTypeDesc'] = this.unitTypeDesc;
    data['VTRHybridFlag'] = this.vTRHybridFlag;
    data['VTRSUVFlag'] = this.vTRSUVFlag;
    data['VehicleBase64Image'] = this.vehicleBase64Image;
    data['VehicleBrandImageName'] = this.vehicleBrandImageName;
    data['VehicleImage'] = this.vehicleImage;
    data['VehicleTypeKey'] = this.vehicleTypeKey;
    data['VehicleTypeName'] = this.vehicleTypeName;
    data['WiFiEnabled'] = this.wiFiEnabled;
    return data;
  }
}
