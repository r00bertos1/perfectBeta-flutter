import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/access_levels.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:get/get.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'access_level_menu_item.dart';
import 'custom_text.dart';

class AccessLevelDropdownMenu extends StatefulWidget {
  const AccessLevelDropdownMenu({Key key}) : super(key: key);

  @override
  _AccessLevelDropdownMenu createState() => _AccessLevelDropdownMenu();
}

class _AccessLevelDropdownMenu extends State<AccessLevelDropdownMenu> {
  String selectedAccessLevel;
  String valueAccessLevel;
  String newAccessLevel;
  List<AccessLevelNameItem> accessLevelsList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final accessLevel = await secStore.getAccessLevel() ?? '';
    final levelsList = await getAccessLevelMenuItemRoutes();
    setState(() {
      this.selectedAccessLevel = accessLevel;
      this.accessLevelsList = levelsList;
    });
  }

  @override
  Widget build(BuildContext context) {
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: valueAccessLevel,
                  alignment: Alignment.center,
                  items: accessLevelsList
                      .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                                value: value.name,
                                child: AccessLevelMenuItem(
                                    itemName: value.name, onTap: null),
                              ))
                      .toList() ?? [],
                  hint: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: accessLevelController
                            .returnIconFor(selectedAccessLevel.capitalize),
                      ),
                      CustomText(
                        text: selectedAccessLevel.capitalize ?? '',
                        color: accessLevelsList.length > 1 ? dark : lightGrey,
                        //size: 18,
                        weight:  accessLevelsList.length > 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ],
                  ),
                  onChanged: accessLevelsList.length > 1 ? (newAccessLevelValue) {
                      if (valueAccessLevel != newAccessLevelValue) {
                        setState(() {
                          valueAccessLevel = newAccessLevelValue;
                          this.newAccessLevel = valueAccessLevel.toUpperCase();
                          _handleOnChangedAccessLevel(newAccessLevelValue);
                          secStore.changeAccessLevel(newAccessLevel);
                        });
                      }
                  } : null),
            );
  }

  _handleOnChangedAccessLevel(value) {
    if (value == adminDisplayName) {
      accessLevelController.changeActiveItemTo(adminDisplayName);
    }
    if (value == managerDisplayName) {
      accessLevelController.changeActiveItemTo(managerDisplayName);
    }
    if (value == climberDisplayName) {
      accessLevelController.changeActiveItemTo(climberDisplayName);
    }
    if (accessLevelController.isActive(value)) {
      accessLevelController.changeActiveItemTo(value);
      //Get.offAllNamed(rootRoute);
      //menuController.changeActiveItemTo(overviewPageDisplayName);
    }
  }
}
