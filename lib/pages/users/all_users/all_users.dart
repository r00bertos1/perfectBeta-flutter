import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/users/all_users/widgets/all_users_table.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: ResponsiveWidget.isSmallScreen(context) ? 100 : 10,
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
              child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              AllUsersTable(),
            ],
          )),
        ],
      ),
    );
  }
}
