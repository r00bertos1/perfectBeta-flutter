import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/add_route/widgets/add_steps.dart';
import 'package:perfectBeta/pages/add_route/widgets/route_steps.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

class AddRoutePage extends StatelessWidget {
  const AddRoutePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(
                () => Row(
              children: [
                Container(
                    color: light,
                    margin: EdgeInsets.only(
                        top: ResponsiveWidget.isSmallScreen(context) ? 80 : 10,
                        bottom:
                        ResponsiveWidget.isSmallScreen(context) ? 20 : 20),
                    child: CustomText(
                      text: menuController.activeItem.value,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
              child: AddSteps(),
              //child: AddImagePage(onSubmit: (String value) {  },)
              ),
        ],
      ),
    );
  }
}
