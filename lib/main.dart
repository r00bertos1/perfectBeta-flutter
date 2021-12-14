import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/controllers/menu_controller.dart';
import 'package:perfectBeta/controllers/navigation_controller.dart';
import 'package:perfectBeta/layout.dart';
import 'package:perfectBeta/pages/404/error.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfectBeta/routing/http_overwrites.dart';

import 'routing/routes.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  Get.put(MenuController());
  Get.put(NavigationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: authenticationPageRoute,
        unknownRoute: GetPage(name: '/not-found', page: () => PageNotFound(), transition: Transition.fadeIn),
        getPages: [
        GetPage(name: rootRoute, page: () {
          return SiteLayout();
        }),
        GetPage(name: authenticationPageRoute, page: () => AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.black
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: active,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
        )),
        pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      }
    ),
        primarySwatch: Colors.teal,
      ),
      // home: AuthenticationPage(),
    );
  }
}
