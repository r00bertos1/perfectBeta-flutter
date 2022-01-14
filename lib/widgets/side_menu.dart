import 'package:flutter/material.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:perfectBeta/widgets/side_menu_item.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key key}) : super(key: key);

  static ApiClient _client = new ApiClient();
  var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    List<MenuItem> sideMenuItems = [];

    return Container(
      color: light,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(width: _width / 48),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image.asset("assets/icons/logo.png"),
                    ),
                    Flexible(
                      child: CustomText(
                        text: "PerfectBeta",
                        size: 20,
                        weight: FontWeight.bold,
                        color: active,
                      ),
                    ),
                    Flexible(
                      child: FutureBuilder(
                          future: secStore.getAccessLevel(),
                          initialData: "Loading ...",
                          builder: (BuildContext context,
                              AsyncSnapshot<String> text) {
                            if (text.hasError) return Container();
                            return CustomText(
                              text: text.data.capitalize,
                              size: 14,
                              weight: FontWeight.bold,
                              color: lightGrey,
                            );
                          }),
                    ),
                    SizedBox(width: _width / 48),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          Divider(
            color: lightGrey.withOpacity(.1),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FutureBuilder<List<MenuItem>>(
                  future: getsideMenuItemRoutes(),
                  builder: (BuildContext context, menuItems) {
                    if (menuItems.hasData) {
                      sideMenuItems = menuItems.data;
                      return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: sideMenuItems.isNotEmpty
                              ? sideMenuItems
                                  .map<Widget>((item) => SideMenuItem(
                                      itemName: item.name,
                                      onTap: () {
                                        if (item.route ==
                                            authenticationPageRoute) {
                                           _authenticationEndpoint.logout();
                                          Get.offAllNamed(
                                              authenticationPageRoute);
                                          menuController.changeActiveItemTo(
                                              overviewPageDisplayName);
                                        }
                                        if (item.route ==
                                            registrationPageRoute) {
                                          Get.offAllNamed(
                                              registrationPageRoute);
                                          menuController.changeActiveItemTo(
                                              overviewPageDisplayName);
                                        }
                                        if (!menuController
                                            .isActive(item.name)) {
                                          menuController
                                              .changeActiveItemTo(item.name);
                                          if (ResponsiveWidget.isSmallScreen(
                                              context)) Get.back();
                                          navigationController
                                              .navigateTo(item.route);
                                        }
                                      }))
                                  .toList()
                              : []);
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }
}
