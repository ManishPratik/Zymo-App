// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:letzrentnew/Screens/auth_screens/otp_screen.dart';
// import 'package:letzrentnew/Screens/tabs_screen.dart';
// import 'package:letzrentnew/Services/firebase_services.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/functions.dart';
// import 'package:letzrentnew/providers/home_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// //import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class Auth {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//   // Future<void> signInWithApple(BuildContext context) async {
//   //   final appleIdCredential = await SignInWithApple.getAppleIDCredential(
//   //     scopes: [
//   //       AppleIDAuthorizationScopes.email,
//   //       AppleIDAuthorizationScopes.fullName,
//   //     ],
//   //   );
//   //   final oAuthProvider = OAuthProvider('apple.com');
//   //   final credential = oAuthProvider.credential(
//   //     idToken: appleIdCredential.identityToken,
//   //     accessToken: appleIdCredential.authorizationCode,
//   //   );
//   //   await signInFunction(credential, context);
//   // }


//   Future<User?> signInWithEmail(context, String email, String password) async {
//     try{
//     final UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     if (authResult.user != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) =>  TabScreen()),
//       );
//     }
//     return authResult.user;
//   }catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error signing in: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//   print('Error signing in: $e.');
//   return null;
//   }
// }


// // Future<void> signInWithGoogle(BuildContext context) async {
//   //   final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//   //   final GoogleSignInAuthentication googleSignInAuthentication =
//   //       await googleSignInAccount.authentication;

//   //   final AuthCredential credential = GoogleAuthProvider.credential(
//   //     accessToken: googleSignInAuthentication.accessToken,
//   //     idToken: googleSignInAuthentication.idToken,
//   //   );

//   //   await signInFunction(credential, context);
//   // }

//   Future<void> signInFunction(
//       AuthCredential credential, BuildContext context) async {
//     final UserCredential authResult =
//         await firebaseAuth.signInWithCredential(credential);
//     final User user = authResult.user!;

//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);

//     final User currentUser = firebaseAuth.currentUser!;
//     assert(user.uid == currentUser.uid);
//     await postCreation(authResult, context);
//   }

//   static Future<void> postCreation(
//       UserCredential authResult, BuildContext context) async {
//     bool isNewUser = authResult.additionalUserInfo!.isNewUser;
//     if (isNewUser) {
//       final HomeProvider provider =
//           Provider.of<HomeProvider>(context, listen: false);
//       provider.isNewUserFunction(true);
//       final amount = (await FirebaseServices().getVoucherAmount())!;
//       await FirebaseServices().addNewVoucher(
//           amount['newUserAmount'] ?? 50, context,
//           validTillDateTime: DateTime.now().add(Duration(days: 15)));
//       await FirebaseServices().setUserDetails(authResult.user!.uid,
//           authResult.user!.displayName ?? '', authResult.user!.email ?? '',
//           phone: authResult.user!.phoneNumber);
//       // mixpanel!.identify(authResult.user!.uid);
//     }
//   }

//   Future<bool> signUpWithEmail(BuildContext context, String email, String password, String name, String Phone) async {
//     try {
//       UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (authResult.user != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => TabScreen()),
//         );
//       }
//       await firebaseAuth.currentUser!.updateDisplayName(name);
//       await FirebaseServices().setUserDetails(authResult.user!.uid, name, authResult.user!.email, phone: Phone);

//       return true;
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "$e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       print("Error signing up: $e");
//       return false; // Indicate sign up failed
//     }
//   }


//   Future<bool> forgotPassword(String email) async {
//     try {
//       await firebaseAuth.sendPasswordResetEmail(email: email);
//       Fluttertoast.showToast(
//         msg: "Resent mail sent successfully",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       return true; // Indicate success
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error sending password reset email: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       return false; // Indicate failure
//     }

//   }

//   User? getCurrentUser() {
//     final User? user = firebaseAuth.currentUser;
//     return user;
//   }

//   Future<void> signOut() async {
//     await firebaseAuth.signOut();
//     await GoogleSignIn().signOut();
//   }

//   Future<bool> signInWithOTP(
//       String verificationId, BuildContext context, String otp) async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: otp,
//       );
//       await signInFunction(credential, context);
//       return true;
//     } catch (e) {
//       // mixpanel!.track('OTP error', properties: {'error': e});
//       // if (e.code == 'invalid-verification-code') {
//       if (e == 'invalid-verification-code') {
//         warningPopUp(context, oops, 'Invalid OTP');
//       } else {
//         warningPopUp(context, oops, 'Something went wrong. $e');
//       }
//       return false;
//     }
//   }

//   Future<void> sendOTP(
//       String? phone, BuildContext context, bool isResend) async {
//     final PhoneVerificationCompleted verificationCompleted =
//         (PhoneAuthCredential credential) async {
//       await firebaseAuth.signInWithCredential(credential);
//     };

