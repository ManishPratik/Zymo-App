import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/new_cars_model.dart';

class RecommendedCars extends StatefulWidget {
  const RecommendedCars({Key? key}) : super(key: key);

  @override
  State<RecommendedCars> createState() => _RecommendedCarsState();
}

class _RecommendedCarsState extends State<RecommendedCars> {
  List<NewCarsModel> newCars = [
    NewCarsModel(
      carName: 'Hyundai Creta',
      imageUrl: 'assets/images/NewCars/huyndai-creta.jpg',
      price: '9.92 Lakhs',
      rating: '4.2',
    ),
    NewCarsModel(
      carName: 'Maruti Suzuki Ertika',
      imageUrl: 'assets/images/NewCars/maruti-suzuki-ertika.jpg',
      price: '8.69 Lakhs',
      rating: '4.3',
    ),
    NewCarsModel(
      carName: 'MG Astor',
      imageUrl: 'assets/images/NewCars/mg-astor.jpg',
      price: '9.98 Lakhs',
      rating: '4.5',
    ),
    NewCarsModel(
      carName: 'Tata Nexon',
      imageUrl: 'assets/images/NewCars/tata-nexon.jpg',
      price: '8.15 Lakhs',
      rating: '4.45',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 1.sw,
      decoration: BoxDecoration(
        color: Color.fromARGB(78, 123, 39, 138),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Recommend for you',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              height: 330,
              viewportFraction: 0.75,
            ),
            items: newCars.map((card) {
              return RecommendedCarsContainer(
                carName: card.carName,
                imageUrl: card.imageUrl,
                price: card.price,
                rating: card.rating,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class RecommendedCarsContainer extends StatefulWidget {
  final String imageUrl;
  final String rating;
  final String carName;
  final String price;
  const RecommendedCarsContainer(
      {required this.carName,
      required this.imageUrl,
      required this.price,
      required this.rating,
      Key? key})
      : super(key: key);

  @override
  State<RecommendedCarsContainer> createState() =>
      _RecommendedCarsContainerState();
}

class _RecommendedCarsContainerState extends State<RecommendedCarsContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      // shape: ,
      child: Container(
        // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: 380,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage(widget.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.carName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.price,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Onwards',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.yellow,),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      height: 40,
                      width: 80,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(31, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.rating,
                            style: contentStyle,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Book test drive',
                    style: contentStyle.copyWith(
                      color: Colors.yellow,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
