import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Services/car_functions.dart';
import 'package:letzrentnew/Services/car_services.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/models/car_model.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:provider/provider.dart';

class SelfDrive extends StatelessWidget {
  static const routeName = 'Self Drive Cars';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(SelfDrive.routeName),
          ),
          body: SingleChildScrollView(
            child: Consumer<CarProvider>(
                builder: (BuildContext context, value, Widget? child) =>
                    Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // padding: EdgeInsets.all(28),
                          child: Image.asset(
                            'assets/images/onboarding_images/earn.jpeg',
                            height: .25.sh,
                          ),
                          // child: Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             const Text(
                          //               'Maximum Options At\nBest Prices',
                          //               style: smallBlackHeadingStyle,
                          //             ),
                          //             const SizedBox(
                          //               height: 10,
                          //             ),
                          //             const Text(
                          //               '• Thirty Thousand Plus Cars',
                          //               style: semiBoldBlackTitleStyle,
                          //             ),
                          //             const Text(
                          //               '• Available In 50+ Cities',
                          //               style: semiBoldBlackTitleStyle,
                          //             ),
                          //             const Text(
                          //               '• Highest Rated App in Category*',
                          //               style: semiBoldBlackTitleStyle,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          // CachedNetworkImage(
                          //   imageUrl:
                          //       'https://cars.tatamotors.com/images/design-mobile.jpg',
                          //   width: .4.sw,
                          // ),
                          //])
                        ),
                      ),
                      SizedBox(
                        height: .02.sh,
                      ),
                      SizedBox(
                        height: .01.sh,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: durationPicker(context, value),
                              ),
                            ),
                            SizedBox(
                              height: .01.sh,
                            ),
                            PickLocationWidget(),
                            SizedBox(
                              height: .01.sh,
                            ),
                            TripDurationWidget(
                                duration: value.getTripDuration()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: .02.sh,
                      ),
                      SizedBox(
                          height: .06.sh,
                          child: value.isLoading
                              ? spinkit
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: AppButton(
                                      title: 'Search',
                                      // screenWidth: screenWidth * 1.8,
                                      screenHeight: 1.sh,
                                      function: () =>
                                          CarFunctions.selfDriveNavigate(
                                              context)),
                                )),
                      SizedBox(
                        height: .01.sh,
                      ),
                      RecentSearches(provider: value)
                    ])),
          )),
    );
  }
}

class RecentSearches extends StatelessWidget {
  final CarProvider? provider;

  const RecentSearches({Key? key, this.provider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final HomeProvider value =
        Provider.of<HomeProvider>(context, listen: false);
    return FutureBuilder<DriveModel?>(
        future: value.getRecentSearch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final DriveModel? model = snapshot.data;
          if (model != null)
            // return Card(
            //   child: DurationTile(
            //     title: 'Recent Search',
            //     body: CarServices.getDurationText(
            //         DriveTypes.SD,
            //         model.startDate,
            //         model.endDate,
            //         model.starttime,
            //         model.endtime,
            //         5),
            //   ),
            // );
            return Container(
              width: double.infinity,
              child: Card(
                color: Color(0xff303030),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () => setDateAndTime(model, context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Recent Search: ${model.remainingDuration}',
                          style: bigHeadingStyle,
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Text(
                        //   '${model.remainingDuration}',
                        //   style: headingStyle,
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          CarServices.getDurationText(
                              DriveTypes.SD,
                              model.startDate,
                              model.endDate,
                              model.starttime,
                              model.endtime,
                              5),
                          style: contentStyle,
                        ),
                        Text(
                          'Tap to search',
                          style: titleStyle,
                          
                        ),
                      ],
                    ),
                  ),
                ),
                // elevation: 5,
                // child: ListTile(
                //     onTap: () => setDateAndTime(model, context),
                //     contentPadding:
                //         EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                //     title:
                //         Text('Recent Search: ${model.remainingDuration}'),
                //     subtitle: Text(CarServices.getDurationText(
                //         DriveTypes.SD,
                //         model.startDate,
                //         model.endDate,
                //         model.starttime,
                //         model.endtime,
                //         5)),
                //     trailing: Icon(Icons.arrow_right)),
              ),
            );
          return Container();
        });
  }

  void setDateAndTime(DriveModel model, BuildContext context) {
    try {
      provider!.setStartAndEndDate(dateFormatter.parse(model.startDate!),
          dateFormatter.parse(model.endDate!));
      provider!.setStartTime(
          TimeOfDay.fromDateTime(timeFormat.parse(model.starttime!)));
      provider!.setEndTime(
          TimeOfDay.fromDateTime(timeFormat.parse(model.endtime!)));
      CarFunctions.selfDriveNavigate(context);
    } catch (e) {
      // mixpanel!.track('duration', properties: {'issue': e});
    }
  }
}
