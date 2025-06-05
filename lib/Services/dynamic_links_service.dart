// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:letzrentnew/providers/home_provider.dart';
// import 'package:letzrentnew/Utils/app_data.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'auth_services.dart';
// import 'firebase_services.dart';

// class DynamicLinksService {
//   final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   Future<void> initDynamicLinks(BuildContext context) async {
//     // Get the initial dynamic link if the app is opened with a dynamic link
//     final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
//     // handle link that has been retrieved
//     if (data != null) {
//       _handleDynamicLinkUtil(data, context);
//     }
//     // Register a link callback to fire if the app is opened up from the background
//     // using a dynamic link.
//     dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLink) async {
//       // handle link that has been retrieved
//       _handleDynamicLinkUtil(dynamicLink, context);
//         });
//   }

//   void _handleDynamicLinkUtil(
//       PendingDynamicLinkData data, BuildContext context) async {
//     final String? uid = Auth().getCurrentUser()?.uid;
//     final Uri deepLink = data.link;
//     final referralUid = deepLink.path.split('/');
//     if (referralUid[1].length == 28 && referralUid[1] != uid) {
//       Provider.of<HomeProvider>(context, listen: false)
//           .isReferralFunction(true);
//       await FirebaseServices()
//           .addReferralVouchers(referralUid[1], uid, referralAmount);
//     }
//     }

// //   var referralText =
// //       '''I wanted to share an awesome app for self-drive car rentals with you. It's called Zymo and I've been using it for a while now. It's super convenient and easy to use.

// // The best part is that if you sign up using my referral code, we both will get a voucher worth Rs 200! It's a win-win situation for both of us.

// // So if you're planning to rent a car anytime soon, give Zymo a try. You won't be disappointed!

// // Here's my referral code: [insert referral code].''';

//   Future<String?> createDynamicLink() async {
//     final User user = Auth().getCurrentUser()!;
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? link = prefs.getString(user.uid);
//     if (link != null && link.isNotEmpty) {
//       return link;
//     }
//     try {
//       final DynamicLinkParameters parameters = DynamicLinkParameters(
//         uriPrefix: 'https://letzrentnew.page.link',
//         link: Uri.parse('https://letzrent.com/${user.uid}'),
//         androidParameters: AndroidParameters(
//           packageName: 'com.letzrent.letzrentnew',
//         ),
//         iosParameters: IOSParameters(
//           bundleId: 'com.letzrent.letzrent',
//           appStoreId: appStoreId,
//         ),
//         socialMetaTagParameters: SocialMetaTagParameters(
//           title: 'Zymo Referral Link',
//           description:
//               'Refer Zymo app to your friends and get ${rupeeSign}100 off for you and your friend.',
//         ),
//       );

//       final ShortDynamicLink shortDynamicLink =
//           await dynamicLinks.buildShortLink(parameters);
//       final Uri shortUrl = shortDynamicLink.shortUrl;
//       final String finalLink = shortUrl.toString();
//       await prefs.setString(user.uid, finalLink);
//       return shortUrl.toString();
//     } catch (e) {
//       return null;
//     }
//   }
// }

