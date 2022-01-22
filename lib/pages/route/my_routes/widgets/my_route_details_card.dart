import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

class MyRouteDetailsCard extends StatelessWidget {
  const MyRouteDetailsCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                  color: active, borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CustomText(
                text: "Close",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
