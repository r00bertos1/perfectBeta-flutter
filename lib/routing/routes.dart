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

//ADMIN + MANAGER
const usersPageDisplayName = "Users";
const usersPageRoute = "/users";


class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

Future<List<MenuItem>> getsideMenuItemRoutes() async {
  List<MenuItem> sideMenuItemRoutes = [];
  final accessLevel = await secStore.getAccessLevel();
  if (accessLevel == 'CLIMBER') {
    sideMenuItemRoutes = [
      MenuItem(overviewPageDisplayName, overviewPageRoute),
      MenuItem(gymsPageDisplayName, gymsPageRoute),
      MenuItem(myRoutesPageDisplayName, myRoutesPageRoute),
      MenuItem(authenticationPageDisplayName, authenticationPageRoute),
    ];
  } else if (accessLevel == 'MANAGER') {
    sideMenuItemRoutes = [
      MenuItem(overviewPageDisplayName, overviewPageRoute),
      MenuItem(gymsPageDisplayName, managerGymsPageRoute),
      MenuItem(usersPageDisplayName, usersPageRoute),
      MenuItem(addRoutePageDisplayName, addRoutePageRoute),
      MenuItem(registerGymPageDisplayName, registerGymPageRoute),
      MenuItem(authenticationPageDisplayName, authenticationPageRoute),
    ];
  } else if (accessLevel == 'ADMIN') {
    sideMenuItemRoutes = [
      MenuItem(overviewPageDisplayName, overviewPageRoute),
      MenuItem(allGymsPageDisplayName, allGymsPageRoute),
      MenuItem(usersPageDisplayName, usersPageRoute),
      MenuItem(registerManagerPageDisplayName, registerManagerPageRoute),
      MenuItem(authenticationPageDisplayName, authenticationPageRoute),
    ];
  } else {
    sideMenuItemRoutes = [
      MenuItem(overviewPageDisplayName, overviewPageRoute),
      MenuItem(gymsPageDisplayName, gymsPageRoute),
      MenuItem(registrationPageDisplayName, registrationPageRoute),
      MenuItem(authenticationPageAnonimDisplayName, authenticationPageRoute),
    ];
  }

  return sideMenuItemRoutes;
}