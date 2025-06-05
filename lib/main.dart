import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/app_data.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/Utils/routes.dart';
import 'package:letzrentnew/firebase_options.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import 'Screens/auth_screens/login_screen.dart';
import 'providers/car_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await CommonFunctions.updateFCMtoken();
    // CommonFunctions.appsflyerInit();
    // await initMixpanel();
    await initCrashlytics();
    // FlutterBranchSdk.setPreinstallCampaign('$appName Campaign');
    // FlutterBranchSdk.initSession();
    runApp(MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> initCrashlytics() async {
  final FirebaseCrashlytics crashlyitics = FirebaseCrashlytics.instance;
  FlutterError.onError = crashlyitics.recordFlutterError;
  if (currentEnv == Environment.Prod && kReleaseMode) {
    await crashlyitics.setCrashlyticsCollectionEnabled(true);
  } else {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };
    await crashlyitics.setCrashlyticsCollectionEnabled(false);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (c, v) => MultiProvider(
        providers: [
          ChangeNotifierProvider<CarProvider>(
              create: (BuildContext context) => CarProvider()),
          ChangeNotifierProvider<HomeProvider>(
              create: (BuildContext context) => HomeProvider()),
          ChangeNotifierProvider<ThemeProvider>(
            create: (BuildContext context) => ThemeProvider(),
          )
        ],
        child: ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
          child: Consumer<ThemeProvider>(
            builder: (context, value, child) => MaterialApp(
              locale: const Locale('en', 'US'),
              debugShowCheckedModeBanner: false,
              title: appName,
              theme: value.isDark! ? darkTheme : lightTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!,
              ),
              home: TabScreen(),
              // home: GearVehicleTypeListScreen(
              //   cityKey: 345, // Example cityKey
              //   pickupDate: DateTime.now(),
              //   dropoffDate: DateTime.now().add(const Duration(days: 1)),
              // ),
              routes: PageRoutes.routes,
              onUnknownRoute: (settings) {
                return MaterialPageRoute(builder: (ctx) => TabScreen());
              },
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<User?> home() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return spinkit;
        } else if (snapshot.hasData) {
          return TabScreen();
        }
        return LoginScreen();
      },
    );
  }
}
