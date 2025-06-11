import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/extensions.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/Services/car_services.dart';
import 'package:letzrentnew/widgets/Cars/user_booking_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../Utils/widgets.dart';

class CarsView extends StatefulWidget {
  final DriveModel model;

  const CarsView({super.key, required this.model});

  @override
  State<CarsView> createState() => _CarsViewState();
}

class _CarsViewState extends State<CarsView> {
  List<List<CarModel>>? finalList;
  bool automatic = false;
  bool manual = false;
  bool lowToHigh = true;
  bool hightolow = false;
  bool isSelfPickup = false;
  String carType = 'all';
  int seatCapacity = 0;

  final Map<String, List<String>> _dropdownOptions = {
    'All': ['All'],
    'Transmission': ['Transmission', 'Automatic', 'Manual'],
    'Sort': ['Low - High', 'High - Low'],
    'Fuel': ['Fuel Type', 'Petrol', 'Diesel', 'Electric'],
    'Seats': ['Seats', '5 Seats', '6 Seats', '7 Seats', '8 Seats'],
  };

  final Map<String, String> _selectedValues = {
    'All': 'All',
    'Transmission': 'Transmission',
    'Sort': 'Low - High',
    'Fuel': 'Fuel Type',
    'Seats': 'Seats',
  };

  //coonectivity

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  Future<void> _checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (error) {
      print(error.toString());
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    setState(() {
      // Use the first connectivity result from the list, or default to none
      _connectionStatus =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      print(_connectionStatus);
    });
  }

