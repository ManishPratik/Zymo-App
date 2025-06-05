import 'package:flutter/cupertino.dart';
import 'package:letzrentnew/Screens/auth_screens/login_screen.dart';
import 'package:letzrentnew/Screens/contact_us.dart';
import 'package:letzrentnew/Screens/documents_upload.dart';
import 'package:letzrentnew/Screens/FAQs.dart';
import 'package:letzrentnew/Screens/my%20orders.dart';
import 'package:letzrentnew/Screens/offers.dart';
import 'package:letzrentnew/Screens/orders_screen.dart';
import 'package:letzrentnew/Screens/referral_screen.dart';
import 'package:letzrentnew/Screens/Rewards/vouchers_screen.dart';
import 'package:letzrentnew/Screens/submit_success_screen.dart';
import 'package:letzrentnew/Screens/tabs_screen.dart';
import 'package:letzrentnew/Screens/user_profile.dart';
import 'package:letzrentnew/screens/EV_FAQ.dart';
import 'package:letzrentnew/Widgets/Aircraft/aircraft_payment.dart';
import 'package:letzrentnew/Widgets/Cars/chauffeur_drive.dart';
import 'package:letzrentnew/Widgets/Cars/monthly_rental.dart';
import 'package:letzrentnew/Widgets/Cars/payment_fail.dart';
import 'package:letzrentnew/Widgets/Cars/payment_success.dart';
import 'package:letzrentnew/Widgets/Cars/self_drive.dart';

class PageRoutes {
 static Map<String, WidgetBuilder> get routes {
    return {
      OrdersScreen.routeName: (ctx) => OrdersScreen(),
      SelfDrive.routeName: (ctx) => SelfDrive(),
      // UserBookingScreen.routeName: (ctx) => UserBookingScreen(),
      // ColivingFilterScreen.routeNmae: (ctx) => ColivingFilterScreen(),
      // RoomsScreen.routeName: (ctx) => RoomsScreen(),
      // ColivingBooking.routeName: (ctx) => ColivingBooking(),
      TabScreen.routeName: (ctx) => TabScreen(),
      SubmitSuccessScreen.routeName: (ctx) => SubmitSuccessScreen(),
      SuccessPage.routeName: (ctx) => SuccessPage(),
      FailedPage.routeName: (ctx) => FailedPage(),
      MonthlyRental.routeName: (ctx) => const MonthlyRental(),
      UserProfile.routeName: (ctx) => UserProfile(),
      DocumentsUpload.routeNmae: (ctx) => DocumentsUpload(),
      Help.routeName: (ctx) => Help(),
      EV_Faq.routeName: (ctx) => EV_Faq(), 
      ContactUs.routeName: (ctx) => ContactUs(),
      MyBookings.routeName: (ctx) => MyBookings(),
      // AircraftsFilterScreen.routeNmae: (ctx) => AircraftsFilterScreen(),
      // AircraftsGrid.routeName: (ctx) => AircraftsGrid(),
      // AircraftsBooking.routeName: (ctx) => AircraftsBooking(),
      // ConfirmAircraftsBooking.routeName: (ctx) => ConfirmAircraftsBooking(),
      AircraftPaymentPage.routeName: (ctx) => AircraftPaymentPage(),
      // RentPay.routeNmae: (ctx) => RentPay(),
      RewardsScreen.routeName: (ctx) => RewardsScreen(),
      OfferPage.routeName: (ctx) => OfferPage(),
      // CheckRazor.routeName: (ctx) => CheckRazor(),
      LoginScreen.routeName: (ctx) => LoginScreen(),
      ReferralScreen.routeName: (ctx) => ReferralScreen(),
      ChauffeurDrive.routeName: (ctx) => const ChauffeurDrive()
    };
  }
}
