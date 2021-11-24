import 'package:flutter/material.dart';
import 'package:perfectBeta/helpers/local_navigator.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/large_screen.dart';
import 'package:perfectBeta/widgets/side_menu.dart';

import 'widgets/top_nav.dart';

class SiteLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
          largeScreen: LargeScreen(),
          hugeScreen: LargeScreen(),
          smallScreen: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: localNavigator(),
          )),
    );
  }
}
