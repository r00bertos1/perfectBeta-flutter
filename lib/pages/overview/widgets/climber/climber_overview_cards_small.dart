import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../info_card_small.dart';
import 'package:perfectBeta/helpers/helper_data_methods.dart';

class ClimberOverviewCardsSmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _gyms;
    int _routes;
    int _reviews;
    int _favs;
    List<int> climberDataCount = [0,0,0,0];

    return Container(
        height: 400,
        child: FutureBuilder(
            future: loadGymsAndRoutesDataClimber(climberDataCount),
            builder: (context, climberData) {
                switch (climberData.connectionState) {
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
                          title: "Routes",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Your reviews",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: _width / 64,
                        ),
                        InfoCardSmall(
                          title: "Liked routes",
                          value: Center(
                            child: new CircularProgressIndicator.adaptive(),
                          ),
                          onTap: () {},
                        ),
                      ],
                    );
                  default:
                    if (climberData.hasError)
                      return new Text('Error: ${climberData.error}');
                    else
                    _gyms = climberData.data[0];
                    _routes = climberData.data[1];
                    _reviews = climberData.data[2];
                    _favs = climberData.data[3];
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
                            title: "Routes",
                            value: CustomText(
                                text: '$_routes',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Your reviews",
                            value: CustomText(
                                text: '$_reviews',
                                size: 24,
                                weight: FontWeight.bold,
                                color: dark),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: _width / 64,
                          ),
                          InfoCardSmall(
                            title: "Liked routes",
                            value: CustomText(
                                text: '$_favs',
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
