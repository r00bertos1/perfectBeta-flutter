import 'package:flutter/material.dart';
import 'package:perfectBeta/pages/authentication/registration.dart';
import 'package:perfectBeta/pages/gym/all_gyms_page.dart';
import 'package:perfectBeta/pages/gym/gym_registration_page.dart';
import 'package:perfectBeta/pages/route/my_routes/my_routes_page.dart';
import 'package:perfectBeta/pages/gym/gyms_page.dart';
import 'package:perfectBeta/pages/overview/overview.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/pages/users/manager_registration_page.dart';
import 'package:perfectBeta/pages/users/all_users_page.dart';
import 'package:perfectBeta/pages/users/user_page.dart';
import 'package:perfectBeta/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case gymsPageRoute:
    case ownedGymsPageRoute:
    case maintainedGymsPageRoute:
    case managerGymsPageRoute:
      return _getPageRoute(GymsPage());
    case usersPageRoute:
      return _getPageRoute(UserPage());
    case registrationPageRoute:
      return _getPageRoute(RegistrationPage());
    case myRoutesPageRoute:
      return _getPageRoute(MyRoutesPage());
    case addRoutePageRoute:
      return _getPageRoute(AddRoutePage());
    case registerGymPageRoute:
      return _getPageRoute(GymRegistrationPage());
    case registerManagerPageRoute:
      return _getPageRoute(ManagerRegistrationPage());
    case allGymsPageRoute:
      return _getPageRoute(AllGymsPage());
    case usersPageRoute:
      return _getPageRoute(AllUsersPage());
    default:
      return _getPageRoute(OverviewPage());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}