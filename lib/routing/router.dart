import 'package:flutter/material.dart';
import 'package:perfectBeta/pages/authentication/registration.dart';
import 'package:perfectBeta/pages/gym/registration/gym_registration.dart';
import 'package:perfectBeta/pages/route/my_routes/my_routes.dart';
import 'package:perfectBeta/pages/gym/gyms.dart';
import 'package:perfectBeta/pages/overview/overview.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/pages/users/manager_registration.dart';
import 'package:perfectBeta/pages/users/all_users/all_users.dart';
import 'package:perfectBeta/pages/users/managers/managers.dart';
import 'package:perfectBeta/pages/users/user_info/change_email.dart';
import 'package:perfectBeta/pages/users/user_info/user.dart';
import 'package:perfectBeta/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case gymsPageRoute:
    case ownedGymsPageRoute:
    case maintainedGymsPageRoute:
    case managerGymsPageRoute:
    case allGymsPageRoute:
      return _getPageRoute(GymsPage());
    case userPersonalPageRoute:
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
    case usersPageRoute:
      return _getPageRoute(AllUsersPage());
    case managersPageRoute:
      return _getPageRoute(ManagersPage());
      case changeEmailPageRoute:
      return _getPageRoute(ChangeEmailPage());
    default:
      return _getPageRoute(OverviewPage());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}