  @override
  void initState() {
    mixpanel.track('Car listing page', properties: {
      'Map Location': widget.model.mapLocation,
      'Duration selected': widget.model.remainingDuration,
      'City': widget.model.city,
      'Type': widget.model.drive.toString()
    });
    super.initState();
    // Subscribe to the connectivity change stream
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // Initial connectivity check
    _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    final _startTime = widget.model.starttime;
    final _endTime = widget.model.endtime;
    final DriveTypes? _drive = widget.model.drive;
    final _startDate = widget.model.startDate.toString().substring(0, 7);
    final _endDate = widget.model.endDate.toString().substring(0, 7);
    final distance = widget.model.distanceOs;
    final String remainingDuration = widget.model.remainingDuration!;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: darkBgColor,
        appBar: AppBar(
          backgroundColor: darkBgColor,
          title: Text(
            remainingDuration,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
          ),
          actions: [
            if (widget.model.city!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 25,
                    ),
                    Text(widget.model.city!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              )
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            SizedBox(
              // width: .9.sw,
              height: .07.sh,
              child: Card(
                color: accentColor,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: Text(
                      '${CarServices.getDurationText(_drive!, _startDate, _endDate, _startTime!, _endTime!, distance!)} ',
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            /*Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: const Text(
                          'All',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterRow([
                    _buildDropdown('Transmission'),
                    _buildDropdown('Sort'),
                  ]),
                  const SizedBox(height: 12),
                  _buildFilterRow([
                    _buildDropdown('Seats'),
                    _buildDropdown('Fuel'),
                  ]),
                  const SizedBox(height: 12),
                  _buildFilterRow([
                    _buildActionButton(
                      icon: Icons.refresh,
                      color: const Color(0xFF3A3A3A),
                      onPressed: _resetFilters,
                    ),
                    _buildActionButton(
                      label: 'Apply',
                      color: const Color(0xFFF8F587),
                      onPressed: () {},
                    ),
                  ]),
                ],
              ),
            ),*/
            Expanded(
              child: FutureBuilder<List<CarModel>>(
                  future: getFuture(widget.model),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _connectionStatus == ConnectivityResult.none
                          ? Center(
                              child: AppErrorWidget(
                              error: 'Oops! Internet Lost. Please try again',
                              function: () {
                                setState(() {});
                              },
                            ))
                          : shimmerLoading(context);
                    } else if (snapshot.hasError) {
                      return AppErrorWidget(
                        error: 'Oops! ${snapshot.error}',
                        function: () {
                          setState(() {});
                        },
                      );
                    } else {
                      finalList =
                          getCarList(snapshot.data!, widget.model.carGrouping!);
                      if (finalList!.isEmpty) {
                        return _connectionStatus == ConnectivityResult.none
                            ? Center(
                                child: AppErrorWidget(
                                error: 'Oops! Internet Lost. Please try again',
                                function: () {
                                  setState(() {});
                                },
                              ))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.carBurst,
                                    size: .1.sh,
                                  ),
                                  SizedBox(
                                    height: .05.sh,
                                  ),
                                  Text(
                                      'No cars available for the selected duration.',
                                      style: largeStyle),
                                  ElevatedButton(
                                      onPressed: () => setState(() {}),
                                      child: Text('Retry'))
                                ],
                              );
                      } else {
                        finalList = sortingFunction(finalList!);
                        return Scrollbar(
                          interactive: true,
                          child: RefreshIndicator(
                            onRefresh: () async => refreshFunction(),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: finalList?.length,
                              itemBuilder: (context, index) {
                                return CarTile(
                                  model: widget.model,
                                  carModelList: finalList![index],
                                );
                              },
                            ),
                          ),
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(List<Widget> children) {
    return Row(
      children: children
          .map((child) => Expanded(child: child))
          .expand((widget) => [widget, const SizedBox(width: 12)])
          .toList()
        ..removeLast(),
    );
  }

  Widget _buildDropdown(String key, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedValues[key],
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: Colors.grey[800],
          style: const TextStyle(color: Colors.white),
          items: _dropdownOptions[key]!
              .map((opt) => DropdownMenuItem(
                    value: opt,
                    child: Text(opt),
                  ))
              .toList(),
          onChanged: enabled
              ? (val) => setState(() => _selectedValues[key] = val!)
              : null,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    String? label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: icon != null
          ? Icon(icon, color: const Color(0xFFF8F587))
          : Text(label!,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedValues.forEach((key, value) {
        _selectedValues[key] = _dropdownOptions[key]!.first;
      });
    });
  }

  Future<List<CarModel>> getFuture(DriveModel model) {
    return CarServices()
        .getCars(model)
        .timeout(timeOutDuration, onTimeout: () => throw ('Timed out'));
  }

  void refreshFunction() {
    return setState(() {
      finalList = [];
    });
  }

  List<List<CarModel>> sortingFunction(List<List<CarModel>> data) {
    /*if (lowToHigh) {
      data.sort((a, b) => a.first.finalPrice.compareTo(b.first.finalPrice));
    } else {
      data.sort((a, b) => b.first.finalPrice.compareTo(a.first.finalPrice));
    }*/
    // if (carType != null && carType != 'all') {
    //   data = data.where((element) {
    //     return (element.first.type?.toLowerCase() ?? '') == carType;
    //   }).toList();
    // }
    if (manual) {
      data = data.where((element) {
        return (element.first.transmission.toLowerCase() ?? '') == 'manual';
      }).toList();
    } else if (automatic) {
      data = data
          .where((element) =>
              (element.first.transmission.toLowerCase() ?? '') == 'automatic')
          .toList();
    }
    if (isSelfPickup) {
      // data = data.where((element) {
      //   return (element.first.transmission?.toLowerCase() ?? '') == 'manual';
      // }).toList();
    } else if (automatic) {
      data = data
          .where((element) => (element.first.vendor!.name != zoomCar))
          .toList();
    }
    if (seatCapacity != 0) {
      data = data
          .where((element) => (element.first.seats == seatCapacity))
          .toList();
    }
    return data;
  }

  List<List<CarModel>> getCarList(List<CarModel> carList, List carGroup) {
    final Map<String, List<CarModel>> tempList = {};
    carList.forEach((car) {
      final List<CarModel> eachCarList = carList.where((element) {
        final String elementName = getCarName(element.name, carGroup);
        final String carName = getCarName(car.name, carGroup);
        return elementName == carName;
      }).toList();

      tempList.addAll({eachCarList.first.name: eachCarList});
    });
    final List<List<CarModel>> unsortedList = tempList.values.toList();
    final List<List<CarModel>> sortedList = [];
    unsortedList.forEach((bucket) {
      bucket.sort((a, b) {
        final ap = a.finalPrice ?? double.infinity;
        final bp = b.finalPrice ?? double.infinity;
        return ap.compareTo(bp);
      });
      sortedList.add(bucket);
    });

    return sortedList;
  }

  String getCarName(String carName, List carGroup) {
    String name = carName.toLowerCase();
    carGroup.forEach((element) {
      if (name.contains(element.toLowerCase())) {
        carName = element;
      }
    });
    return carName.toUpperCase();
  }

  Future showFilter(BuildContext context, DriveTypes drive) {
    const String all = 'all';
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: .72.sh,
        width: 1.sw,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    const Text('Filters', style: bigTitleStyle),
                    Spacer(),
                    InkWell(
                      onTap: () => setState(() {
                        carType = all;
                        automatic = false;
                        manual = false;
                      }),
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: .03.sh,
                ),
                if (drive != DriveTypes.WC ||
                    drive != DriveTypes.AT ||
                    drive != DriveTypes.RT)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transmission',
                        style: headingStyle,
                      ),
                      SizedBox(
                        height: .01.sh,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilterItem(
                            isSelected: manual,
                            title: 'Manual',
                            function: () => setState(() {
                              manual = true;
                              automatic = false;
                            }),
                            width: .22.sw,
                          ),
                          FilterItem(
                              isSelected: automatic,
                              title: 'Automatic',
                              function: () => setState(() {
                                    manual = false;
                                    automatic = true;
                                  }),
                              width: .22.sw),
                          FilterItem(
                              isSelected: !automatic && !manual,
                              title: 'All',
                              function: () => setState(() {
                                    automatic = false;
                                    manual = false;
                                  }),
                              width: .22.sw),
                        ],
                      ),
                    ],
                  ),
                SizedBox(
                  height: .03.sh,
                ),
                const Text(
                  'Price',
                  style: headingStyle,
                ),
                SizedBox(
                  height: .01.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilterItem(
                        isSelected: lowToHigh,
                        title: 'Low to High',
                        function: () => setState(() {
                              lowToHigh = true;
                              hightolow = false;
                            }),
                        width: .24.sw),
                    FilterItem(
                        isSelected: hightolow,
                        title: 'High to Low',
                        function: () => setState(() {
                              lowToHigh = false;
                              hightolow = true;
                            }),
                        width: .24.sw),
                  ],
                ),
                SizedBox(
                  height: .03.sh,
                ),
                const Text(
                  'Delivery',
                  style: headingStyle,
                ),
                SizedBox(
                  height: .01.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilterItem(
                        isSelected: isSelfPickup,
                        title: 'Self Pickup',
                        function: () => setState(() {
                              isSelfPickup = true;
                            }),
                        width: .24.sw),
                    FilterItem(
                        isSelected: !isSelfPickup,
                        title: 'Home Delivery',
                        function: () => setState(() {
                              isSelfPickup = false;
                            }),
                        width: .24.sw),
                  ],
                ),
                SizedBox(
                  height: .03.sh,
                ),
                const Text(
                  'Seats',
                  style: headingStyle,
                ),
                SizedBox(
                  height: .01.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilterItem(
                      isSelected: seatCapacity == 5,
                      title: '5',
                      function: () => setState(() {
                        seatCapacity = 5;
                      }),
                      width: .22.sw,
                    ),
                    FilterItem(
                      isSelected: seatCapacity == 6,
                      title: '6',
                      function: () => setState(() {
                        seatCapacity = 6;
                      }),
                      width: .22.sw,
                    ),
                    FilterItem(
                      isSelected: seatCapacity == 7,
                      title: '7',
                      function: () => setState(() {
                        seatCapacity = 7;
                      }),
                      width: .22.sw,
                    ),
                  ],
                ),
                SizedBox(
                  height: .01.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterItem(
                      isSelected: seatCapacity == 8,
                      title: '8',
                      function: () => setState(() {
                        seatCapacity = 8;
                      }),
                      width: .22.sw,
                    ),
                    FilterItem(
                      isSelected: seatCapacity == 0,
                      title: 'All',
                      function: () => setState(() {
                        seatCapacity = 0;
                      }),
                      width: .22.sw,
                    ),
                  ],
                ),
                Spacer(),
                AppButton(
                  screenHeight: 100,
                  title: "Apply",
                  function: () => Navigator.pop(context),
                  textSize: 15,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.error,
    required this.function,
  });

  final String error;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.carBurst,
          size: .1.sh,
        ),
        SizedBox(
          height: .05.sh,
        ),
        Text(
          error,
          style: largeStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: .025.sh,
        ),
        AppButton(
          screenWidth: .8.sw,
          screenHeight: .8.sh,
          textSize: 16,
          title: 'Retry',
          function: function,
          color: Colors.black,
        )
      ],
    );
  }
}

