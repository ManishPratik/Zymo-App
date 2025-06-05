class DocumentModel {
  String? aadhaarFront;
  String? aadhaarBack;
  String? licenseFront;
  String? licenseBack;

  DocumentModel(
      {this.aadhaarFront,
      this.aadhaarBack,
      this.licenseFront,
      this.licenseBack});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    licenseFront = json['front_page_driving_license'];
    licenseBack = json['back_page_driving_license'];
    aadhaarFront = json['front_page_aadhaar_card'];
    aadhaarBack = json['back_page_aadhaar_card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['aadhaarFront'] = aadhaarFront;
    data['aadhaarBack'] = aadhaarBack;
    data['LicenseFront'] = licenseFront;
    data['LicenseBack'] = licenseBack;
    return data;
  }
}
