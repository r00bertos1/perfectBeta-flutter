import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/widgets/gym_details_routes.dart';
import 'package:perfectBeta/pages/route/my_routes/widgets/my_routes_table.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

class GymDetailsPage extends StatelessWidget {
  final int gymId;
  final String gymName;
  const GymDetailsPage({Key key, this.gymId, this.gymName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: ResponsiveWidget.isSmallScreen(context) ? 100 : 10,
                        bottom:
                            ResponsiveWidget.isSmallScreen(context) ? 0 : 20),
                    child: CustomText(
                      //Gym name
                      text: gymName,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          Expanded(child: GymsDetailsRoutes(gymId: gymId)),
        ],
      ),
    );
  }
}
