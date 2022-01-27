import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/pages/route/my_routes/my_routes_page.dart';
import 'package:perfectBeta/service.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../gym_details.dart';

/// Example without datasource
class GymsGrid extends StatelessWidget {
  final numbers = List.generate(16, (index) => '$index');
  bool _added = false;
  // dynamic initializeApiClient(){
  //   ApiClient _client = new ApiClient();
  //   return ClimbingGymEndpoint(_client.init());
  // }
  // Dio _client = new Dio();

  static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  var _climbingGymEndpoint = new ClimbingGymEndpoint(_client.init());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataPage>(
        future: _climbingGymEndpoint.getVerifiedGyms(),
        builder: (context, snapshot) {
          print('Connection state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data.content.length,
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing:
                      ResponsiveWidget.isSmallScreen(context) ? 32 : 64,
                  mainAxisSpacing:
                      ResponsiveWidget.isSmallScreen(context) ? 32 : 64,
                  // childAspectRatio: MediaQuery.of(context).size.width /
                  //     (MediaQuery.of(context).size.height),
                  crossAxisCount: ResponsiveWidget.isSmallScreen(context)
                      ? 2
                      : ResponsiveWidget.isMediumScreen(context)
                          ? 3
                          : ResponsiveWidget.isLargeScreen(context)
                              ? 4
                              : 5,
                ),
                itemBuilder: (context, index) {
                  //return Text("${snapshot.data.content[index].gymName}");
                  //itemBuilder: (context, index) {
                  //final item = numbers[index];
                  return buildGymGridFromSnapshot(context, snapshot, index);
                },
              );
            } else {
              return Text("No data");
            }
          } else
            return SizedBox(child: Center(child: CircularProgressIndicator.adaptive()));
        });
  }

  void _onTileClicked(int index, int gymId, String gymName, context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GymDetails(gymId: gymId)),
    );
  }

  Widget buildGymGridFromSnapshot(context, snapshot, index) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: lightGrey.withOpacity(.1),
                  blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridTile(
            child: GestureDetector(
              onTap: () => _onTileClicked(index, snapshot.data.content[index].id, snapshot.data.content[index].gymName, context),
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/gym-template.jpg')),
            ),
            footer: GridTileBar(
              //contentPadding: const EdgeInsets.symmetric(horizontal: 32),
              title: Text("${snapshot.data.content[index].gymName}"),
              subtitle: Text('Wersalska 47/75, 90-001 Łódź'),
            ),
          ),
        ),
      );
}