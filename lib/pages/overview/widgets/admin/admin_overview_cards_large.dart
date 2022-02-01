import 'package:flutter/material.dart';
import 'package:perfectBeta/helpers/data_functions.dart';
import 'package:perfectBeta/pages/overview/widgets/info_card.dart';

class AdminOverviewCardsLargeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _registeredUsers;
    int _admins;
    int _managers;
    int _climbers;
    List<int> userCount = [0,0,0,0];

    return FutureBuilder(
        future: loadUsersData(userCount),
        builder: (context, usersData) {
          switch (usersData.connectionState) {
            case ConnectionState.waiting:
              return Row(
                children: [
                  InfoCard(
                    title: "Active users",
                    value: "-",
                    onTap: () {},
                    topColor: Colors.orange,
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Climbers",
                    value: "-",
                    topColor: Colors.lightGreen,
                    onTap: () {},
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Managers",
                    value: "-",
                    topColor: Colors.redAccent,
                    onTap: () {},
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Admins",
                    value: "-",
                    onTap: () {},
                  ),
                ],
              );
            default:
              if (usersData.hasError)
                return new Text('Error: ${usersData.error}');
              else
                _registeredUsers = usersData.data[0];
              _admins = usersData.data[1];
              _managers = usersData.data[2];
              _climbers = usersData.data[3];
              return Row(
                children: [
                  InfoCard(
                    title: "Active users",
                    value: "$_registeredUsers",
                    onTap: () {},
                    topColor: Colors.orange,
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Climbers",
                    value: "$_climbers",
                    topColor: Colors.lightGreen,
                    onTap: () {},
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Managers",
                    value: "$_managers",
                    topColor: Colors.redAccent,
                    onTap: () {},
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Admins",
                    value: "$_admins",
                    onTap: () {},
                  ),
                ],
              );
          }
        });
  }
}
