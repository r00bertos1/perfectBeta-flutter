import 'package:flutter/cupertino.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/routing/router.dart';
import 'package:perfectBeta/routing/routes.dart';

Navigator localNavigator() =>   Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: overviewPageRoute,
    );



