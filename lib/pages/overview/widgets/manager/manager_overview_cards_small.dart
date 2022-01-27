import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../info_card_small.dart';
import 'package:perfectBeta/helpers/helper_data_methods.dart';

class ManagerOverviewCardsSmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _gyms;
    int _owned;
    int _maintained;
    int _routes;
    List<int> managerDataCount = [0,0,0,0];

    return Container(
        height: 400,
        child: FutureBuilder(
            future: loadGymsAndRoutesDataManager(managerDataCount),
            builder: (context, managerData) {
                switch (managerData.connectionState) {
                  case ConnectionState.waiting:
                    return Column(
                      children: [
                        InfoCardSmall(
                          title: "Verified gyms",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                          isActive: true,
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Owned gyms",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Maintained gyms",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Routes in owned gyms",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                        ),
                      ],
                    );
                  default:
                    if (managerData.hasError)
                      return new Text('Error: ${managerData.error}');
                    else
                    _gyms = managerData.data[0];
                    _owned = managerData.data[1];
                    _maintained = managerData.data[2];
                    _routes = managerData.data[3];
                      return Column(
                        children: [
                          InfoCardSmall(
                            title: "Verified gyms",
                            value: CustomText(
                                text: '$_gyms',
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
                            title: "Owned gyms",
                            value: CustomText(
                                text: '$_owned',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Maintained gyms",
                            value: CustomText(
                                text: '$_maintained',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Routes in owned gyms",
                            value: CustomText(
                                text: '$_routes',
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
