import 'package:perfectBeta/storage/secure_storage.dart';

const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const gymsPageDisplayName = "Gyms";
const gymsPageRoute = "/gyms/verified/all";

const authenticationPageDisplayName = "Log out";
const authenticationPageAnonimDisplayName = "Log in";
const authenticationPageRoute = "/auth";

const userPersonalPageDisplayName = "User";
const userPersonalPageRoute = "/user";

const changeEmailPageRoute = "/user/change_email";

//ANONIM
const registrationPageDisplayName = "Register account";
const registrationPageRoute = "/register";

//CLIMBER
const myRoutesPageDisplayName = "My routes";
const myRoutesPageRoute = "/my-routes";

//MANAGER
const addRoutePageDisplayName = "Add route";
const addRoutePageRoute = "/add-route";

const ownedGymsPageRoute = "/gyms/owned_gyms";
const maintainedGymsPageRoute = "/gyms/maintained_gyms";
const managerGymsPageRoute = "/gyms/manager_gyms";

const registerGymPageDisplayName = "Register gym";
const registerGymPageRoute = "/gym/register";

//ADMIN
const registerManagerPageDisplayName = "Register manager";
const registerManagerPageRoute = "/managers/register";

const allGymsPageDisplayName = "Gyms";
const allGymsPageRoute = "/gyms/all";

const usersPageDisplayName = "All users";
const usersPageRoute = "/users";

const managersPageDisplayName = "Managers";
const managersPageRoute = "/managers";


class MyMenuItem {
  final String name;
  final String route;

  MyMenuItem(this.name, this.route);
}

Future<List<MyMenuItem>> getsideMenuItemRoutes() async {
  List<MyMenuItem> sideMenuItemRoutes = [];
  final accessLevel = await secStore.getAccessLevel();
  if (accessLevel == 'CLIMBER') {
    sideMenuItemRoutes = [
      MyMenuItem(overviewPageDisplayName, overviewPageRoute),
      MyMenuItem(gymsPageDisplayName, gymsPageRoute),
      MyMenuItem(myRoutesPageDisplayName, myRoutesPageRoute),
      MyMenuItem(authenticationPageDisplayName, authenticationPageRoute),
    ];
  } else if (accessLevel == 'MANAGER') {
    sideMenuItemRoutes = [
      MyMenuItem(overviewPageDisplayName, overviewPageRoute),
      MyMenuItem(gymsPageDisplayName, managerGymsPageRoute),
      MyMenuItem(addRoutePageDisplayName, addRoutePageRoute),
      MyMenuItem(registerGymPageDisplayName, registerGymPageRoute),
      MyMenuItem(authenticationPageDisplayName, authenticationPageRoute),
    ];
  } else if (accessLevel == 'ADMIN') {
    sideMenuItemRoutes = [
      MyMenuItem(overviewPageDisplayName, overviewPageRoute),
      MyMenuItem(allGymsPageDisplayName, allGymsPageRoute),
      MyMenuItem(usersPageDisplayName, usersPageRoute),
      MyMenuItem(managersPageDisplayName, managersPageRoute),
      MyMenuItem(registerManagerPageDisplayName, registerManagerPageRoute),
      MyMenuItem(authenticationPageDisplayName, authenticationPageRoute),
    ];
  } else {
    sideMenuItemRoutes = [
      MyMenuItem(overviewPageDisplayName, overviewPageRoute),
      MyMenuItem(gymsPageDisplayName, gymsPageRoute),
      MyMenuItem(registrationPageDisplayName, registrationPageRoute),
      MyMenuItem(authenticationPageAnonimDisplayName, authenticationPageRoute),
    ];
  }

  return sideMenuItemRoutes;
}