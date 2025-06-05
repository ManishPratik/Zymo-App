class TopCarsModel {
  final String imageUrl;
  final String title;
  final String description;

  TopCarsModel(
      {required this.description, required this.imageUrl, required this.title});

  factory TopCarsModel.fromJson(Map<String, dynamic> json) {
    return TopCarsModel(
      description: json['description'],
      imageUrl: json['imageUrl'],
      title: json['title'],
    );
  }
}
