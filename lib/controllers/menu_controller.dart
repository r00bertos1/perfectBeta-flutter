import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
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
      case overviewPageDisplayName:
        return _customIcon(Icons.trending_up, itemName);
      case gymsPageDisplayName:
      case allGymsPageDisplayName:
        return _customIcon(Icons.fitness_center, itemName);
      case authenticationPageDisplayName:
        return _customIcon(Icons.logout, itemName);
      case authenticationPageAnonimDisplayName:
        return _customIcon(Icons.login, itemName);
      case registrationPageDisplayName:
        return _customIcon(Icons.app_registration, itemName);
      case myRoutesPageDisplayName:
        return _customIcon(Icons.alt_route, itemName);
        //return _customIcon(Icons.alt_route, itemName);
      case addRoutePageDisplayName:
        return _customIcon(Icons.add, itemName);
      case registerGymPageDisplayName:
        return _customIcon(Icons.add_business, itemName);
      case registerManagerPageDisplayName:
        return _customIcon(Icons.manage_accounts, itemName);
      case usersPageDisplayName:
        return _customIcon(Icons.people, itemName);
      default:
        return _customIcon(Icons.list, itemName);
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
