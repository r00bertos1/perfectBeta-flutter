import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:perfectBeta/pages/users/user.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'access_level_dropdown_menu.dart';
import 'custom_text.dart';

Map dropDownItemsMap;
List<DropdownMenuItem<int>> list = [];

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/icons/logo.png",
                    width: 28,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                key.currentState.openDrawer();
              }),
      title: Container(
        child: Row(
          children: [
            Visibility(
                visible: !ResponsiveWidget.isSmallScreen(context),
                child: CustomText(
                  text: "PerfectBeta",
                  color: lightGrey,
                  size: 20,
                  weight: FontWeight.bold,
                )),
          ],
        ),
      ),
      actions: [
        FutureBuilder<bool>(
            future: isAnonymous(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return _buildAnonimTopBar(context);
                } else {
                  return _buildUserTopBar(context);
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
      ],
      iconTheme: IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );

Future<bool> isAnonymous() async {
  final anonymousCheckValue = await secStore.secureRead('isAnonymous');
  if (anonymousCheckValue == 'true') {
    return true;
  }
  return false;
}

Widget _buildAnonimTopBar(context) {
  return !kIsWeb
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(
                  Icons.login,
                  color: dark,
                ),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationPage()),
                    )),
            SizedBox(
              width: 16,
            ),
          ],
        )
      : Container();
}

Widget _buildUserTopBar(context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 50,
      ),
      AccessLevelDropdownMenu(),
      SizedBox(
        width: 16,
      ),
      Container(
        width: 1,
        height: 22,
        color: lightGrey,
      ),
      SizedBox(
        width: 24,
      ),
      Container(
        width: 80,
        alignment: Alignment.centerRight,
        child: FutureBuilder(
            future: secStore.getUsername(),
            initialData: "Username",
            builder: (BuildContext context, AsyncSnapshot<String> text) {
              if (text.hasError) {
                return Container();
              } else if (text.hasData) {
                return CustomText(
                  text: text.data,
                  color: lightGrey,
                  weight: FontWeight.bold,
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      SizedBox(
        width: 16,
      ),
      InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: active.withOpacity(.5),
              borderRadius: BorderRadius.circular(30)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(2),
            child: CircleAvatar(
              backgroundColor: light,
              child: Icon(
                Icons.person_outline,
                color: dark,
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 16,
      ),
    ],
  );
}
