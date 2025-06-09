// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/screens/auth_screens/phone_input_screen.dart';
// import 'package:letzrentnew/screens/home_page.dart';

// import 'package:provider/provider.dart';

// import 'Utils/constants.dart';
// import 'Utils/app_data.dart';
// import 'Utils/functions.dart';
// import 'Utils/routes.dart';
// import 'firebase_options.dart';

// import 'providers/home_provider.dart';
// import 'providers/car_provider.dart';
// import 'providers/theme_provider.dart';
         

// void main() async {
//   runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     await CommonFunctions.updateFCMtoken();
//     await initCrashlytics();

//     runApp(MyApp());
//   }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
// }

// Future initCrashlytics() async {
//   final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
//   FlutterError.onError = crashlytics.recordFlutterError;
//   if (currentEnv == Environment.Prod && kReleaseMode) {
//     await crashlytics.setCrashlyticsCollectionEnabled(true);
//   } else {
//     FlutterError.onError = (FlutterErrorDetails details) {
//       FlutterError.dumpErrorToConsole(details);
//     };
//     await crashlytics.setCrashlyticsCollectionEnabled(false);
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       builder: (c, v) => MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => CarProvider()),
//           ChangeNotifierProvider(create: (_) => HomeProvider()),
//           ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ],
//         child: Consumer<ThemeProvider>(
//           builder: (context, themeProvider, child) => MaterialApp(
//             locale: const Locale('en', 'US'),
//             debugShowCheckedModeBanner: false,
//             title: appName,
//             theme: themeProvider.isDark! ? darkTheme : lightTheme,

//             // Initial screen: PhoneInputScreen (OTP Login)
//             //home: PhoneInputScreen(),
            

//             // Routes for navigation
//             routes: {
//               '/home': (context) => HomePage(),
//               // add other routes if needed
//             },

//             builder: (context, child) => MediaQuery(
//               data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//               child: child!,
//             ),

//             onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => PhoneInputScreen()),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzrentnew/screens/auth_screens/phone_input_screen.dart';
import 'package:letzrentnew/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'Utils/constants.dart';
import 'Utils/app_data.dart';
import 'Utils/functions.dart';
import 'firebase_options.dart';
import 'providers/home_provider.dart';
import 'providers/car_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await CommonFunctions.updateFCMtoken();
    await initCrashlytics();
    runApp(MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future initCrashlytics() async {
  final crash = FirebaseCrashlytics.instance;
  FlutterError.onError = crash.recordFlutterError;
  await crash.setCrashlyticsCollectionEnabled(currentEnv == Environment.Prod && kReleaseMode);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CarProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, theme, _) => MaterialApp(
            locale: const Locale('en', 'US'),
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: theme.isDark! ? darkTheme : lightTheme,
            home: AuthGate(),
            routes: {
              '/home': (_) => HomePage(),
            },
            onGenerateRoute: (settings) {
              // future expansion point - dynamic routing
              return null;
            },
            onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => PhoneInputScreen()),
          ),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.hasData ? HomePage() : PhoneInputScreen();
      },
    );
  }
}

