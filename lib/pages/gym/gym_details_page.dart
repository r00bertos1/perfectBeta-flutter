import 'package:flutter/material.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/widgets/all_gym_details_routes.dart';
import 'package:perfectBeta/pages/gym/widgets/gym_details_routes.dart';
import 'package:perfectBeta/pages/route/my_routes/widgets/my_routes_table.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:get/get.dart';

class GymDetailsPage extends StatelessWidget {
  final int gymId;
  final String gymName;
  GymDetailsPage({Key key, this.gymId, this.gymName}) : super(key: key);

  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 100 : 10,
                      bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 20),
                  child: CustomText(
                    //Gym name
                    text: gymName,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
          Expanded(
            child: FutureBuilder(
                future: secStore.getAccessLevel(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container();
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        switch (snapshot.data) {
                          case 'ADMIN':
                            return AllGymDetailsRoutes();
                          case 'MANAGER':
                            return GymDetailsRoutes();
                          case 'CLIMBER':
                            return GymDetailsRoutes();
                          default:
                            return GymDetailsRoutes();
                        }
                  }
                }),
          )
        ],
      ),
    );
  }
}
