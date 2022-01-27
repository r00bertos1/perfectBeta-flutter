import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../info_card_small.dart';
import 'package:perfectBeta/helpers/helper_data_methods.dart';

class OverviewCardsSmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _gyms;
    int _routes;
    List<int> gymRouteCount = [0,0];

    return Container(
        height: 400,
        child: FutureBuilder(
            future: loadGymsAndRoutesData(gymRouteCount),
            builder: (context, gymRouteData) {
                switch (gymRouteData.connectionState) {
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
                      ],
                    );
                  default:
                    if (gymRouteData.hasError)
                      return new Text('Error: ${gymRouteData.error}');
                    else
                      _gyms = gymRouteData.data[0];
                    _routes = gymRouteData.data[1];
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
                        ],
                      );
                }
            }));
  }
}
