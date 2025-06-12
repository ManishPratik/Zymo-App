import 'package:flutter/material.dart';

/// A utility class to provide screen dimensions such as height and width.
class Dimensions {
  /// Returns the screen width for the given BuildContext.
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}