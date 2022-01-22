import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var _child = child;

    // if (showPadding) {
    //   _child = Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
    //     child: child,
    //   );
    // } else {
    //   _child = Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
    //     child: child,
    //   );
    // }

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Dialog(
        elevation: 0,
        insetAnimationCurve: Curves.easeInOut,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: _child,
      ),
    );
  }
}