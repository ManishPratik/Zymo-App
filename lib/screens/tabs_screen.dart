import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:letzrentnew/Screens/home_page.dart';
import 'package:letzrentnew/Services/dynamic_links_service.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/providers/home_provider.dart';
//import 'package:package_info_plus/package_info_plus.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/contact_us.dart';
import 'my orders.dart';
import 'Rewards/my_rewards.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    checkForUpdate(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  void _selectPage(int index, HomeProvider value) {
    setState(() {
      _selectedPageIndex = index;
    });
    if (index == 1) {
      if (value.rewardIndicator) {
        value.setRewardIndicator(false);
      }
    }
  }

  Widget _buildBottomNav(BuildContext context, HomeProvider value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
          
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2), // Shadow color
        spreadRadius: 2, // Spread radius
        blurRadius: 8,  // Blur radius for a soft shadow
        offset: Offset(4, 4), // Shadow position (horizontal, vertical)
      ),
    ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0, value),
          _buildNavItem(Icons.workspace_premium_rounded, 'Rewards', 1, value),
          _buildNavItem(Icons.shopping_bag_outlined, 'Bookings', 2, value),
          _buildNavItem(Icons.phone_outlined, 'Contact', 3, value),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, HomeProvider value) {
    final isSelected = _selectedPageIndex == index;
    return GestureDetector(
      onTap: () => _selectPage(index, value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? appColor : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? appColor : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedPageIndex,
            children: [
              HomePage(),
              MyRewards(),
              MyBookings(),
              ContactUs(),
            ],
          ),
        ),
        bottomNavigationBar: Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) =>
              _buildBottomNav(context, value),
        ),
      ),
    );
  }

  void checkForUpdate(BuildContext context) async {
    //   final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   final int currentVersion =  int.parse(packageInfo.version.replaceAll('.', ''));
    // final Map updateData = (await FirebaseServices().getUpdateInfo())!;
    // final Map data = updateData[Platform.isIOS ? 'iOS' : 'Android'];
    // final int minVersion = data['minVersionAllowedProd'] ?? 0;
    // final int latestVersion = data['latestVersion'] ?? 0;
    // contactNumber = data['contactNumber'];
    // if (currentVersion < minVersion) {
    //   showUpdateDialog(context, isForced: true);
    // } else if (currentVersion < latestVersion) {
    //   showUpdateDialog(context);
    // }
  }

  void showUpdateDialog(BuildContext context, {bool isForced = false}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Update Available'),
        content: Text(
            'A new version of $appName is available. Please update the app to get the latest features!$happyEmoji'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Update'),
            onPressed: () async {
              try {
                await InAppReview.instance
                    .openStoreListing(appStoreId: appStoreId);
              } catch (e) {
                launchUrl(Uri.parse(platformStoreLink));
              }
              SystemNavigator.pop();
            },
          ),
          if (!isForced)
            CupertinoDialogAction(
              child: Text('Next time'),
              onPressed:
                  isForced ? null : () => Navigator.of(context).pop(true),
            ),
        ],
      ),
    );
  }
}
