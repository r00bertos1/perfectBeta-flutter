const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const gymsPageDisplayName = "Gyms";
const gymsPageRoute = "/gyms";

const myRoutesPageDisplayName = "My routes";
const myRoutesPageRoute = "/my-routes";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}



List<MenuItem> sideMenuItemRoutes = [
 MenuItem(overviewPageDisplayName, overviewPageRoute),
 MenuItem(gymsPageDisplayName, gymsPageRoute),
 MenuItem(myRoutesPageDisplayName, myRoutesPageRoute),
 MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