class CarTile extends StatefulWidget {
  final DriveModel model;
  final List<CarModel> carModelList;

  const CarTile({
    super.key,
    required this.model,
    required this.carModelList,
  });

  @override
  State<CarTile> createState() => _CarTileState();
}

/*class _CarTileState extends State<CarTile> {
  @override
  Widget build(BuildContext context) {
    final double? lowestPrice = widget.carModelList.first.finalPrice != null
        ? widget.carModelList.first.finalPrice
        : 0.0;
    final List<String> vendorImages = widget.carModelList
        .map((element) => element.vendor!.imageUrl!)
        .toSet()
        .toList();

    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => openCarPopup(widget.carModelList, context),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[800]),
          height: 400, // Adjust height as needed
          child: Stack(
            children: [
              // Car Image Positioned at the top center
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          border:
                              Border.all(style: BorderStyle.solid, width: 10)),
                      child: carImage(widget.carModelList.first.imageUrl, context)),
                ),
              ),
              // Car Name and Features Positioned below the image
              Positioned(
                top: 270, // Adjust based on image height
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        carName(context, widget.carModelList.first.name),
                        featureRow(widget.carModelList),
                      ],
                    ),
                    startingAt(lowestPrice!),
                  ],
                ),
              ),
              // Vendor Images Positioned below the features
              Positioned(
                top: 340, // Adjust as needed
                left: 12,
                right: 12,
                child: VendorImages(vendorImages: vendorImages),
              ),
              // Distance Text Positioned near the bottom
              Positioned(
                top: 370,
                left: 12,
                child: Text(
                  '${widget.carModelList.first.pickups?.first.distanceFromUser != null ? widget.carModelList.first.pickups?.first.distanceFromUser : 0.0} KMs away',
                  style: itleStyle,
                ),
              ),
              // Booking Fast Widget Positioned at the bottom if applicable
              if (bookingFastList
                  .where(
                      (element) => element.startsWith(widget.carModelList.first.name))
                  .isNotEmpty)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: bookingFastWidget(),
                ),
            ],
          ),
        ),
      ),
    );
    Card(
      //Added Elevation in the blur
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => openCarPopup(widget.carModelList, context),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: carImage(widget.carModelList.first.imageUrl, context)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          carName(context, widget.carModelList.first.name),
                          featureRow(widget.carModelList),
                        ],
                      ),
                      startingAt(lowestPrice),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                ),
                VendorImages(vendorImages: vendorImages),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Text(
                    '${widget.carModelList.first.pickups!.first.distanceFromUser} KMs away',
                    style: itleStyle),
                if (bookingFastList
                    .where((element) =>
                        element.startsWith(widget.carModelList.first.name))
                    .isNotEmpty)
                  bookingFastWidget(),
              ]),
        ),
      ),
    );
  }*/
