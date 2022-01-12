import 'package:perfectBeta/storage/secure_storage.dart';

const adminDisplayName = "Admin";
const managerDisplayName = "Manager";
const climberDisplayName = "Climber";

class AccessLevelNameItem {
  final String name;

  AccessLevelNameItem(this.name);
}

Future<List<AccessLevelNameItem>> getAccessLevelMenuItemRoutes() async {
  List<AccessLevelNameItem> accessLevelMenuItemRoutes = [];
  final accessLevelsMap = await secStore.getAccessLevels();
  if (accessLevelsMap.containsKey('ADMIN') && accessLevelsMap["ADMIN"] == true) {
    accessLevelMenuItemRoutes.add(AccessLevelNameItem(adminDisplayName));
  }
  if (accessLevelsMap.containsKey('MANAGER') && accessLevelsMap["MANAGER"] == true) {
    accessLevelMenuItemRoutes.add(AccessLevelNameItem(managerDisplayName));
  }
  if (accessLevelsMap.containsKey('CLIMBER') && accessLevelsMap["CLIMBER"] == true) {
    accessLevelMenuItemRoutes.add(AccessLevelNameItem(climberDisplayName));
  }

  return accessLevelMenuItemRoutes;
}
