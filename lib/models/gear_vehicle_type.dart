class GearVehicleType {
  final String? code;
  final String? description;
  final int? key;

  GearVehicleType({
    this.code,
    this.description,
    this.key,
  });

  factory GearVehicleType.fromJson(Map<String, dynamic> json) {
    return GearVehicleType(
      code: json['Code'],
      description: json['Description'],
      key: json['Key'],
    );
  }
}
