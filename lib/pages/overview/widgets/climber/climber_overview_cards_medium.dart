import 'package:flutter/material.dart';
import 'package:perfectBeta/helpers/helper_data_methods.dart';
import 'package:perfectBeta/pages/overview/widgets/info_card.dart';

class ClimberOverviewCardsMediumScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _gyms;
    int _routes;
    int _reviews;
    int _favs;
    List<int> climberDataCount = [0,0,0,0];

   return FutureBuilder(
        future: loadGymsAndRoutesDataClimber(climberDataCount),
        builder: (context, climberData) {
          switch (climberData.connectionState) {
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
                  SizedBox(
                    height: _width / 64,
                  ),
                  Row(
                    children: [
                      InfoCard(
                        title: "Your reviews",
                        value: "-",
                        topColor: Colors.redAccent,
                        onTap: () {},
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      InfoCard(
                        title: "Liked routes",
                        value: "-",
                        onTap: () {},
                      ),
                    ],
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
                  SizedBox(
                    height: _width / 64,
                  ),
                  Row(
                    children: [
                      InfoCard(
                        title: "Your reviews",
                        value: "$_reviews",
                        topColor: Colors.redAccent,
                        onTap: () {},
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      InfoCard(
                        title: "Liked routes",
                        value: "$_favs",
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
