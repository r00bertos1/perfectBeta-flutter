import 'package:flutter/material.dart';
import 'package:perfectBeta/helpers/data_functions.dart';
import 'package:perfectBeta/pages/overview/widgets/info_card.dart';

class ManagerOverviewCardsMediumScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _gyms;
    int _owned;
    int _maintained;
    int _routes;
    List<int> managerDataCount = [0,0,0,0];

   return FutureBuilder(
        future: loadGymsAndRoutesDataManager(managerDataCount),
        builder: (context, managerData) {
          switch (managerData.connectionState) {
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
                        title: "Routes in owned gyms",
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
                        title: "Owned gyms",
                        value: "-",
                        topColor: Colors.redAccent,
                        onTap: () {},
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      InfoCard(
                        title: "Maintained gyms",
                        value: "-",
                        onTap: () {},
                      ),
                    ],
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
                        title: "Routes in owned gyms",
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
                        title: "Owned gyms",
                        value: "$_owned",
                        topColor: Colors.redAccent,
                        onTap: () {},
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      InfoCard(
                        title: "Maintained gyms",
                        value: "$_maintained",
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
