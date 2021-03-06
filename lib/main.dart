import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/controllers/access_level_controller.dart';
import 'package:perfectBeta/controllers/menu_controller.dart';
import 'package:perfectBeta/controllers/navigation_controller.dart';
import 'package:perfectBeta/layout.dart';
import 'package:perfectBeta/pages/404/error.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfectBeta/pages/authentication/registration.dart';
import 'package:perfectBeta/routing/http_overwrites.dart';
import 'routing/routes.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  HttpOverrides.global = MyHttpOverrides();
  getIt.registerLazySingleton<Dio>(() => ApiClient().init());
  Get.put(MenuController());
  Get.put(NavigationController());
  Get.put(AccessLevelController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      initialRoute: authenticationPageRoute,
      unknownRoute: GetPage(name: '/not-found', page: () => PageNotFound(), transition: Transition.fadeIn),
      getPages: [
        GetPage(
            name: rootRoute,
            page: () {
              return SiteLayout();
            }),
        GetPage(name: authenticationPageRoute, page: () => AuthenticationPage()),
        GetPage(name: registrationPageRoute, page: () => RegistrationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
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
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.teal,
      ),
    );
  }
}
