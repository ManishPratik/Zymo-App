// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letzrentnew/Utils/functions.dart';
// import 'package:letzrentnew/providers/home_provider.dart';
// import 'package:provider/provider.dart';

// class OnBoardingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Consumer<HomeProvider>(
//             builder: (BuildContext context, value, Widget child) => Stack(
//               children: [
//                 Column(
//                   children: [
//                     Expanded(
//                       child: PageView.builder(
//                           controller: value.pageController,
//                           onPageChanged: value.setPage,
//                           itemCount: value.onboardingPages.length,
//                           itemBuilder: (context, index) {
//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   value.onboardingPages[index]['image'],
//                                   height: .4.sh,
//                                 ),
//                                 const SizedBox(height: 32),
//                                 Text(
//                                   value.onboardingPages[index]['title'],
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                                 SizedBox(height: 15),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 64.0),
//                                   child: Text(
//                                     value.onboardingPages[index]['body'],
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
//                     ),
//                     SizedBox(
//                       height: .05.sh,
//                       width: .2.sw,
//                       child: ListView.builder(
//                           itemCount: value.onboardingPages.length,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) => Container(
//                                 margin: const EdgeInsets.all(4),
//                                 width:
//                                     value.selectedPageIndex == index ? 10 : 6,
//                                 height:
//                                     value.selectedPageIndex == index ? 10 : 6,
//                                 decoration: BoxDecoration(
//                                   color: value.selectedPageIndex == index
//                                       ? Colors.black
//                                       : Colors.grey,
//                                   shape: BoxShape.circle,
//                                 ),
//                               )),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(.08.sw),
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () => value.isLastPage
//                               ?CommonFunctions. navigateToSignIn(context)
//                               : value.forwardAction(),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(value.isLastPage ? 'Get started' : 'Next',
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600)),
//                               const Icon(Icons.arrow_right_alt_rounded)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (value.isLastPage)
//                   Container()
//                 else
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: InkWell(
//                       onTap: () =>CommonFunctions. navigateToSignIn(context),
//                       child: const Padding(
//                         padding: EdgeInsets.all(14.0),
//                         child: Text('Skip'),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
