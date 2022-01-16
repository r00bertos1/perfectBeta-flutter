import 'package:flutter/material.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/dto/auth/token_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/pages/overview/widgets/available_drivers_table.dart';
import 'package:perfectBeta/pages/overview/widgets/admin/admin_overview_cards_large.dart';
import 'package:perfectBeta/pages/overview/widgets/admin/admin_overview_cards_medium.dart';
import 'package:perfectBeta/pages/overview/widgets/admin/admin_overview_cards_small.dart';
import 'package:perfectBeta/pages/overview/widgets/revenue_section_large.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

import 'widgets/revenue_section_small.dart';

class OverviewPage extends StatelessWidget {
  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

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
              FutureBuilder(
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
                              return Column(
                                children: [
                                  if (ResponsiveWidget.isHugeScreen(context))
                                    AdminOverviewCardsLargeScreen()
                                  else if (ResponsiveWidget.isLargeScreen(context) ||
                                      ResponsiveWidget.isMediumScreen(context))
                                    if (ResponsiveWidget.isCustomSize(context))
                                      AdminOverviewCardsMediumScreen()
                                    else
                                      AdminOverviewCardsLargeScreen()
                                  else
                                    AdminOverviewCardsSmallScreen(),
                                  // if (!ResponsiveWidget.isSmallScreen(context))
                                  //   RevenueSectionLarge()
                                  // else
                                  //   RevenueSectionSmall(),
                                  // AvailableDriversTable(),
                                ],
                              );
                            case 'MANAGER':
                              return Text('MANAGER');
                            case 'CLIMBER':
                              return Text('CLIMBER');
                            default:
                              return Text('default');
                          }
                    }
                  }),
            ],
          ))
        ],
      ),
    );
  }
}
