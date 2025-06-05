import 'package:flutter/material.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/brand_model.dart';

class ViewMoreBrands extends StatefulWidget {
  const ViewMoreBrands({Key? key}) : super(key: key);

  @override
  State<ViewMoreBrands> createState() => _ViewMoreBrandsState();
}

class _ViewMoreBrandsState extends State<ViewMoreBrands> {
  List<Brand> brands = [
    Brand(name: 'Audi', imageUrl: 'assets/images/brands/audi-logo.jpg'),
    Brand(name: 'Kia', imageUrl: 'assets/images/brands/kia.png'),
    Brand(name: 'BMW', imageUrl: 'assets/images/brands/bmw-logo.jpg'),
    Brand(name: 'Mahindra', imageUrl: 'assets/images/brands/mahindra.png'),
    Brand(name: 'Mercedes', imageUrl: 'assets/images/brands/mercedes.png'),
    Brand(
        name: 'Morris Garages',
        imageUrl: 'assets/images/brands/morris-garage.jpg'),
    Brand(name: 'Maruti', imageUrl: 'assets/images/brands/maruti.png'),
    Brand(name: 'Tata', imageUrl: 'assets/images/brands/tata.png'),
    Brand(name: 'Toyota', imageUrl: 'assets/images/brands/toyota.png'),
    Brand(name: 'Honda', imageUrl: 'assets/images/brands/honda-logo.jpg'),
  ];
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black, // Set background color to black
        padding: const EdgeInsets.all(8),
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
                  margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey[850], // Foreground color
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.clear_outlined,
                      color: Colors.white, // Icon color to white
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: brands.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items in each row
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey), // Border color
                    ),
                    color: Colors.grey[850], // Foreground color for the card
                    elevation: 4,
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                image: AssetImage(brands[index].imageUrl),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              brands[index].name,
                              style: TextStyle(
                                color: Colors.white, // Text color for brand name
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}