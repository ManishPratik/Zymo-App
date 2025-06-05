import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/models/mychoize_model.dart';


class MyChoizeService {
  // Base URL for the MyChoize API
  static const String _baseUrl = 'https://orixiddriveuat.orixindia.com/OrixMobileAppThirdParty/BookingService/SearchBookingNewSortList';
  
  // Static credentials (consider moving to a secure configuration in production)
  static const String _customerSecurityToken = 'Letsrent@test123';
  static const String _customerType = 'LETSRENTTEST';

  /// Fetch available vehicles from MyChoize API
  /// 
  /// [pickupDate] - DateTime for pickup
  /// [dropDate] - DateTime for drop-off
  /// [cityKey] - Key representing the city
  /// [fuelType] - Optional fuel type filter
  /// [gearType] - Optional transmission type filter
  /// [vehicleType] - Optional vehicle type filter
  Future<List<MyChoizeModel>> searchAvailableVehicles({
    required DateTime pickupDate,
    required DateTime dropDate,
    required int cityKey,
    String fuelType = '',
    String gearType = '',
    String vehicleType = '',
  }) async {
    try {
      // Convert dates to MyChoize's specific date format
      String formattedPickupDate = _formatDateForMyChoize(pickupDate);
      String formattedDropDate = _formatDateForMyChoize(dropDate);

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'PickDate': formattedPickupDate,
        'DropDate': formattedDropDate,
        'CityKey': cityKey,
        'FuelType': fuelType,
        'GearType': gearType,
        'LocationKey': 0, // Default as per your example
        'PageNo': 1,
        'PageSize': 50,
        'RentalType': 'D', // Daily rental
        'CustomerSecurityToken': _customerSecurityToken,
        'CustomerType': _customerType,
        'VehcileType': vehicleType,
      };

      // Make HTTP POST request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Check response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check for successful API response
        if (responseData['ErrorFlag'] == 'N') {
          // Parse the search results
          List<dynamic> searchResults = responseData['SearchBookingModel'] ?? [];
          
          return searchResults
              .map((vehicleJson) => MyChoizeModel.fromJson(vehicleJson))
              .toList();
        } else {
          // Handle API-level errors
          throw Exception('MyChoize API Error: ${responseData['ErrorMessage']}');
        }
      } else {
        // Handle HTTP errors
        throw Exception('Failed to load vehicles. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error in MyChoize vehicle search: $e');
      rethrow;
    }
  }

  /// Convert DateTime to MyChoize's specific date format
  /// 
  /// MyChoize uses a specific date format with milliseconds since epoch
  String _formatDateForMyChoize(DateTime date) {
    // Convert to milliseconds with timezone offset (+0530 for India)
    int millisecondsSinceEpoch = date.millisecondsSinceEpoch;
    return '/Date($millisecondsSinceEpoch+0530)/';
  }

  /// Transform MyChoize vehicles to your app's internal CarModel
  /// 
  /// This method helps bridge the gap between MyChoize's data model 
  /// and your application's expected model
  List<CarModel> transformToCarModels(List<MyChoizeModel> myChoizeVehicles) {
    return myChoizeVehicles.map((vehicle) {
      return CarModel(
        name: vehicle.brandName,
        finalPrice: vehicle.totalExpCharge?.toDouble(),
        imageUrl: vehicle.vehicleBrandImageName,
        // vendor: Vendor(
        //   name: 'MyChoize',
        //   imageUrl: vehicle.vehicleBrandImageName,
        // ),
        // Map other relevant fields from MyChoizeModel
        // You'll need to adjust based on your exact CarModel structure
      );
    }).toList();
  }
}