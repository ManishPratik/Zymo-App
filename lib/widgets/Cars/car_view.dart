import 'dart:async';

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
import '../../Utils/widgets.dart';

class CarsView extends StatefulWidget {
  final DriveModel model;

  const CarsView({Key? key, required this.model}) : super(key: key);
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

  @override
  void initState() {
    // mixpanel!.track('Car listing page', properties: {
    //   'Map Location': widget.model.mapLocation,
    //   'Duration selected': widget.model.remainingDuration,
    //   'City': widget.model.city,
    //   'Type': widget.model.drive.toString()
    // });

    super.initState();

    // Initial connectivity check
    // _checkConnection();
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.grey[900], borderRadius: BorderRadius.circular(8)
                // shape: BoxShape.circle,
                ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              // color: Colors.grey[900], // Color of the back arrow
              onPressed: () {
                Navigator.pop(context); // Default back action
              },
            ),
          ),
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
                child: Container(
                  height: 38,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8)
                      // shape: BoxShape.circle,
                      ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                      ),
                      Text(widget.model.city!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       showFilter(context, DriveTypes.WC);
            //     },
            //     child: Text('Filter')),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              // width: .9.sw,
              height: .07.sh,

              child: Row(
                children: [
                  Flexible(
                    flex: 7, // 80% of the available space
                    child: Card(
                      color: Colors.grey[900],
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Center(
                          child: Text(
                            '${CarServices.getDurationText(_drive, _startDate, _endDate, _startTime, _endTime, distance)} ',
                            // maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 10), // Add some spacing between the two buttons
                  Flexible(
                    flex: 1, // 20% of the available space
                    child: Container(
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shadowColor: WidgetStateProperty.all(Colors.grey),
                          side: WidgetStateProperty.all(
                              BorderSide(color: const Color(0xFFFFFA8D))), // Yellow border
                          backgroundColor: WidgetStateProperty.all(
                              Colors.grey[850]), // Dark background
                          foregroundColor:
                              WidgetStateProperty.all(const Color(0xFFFFFA8D)), // Yellow text
                          padding: WidgetStateProperty.all(EdgeInsets.all(8.0)),
                        ),
                        onPressed: () {
                          showFilter(context, _drive);
                        },
                        child: Row(
                          children: [
                            // SizedBox(width: 10),
                            Icon(Icons.sort),
                            // SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // child: Row(
              //   children: [
              //     Card(

              //       elevation: 5,
              //       shape: const RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(10))),
              //       child: InkWell(
              //         onTap: () => Navigator.pop(context),
              //         child: Center(
              //           child: Text(
              //             '${CarServices.getDurationText(_drive, _startDate, _endDate, _startTime, _endTime, distance)} ',
              //             // maxLines: 1,
              //             style: const TextStyle(
              //                 fontWeight: FontWeight.w600, fontSize: 15),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //         color: Colors.white,
              //         width: 104,
              //         child: Row(children: [
              //           // Icon(Icons.sort),
              //           ElevatedButton(
              //               style: ButtonStyle(
              //                 side: MaterialStateProperty.all(BorderSide(
              //                     color: Colors.purple)), // Purple border
              //                 backgroundColor: MaterialStateProperty.all(
              //                     Colors.white), // White background
              //                 foregroundColor: MaterialStateProperty.all(
              //                     Colors.purple), // Purple text
              //                 padding: MaterialStateProperty.all(
              //                     EdgeInsets.symmetric(horizontal: 16.0)),
              //               ),
              //               onPressed: () {
              //                 showFilter(context, _drive);
              //               },
              //               child: Row(children: [
              //                 Icon(Icons.sort),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text('Filter')
              //               ]))
              //         ])),
              //   ],
              // ),
            ),
            Expanded(
              child: FutureBuilder<List<CarModel>>(
                  future: getFuture(widget.model),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return shimmerLoading(context);
                    } else if (snapshot.hasError) {
                      return AppErrorWidget(
                        error: 'Oops! ${snapshot.error}',
                        function: () {
                          setState(() {});
                        },
                      );
                    } else {
                      finalList =
                          getCarList(snapshot.data, widget.model.carGrouping);
                      if (finalList == null) {
                        return AppErrorWidget(
                            error:
                                'Sorry, we are presently not available in this location.');
                      } else if (finalList == null) {
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
                              'No cars available for the selected duration.',
                              style: largeStyle,
                            ),
                            ElevatedButton(
                              onPressed: () => setState(() {}),
                              child: Text('Retry'),
                            ),
                          ],
                        );
                      } else {
                        finalList = sortingFunction(finalList);
                        if (finalList!.isEmpty) {
                          return AppErrorWidget(
                              error:
                                  'Sorry, No cars available for the given filters.');
                        } else {
                          return Scrollbar(
                            interactive: true,
                            child: RefreshIndicator(
                              onRefresh: () async => refreshFunction(),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: finalList!.length,
                                itemBuilder: (context, index) {
                                  snapshot.data?.forEach((element) {});
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
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<CarModel>>? getFuture(DriveModel model) {
    return finalList?.isEmpty ?? true
        ? CarServices()
            .getCars(model)
            .timeout(timeOutDuration, onTimeout: (() => throw ('Timed out')))
        : null;
  }

  void refreshFunction() {
    return setState(() {
      finalList = [];
    });
  }

  List<List<CarModel>>? sortingFunction(List<List<CarModel>>? data) {
    // TO AVOID GLITCH BOOKING RATES, FILTERING CARS BELOW [RS.750]
    data = data
        ?.map((list) => list.where((element) {
              return (element.finalPrice ?? 0) > 750;
            }).toList())
        .where((list) => list.isNotEmpty)
        .toList();

    if (carType != 'all') {
      data = data
          ?.map((list) => list.where((element) {
                return (element.type?.toLowerCase() ?? '') == carType;
              }).toList())
          .toList();
    }

    data = data
        ?.map((list) => list.where((element) {
              final transmission = element.transmission?.toLowerCase();
              if (manual) {
                return transmission == 'manual';
              } else if (automatic) {
                return transmission == 'automatic';
              } else {
                return true;
              }
            }).toList())
        .where((list) => list.isNotEmpty)
        .toList();

    if (seatCapacity != 0) {
      data = data
          ?.map((list) => list.where((element) {
                return element.seats == seatCapacity;
              }).toList())
          .where((list) => list.isNotEmpty)
          .toList();
    }
    // if (lowToHigh) {
    // data = data!.map((list) {
    //   list.sort((a, b) => a.finalPrice!.compareTo(b.finalPrice!));
    //   return list;
    // }).toList();
    // }
    // else {
    //   data?.forEach((list) {
    //     list.sort((a, b) => b.finalPrice!.compareTo(a.finalPrice!));
    //   });
    // }

    return data;
  }

  List<List<CarModel>> getCarList(List<CarModel>? carList, List? carGroup) {
    if (carList == null || carList.isEmpty) {
      // Return an empty list if carList is null or empty.
      return [];
    }

    final Map<String?, List<CarModel>> tempList = {};
    carList.forEach((car) {
      //////Added is sold out logic
      if (car.name != null && car.isSoldOut != true) {
        final List<CarModel> eachCarList = carList.where((element) {
          if (element.name != null) {
            final String elementName = getCarName(element.name!, carGroup!);
            final String carName = getCarName(car.name!, carGroup);
            return elementName == carName;
          } else {
            return false;
          }
        }).toList();

        tempList.addAll({eachCarList.first.name: eachCarList});
        // print('this is Temp List $tempList');
      }
    });

    final List<List<CarModel>> unsortedList = tempList.values.toList();
    // print('This is unsorted List $unsortedList');

    final List<List<CarModel>> sortedList = [];
    unsortedList.forEach((element) {
      element.sort((a, b) => a.finalPrice!.compareTo(b.finalPrice!));
      sortedList.add(element);
    });
    sortedList
        .sort((a, b) => a.first.finalPrice!.compareTo(b.first.finalPrice!));
    // print('This is sorted List $sortedList');
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

  Future<void> showFilter(BuildContext context, DriveTypes? drive) async {
    return showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: .52.sh,
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
                    const Text('Filters',
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    Spacer(),
                    InkWell(
                      onTap: () => setState(() {
                        carType = 'all';
                        automatic = false;
                        manual = false;
                        lowToHigh = true;
                        hightolow = false;
                        isSelfPickup = false;
                        // String carType = 'all';
                        seatCapacity = 0;
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
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
                // const Text(
                //   'Price',
                //   style: headingStyle,
                // ),
                // SizedBox(
                //   height: .01.sh,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     FilterItem(
                //         isSelected: lowToHigh,
                //         title: 'Low to High',
                //         function: () => setState(() {
                //               lowToHigh = true;
                //               hightolow = false;
                //             }),
                //         width: .24.sw),
                //     FilterItem(
                //         isSelected: hightolow,
                //         title: 'High to Low',
                //         function: () => setState(() {
                //               lowToHigh = false;
                //               hightolow = true;
                //             }),
                //         width: .24.sw),
                //   ],
                // ),
                // SizedBox(
                //   height: .03.sh,
                // ),
                // const Text(
                //   'Delivery',
                //   style: headingStyle,
                // ),
                // SizedBox(
                //   height: .01.sh,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     FilterItem(
                //         isSelected: isSelfPickup,
                //         title: 'Self Pickup',
                //         function: () => setState(() {
                //               isSelfPickup = true;
                //             }),
                //         width: .24.sw),
                //     FilterItem(
                //         isSelected: !isSelfPickup,
                //         title: 'Home Delivery',
                //         function: () => setState(() {
                //               isSelfPickup = false;
                //             }),
                //         width: .24.sw),
                //   ],
                // ),
                SizedBox(
                  height: .03.sh,
                ),
                const Text(
                  'Seats',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
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
                // AppButton(
                //   screenHeight: 100,
                //   title: "Apply",
                //   function: Navigator.pop(context),
                // )
                ElevatedButton(
                    onPressed: () async {
                      refreshFunction();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Colors.black),
                    ))
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
    Key? key,
    this.error,
    this.function,
  }) : super(key: key);

  final String? error;
  final Function? function;
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
          error!,
          style: largeStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: .025.sh,
        ),
        if (function != null)
          AppButton(
            screenWidth: .8.sw,
            screenHeight: .8.sh,
            textSize: 16,
            title: 'Retry',
            function: function,
          )
      ],
    );
  }
}

class CarTile extends StatelessWidget {
  final DriveModel model;
  final List<CarModel>? carModelList;

  const CarTile({
    Key? key,
    required this.model,
    this.carModelList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double lowestPrice = carModelList!.first.finalPrice!;
    final List<String?> vendorImages = carModelList!
        .map((element) => element.vendor!.imageUrl)
        .toSet()
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => openCarPopup(carModelList, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Row
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     const Icon(Icons.star, color: Colors.yellow, size: 16),
            //     Text(
            //       '4.5',  // You can replace with actual rating if available in your model
            //       style: const TextStyle(color: Colors.yellow),
            //     ),
            //   ],
            // ),

            // Car Name and Features Row
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    carName(context, carModelList!.first.name!),
                    const SizedBox(height: 4),
                    featureRow(carModelList!),
                  ],
                ),
                const Spacer(),
                startingAt(lowestPrice),
              ],
            ),

            const SizedBox(height: 20),

            // Car Image in Yellow Container
            Center(
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFA8D),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: carImage(carModelList!.first.imageUrl, context),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottom Section with Vendor Images and Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Vendor Images Section
                Expanded(
                  child: VendorImages(vendorImages: vendorImages),
                ),

                // Action Buttons
                Row(
                  children: [
                    // _buildActionButton(Icons.close),
                    // const SizedBox(width: 10),
                    _buildActionButton(Icons.favorite_border),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFA8D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Distance Information
            if (carModelList!.first.pickups?.first.distanceFromUser != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${carModelList!.first.pickups!.first.distanceFromUser} KMs away',
                  style: itleStyle,
                ),
              ),

            // Booking Fast Badge
            if (bookingFastList
                .where(
                    (element) => element.startsWith(carModelList!.first.name!))
                .isNotEmpty)
              bookingFastWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Icon(icon, color: Colors.white),
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
      children: [
        const Text(
          'Starts at',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        Text(
          '$rupeeSign${lowestPrice.toStringAsFixed(0).commaFunction()}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        const Text(
          '(GST incl)',
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ],
    );
  }

  Widget carImage(String? image, BuildContext context) {
    return SizedBox(
      width: .8.sw,
      height: .22.sh,
      child: image == null
          ? Image.asset(
              "assets/icons/selfDriveIcon.png",
              height: 15,
            )
          : CachedNetworkImage(
              imageUrl: image,
              // height: 0.22.sw,
              fit: BoxFit.fitWidth,
              placeholder: (context, ok) => const Center(
                child: Text(
                  'ZYMO',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w600),
                ),
              ),
              errorWidget: (c, s, w) => Icon(Icons.error_outline),
            ),
    );
  }

  Row featureRow(List<CarModel> carModelList) {
    return Row(
      children: [
        Text(
          "${carModelList.first.seats?.toString() ?? '4'} seater",
          style: titleStyle,
        ),
        const Text(
          " | ",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          carModelList.showOptionsText(),
          style: titleStyle,
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
              fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }

  Future<void> openCarPopup(
    List<CarModel>? carModelList,
    BuildContext context,
  ) async {
    showModalBottomSheet(
        backgroundColor: Colors.black,
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
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text(
                  'Showing ${carModelList!.showOptionsText()}',
                  style: TextStyle(color: Colors.white),
                ),
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
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF212121), // Dark grey color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CompareWidget(
                          carModel: carModelList[index],
                          model: model,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class VendorImages extends StatelessWidget {
  const VendorImages({
    Key? key,
    required this.vendorImages,
  }) : super(key: key);

  final List<String?> vendorImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .02.sh,
      width: .4.sw,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vendorImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CachedNetworkImage(
                        width: .12.sw, imageUrl: vendorImages[index]!),
                  );
                }),
          ),
          if (vendorImages.length > 3)
            Text(' +${vendorImages.length - 3}',
                style: TextStyle(color: Colors.black54, fontSize: 12))
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              const Text('Fulfilled by',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
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
                    placeholder: (context, ok) => const Center(
                      child: Text(
                        'ZYMO',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              if (carModel.vendor?.rating != null)
                RatingWidget(totalStars: carModel.vendor!.rating),
              const Spacer(),
              prices(carModel)
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // print(carModel.isSoldOut)
                extraDetails(carModel, model),
                // (carModel.isSoldOut ?? false)
                (carModel.isSoldOut == true)
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
                          backgroundColor: appColor,
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
            if (carModel.vendor!.offer != null) OfferWidget(carModel: carModel),
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
            builder: (_) => UserBookingScreen(
                model: model,
                carModel: carModel,
                details: data(carModel, carModel.vendor, model))));
  }

  List<String> data(CarModel carModel, Vendor? vendor, DriveModel model) {
    final List<String> details = [];
    if (model.drive == DriveTypes.SD) {
      if (carModel.vendor!.plateColor != null) {
        details.add('Registration - ${carModel.vendor!.plateColor} Board');
      }
      details.add('Package - ' + carModel.package!);
      if ((vendor!.securityDeposit ?? 0) > 0) {
        details
            .add('Refundable Deposit - $rupeeSign${vendor.securityDeposit}/-');
      }

      if (carModel.extraKmCharge != null && carModel.freeKm != null) {
        details.add('Extra KMs - @$rupeeSign${carModel.extraKmCharge}/KM ');
      } else if (carModel.extraHrCharge != null) {
        details.add('Extra hour charges @$rupeeSign${carModel.extraHrCharge}');
      }
      if (carModel.pickUpAndDrop.isTrulyNotEmpty()) {
        details.add('Pick/Drop location - ${carModel.pickUpAndDrop}');
      } else {
        // details
        //     .add('Pickup location will be notified 4 hours prior to the trip.');
      }
      if (carModel.vendor!.name == zoomCar) {
        final kmsDriven = carModel.kmsDriven!;
        if (kmsDriven.isTrulyNotEmpty()) {
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
      if (carModel.pickUpAndDrop != null) {
        details.add('Pick/Drop location: ${carModel.pickUpAndDrop}');
      }
    }
    return details;
  }

  Padding prices(CarModel carModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: carPrice(carModel.finalDiscount!, carModel.finalPrice!),
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
              color: Colors.white,
            ),
          ),
        Text('$rupeeSign${price.toStringAsFixed(0).commaFunction()} ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
        const Text(
          '(GST incl)',
          style: TextStyle(fontSize: 11, color: Colors.white),
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
            '• Book by paying ${(carModel.vendor!.advancePay! * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              color: Colors.white,
            ),
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
                  const Text(
                    '• Home Delivery (Charges extra)',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                else if (carModel.pickUpAndDrop == airportPickup)
                  const Text(
                    '• Airport Pickup',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                else
                  const Text(
                    '• Self Pickup',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ],
              Text(
                "• ${carModel.transmission} Transmission",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "• ${carModel.fuel}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const Text(
                "• Fuel Not Included",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        if ((carModel.vendor!.name == avis || carModel.vendor!.name == eco) &&
            (model.drive == DriveTypes.RT ||
                model.drive == DriveTypes.OW ||
                model.drive == DriveTypes.WC ||
                model.drive == DriveTypes.AT))
          const Text(
            '• Uniformed Chauffeur',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        Text(
          '• ${CarModel.getFreeKm(model, carModel)}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class OfferWidget extends StatelessWidget {
  const OfferWidget({
    Key? key,
    required this.carModel,
  }) : super(key: key);

  final CarModel carModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: .8.sw,
        decoration: BoxDecoration(
            color: appColor,
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
