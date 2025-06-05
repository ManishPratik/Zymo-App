import 'package:flutter/material.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/models/user_model.dart';
import 'package:letzrentnew/screens/NewCars/car_data.dart';
import 'package:letzrentnew/screens/NewCars/document_upload.dart';
import 'package:letzrentnew/screens/NewCars/test_drive_booking.dart';
import 'package:provider/provider.dart';

class TestDriveBookingForm extends StatefulWidget {
  final CarData car;
  final bool isExtended;
  final String userId;

  const TestDriveBookingForm({
    Key? key,
    required this.car,
    required this.isExtended,
    required this.userId,
  }) : super(key: key);

  @override
  State<TestDriveBookingForm> createState() => _TestDriveBookingFormState();
}

class _TestDriveBookingFormState extends State<TestDriveBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseServices _firebaseServices = FirebaseServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _firebaseServices.getUserDetails(widget.userId);

      if (userData != null) {
        setState(() {
          _nameController.text = userData.name ?? '';
          _emailController.text = userData.email ?? '';
          _phoneController.text = userData.phoneNumber?.replaceFirst('+91', '') ?? '';
          _streetController.text = userData.street1 ?? '';
          _cityController.text = userData.city ?? '';
          _pincodeController.text = userData.zipcode ?? '';
          _aadhaarController.text = userData.aadhaarNumber ?? '';
          if (userData.dob != null) {
            _selectedDate = DateTime.parse(userData.dob!);
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your date of birth')),
        );
        return;
      }

      final userModel = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: '+91${_phoneController.text}',
        street1: _streetController.text,
        city: _cityController.text,
        zipcode: _pincodeController.text,
        aadhaarNumber: _aadhaarController.text,
        dob: _selectedDate?.toIso8601String(),
      );

      try {
        await _firebaseServices.addUserData(userModel.toJson());

        Navigator.push(
          context,
          MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => UserModel(), // Initialize your UserModel here
                      child: DocumentUploadScreen(car: widget.car)
                    ),
                  ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFedff8d),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.isExtended ? 'Extended Test Drive Booking' : 'Test Drive Booking',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Name (as on Driving License)'),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter your full name',
                validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Email'),
              _buildTextField(
                controller: _emailController,
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Phone Number'),
              _buildTextField(
                controller: _phoneController,
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'Phone number is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Aadhaar Number'),
              _buildTextField(
                controller: _aadhaarController,
                hint: 'Enter your Aadhaar number',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Aadhaar number is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Street Address'),
              _buildTextField(
                controller: _streetController,
                hint: 'Enter street address',
                validator: (value) => value?.isEmpty ?? true ? 'Street address is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('City'),
              _buildTextField(
                controller: _cityController,
                hint: 'Enter city',
                validator: (value) => value?.isEmpty ?? true ? 'City is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Pincode'),
              _buildTextField(
                controller: _pincodeController,
                hint: 'Enter pincode',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Pincode is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Date of Birth'),
              GestureDetector(
                onTap: () => _showCustomDatePicker(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey : Colors.white,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUserData,
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  void _showCustomDatePicker(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
    firstDate: DateTime(1900),
    lastDate: DateTime.now().subtract(const Duration(days: 6570)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFFedff8d),
            onPrimary: Colors.grey,
            surface: Colors.grey[900]!,
            onSurface: Colors.white,
          ),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary, // Ensures that buttons use the theme's primary color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey, // Changes the text color of the buttons
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _selectedDate = picked;
    });
  }
}

}