class _CarTileState extends State<CarTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 280, // Height showing only image + car name
      end: 400,   // Expanded height showing all details
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double? lowestPrice = widget.carModelList.first.finalPrice != null
        ? widget.carModelList.first.finalPrice
        : 0.0;
    final List<String> vendorImages = widget.carModelList
        .map((element) => element.vendor!.imageUrl!)
        .toSet()
        .toList();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Card(
          elevation: 15,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: _toggleExpand,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 34, 34, 34),
              ),
              height: _heightAnimation.value,
              child: Stack(
                children: [
                  // Always visible elements
                  // Car Image
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(style: BorderStyle.solid, width: 10, color: accentColor),
                        ),
                        child: carImage(widget.carModelList.first.imageUrl, context),
                      ),
                    ),
                  ),

                  // Car Name (always visible)
                  Positioned(
                    top: 240,
                    left: 12,
                    right: 12,
                    child: carName(context, widget.carModelList.first.name),
                  ),

                  // Details that appear on expansion
                  if (_heightAnimation.value > 300) // Only show when expanded enough
                    Positioned(
                      top: 240,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // Features and Price
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  featureRow(widget.carModelList),
                                  startingAt(lowestPrice!),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VendorImages(vendorImages: vendorImages),

                                  // Distance
                                  Text(
                                    '${widget.carModelList.first.pickups?.first.distanceFromUser != null ? widget.carModelList.first.pickups?.first.distanceFromUser : 0.0} KMs away',
                                    style: itleStyle,
                                  ),

                                  // Booking Fast Widget
                                  if (bookingFastList
                                      .where((element) =>
                                      element.startsWith(widget.carModelList.first.name))
                                      .isNotEmpty)
                                    bookingFastWidget()

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Floating action button for popup (shown when expanded)
                  if (_isExpanded)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: FloatingActionButton(
                        backgroundColor: accentColor,
                        onPressed: () => openCarPopup(widget.carModelList, context),
                        child: const Icon(Icons.arrow_forward, color: Colors.black,),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Row bookingFastWidget() {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.bolt,
          color: Colors.red,
          size: 14,
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          'Booking fast!',
          style: TextStyle(
              fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  startingAt(double lowestPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Starts at',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          '$rupeeSign${lowestPrice.toStringAsFixed(0).commaFunction()}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        const Text(
          '(GST incl)',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget carImage(String image, BuildContext context) {
    return SizedBox(
      width: .8.sw,
      height: .22.sh,
      child: CachedNetworkImage(
        imageUrl: image,
        // height: 0.22.sw,
        fit: BoxFit.fitWidth,
        placeholder: (context, ok) => const Center(
          child: Text(
            'ZYMO',
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ),
        errorWidget: (c, s, w) => Icon(Icons.error_outline),
      ),
    );
  }

  Row featureRow(List<CarModel> carModelList) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Image.asset(
                "assets/images/ZymoBenefits/carlogo.png",
                //colorBlendMode: BlendMode.darken,
                fit: BoxFit.contain,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(width: 5,),
              Text(
                "${carModelList.first.seats?.toString() ?? carModelList.first.fuel.toString() ?? '4'}",
                style: whiteTitleStyle,
              ),
            ],
          ),
        ),
        const Text(
          " | ",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          carModelList.showOptionsText(),
          style: whiteTitleStyle,
        )
        //deposit, fuel, price too high
      ],
    );
  }

  SizedBox carName(BuildContext context, String name) {
    return SizedBox(
      width: 0.5.sw,
      child: Text(name,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900, color: accentColor),
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }

  Future<void> openCarPopup(
    List<CarModel> carModelList,
    BuildContext context,
  ) async {
    showModalBottomSheet(
      backgroundColor: accentColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0) +
                const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose from',
                      style: bigTitleStyle,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text('Showing ${carModelList.showOptionsText()}', style: TextStyle(fontSize: 16),),
                const SizedBox(
                  height: 6,
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: .7.sh),
                    child: Scrollbar(
                      interactive: true,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: carModelList.length,
                          itemBuilder: (context, index) => CompareWidget(
                                carModel: carModelList[index],
                                model: widget.model,
                              )),
                    )),
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
          );
        });
  }
}

