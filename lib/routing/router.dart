import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/my_routes/my_routes.dart';
import 'package:flutter_web_dashboard/pages/gyms/gyms.dart';
import 'package:flutter_web_dashboard/pages/overview/overview.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case gymsPageRoute:
      return _getPageRoute(GymsPage());
    case myRoutesPageRoute:
      return _getPageRoute(MyRoutesPage());
    default:
      return _getPageRoute(OverviewPage());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}