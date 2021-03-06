import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/widgets/gyms_grid_admin.dart';
import 'package:perfectBeta/pages/gym/widgets/gyms_table_manager.dart';
import 'package:perfectBeta/pages/gym/widgets/gyms_grid.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

class GymsPage extends StatelessWidget {
  GymsPage({Key key}) : super(key: key);

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
                        top: ResponsiveWidget.isSmallScreen(context) ? 100 : 10, bottom: ResponsiveWidget.isSmallScreen(context) ? 20 : 20),
                    child: CustomText(
                      text: menuController.activeItem.value,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: secStore.getAccessLevel(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container();
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        switch (snapshot.data) {
                          case 'ADMIN':
                            return GymsGridAdmin();
                          case 'MANAGER':
                            return GymsTableManager();
                          case 'CLIMBER':
                          default:
                            return GymsGrid();
                        }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
