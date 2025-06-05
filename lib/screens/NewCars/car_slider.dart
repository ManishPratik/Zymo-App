import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/new_cars_model.dart';

class CarsCardSlider extends StatefulWidget {
  const CarsCardSlider({Key? key}) : super(key: key);

  @override
  State<CarsCardSlider> createState() => _CarsCardSliderState();
}

class _CarsCardSliderState extends State<CarsCardSlider> {
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
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: false,
        height: 320,
        viewportFraction: 0.9,
      ),
      items: newCars.map((card) {
        return CarsContaner(
          carName: card.carName,
          imageUrl: card.imageUrl,
          price: card.price,
          rating: card.rating,
        );
      }).toList(),
    );
  }
}

class CarsContaner extends StatefulWidget {
  final String imageUrl;
  final String rating;
  final String carName;
  final String price;
  const CarsContaner(
      {required this.carName,
      required this.imageUrl,
      required this.price,
      required this.rating,
      Key? key})
      : super(key: key);

  @override
  State<CarsContaner> createState() => _CarsContanerState();
}

class _CarsContanerState extends State<CarsContaner> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      // shape: ,
      child: Container(
        // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.all(10),
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            widget.price,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Onwards',
                            style:
                                TextStyle(fontSize: 15, color: Colors.yellow,),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    height: 40,
                    width: 100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(66, 0, 0, 0),
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
                          width: 5,
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
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: TestDriveModal(),
                      ),
                    );
                  },
                );
              },
              child: Container(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestDriveModal extends StatefulWidget {
  const TestDriveModal({Key? key}) : super(key: key);

  @override
  State<TestDriveModal> createState() => _TestDriveModalState();
}

class _TestDriveModalState extends State<TestDriveModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                width: 30,
                height: 30,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(139, 0, 0, 0),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Icon(
                    Icons.clear_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 150,
            width: 1.sw,
            decoration: BoxDecoration(
              color: const Color.fromARGB(55, 155, 39, 176),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: 95,
                  width: 1.sw,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Renault Kiger',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '6.00 Lakhs',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Onwards',
                                  style: contentStyle,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                        height: 70,
                        width: 70,
                        padding: EdgeInsets.all(10),
                        child: Image.asset('assets/images/brands/tata.png'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star_border_outlined,
                        color: const Color.fromARGB(129, 0, 0, 0),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '528 ratings',
                        style: contentStyle,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Enter your name',
                style: contentStyle.copyWith(
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '*',
                style: contentStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: Color.fromARGB(85, 0, 0, 0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.yellow,),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Text(
                'Your city',
                style: contentStyle.copyWith(
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '*',
                style: contentStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Your City',
                  hintStyle: TextStyle(color: Color.fromARGB(85, 0, 0, 0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.yellow,),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Text(
                'Enter phone number',
                style: contentStyle.copyWith(
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '*',
                style: contentStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: SizedBox(
              height: 50,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter phone number',
                  hintStyle: TextStyle(color: Color.fromARGB(85, 0, 0, 0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.yellow,),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            width: 1.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: gradientColors),
            ),
            child: Center(
              child: Text(
                'Request a callback',
                style: contentStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              "Don't worry! We won't span you",
              style: titleStyle.copyWith(
                  fontSize: 12, color: Color.fromARGB(146, 0, 0, 0)),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