import 'dart:async';
// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppsFlyerService {
  // static final AppsFlyerOptions _options = AppsFlyerOptions(
  //   afDevKey: AppsFlyerKey,
  //   appId: "com.letzrent.letzrentnew",
  //   showDebug: true,
  // );
  // static final AppsflyerSdk _appsFlyerSdk = AppsflyerSdk(_options);

  // static Future<Map<String, dynamic>>? _conversionDataFuture;
  // static DeepLink? deepLinkData;

  // static void initialize() {
  //   _appsFlyerSdk.initSdk(
  //     registerConversionDataCallback: true,
  //     registerOnAppOpenAttributionCallback: true,
  //     registerOnDeepLinkingCallback: true,
  //   );

  //   _conversionDataFuture = _setupConversionDataListener();
  // }

  static Future<Map<String, dynamic>> _setupConversionDataListener() {
    Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    // _appsFlyerSdk.onInstallConversionData((res) {
    //   Map<String, dynamic> convData = res["payload"];
    //   completer.complete(convData);
    // });

    return completer.future;
  }

  //static Future<Map<String, dynamic>>? get conversionDataFuture => _conversionDataFuture;

  // static void registerCallbacks() {
  //   _appsFlyerSdk.onDeepLinking((res) {
  //     switch (res.status) {
  //       case Status.FOUND:
  //         debugPrint("deeplink happened res: ${res.deepLink}");
  //         deepLinkData = res.deepLink;
  //         _handleDeepLink(deepLinkData);
  //         break;
  //       case Status.NOT_FOUND:
  //         debugPrint("deep link not found");
  //         break;
  //       case Status.ERROR:
  //         debugPrint("deep link error: ${res.error}");
  //         break;
  //       case Status.PARSE_ERROR:
  //         debugPrint("deep link status parsing error");
  //         break;
  //     }
  //   });
  // }

  // static void _handleDeepLink(DeepLink? deepLinkData) {
  //   if (deepLinkData != null) {
  //     final String? deepLinkValue = deepLinkData.deepLinkValue;
  //     final bool isDeferred = deepLinkData.isDeferred ?? false;
  //     if (deepLinkValue != null) {
  //       final Uri deepLinkUri = Uri.parse(deepLinkValue);
  //       final String? uid = deepLinkUri.queryParameters['uid'];
  //       if (uid != null) {
  //         _rewardUsers(uid);
  //       }
  //     }
  //   }
  // }

  static void _rewardUsers(String referrerUid) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null && currentUserId != referrerUid) {
      final FirebaseServices firebaseServices = FirebaseServices();
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      firebaseServices.addReferralVouchers(referrerUid, currentUserId, referralAmount);
    }
  }

  static Future<String?> createDynamicLink() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? link = prefs.getString(user.uid);
    if (link != null && link.isNotEmpty) {
      return link;
    }

    try {
      final String userSpecificLink = 'https://zymo.com/${user.uid}';

      // final AppsFlyerInviteLinkParams params = AppsFlyerInviteLinkParams(
      //   channel: 'flutter_app',
      //   campaign: 'referral',
      //   referrerName: user.displayName ?? '',
      //   referreImageUrl: user.photoURL ?? '',
      //   customerID: user.uid,
      //   baseDeepLink: userSpecificLink,
      //   brandDomain: 'zymo.onelink.me',
      //   customParams: {
      //     "deep_link_value": user.uid,
      //     "deep_link_sub1": "referral",
      //   },
      // );

      final completer = Completer<String?>();
      // _appsFlyerSdk.generateInviteLink(
      //   params,
      //   (dynamic result) {
      //     final Uri shortUrl = Uri.parse(result['link']);
      //     final String finalLink = shortUrl.toString();
      //     prefs.setString(user.uid, finalLink);
      //     completer.complete(finalLink);
      //   },
      //   (dynamic error) {
      //     completer.completeError(error);
      //   },
      // );

      return completer.future;
    } catch (e) {
      print("Error generating dynamic link: $e");
      return null;
    }
  }

  static void generateInviteLink({required fruit, required sub1Value}) {
    // _appsFlyerSdk.generateInviteLink(
    //     AppsFlyerInviteLinkParams(
    //         baseDeepLink: "zymo.onelink.me",
    //         customParams: {
    //           "deep_link_value": fruit,
    //           "deep_link_sub1": sub1Value,
    //           "deep_link_sub2": "THIS_USER_ID",
    //         }), (result) {
    //   Clipboard.setData(
    //       ClipboardData(text: result["payload"]["userInviteURL"]));
    // }, (error) {
    //   debugPrint("error-123 $error");
    // });
  }
}