//     final PhoneVerificationFailed verificationFailed =
//         (FirebaseAuthException e) {
//       CommonFunctions.showSnackbar(context, 'OTP verfication failed $e');
//     };
//     final provider = Provider.of<HomeProvider>(context, listen: false);

//     final PhoneCodeSent smsOtpSend =
//         (String verificationId, int? resendToken) async {
//       provider.otpInitTimer(30, resendToken);
//       if (isResend) {
//         CommonFunctions.showSnackbar(context, 'OTP sent');
//       } else {
//         final value = await Navigator.of(context).push(
//           MaterialPageRoute(
//               builder: (context) => Otp(
//                     verificationId: verificationId,
//                     phoneNumber: phone!,
//                   )),
//         );
//         Navigator.pop(context, value);
//       }
//     };

//     try {
//       await firebaseAuth.verifyPhoneNumber(
//         phoneNumber: phone,
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: smsOtpSend,
//         forceResendingToken: provider.resendToken,
//         codeAutoRetrievalTimeout: (String verId) {},
//       );
//     } catch (e) {
//       // mixpanel!.track('otp fail', properties: {'error': e});
//       CommonFunctions.showSnackbar(context, 'Something went wrong $e');
//       print(e);
//     }
//   }

//   Future<void> deleteAccount() async {
//     try {
//       final currentUser2 = firebaseAuth.currentUser!;
//       await currentUser2.delete();
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> signInWithApple(BuildContext context) async {
//     final appleIdCredential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//     );
//     final oAuthProvider = OAuthProvider('apple.com');
//     final credential = oAuthProvider.credential(
//       idToken: appleIdCredential.identityToken,
//       accessToken: appleIdCredential.authorizationCode,
//     );
//     final UserCredential authResult =
//         await FirebaseAuth.instance.signInWithCredential(credential);
//     final User user = authResult.user!;
//     await Auth.postCreation(authResult, context);
//     assert(!user.isAnonymous);
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letzrentnew/Screens/auth_screens/otp_screen.dart';
import 'package:letzrentnew/Screens/tabs_screen.dart';
import 'package:letzrentnew/Services/firebase_services.dart';
import 'package:letzrentnew/Utils/constants.dart';
import 'package:letzrentnew/Utils/functions.dart';
import 'package:letzrentnew/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential authResult =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TabScreen()),
        );
      }
      return authResult.user;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error signing in: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Error signing in: $e.');
      return null;
    }
  }

  Future<void> signInFunction(
      AuthCredential credential, BuildContext context) async {
    final UserCredential authResult =
        await firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = firebaseAuth.currentUser!;
    assert(user.uid == currentUser.uid);
    await postCreation(authResult, context);
  }

  static Future<void> postCreation(
      UserCredential authResult, BuildContext context) async {
    bool isNewUser = authResult.additionalUserInfo!.isNewUser;
    if (isNewUser) {
      final HomeProvider provider =
          Provider.of<HomeProvider>(context, listen: false);
      provider.isNewUserFunction(true);

      final amount = (await FirebaseServices().getVoucherAmount())!;
      await FirebaseServices().addNewVoucher(
        amount['newUserAmount'] ?? 50,
        context,
        validTillDateTime: DateTime.now().add(Duration(days: 15)),
      );

      await FirebaseServices().setUserDetails(
        authResult.user!.uid,
        authResult.user!.displayName ?? '',
        authResult.user!.email ?? '',
        phone: authResult.user!.phoneNumber,
      );
    }
  }

  Future<bool> signUpWithEmail(BuildContext context, String email,
      String password, String name, String phone) async {
    try {
      UserCredential authResult =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TabScreen()),
        );
      }

      await firebaseAuth.currentUser!.updateDisplayName(name);
      await FirebaseServices().setUserDetails(
          authResult.user!.uid, name, authResult.user!.email,
          phone: phone);

      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Error signing up: $e");
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Reset mail sent successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error sending reset email: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  // 🔐 OTP AUTH STARTS HERE

  Future<void> sendOTP({
    required String phoneNumber,
    required BuildContext context,
    required bool isResend,
  }) async {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification completed
        await firebaseAuth.signInWithCredential(credential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => TabScreen()));
      },
      verificationFailed: (FirebaseAuthException e) {
        CommonFunctions.showSnackbar(context, 'OTP failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        provider.otpInitTimer(30, resendToken);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otp(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      forceResendingToken: provider.resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> signInWithOTP({
    required String verificationId,
    required String smsCode,
    required BuildContext context,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await signInFunction(credential, context);
      return true;
    } catch (e) {
      warningPopUp(context, oops, 'OTP verification failed: $e');
      return false;
    }
  }

  // 🍎 Apple Sign In
  Future<void> signInWithApple(BuildContext context) async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = authResult.user!;
    await Auth.postCreation(authResult, context);
    assert(!user.isAnonymous);
  }

  Future<void> deleteAccount() async {
    try {
      final currentUser = firebaseAuth.currentUser!;
      await currentUser.delete();
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}