class VendorImages extends StatelessWidget {
  const VendorImages({
    super.key,
    required this.vendorImages,
  });

  final List<String> vendorImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .04.sh,
      width: .8.sw,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vendorImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: CachedNetworkImage(
                        width: .12.sw, imageUrl: vendorImages[index]),
                  );
                }),
          ),
          if (vendorImages.length > 3)
            Text(' +${vendorImages.length - 3}',
                style: TextStyle(color: Colors.white, fontSize: 12))
        ],
      ),
    );
  }
}

class CompareWidget extends StatelessWidget {
  final DriveModel model;
  final CarModel carModel;

  const CompareWidget({
    required this.model,
    required this.carModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              const Text('Fulfilled by', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 0.12.sw,
                  height: .04.sh,
                  child: CachedNetworkImage(
                    imageUrl: carModel.vendor!.imageUrl!,
                    height: 0.22.sw,
                    width: 0.47.sw,
                    fit: BoxFit.fitWidth,
                    color: accentColor,
                    placeholder: (context, ok) => const Center(
                      child: Text(
                        'ZYMO',
                        style: TextStyle(
                            color: accentColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              RatingWidget(totalStars: carModel.vendor!.rating!),
              const Spacer(),
              prices(carModel)
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                extraDetails(carModel, model),
                (carModel.isSoldOut ?? false)
                    ? Text('Sold out',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ))
                    : SizedBox(
                        width: .25.sw,
                        height: .05.sh,
                        //Added purple color in book button
                        child: FloatingActionButton.extended(
                          backgroundColor: accentColor,
                          label: const Text(
                            'BOOK',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                          onPressed: () => navigateToBooking(context, carModel),
                        ),
                      ),
              ],
            ),
            OfferWidget(carModel: carModel),
          ],
        ),
      ),
    );
  }

