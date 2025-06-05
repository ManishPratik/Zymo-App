import 'package:flutter/material.dart';

class PriceCategory extends StatefulWidget {
  const PriceCategory({Key? key}) : super(key: key);

  @override
  State<PriceCategory> createState() => _PriceCategoryState();
}

class _PriceCategoryState extends State<PriceCategory> {
  int activeIndex = 0;
  List price = ['5-10 Lakhs', '10-15 Lakhs', '15-20 Lakhs', '>20 Lakhs'];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 45,
            // padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: price.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        width: 150,
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          color: index == activeIndex
                              ? Colors.yellow
                              : Color.fromARGB(96, 80, 31, 88),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                            child: Text(
                              price[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: activeIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
