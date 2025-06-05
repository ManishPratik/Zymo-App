import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/models/document_model.dart';
import 'package:letzrentnew/models/user_model.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:letzrentnew/screens/NewCars/car_data.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:io';

class DocumentUploadScreen extends StatefulWidget {
  final CarData car;
  // final DateTime pickupDate;
  

  const DocumentUploadScreen({
    Key? key,
    required this.car,
    // required this.pickupDate,
    
  }) : super(key: key);

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  late Razorpay _razorpay;
  bool _isLoading = true;
  bool _isUploading = false;
  DocumentModel? documents;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    _loadExistingDocuments();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadExistingDocuments() async {
    try {
      final snapshot = await _firebaseServices.getDocuments().first;
      setState(() {
        documents = snapshot.data() != null 
          ? DocumentModel.fromJson(snapshot.data() as Map<String, dynamic>)
          : DocumentModel();
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error loading documents', e);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isUploading = true);

    try {
      final user = Provider.of<UserModel>(context, listen: false);
      
      // if (user != null) {
      //   final driveModel = DriveModel()
      //     ..startDate = widget.pickupDate.toIso8601String()
      //     ..endDate = widget.dropDate.toIso8601String()
      //     ..starttime = widget.pickupDate.toString()
      //     ..endtime = widget.dropDate.toString()
      //     ..drive = DriveTypes.SD;

      //   final carModel = CarModel()
      //     ..name = widget.car.name
      //     ..vendor = VendorModel()..name = widget.car.vendor
      //     ..pickUpAndDrop = widget.car.pickupLocation
      //     ..finalPrice = widget.car.actualPrice
      //     ..package = widget.car.package;

      //   await _firebaseServices.addBooking(user, carModel, driveModel);

      //   if (mounted) {
      //     Navigator.pushNamed(context, 'success_page', arguments: response.paymentId);
      //   }
      // }
    } catch (e) {
      _handleError('Error processing payment', e);
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pushNamed(
      context,
      'failed_page',
      arguments: {'response': response},
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External wallet selected: ${response.walletName}");
  }

  Future<void> _initiatePayment() async {
    try {
      final user = Provider.of<UserModel>(context, listen: false);

      if (user == null) {
        throw Exception('User information not found. Please log in again.');
      }

      if (!_areAllDocumentsUploaded) {
        throw Exception('Please upload all required documents');
      }

      final options = {
        'key': RazorPayKey,
        'amount': (widget.car.actualPrice * 100).toInt(),
        'name': appName,
        'description': 'Car Rental Payment',
        'prefill': {
          'contact': user.phoneNumber,
          'email': user.email
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      _razorpay.open(options);
    } catch (e) {
      _handleError('Payment initialization failed', e);
    }
  }

  void _handleError(String prefix, dynamic error) {
    debugPrint('$prefix: $error');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$prefix: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool get _areAllDocumentsUploaded =>
      documents?.licenseFront != null &&
      documents?.licenseBack != null &&
      documents?.aadhaarFront != null &&
      documents?.aadhaarBack != null;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 40),
                        Consumer<HomeProvider>(
                          builder: (context, value, child) => AllDocumentsWidget(
                            documents: documents,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildPaymentButton(),
              ],
            ),
            if (_isUploading) _buildUploadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFDEFF63),
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

  Widget _buildTitle() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "You're just one step away from ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Booking',
            style: TextStyle(
              color: Color(0xFFDEFF63),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isUploading ? null : (_areAllDocumentsUploaded ? _initiatePayment : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDEFF63),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          _isUploading ? 'Processing...' : 'Proceed to Payment',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFDEFF63),
        ),
      ),
    );
  }
}