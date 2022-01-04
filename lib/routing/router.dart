import 'package:flutter/material.dart';
import 'package:perfectBeta/pages/my_routes/my_routes_page.dart';
import 'package:perfectBeta/pages/gyms/gyms_page.dart';
import 'package:perfectBeta/pages/overview/overview.dart';
import 'package:perfectBeta/pages/add_route/add_route.dart';
import 'package:perfectBeta/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case gymsPageRoute:
      return _getPageRoute(GymsPage());
    case myRoutesPageRoute:
      return _getPageRoute(MyRoutesPage());
    case addRoutePageRoute:
      return _getPageRoute(AddRoutePage());
    default:
      return _getPageRoute(OverviewPage());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}