  Future<dynamic> navigateToBooking(BuildContext context, CarModel carModel) {
    carModel.package = CarModel.getFreeKm(model, carModel);
    Navigator.of(context).pop();
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => UserBookingScreen(),
            settings:
                RouteSettings(name: UserBookingScreen.routeName, arguments: {
              'model': model,
              'carModel': carModel,
              'details': data(carModel, carModel.vendor!, model)
            })));
  }

  List<String> data(CarModel carModel, Vendor vendor, DriveModel model) {
    final List<String> details = [];
    if (model.drive == DriveTypes.SD) {
      details.add('Registration: ${carModel.vendor!.plateColor} Board');
      details.add('Package - ' + carModel.package!);
      if ((vendor.securityDeposit ?? 0) > 0) {
        details
            .add('Refundable Deposit - $rupeeSign${vendor.securityDeposit}/-');
      }

      if (carModel.freeKm != null) {
        details.add('Extra KMs - @$rupeeSign${carModel.extraKmCharge}/KM ');
      } else
        details.add('Extra hour charges @$rupeeSign${carModel.extraHrCharge}');

      if (carModel.pickUpAndDrop != null &&
          carModel.pickUpAndDrop!.trim().isNotEmpty) {
        details.add('Pick/Drop location - ${carModel.pickUpAndDrop}');
      }
      /*else {
         details.add('Pickup location will be notified 4 hours prior to the trip.');
      }*/
      if (carModel.vendor!.name == zoomCar) {
        final kmsDriven = carModel.kmsDriven;
        if (kmsDriven!.isTrulyNotEmpty()) {
          details.add('Condition - ' + kmsDriven.trim().toUpperCase());
        }
        details.add('Transmission - ${carModel.transmission}');
        details.add('Fuel type - ${carModel.fuel}');
      }
    } else if (model.drive == DriveTypes.WC) {
      details.add('Minimum Booking Duration ${carModel.minHrs} Hours');
      details.add('${carModel.minHrs! * 10} KMs FREE');
      details.add(
        '$rupeeSign${carModel.rate} Per KM for Extra Usage',
      );
      details.add('$rupeeSign${carModel.ratePerHr} Per Hour for Extra Usage');
    } else if (model.drive == DriveTypes.RT || model.drive == DriveTypes.OW) {
      details.add('Extra KM @$rupeeSign${carModel.ratePerKm}');
      details.add('Excludes toll costs, parking, permits and state tax.');
      details.add('24/7 on-road assistance');
      details.add('Regularly audited cars');
    } else if (model.drive == DriveTypes.AT) {
      details.add('GST inclusive');
      details.add(
          'Includes upto ${carModel.freeKm} KMs, extra KM @$rupeeSign${carModel.ratePerKm} per Km.');
      if (carModel.toll is String && carModel.toll.toLowerCase() == 'true') {
        details.add('Charges include toll.');
      } else {
        details.add('Charges exclude toll');
      }
    } else {
      if ((carModel.extraKmCharge ?? 0) > 0)
        details.add('Extra Kms @$rupeeSign${carModel.extraKmCharge} Per KM ');
      details.add('Pick/Drop location: ${carModel.pickUpAndDrop}');
    }
    return details;
  }

  Padding prices(CarModel carModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: carPrice(
        (carModel.finalDiscount ?? 0).toDouble(),
        (carModel.finalPrice ?? 0).toDouble(),
      ),
    );
  }

  Widget carPrice(double discount, double price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (discount > price)
          Text(
            '$rupeeSign${discount.toStringAsFixed(0).commaFunction()}',
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: accentColor
            ),
          ),
        Text('$rupeeSign${price.toStringAsFixed(0).commaFunction()} ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor)),
        const Text(
          '(GST incl)',
          style: TextStyle(fontSize: 11, color: accentColor),
        ),
      ],
    );
  }

  Widget extraDetails(CarModel carModel, DriveModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (carModel.vendor!.advancePay != 0)
          Text(
            '• Book by paying ${(carModel.vendor!.advancePay! * 100).toStringAsFixed(0)}%',style: TextStyle(color: accentColor),
          ),
        if (!(model.drive == DriveTypes.WC ||
            model.drive == DriveTypes.RT ||
            model.drive == DriveTypes.OW ||
            model.drive == DriveTypes.AT))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (carModel.vendor!.name == zoomCar) ...[
                if (carModel.pickUpAndDrop == homeDelivery)
                  const Text('• Home Delivery (Charges extra)', style: TextStyle(color: accentColor))
                else if (carModel.pickUpAndDrop == airportPickup)
                  const Text('• Airport Pickup', style: TextStyle(color: accentColor))
                else
                  const Text('• Self Pickup', style: TextStyle(color: accentColor))
              ],
              Text(
                "• ${carModel.transmission} Transmission",style: TextStyle(color: accentColor)
              ),
              Text(
                "• ${carModel.fuel}",style: TextStyle(color: accentColor)
              ),
              const Text(
                "• Fuel Not Included",style: TextStyle(color: accentColor)
              ),
            ],
          ),
        if ((carModel.vendor!.name == avis || carModel.vendor!.name == eco) &&
            (model.drive == DriveTypes.RT ||
                model.drive == DriveTypes.OW ||
                model.drive == DriveTypes.WC ||
                model.drive == DriveTypes.AT))
          const Text(
            '• Uniformed Chauffeur',style: TextStyle(color: accentColor)
          ),
        Text('• ${CarModel.getFreeKm(model, carModel)}', style: TextStyle(color: accentColor)),
      ],
    );
  }
}

class OfferWidget extends StatelessWidget {
  const OfferWidget({
    super.key,
    required this.carModel,
  });

  final CarModel carModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: .8.sw,
        decoration: BoxDecoration(
            color: accentColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              '${carModel.vendor!.offer}',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
