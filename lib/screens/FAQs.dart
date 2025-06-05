import 'package:flutter/material.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/screens/referral_screen.dart';

class Help extends StatelessWidget {
  static const routeName = '/help';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 9,
        title: Text(
          'FAQs',
          style: TextStyle(fontWeight: FontWeight.w700,color:Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Card(
                  color: Colors.black,
                  child: Column(children: <Widget>[
                    ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: AppData.faqList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final questions = AppData.faqList[index].keys.first;
                        final answers = AppData.faqList[index].values.first;
                        return FAQTile(questions, answers);
                      },
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
