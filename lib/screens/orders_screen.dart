import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Services/auth_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Screens/order_widget.dart';
import 'package:letzrentnew/models/booking_model.dart';
import 'package:letzrentnew/screens/home_page.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'MyOrders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  User? get user => Auth().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    // Safely handle potentially null route arguments
    final title = ModalRoute.of(context)?.settings.arguments as String? ?? 'My';
    
    return Scaffold(
        appBar: AppBar(
          title: Text('$title Orders', style: TextStyle(
            color: Colors.black,
          )),
        ),
        body: user == null
            ? NoUserError(
                message: "Log in to see your profile",
                onLogin: () => setState(() {}),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: getStream(title),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting ||
                      !chatSnapshot.hasData) {
                    return Center(
                      child: spinkit,
                    );
                  }
                  
                  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                      (chatSnapshot.data?.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>?) ?? [];
                      
                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.magnifyingGlass),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'No past orders found.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, title),
                            child: Text('Checkout $title', style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appColor),
                          )
                        ],
                      ),
                    );
                  }
                  
                  docs.sort((a, b) {
                    final dateA = a.data()['DateOfBooking'];
                    final dateB = b.data()['DateOfBooking'];
                    if (dateA != null && dateB != null) {
                      return dateB.compareTo(dateA);
                    }
                    return 0;
                  });
                  
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (ctx, index) {
                      final model = BookingModel.fromJson(docs[index].data());
                      final String id = docs[index].id;
                      return OrderTile(documentId: id, bookingModel: model);
                    },
                  );
                }));
  }

  Stream<QuerySnapshot>? getStream(String? title) {
    final currentUser = Auth().getCurrentUser();
    if (currentUser == null) return null;
    
    final String uid = currentUser.uid;
    
    switch (title) {
      case 'Self Drive Cars':
        return FirebaseFirestore.instance
            .collection(carsPaymentSuccessDetails)
            .where('UserId', isEqualTo: uid)
            .where('Drive', isEqualTo: 'Sd')
            .snapshots();

      case 'Chauffeur Drive':
        return FirebaseFirestore.instance
            .collection(carsPaymentSuccessDetails)
            .where('UserId', isEqualTo: uid)
            .where('Drive', isNotEqualTo: 'Sd')
            .snapshots();
            
      case 'Co-Living':
        return FirebaseFirestore.instance
            .collection('ColivingPaymentSuccessDetails')
            .where('userid', isEqualTo: uid)
            .snapshots();

      case 'Co-Working':
        return FirebaseFirestore.instance
            .collection('CoworkingPaymentSuccessDetails')
            .where('userid', isEqualTo: uid)
            .snapshots();

      case 'Rent Pay':
        return FirebaseFirestore.instance
            .collection('RentPayPaymentSuccessDetails')
            .where('userid', isEqualTo: uid)
            .snapshots();

      case 'Monthly Car Rental':
        return FirebaseFirestore.instance
            .collection(carsPaymentSuccessDetails)
            .where('UserId', isEqualTo: uid)
            .where('Drive', isEqualTo: 'subscription')
            .snapshots();

      default:
        return FirebaseFirestore.instance
            .collection(carsPaymentSuccessDetails)
            .where('UserId', isEqualTo: uid)
            .snapshots();
    }
  }
}