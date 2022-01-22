import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/routes/route_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/pages/route/my_routes/my_routes_page.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/service.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'add_maintainer_to_gym.dart';
import 'edit_gym_details.dart';

class GymDetails extends StatelessWidget {
  final int gymId;
  bool _added = false;

  static ApiClient _client = new ApiClient();
  var _climbingGymEndpoint = new ClimbingGymEndpoint(_client.init());
  var _routeEndpoint = new RouteEndpoint(_client.init());
  var _userEndpoint = new UserEndpoint(_client.init());

  GymDetails({Key key, this.gymId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Change to FUturebuilder wirh visibility corresponding to access level
    return FutureBuilder(
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
                    return FutureBuilder<ClimbingGymWithDetailsDTO>(
                        future: _climbingGymEndpoint.getGymById(gymId),
                        builder: (context, snapshot) {
                          print(
                              'Connection state: ${snapshot.connectionState}');
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.hasData) {
                              return _buildGymDetailsListView(snapshot);
                            } else {
                              return Text("No data");
                            }
                          } else
                            return SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()));
                        });
                  case 'MANAGER':
                    return FutureBuilder<ClimbingGymWithDetailsDTO>(
                        future: _climbingGymEndpoint.getVerifiedGymById(gymId),
                        builder: (context, snapshot) {
                          print(
                              'Connection state: ${snapshot.connectionState}');
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.hasData) {
                              return _buildGymDetailsListViewManager(snapshot);
                            } else {
                              return Text("No data");
                            }
                          } else
                            return SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()));
                        });
                  case 'CLIMBER':
                    return Text('CLIMBER');
                  default:
                    return Text('default');
                }
          }
        });
  }

  void _onRouteClicked(int index, context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => MyRoutesPage()),
    // );
  }

  Widget _buildGymDetailsListView(snapshot) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: CustomText(
                text: snapshot.data.gymName,
                size: 24,
                weight: FontWeight.bold,
              ),
              subtitle: Text(
                  "${snapshot.data.gymDetailsDTO.street} ${snapshot.data.gymDetailsDTO.number}, ${snapshot.data.gymDetailsDTO.city}, ${snapshot.data.gymDetailsDTO.country}"),
              trailing: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // setState(() {
                  //   // Toggle light when tapped.
                  //   _added = !_added;
                  // });
                },
                child: Icon(_added ? Icons.favorite : Icons.favorite_border),
              ),
            ),
            CustomText(text: "${snapshot.data.gymDetailsDTO.description}"),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: active.withOpacity(.4), width: .5),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 6),
                      color: lightGrey.withOpacity(.1),
                      blurRadius: 12)
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 30, top: 30),
              //height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      CustomText(
                        text: "Routes",
                        color: lightGrey,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  //TODO: Change to table for admin
                  FutureBuilder<DataPage>(
                      future: _routeEndpoint.getAllGymRoutes(gymId),
                      builder: (context, snapshot) {
                        print('Connection state: ${snapshot.connectionState}');
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text("Error");
                          }
                          if (snapshot.hasData) {
                            return GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.content.length,
                              padding: const EdgeInsets.only(top: 20),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing:
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? 20
                                        : 64,
                                mainAxisSpacing:
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? 20
                                        : 64,
                                childAspectRatio: ((MediaQuery.of(context)
                                            .size
                                            .width) /
                                        (MediaQuery.of(context).size.height)) *
                                    1.4,
                                crossAxisCount: ResponsiveWidget.isSmallScreen(
                                        context)
                                    ? 2
                                    : ResponsiveWidget.isMediumScreen(context)
                                        ? 3
                                        : ResponsiveWidget.isLargeScreen(
                                                context)
                                            ? 4
                                            : 5,
                              ),
                              itemBuilder: (context, index) {
                                //return Text("${snapshot.data.content[index].gymName}");
                                //itemBuilder: (context, index) {
                                //final item = numbers[index];
                                return buildRouteGridFromSnapshot(
                                    context, snapshot, index);
                              },
                            );
                          } else {
                            return Text("No data");
                          }
                        } else
                          return SizedBox(
                              child:
                                  Center(child: CircularProgressIndicator()));
                      })
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildGymDetailsListViewManager(snapshot) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: CustomText(
                text: snapshot.data.gymName,
                size: 24,
                weight: FontWeight.bold,
              ),
              subtitle: Text(
                  "${snapshot.data.gymDetailsDTO.street} ${snapshot.data.gymDetailsDTO.number}, ${snapshot.data.gymDetailsDTO.city}, ${snapshot.data.gymDetailsDTO.country}"),
              trailing: FutureBuilder<int>(
                  future: _getCurrentUserId(),
                  builder: (context, userId) {
                    if (userId.hasError) {
                      return Container();
                    } else if (userId.hasData) {
                      return Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: [
                          Visibility(
                            visible: userId.data == snapshot.data.ownerId,
                            child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddMaintainerToGymPage(gymId: gymId),
                                    ),
                                  );
                                },
                                tooltip: 'add maintainer to gym',
                                icon: Icon(Icons.person_add)),
                          ),
                          Visibility(
                            visible: userId.data == snapshot.data.ownerId,
                            child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditGymDetailsPage(gymId: gymId),
                                    ),
                                  );
                                },
                                tooltip: 'edit gym details',
                                icon: Icon(Icons.edit)),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            CustomText(text: "${snapshot.data.gymDetailsDTO.description}"),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: active.withOpacity(.4), width: .5),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 6),
                      color: lightGrey.withOpacity(.1),
                      blurRadius: 12)
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 30, top: 30),
              //height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      CustomText(
                        text: "Routes",
                        color: lightGrey,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  FutureBuilder<List<RouteDTO>>(
                      future: _loadRoutes(gymId),
                      builder: (context, routes) {
                        print('Connection state: ${routes.connectionState}');
                        if (routes.connectionState == ConnectionState.done) {
                          if (routes.hasError) {
                            return Text("Error");
                          }
                          if (routes.hasData && routes.data != null) {
                            return Column(
                              children: [
                                GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: routes.data.length,
                                  padding: const EdgeInsets.only(top: 20),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing:
                                        ResponsiveWidget.isSmallScreen(context)
                                            ? 20
                                            : 64,
                                    mainAxisSpacing:
                                        ResponsiveWidget.isSmallScreen(context)
                                            ? 20
                                            : 64,
                                    childAspectRatio: ((MediaQuery.of(context)
                                                .size
                                                .width) /
                                            (MediaQuery.of(context).size.height)) *
                                        1.4,
                                    crossAxisCount: ResponsiveWidget.isSmallScreen(
                                            context)
                                        ? 2
                                        : ResponsiveWidget.isMediumScreen(context)
                                            ? 3
                                            : ResponsiveWidget.isLargeScreen(
                                                    context)
                                                ? 4
                                                : 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return buildRouteGridFromSnapshotManager(
                                        context, routes, index);
                                  },
                                ),
                                _buildAddRouteButton(context),
                              ],
                            );
                          } else {
                            return _buildAddRouteButton(context);
                          }
                        } else
                          return SizedBox(
                              child:
                                  Center(child: CircularProgressIndicator()));
                      })
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildRouteGridFromSnapshot(context, snapshot, index) => Container(
        child: GridTile(
          child: GestureDetector(
            onTap: () => _onRouteClicked(index, context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: snapshot.data.content[index].photos.length > 0
                      ? "${snapshot.data.content[index].photos[0].photoUrl}"
                      : "test",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: active,
                  ),
                  errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/images/route-template.jpg')),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      title: Text(
                        "${snapshot.data.content[index].routeName}",
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: RatingBarIndicator(
                        rating: snapshot.data.content[index].avgRating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        // itemCount: 5,
                        itemSize: 15.0,
                      ),
                      trailing: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // setState(() {
                          //   // Toggle light when tapped.
                          //   _added = !_added;
                          // });
                        },
                        child: Icon(
                            _added ? Icons.favorite : Icons.favorite_border),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildRouteGridFromSnapshotManager(context, routes, index) => Container(
        child: GridTile(
          child: GestureDetector(
            onTap: () => _onRouteClicked(index, context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: routes.data[index].photos.length > 0
                      ? "${routes.data[index].photos[0].photoUrl}"
                      : "test",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: active,
                  ),
                  errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/images/route-template.jpg')),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      title: Text(
                        "${routes.data[index].routeName}",
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: RatingBarIndicator(
                        rating: routes.data[index].avgRating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        // itemCount: 5,
                        itemSize: 15.0,
                      ),
                      trailing: Wrap(
                        //alignment: WrapAlignment.spaceBetween,
                        //direction: Axis.horizontal,
                        children: [
                          // IconButton(
                          //     iconSize: 18,
                          //     visualDensity: VisualDensity.compact,
                          //     padding: EdgeInsets.all(0),
                          //     onPressed: () {
                          //       //TODO: Edit route details
                          //       // Navigator.push(
                          //       //   context,
                          //       //   MaterialPageRoute(
                          //       //     builder: (context) =>
                          //       //         EditRouteDetailsPage(gymId: gymId),
                          //       //   ),
                          //       // );
                          //     },
                          //     tooltip: 'edit route details',
                          //     icon: Icon(Icons.edit)),
                          IconButton(
                              //iconSize: 18,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.all(0),
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Delete route'),
                                        content: const Text('Are you sure?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: CustomText(
                                                text: 'No',
                                                weight: FontWeight.w300,
                                                color: dark),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _handleRouteDelete(
                                                  context,
                                                  routes.data[index]
                                                      .climbingGymId,
                                                  routes.data[index].id);
                                            },
                                            child: CustomText(
                                                text: 'Yes, delete!',
                                                color: error),
                                          ),
                                        ],
                                      )),
                              tooltip: 'delete route',
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Future<int> _getCurrentUserId() async {
    try {
      UserWithPersonalDataAccessLevelDTO res =
          await _userEndpoint.getUserPersonalDataAccessLevel();
      return res.id;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<List<RouteDTO>> _loadRoutes(gymId) async {
    try {
      DataPage res = await _routeEndpoint.getAllGymRoutes(gymId);
      List<RouteDTO> routes = [];
      res.content.forEach((route) {
        routes.add(route);
      });
      return routes;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  _handleAddRoute(context, gymId) {
    menuController.changeActiveItemTo(addRoutePageDisplayName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRoutePage(gymId: gymId),
      ),
    );
  }

  _handleRouteDelete(context, gymId, routeId) async {
    try {
      var res = await _routeEndpoint.deleteRoute(gymId, routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Route removed!');
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

 Widget _buildAddRouteButton(context) {
    return InkWell(
      onTap: () => _handleAddRoute(context, gymId),
      child: Container(
        decoration: BoxDecoration(
            color: active,
            borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CustomText(
          text: "Add route",
          color: Colors.white,
        ),
      ),
    );
  }
}
