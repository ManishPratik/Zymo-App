
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letzrentnew/Utils/widgets.dart';

class EV_Faq extends StatefulWidget {
  const EV_Faq({Key? key}) : super(key: key);
  static const routeName = '/EV_faq';

  @override
  State<EV_Faq> createState() => _EV_FaqState();
}

class _EV_FaqState extends State<EV_Faq> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EV - FAQ'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
//      stream: FirebaseFirestore.instance.collection("/EV FAQ/MYChoize/Question").snapshots(),
        stream: FirebaseFirestore.instance.collection("EV FAQ").doc("MYChoize").collection("Question").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final questions = docs[index]["question"];
                              final answers = docs[index]["answer"];
                              return FAQTile(questions, answers);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}