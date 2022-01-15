import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/access_levels.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:get/get.dart';

class AccessLevelController extends GetxController {
  static AccessLevelController instance = Get.find();
  var activeItem = overviewPageDisplayName.obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case adminDisplayName:
        return _customIcon(Icons.admin_panel_settings, itemName);
      case managerDisplayName:
        return _customIcon(Icons.verified_user, itemName);
      case climberDisplayName:
        return _customIcon(Icons.account_circle, itemName);
      default:
        return Container();
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: dark);

    return Icon(
      icon,
      color: isHovering(itemName) ? dark : lightGrey,
    );
  }
}
