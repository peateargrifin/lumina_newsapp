import 'package:flutter/material.dart';



extension MediaQueryValues on BuildContext {
  // Screen width
  double get width => MediaQuery.of(this).size.width;

  // Screen height
  double get height => MediaQuery.of(this).size.height;

  // Device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  // Orientation (portrait or landscape)
  Orientation get orientation => MediaQuery.of(this).orientation;

  // Padding (safe area)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  // Text scale factor
  double get textScale => MediaQuery.of(this).textScaleFactor;
}
