// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:letzrentnew/screens/NewCars/car_data.dart';
// import 'package:letzrentnew/screens/NewCars/document_upload.dart';
// import 'package:letzrentnew/models/user_model.dart';
// import 'package:provider/provider.dart';

// class TestDriveBookingScreen extends StatefulWidget {
//   final CarData car;

//   const TestDriveBookingScreen({Key? key, required this.car}) : super(key: key);

//   @override
//   State<TestDriveBookingScreen> createState() => _TestDriveBookingScreenState();
// }

// class _TestDriveBookingScreenState extends State<TestDriveBookingScreen> {
//   DateTime? selectedPickupDate;
//   DateTime? selectedDropDate;

//   @override
//   void initState() {
//     super.initState();
//     // Set initial pickup date to day after tomorrow
//     selectedPickupDate = DateTime.now().add(const Duration(days: 2));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildWelcomeText(),
//                     const SizedBox(height: 40),
//                     _buildPickupSection(),
//                     // const SizedBox(height: 32),
//                     // _buildDropoffSection(),
//                   ],
//                 ),
//               ),
//             ),
//             _buildNextButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(Icons.arrow_back, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeText() {
//     return RichText(
//       text: const TextSpan(
//         children: [
//           TextSpan(
//             text: 'Welcome ',
//             style: TextStyle(
//               color: Color(0xFFDEFF63),
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           TextSpan(
//             text: 'to Extended Test Drive!',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPickupSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Pick-up Date',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildDatePicker(
//           selectedDate: selectedPickupDate,
//           onDateSelected: (date) {
//             setState(() {
//               selectedPickupDate = date;
//               // Reset drop date if it's before pickup date
//               if (selectedDropDate != null &&
//                   selectedDropDate!.isBefore(date)) {
//                 selectedDropDate = null;
//               }
//             });
//           },
//           minDate: DateTime.now().add(const Duration(days: 2)),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropoffSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Drop-off Date',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildDatePicker(
//           selectedDate: selectedDropDate,
//           onDateSelected: (date) {
//             setState(() {
//               selectedDropDate = date;
//             });
//           },
//           minDate: selectedPickupDate ?? DateTime.now(),
//           maxDate: selectedPickupDate?.add(const Duration(days: 30)),
//         ),
//       ],
//     );
//   }

//   Widget _buildDatePicker({
//     required DateTime? selectedDate,
//     required Function(DateTime) onDateSelected,
//     required DateTime minDate,
//     DateTime? maxDate,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             selectedDate != null
//                 ? DateFormat('MMMM dd, yyyy').format(selectedDate)
//                 : 'Select a date',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 80,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 30,
//               itemBuilder: (context, index) {
//                 final date = minDate.add(Duration(days: index));
//                 if (maxDate != null && date.isAfter(maxDate)) {
//                   return const SizedBox.shrink();
//                 }

//                 final isSelected = selectedDate?.year == date.year &&
//                     selectedDate?.month == date.month &&
//                     selectedDate?.day == date.day;

//                 return GestureDetector(
//                   onTap: () => onDateSelected(date),
//                   child: Container(
//                     width: 60,
//                     margin: const EdgeInsets.only(right: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFFDEFF63)
//                           : Colors.grey[800],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           DateFormat('MMM').format(date),
//                           style: TextStyle(
//                             color: isSelected ? Colors.black : Colors.grey,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           date.day.toString(),
//                           style: TextStyle(
//                             color: isSelected ? Colors.black : Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNextButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ElevatedButton(
//         onPressed: selectedPickupDate != null && selectedDropDate != null
//             ? () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChangeNotifierProvider(
//                       create: (_) =>
//                           UserModel(), // Initialize your UserModel here
//                       child: DocumentUploadScreen(
//                         car: widget.car,
//                         pickupDate: selectedPickupDate!,
//                         dropDate: selectedDropDate!,
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             : null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFDEFF63),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: const Text(
//           'Next',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letzrentnew/screens/NewCars/car_data.dart';
import 'package:letzrentnew/screens/NewCars/document_upload.dart';
import 'package:letzrentnew/models/user_model.dart';
import 'package:letzrentnew/screens/NewCars/test_drive_booking_form.dart';
import 'package:provider/provider.dart';

class TestDriveBookingScreen extends StatefulWidget {
  
  final currentUser = FirebaseAuth.instance.currentUser;
  final CarData car;

   TestDriveBookingScreen({Key? key, required this.car}) : super(key: key);

  @override
  State<TestDriveBookingScreen> createState() => _TestDriveBookingScreenState();
}

class _TestDriveBookingScreenState extends State<TestDriveBookingScreen> {
  DateTime? selectedPickupDate;

  @override
  void initState() {
    super.initState();
    // Set initial pickup date to day after tomorrow
    selectedPickupDate = DateTime.now().add(const Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeText(),
                    const SizedBox(height: 40),
                    _buildPickupSection(),
                    const SizedBox(height: 25,),
                    Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFedff8d),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Booking Info',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'You can select a date now and have to return it exactly 1 month later',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Welcome ',
            style: TextStyle(
              color: Color(0xFFDEFF63),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'to Extended Test Drive!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick-up Date',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDatePicker(
          selectedDate: selectedPickupDate,
          onDateSelected: (date) {
            setState(() {
              selectedPickupDate = date;
            });
          },
          minDate: DateTime.now().add(const Duration(days: 2)),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required DateTime minDate,
    DateTime? maxDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedDate != null
                ? DateFormat('MMMM dd, yyyy').format(selectedDate)
                : 'Select a date',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              itemBuilder: (context, index) {
                final date = minDate.add(Duration(days: index));
                if (maxDate != null && date.isAfter(maxDate)) {
                  return const SizedBox.shrink();
                }

                final isSelected = selectedDate?.year == date.year &&
                    selectedDate?.month == date.month &&
                    selectedDate?.day == date.day;

                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFDEFF63)
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMM').format(date),
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: selectedPickupDate != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => UserModel(), // Initialize your UserModel here
                      child: TestDriveBookingForm(car: widget.car, isExtended: true, userId: widget.currentUser?.uid ?? '',)
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDEFF63),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

