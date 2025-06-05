import 'package:flutter/material.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/widgets.dart';

class RentPayFaq extends StatefulWidget {
  const RentPayFaq({Key? key}) : super(key: key);

  @override
  _RentPayFaqState createState() => _RentPayFaqState();
}

class _RentPayFaqState extends State<RentPayFaq> {
  final List<bool> index = List.filled(AppData.rentPayFAQs.length, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('Rent Pay FAQs'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: AppData.rentPayFAQs.length,
            itemBuilder: (BuildContext context, int index) {
              return FAQTile(AppData.rentPayFAQs[index]['heading'],
                  AppData.rentPayFAQs[index]['body']);
            },
          ),
        ));
  }
}
