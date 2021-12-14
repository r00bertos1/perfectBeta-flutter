import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';

class StepsParams {
  static var stepsText = ["Add photo", "Verify holds", "Step 3"];
  static var stepCircleRadius = 10.0;
  static var stepProgressViewHeight = 150.0;
  static Color activeColor = active;
  static Color inactiveColor = Colors.grey;
  static TextStyle headerStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  static TextStyle stepStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
}