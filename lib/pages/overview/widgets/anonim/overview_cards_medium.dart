import 'package:flutter/material.dart';
import 'package:perfectBeta/helpers/helper_data_methods.dart';
import 'package:perfectBeta/pages/overview/widgets/info_card.dart';

class OverviewCardsMediumScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _gyms;
    int _routes;
    List<int> gymRouteCount = [0,0];

   return FutureBuilder(
        future: loadGymsAndRoutesData(gymRouteCount),
        builder: (context, gymRouteData) {
          switch (gymRouteData.connectionState) {
            case ConnectionState.waiting:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InfoCard(
                        title: "Verified gyms",
                        value: "-",
                        onTap: () {},
                        topColor: Colors.orange,
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      InfoCard(
                        title: "Routes",
                        value: "-",
                        topColor: Colors.lightGreen,
                        onTap: () {},
                      ),
                    ],
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InfoCard(
                        title: "Verified gyms",
                        value: "$_gyms",
                        onTap: () {},
                        topColor: Colors.orange,
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      InfoCard(
                        title: "Routes",
                        value: "$_routes",
                        topColor: Colors.lightGreen,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              );
          }
        });
  }
}
