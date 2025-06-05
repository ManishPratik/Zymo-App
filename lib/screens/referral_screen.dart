// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:letzrentnew/Services/dynamic_links_service.dart';
// import 'package:letzrentnew/Utils/constants.dart';
// import 'package:letzrentnew/Utils/functions.dart';
// // import 'package:share_plus/share_plus.dart';

// class ReferralScreen extends StatelessWidget {
//   const ReferralScreen({Key? key}) : super(key: key);
//   static const String routeName = 'ReferralScreen';
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Refer & Earn'),
//         ),
//         // bottomNavigationBar: ,
//         body: FutureBuilder<String?>(
//             future: DynamicLinksService().createDynamicLink(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting)
//                 return Center(
//                   child: spinkit,
//                 );
//               else if (snapshot.hasError) {
//                 print(snapshot.error);
//                 return Center(
//                     child: Text(
//                   'Log In to continue...',
//                   style: largeBlackStyle,
//                 ));
//               } else {
//                 final referralText = getReferralText(snapshot.data);
//                 return SizedBox(
//                   width: 1.sw,
//                   height: 1.sh,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Refer $appName to a friend',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                         SizedBox(
//                           height: .01.sh,
//                         ),
//                         Text(
//                           'And you both win vouchers worth Rs.$referralAmount!',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400, fontSize: 15),
//                         ),
//                         SizedBox(
//                           height: .06.sh,
//                         ),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Theme.of(context)
//                                   .colorScheme
//                                   .secondary
//                                   .withOpacity(.5),
//                               foregroundColor: Theme.of(context).primaryColor,
//                               radius: .07.sw,
//                               child: Text(
//                                 '1',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 20),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               'Invite using link',
//                               style: headingStyle,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: .03.sh,
//                         ),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Theme.of(context)
//                                   .colorScheme
//                                   .secondary
//                                   .withOpacity(.6),
//                               foregroundColor: Theme.of(context).primaryColor,
//                               radius: .07.sw,
//                               child: Text(
//                                 '2',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 20),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               'They download $appName',
//                               style: headingStyle,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: .03.sh,
//                         ),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               foregroundColor: Theme.of(context).primaryColor,
//                               backgroundColor: Theme.of(context)
//                                   .colorScheme
//                                   .secondary
//                                   .withOpacity(.7),
//                               radius: .07.sw,
//                               child: Text(
//                                 '3',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 20),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               'You both receive a voucher!',
//                               style: headingStyle,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: .06.sh,
//                         ),
//                         InputDecorator(
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: const BorderRadius.all(
//                               const Radius.circular(20.0),
//                             )),
//                           ),
//                           child: Text(
//                             '${snapshot.data}',
//                             style: TextStyle(color: Colors.black54),
//                           ),
//                         ),
//                         SizedBox(
//                           height: .03.sh,
//                         ),
//                         // Center(
//                         //   child: AppButton(
//                         //       function: () => Clipboard.setData(
//                         //               ClipboardData(text: snapshot.data))
//                         //           .then((value) => CommonFunctions.showSnackbar(
//                         //               context, 'Copied to clipboard')),
//                         //       screenWidth: 2.sw,
//                         //       screenHeight: 1.sh,
//                         //       title: 'Copy Link!'),
//                         // ),
//                         Row(
//                           children: [
//                             Tiles(
//                               color: Colors.green,
//                               icon: FontAwesomeIcons.whatsapp,
//                               text: "WhatsApp",
//                               func: () => CommonFunctions.whatsappFunction(
//                                   referralText),
//                             ),
//                             // Tiles(
//                             //   color: Colors.green,
//                             //   icon: FontAwesomeIcons.message,
//                             //   text: "Message",
//                             //   func: () => CommonFunctions.message(
//                             //       referralText),
//                             // ),
//                             Tiles(
//                               color: Colors.blue,
//                               icon: FontAwesomeIcons.copy,
//                               text: "Copy Link",
//                               func: () => Clipboard.setData(
//                                       ClipboardData(text: snapshot.data!))
//                                   .then((value) => CommonFunctions.showSnackbar(
//                                       context, 'Copied to clipboard')),
//                             ),
//                             Tiles(
//                               color: Colors.green,
//                               icon: FontAwesomeIcons.shareFromSquare,
//                               text: "More",
//                               // func: () => Share.share(referralText),
//                             ),
//                           ],
//                         ),
//                         // OutlinedButton(
//                         //   onPressed: () {},
//                         //   child: Text("Copy Link"),
//                         //   style: OutlinedButton.styleFrom(
//                         //       foregroundColor: appColor),
//                         // ),
//                         Spacer(),

//                         ElevatedButton(
//                             onPressed: () {}, // => Share.share(referralText),
//                             child: Text("Share Link"))
//                       ],
//                     ),
//                   ),
//                 );
//               }
//             }),
//       ),
//     );
//   }

//   String getReferralText(String? link) {
//     return "Hey there! I recently started using Zymo for all my self-drive car rental needs, and it’s been amazing. They have a huge selection of cars to choose from, and their comparison model makes it easy to find the perfect ride for any occasion.\n\nAnd now, I have even more good news - I can refer you to Zymo and get both of us a Rs 200 discount voucher! Just use my referral code when you sign up, and we’ll both get a discount on our next rental.\n\nSo if you’re in need of a car for your next road trip or just for running errands around town, give Zymo a try. Trust me, you won’t regret it!\n\n Click to download:\n$link";
//   }
// }

// class Tiles extends StatelessWidget {
//   final Function? func;
//   final IconData? icon;
//   final Color? color;
//   final String? text;
//   const Tiles({
//     Key? key,
//     this.func,
//     this.icon,
//     this.text,
//     this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: func as void Function()?,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(
//               icon,
//               color: color,
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Text(text!)
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letzrentnew/Services/dynamic_links_service.dart';
import 'package:letzrentnew/Utils/constants.dart';

import '../Utils/functions.dart';

// import 'package:share_plus/share_plus.dart';
Color color = appColor;

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);
  static const String routeName = 'ReferralScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Refer & Earn',
            style: TextStyle(color: Colors.black),
          ),
        ),
        // bottomNavigationBar: ,
        body: FutureBuilder<String?>(
            future: AppsFlyerService.createDynamicLink(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: spinkit,
                );
              else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Log In to continue...',
                  style: largeBlackStyle,
                ));
              } else {
                // final referralText = getReferralText(snapshot.data!);
                return SafeArea(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradientColors),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height * .04,
                              left: MediaQuery.of(context).size.height * .04,
                              bottom: MediaQuery.of(context).size.height * .025,
                              top: MediaQuery.of(context).size.height * .05,
                            ),
                            child: Card(
                              color: darkGrey,
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.height * .8,
                                height:
                                    MediaQuery.of(context).size.height * .57,
                                child: Column(children: [
                                  Image.network(
                                      "https://imagetolink.com/ib/YVrkz8vH9X.png"),
                                  Text("Spread the Joy of Zymo!",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center),

                                  SizedBox(
                                    height: .01.sh,
                                  ),

                                  Text(
                                    "Refer a friend and both of you earn\nRs 200 in vouchers",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: color.withOpacity(0.7),
                                      // fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: .02.sh,
                                  ),
                                  Divider(
                                    indent: 25,
                                    endIndent: 25,
                                    thickness: 1.5,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(
                                    height: .02.sh,
                                  ),
                                  Text(
                                    "Share referral code via",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: color.withOpacity(0.7),
                                      // fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: .01.sh,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: snapshot.data!))
                                              .then((value) =>
                                                  CommonFunctions.showSnackbar(
                                                    context,
                                                    'Copied to clipboard',
                                                  ));
                                        },
                                        icon: Icon(FontAwesomeIcons.whatsapp),
                                        label: Text("WhatsApp"),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: snapshot.data!))
                                              .then((value) =>
                                                  CommonFunctions.showSnackbar(
                                                    context,
                                                    'Copied to clipboard',
                                                  ));
                                        },
                                        icon: Icon(FontAwesomeIcons.link),
                                        label: Text("Copy Link"),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          backgroundColor:
                                              color.withOpacity(0.7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // DottedBorder(
                                  //   borderType: BorderType.RRect,
                                  //   radius: Radius.circular(35),
                                  //   strokeWidth: 1.5,
                                  //   dashPattern: [6, 3],
                                  //   child: Row(children: [
                                  //     Expanded(
                                  //       child: Text(
                                  //         '${snapshot.data}',
                                  //         style:
                                  //             TextStyle(color: Colors.black54),
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       height: 65,
                                  //       width: 90,
                                  //       decoration: BoxDecoration(
                                  //         color: Theme.of(context)
                                  //             .colorScheme
                                  //             .secondary,
                                  //         borderRadius: BorderRadius.only(
                                  //           topLeft: Radius.circular(5),
                                  //           bottomLeft: Radius.circular(5),
                                  //           topRight: Radius.circular(50),
                                  //           bottomRight: Radius.circular(50),
                                  //         ),
                                  //       ),
                                  //       child:
                                  //           Icon(Icons.copy, color: Colors.white),
                                  //     ),
                                  //   ]),
                                  // ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 40),
                                  CircleAvatar(
                                    backgroundColor: color.withOpacity(0.7),
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: .05.sw,
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Share Zymo through the link',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: .02.sh,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 40),
                                  CircleAvatar(
                                    backgroundColor: color.withOpacity(.7),
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: .05.sw,
                                    child: Text(
                                      '2',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Your friends discover $appName',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: .02.sh,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 40),
                                  CircleAvatar(
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor: color.withOpacity(.7),
                                    radius: .05.sw,
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Unlock rewards together',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  String getReferralText(String link) {
    return "Hey there! I recently started using Zymo for all my self-drive car rental needs, and it’s been amazing. They have a huge selection of cars to choose from, and their comparison model makes it easy to find the perfect ride for any occasion.\n\nAnd now, I have even more good news - I can refer you to Zymo and get both of us a Rs 200 discount voucher! Just use my referral code when you sign up, and we’ll both get a discount on our next rental.\n\nSo if you’re in need of a car for your next road trip or just for running errands around town, give Zymo a try. Trust me, you won’t regret it!\n\n Click to download:\n$link";
  }
}

class Tiles extends StatelessWidget {
  final Function? func;
  final IconData? icon;
  final Color? color;
  final String? text;

  const Tiles({
    Key? key,
    this.func,
    this.icon,
    this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func as void Function()?,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(9),
        child: Column(
          children: [
            Icon(
              icon,
              color: whiteColor,
              size: 30,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
