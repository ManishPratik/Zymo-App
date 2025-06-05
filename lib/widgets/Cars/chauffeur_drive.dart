import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Services/car_functions.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/widgets.dart';
import 'package:letzrentnew/providers/car_provider.dart';
import 'package:provider/provider.dart';

import '../../Services/location_services.dart';

class ChauffeurDrive extends StatelessWidget {
  const ChauffeurDrive({Key? key}) : super(key: key);
  static const routeName = 'Chauffeur Drive';

  @override
  Widget build(BuildContext context) {
    // mixpanel!.track('Chauffeur drive page');

    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: const Text(ChauffeurDrive.routeName)),
        body: SingleChildScrollView(
          child: Consumer<CarProvider>(
            builder: (BuildContext context, value, Widget? child) => Column(
              children: [
                SizedBox(
                  height: .06.sh,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: .11.sw,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: .1.sw,
                      child: cdIcon(value.cdType)),
                ),
                SizedBox(
                  height: .04.sh,
                ),
                cdOptions(value),
                SizedBox(
                  height: .02.sh,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (value.cdType == DriveTypes.AT)
                        atWidgets(value, context),
                      if (value.cdType == DriveTypes.RT ||
                          value.cdType == DriveTypes.OW)
                        osWidgets(value, context),
                      if (value.cdType == DriveTypes.WC)
                        durationPicker(context, value),
                      SizedBox(
                        height: .02.sh,
                      ),
                      if (value.cdType != DriveTypes.AT)
                        TripDurationWidget(duration: value.getTripDuration()),
                    ],
                  ),
                ),
                SizedBox(
                  height: .02.sh,
                ),
                if (value.isLoading)
                  spinkit
                else
                  AppButton(
                    title: 'Search',
                    screenWidth: 1.sw,
                    screenHeight: 1.sh,
                    function: () =>
                        CarFunctions().chauffeurDriveNavigate(context),
                  ),
                SizedBox(
                  height: .02.sh,
                ),
              ],
            ),
          ),
        ));
  }

  Widget osWidgets(
    CarProvider value,
    BuildContext context,
  ) {
    return Column(
      children: [
        osOptions(value),
        destinationWidget(value, context),
        durationPicker(context, value),
      ],
    );
  }

  Widget destinationWidget(
    CarProvider value,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Please select your destination',
              maxLines: 1,
              style: headingStyle,
            ),
          ),
          SizedBox(
            width: 1.sw,
            child: InkWell(
              onTap: () async => value.setDestinationLocation(
                  await LocationService().pickLocation(context)),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
                ),
                child: Text(
                  value.destinationLocation ?? 'Destination location',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row osOptions(CarProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChauffeurOptions(
          title: 'Round trip',
          width: .3.sw,
          isSelected: value.cdType == DriveTypes.RT,
          function: () => value.setCdType(DriveTypes.RT),
        ),
        ChauffeurOptions(
          title: 'One way',
          width: .3.sw,
          isSelected: value.cdType == DriveTypes.OW,
          function: () => value.setCdType(DriveTypes.OW),
        ),
      ],
    );
  }

  Column atWidgets(
    CarProvider value,
    BuildContext context,
  ) {
    return Column(
      children: [
        atOptions(value),
        const Divider(),
        atDurationPicker(context, value),
      ],
    );
  }

  Row cdOptions(CarProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChauffeurOptions(
          title: 'Airport Transfer',
          width: .3.sw,
          isSelected: value.cdType == DriveTypes.AT,
          function: () => value.setCdType(DriveTypes.AT),
        ),
        ChauffeurOptions(
          title: 'Outstation',
          width: .3.sw,
          isSelected:
              value.cdType == DriveTypes.RT || value.cdType == DriveTypes.OW,
          function: () => value.setCdType(DriveTypes.RT),
        ),
        ChauffeurOptions(
          title: 'Within city',
          width: .3.sw,
          isSelected: value.cdType == DriveTypes.WC,
          function: () => value.setCdType(DriveTypes.WC),
        ),
      ],
    );
  }

  Row atOptions(CarProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChauffeurOptions(
          title: 'Airport pickup',
          width: .3.sw,
          isSelected: value.atType == AirportTransferTypes.pickup,
          function: () => value.setAtType(AirportTransferTypes.pickup),
        ),
        ChauffeurOptions(
          title: 'Airport drop',
          width: .3.sw,
          isSelected: value.atType == AirportTransferTypes.drop,
          function: () => value.setAtType(AirportTransferTypes.drop),
        ),
      ],
    );
  }

  Widget? cdIcon(DriveTypes cdType) {
    if (cdType == DriveTypes.AT) {
      return Image.asset(
        'dev_assets/new_logo.jpeg',
        height: .1.sh,
      );
    }
    if (cdType == DriveTypes.RT || cdType == DriveTypes.OW) {
      return Icon(
        FontAwesomeIcons.carRear,
        size: .05.sh,
        color: Colors.black,
      );
    }
    if (cdType == DriveTypes.WC) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/icons/cd.jpeg',
              height: .05.sh,
            ),
            Icon(
              FontAwesomeIcons.car,
              size: .05.sh,
              color: Colors.black,
            ),
          ],
        ),
      );
    } else {
      return null;
    }
  }
}

class ChauffeurOptions extends StatelessWidget {
  final String? title;
  final double? width;
  final Function? function;
  final bool? isSelected;
  const ChauffeurOptions(
      {Key? key, this.title, this.function, this.isSelected, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: InkWell(
          onTap: () => function!(),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected!
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withOpacity(.1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Text(
                title!,
                style: TextStyle(
                    color: isSelected!
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary),
              ),
            ),
          )),
    );
  }
}
