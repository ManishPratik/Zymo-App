import 'package:flutter/material.dart';
import 'package:letzrentnew/screens/NewCars/car_data.dart';
import 'package:letzrentnew/screens/NewCars/test_drive_booking.dart';

class SummaryAndFAQScreen extends StatefulWidget {
  // const SummaryAndFAQScreen({Key? key}) : super(key: key);
  final CarData car;
  const SummaryAndFAQScreen({
    Key? key,
    required this.car,
  }) : super(key: key);
  @override
  State<SummaryAndFAQScreen> createState() => _SummaryAndFAQScreenState();
}

class _SummaryAndFAQScreenState extends State<SummaryAndFAQScreen> {
  int? expandedIndex;
  int currentImageIndex = 0;
  final PageController _pageController = PageController();

  final List<String> carImages = [
    'assets/images/NewCars/nexon.png',
    'assets/images/NewCars/nexon2.png',
    'assets/images/NewCars/nexon3.png',
  ];

  final List<Map<String, dynamic>> faqs = [
    {
      'question': 'How do I Charge the vehicle at home?',
      'answer':
          '• A regular household outlet (15A plug) can charge the Tata Nexon EV via AC power. The charging time will be eight to nine hours using AC power.\n\n• The Tata Nexon EV can be charged using a standard 15A plug point. It takes around 8-9 hours to charge the vehicle completely.',
    },
    {
      'question': 'Will You Provide a Charger?',
      'answer':
          'Yes, We shall provide you with a Charger. The charger needs to be maintained carefully with the user.',
    },
    {
      'question': 'What if I do FAST Charging?',
      'answer':
          '• There needs to be 1 - 100% Slow Charging after every 3 Fast Charging cycles.\n\n• It is always recommended to charge 100% every time',
    },
    {
      'question': 'How do I create charging facility at my home?',
      'answer':
          'You would require to seek necessary permission from society if required, dedicated covered parking slot shall be essential. There would be wiring work to be done from your meter by an electrician with proper earthing suitable for EV charging.\n\nThere may be some cities where electricity board NOC may also be required for installing EV charging.',
    },
    {
      'question': 'Can ORIX create charging point for me?',
      'answer':
          'Yes, this can be done with additional charges payable on estimating the wiring required with other applicable charges.',
    },
    {
      'question':
          'What if charger is damaged, can it be repaired or claimed under insurance?',
      'answer':
          'Charger is non repairable, apart, charger is considered as accessories and is not part of vehicle, thus, cannot be claimed under insurance for any damages. Cost for new charger shall be absorbed by customer.',
    },
    {
      'question': 'What if the vehicle is not getting charged properly?',
      'answer':
          'We would need to send the vehicle to workshop to check, if fault with charger or EV battery',
    },
    {
      'question':
          'What if my driving battery drained down and not starting during the trip, should there be any mark off which below not to drive?',
      'answer':
          'If the running battery is drained down, it would require to be towed to the nearest charging station or your residence for charging.\n\nIt is recommended not to drive with battery at 25% or less',
    },
    {
      'question': 'What is the range for 100% charged vehicle?',
      'answer':
          'The drive ranges from 180 to 220kms depending on the terrain and driving modes',
    },
    {
      'question': 'How many airbags in an EV?',
      'answer': 'There are 6 airbags in Nexon EV',
    },
    {
      'question': 'Will the mileage differ with car speed?',
      'answer':
          'High speed driving with effect the mileage, apart, the traffic conditions also results in low mileage',
    },
    {
      'question': 'What will be the speed Limit in EV?',
      'answer':
          'As per government regulations, since, this is commercial vehicle the vehicle is speed restricted to 80kmph',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Summary',
                  style: TextStyle(
                    color: const Color(0xFFDEFF63),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFedff8d),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  currentImageIndex = index;
                                });
                              },
                              itemCount: carImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      carImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  carImages.length,
                                  (index) => Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentImageIndex == index
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Nexon EV', // You can replace this with a static name or use widget.car.name
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Monthly Test Drive Fee', '₹52,500'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Security Deposit', '₹40,000'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Colors.grey),
                      ),
                      _buildSummaryRow('Total Amount', '₹92,500',
                          isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Free Kilometers',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '1,500 km',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Vendor',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'MyChoize',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'FAQs',
                  style: TextStyle(
                    color: const Color(0xFFDEFF63),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        onExpansionChanged: (isExpanded) {
                          setState(() {
                            expandedIndex = isExpanded ? index : null;
                          });
                        },
                        initiallyExpanded: index == expandedIndex,
                        title: Text(
                          faqs[index]['question'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              faqs[index]['answer'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TestDriveBookingScreen(car: widget.car),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFedff8d),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
