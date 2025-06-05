class NewCarsModel {
  final String imageUrl;
  final String rating;
  final String carName;
  final String price;

  NewCarsModel({
    required this.carName,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  factory NewCarsModel.fromJson(Map<String, dynamic> json) {
    return NewCarsModel(
      carName: json['carName'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      rating: json['rating'],
    );
  }
}
