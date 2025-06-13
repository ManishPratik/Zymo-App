class DocumentModel {
  String? aadhaarFront;
  String? aadhaarBack;
  String? licenseFront;
  String? licenseBack;

  DocumentModel(
      {required this.aadhaarFront,
      required this.aadhaarBack,
      required this.licenseFront,
      required this.licenseBack});

  factory DocumentModel.empty() => DocumentModel(
    aadhaarFront: '',
    aadhaarBack: '',
    licenseFront: '',
    licenseBack: '',
  );

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      licenseFront: json['front_page_driving_license']  as String? ?? '',
      licenseBack:  json['back_page_driving_license']   as String? ?? '',
      aadhaarFront: json['front_page_aadhaar_card']     as String? ?? '',
      aadhaarBack:  json['back_page_aadhaar_card']      as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'aadhaarFront':    aadhaarFront,
    'aadhaarBack':     aadhaarBack,
    'LicenseFront':    licenseFront,
    'LicenseBack':     licenseBack,
  };
}
