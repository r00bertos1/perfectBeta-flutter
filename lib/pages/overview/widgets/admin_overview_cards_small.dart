import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'info_card_small.dart';
import 'package:perfectBeta/helpers/helper_data_methods.dart';

class AdminOverviewCardsSmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _registeredUsers;
    int _admins;
    int _managers;
    int _climbers;
    List<int> userCount = [0,0,0,0];

    return Container(
        height: 400,
        child: FutureBuilder(
            future: loadUsersData(userCount),
            builder: (context, usersData) {
                switch (usersData.connectionState) {
                  case ConnectionState.waiting:
                    return Column(
                      children: [
                        InfoCardSmall(
                          title: "Registered users",
                          value: Center(
                            child: new CircularProgressIndicator(),
                          ),
                          onTap: () {},
                          isActive: true,
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Climbers",
                          value: Center(
                            child: new CircularProgressIndicator(),
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Managers",
                          value: Center(
                            child: new CircularProgressIndicator(),
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Admins",
                          value: Center(
                            child: new CircularProgressIndicator(),
                          ),
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
                      return Column(
                        children: [
                          InfoCardSmall(
                            title: "Registered users",
                            value: CustomText(
                                text: '$_registeredUsers',
                                size: 24,
                                weight: FontWeight.bold,
                                color: active),
                            onTap: () {},
                            isActive: true,
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Climbers",
                            value: CustomText(
                                text: '$_climbers',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Managers",
                            value: CustomText(
                                text: '$_managers',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Admins",
                            value: CustomText(
                                text: '$_admins',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                        ],
                      );
                }
            }));
  }
}
