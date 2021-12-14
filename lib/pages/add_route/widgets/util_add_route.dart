import 'dart:ui';
import 'package:perfectBeta/pages/add_route/widgets/step_progress_view.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';

Size safeAreaSize;
int _curPage = 1;

final _stepsText = ["Add photo", "Verify holds", "Step 3"];
final _stepCircleRadius = 10.0;
final _stepProgressViewHeight = 150.0;
final _stepProgressViewHeightMobile = 50.0;
Color _activeColor = active;
Color _inactiveColor = Colors.grey;
TextStyle _headerStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
TextStyle _stepStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

StepProgressView _getStepProgress() {
  return StepProgressView(
    _stepsText,
    _curPage,
    _stepProgressViewHeight,
    safeAreaSize.width,
    _stepCircleRadius,
    _activeColor,
    _inactiveColor,
    _headerStyle,
    _stepStyle,
    decoration: BoxDecoration(color: light),
  );
}