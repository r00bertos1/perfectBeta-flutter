import 'package:flutter/material.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/pages/overview/widgets/admin/admin_overview_cards_large.dart';
import 'package:perfectBeta/pages/overview/widgets/admin/admin_overview_cards_medium.dart';
import 'package:perfectBeta/pages/overview/widgets/admin/admin_overview_cards_small.dart';
import 'package:perfectBeta/pages/overview/widgets/anonim/overview_cards_large.dart';
import 'package:perfectBeta/pages/overview/widgets/anonim/overview_cards_medium.dart';
import 'package:perfectBeta/pages/overview/widgets/anonim/overview_cards_small.dart';
import 'package:perfectBeta/pages/overview/widgets/climber/climber_overview_cards_large.dart';
import 'package:perfectBeta/pages/overview/widgets/climber/climber_overview_cards_medium.dart';
import 'package:perfectBeta/pages/overview/widgets/climber/climber_overview_cards_small.dart';
import 'package:perfectBeta/pages/overview/widgets/manager/manager_overview_cards_large.dart';
import 'package:perfectBeta/pages/overview/widgets/manager/manager_overview_cards_medium.dart';
import 'package:perfectBeta/pages/overview/widgets/manager/manager_overview_cards_small.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

class OverviewPage extends StatelessWidget {
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
                                ],
                              );
                            case 'MANAGER':
                              return Column(
                                children: [
                                  if (ResponsiveWidget.isHugeScreen(context))
                                    ManagerOverviewCardsLargeScreen()
                                  else if (ResponsiveWidget.isLargeScreen(context) ||
                                      ResponsiveWidget.isMediumScreen(context))
                                    if (ResponsiveWidget.isCustomSize(context))
                                      ManagerOverviewCardsMediumScreen()
                                    else
                                      ManagerOverviewCardsLargeScreen()
                                  else
                                    ManagerOverviewCardsSmallScreen(),
                                ],
                              );
                            case 'CLIMBER':
                              return Column(
                                children: [
                                  if (ResponsiveWidget.isHugeScreen(context))
                                    ClimberOverviewCardsLargeScreen()
                                  else if (ResponsiveWidget.isLargeScreen(context) ||
                                      ResponsiveWidget.isMediumScreen(context))
                                    if (ResponsiveWidget.isCustomSize(context))
                                      ClimberOverviewCardsMediumScreen()
                                    else
                                      ClimberOverviewCardsLargeScreen()
                                  else
                                    ClimberOverviewCardsSmallScreen(),
                                ],
                              );
                            default:
                              return Column(
                                children: [
                                  if (ResponsiveWidget.isHugeScreen(context))
                                    OverviewCardsLargeScreen()
                                  else if (ResponsiveWidget.isLargeScreen(context) ||
                                      ResponsiveWidget.isMediumScreen(context))
                                    if (ResponsiveWidget.isCustomSize(context))
                                      OverviewCardsMediumScreen()
                                    else
                                      OverviewCardsLargeScreen()
                                  else
                                    OverviewCardsSmallScreen(),
                                ],
                              );
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
