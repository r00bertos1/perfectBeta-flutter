import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/routes/route_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/gym/widgets/favourite_button.dart';
import 'package:perfectBeta/pages/gym/widgets/status_switch_button.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/pages/route/route_details.dart';
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

class GymDetails extends StatefulWidget {
  final int gymId;
  static ApiClient _client = new ApiClient();

  GymDetails({Key key, this.gymId}) : super(key: key);

  @override
  State<GymDetails> createState() => _GymDetailsState();
}

class _GymDetailsState extends State<GymDetails> {
  bool _added = false;
  bool _isVerified = false;
  int _currentUserId;

  var _climbingGymEndpoint = new ClimbingGymEndpoint(GymDetails._client.init());
  var _routeEndpoint = new RouteEndpoint(GymDetails._client.init());
  var _userEndpoint = new UserEndpoint(GymDetails._client.init());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        future: _climbingGymEndpoint.getGymById(widget.gymId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.hasData) {
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child:
                                      _buildGymDetailsListViewAdmin(snapshot, context));
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
                        future: _climbingGymEndpoint
                            .getVerifiedGymById(widget.gymId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.hasData) {
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildGymDetailsListViewManager(
                                      snapshot, context));
                            } else {
                              return Text("No data");
                            }
                          } else
                            return SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()));
                        });
                  case 'CLIMBER':
                    return FutureBuilder<ClimbingGymWithDetailsDTO>(
                        future: _climbingGymEndpoint
                            .getVerifiedGymById(widget.gymId),
                        builder: (context, snapshot) {
                          // print(
                          //     'Connection state: ${snapshot.connectionState}');
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.hasData) {
                              return RefreshIndicator(
                                // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildGymDetailsListViewClimber(snapshot, context));
                            } else {
                              return Text("No data");
                            }
                          } else
                            return SizedBox(
                                child:
                                Center(child: CircularProgressIndicator()));
                        });
                  default:
                    return FutureBuilder<ClimbingGymWithDetailsDTO>(
                        future: _climbingGymEndpoint
                            .getVerifiedGymById(widget.gymId),
                        builder: (context, snapshot) {
                          // print(
                          //     'Connection state: ${snapshot.connectionState}');
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.hasData) {
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildGymDetailsListView(snapshot, context));
                            } else {
                              return Text("No data");
                            }
                          } else
                            return SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()));
                        });
                }
          }
        });
  }

  Widget _buildGymDetailsListViewAdmin(
      AsyncSnapshot<ClimbingGymWithDetailsDTO> snapshot, context) {
    _isVerified = snapshot.data.status == GymStatusEnum.VERIFIED ? true : false;
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              isThreeLine: true,
              title: _gymTitleWidget(snapshot),
              subtitle: _gymSubtitleWidget(snapshot),
              trailing: _gymTrailingWidgetAdmin(snapshot, context),
            ),
            SizedBox(
              height: 10,
            ),
            _gymDescriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            _gymRoutesWidget(snapshot, context),

          ],
        ),
      ],
    );
  }

  Widget _buildGymDetailsListViewManager(
      AsyncSnapshot<ClimbingGymWithDetailsDTO> snapshot, context) {
    _isVerified = snapshot.data.status == GymStatusEnum.VERIFIED ? true : false;
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              isThreeLine: true,
              title: _gymTitleWidget(snapshot),
              subtitle: _gymSubtitleWidget(snapshot),
              trailing: _gymTrailingWidgetManager(snapshot, context),
            ),
            SizedBox(
              height: 10,
            ),
            _gymDescriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            _gymRoutesWidgetManager(snapshot, context),

          ],
        ),
      ],
    );
  }

  Widget _buildGymDetailsListView(
      AsyncSnapshot<ClimbingGymWithDetailsDTO> snapshot, context) {
    _isVerified = snapshot.data.status == GymStatusEnum.VERIFIED ? true : false;
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              isThreeLine: true,
              title: _gymTitleWidget(snapshot),
              subtitle: _gymSubtitleWidget(snapshot),
            ),
            SizedBox(
              height: 10,
            ),
            _gymDescriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            _gymRoutesWidget(snapshot, context),

          ],
        ),
      ],
    );
  }

  Widget _buildGymDetailsListViewClimber(
      AsyncSnapshot<ClimbingGymWithDetailsDTO> snapshot, context) {
    _isVerified = snapshot.data.status == GymStatusEnum.VERIFIED ? true : false;
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              isThreeLine: true,
              title: _gymTitleWidget(snapshot),
              subtitle: _gymSubtitleWidget(snapshot),
            ),
            SizedBox(
              height: 10,
            ),
            _gymDescriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            _gymRoutesWidgetClimber(snapshot, context),

          ],
        ),
      ],
    );
  }

  Widget buildRouteGridFromSnapshot(
      context, AsyncSnapshot<List<RouteDTO>> routes, index) {
    String cover = routes.data[index].photos.length > 0
        ? routes.data[index].photos[0].photoUrl
        : "";
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () => _onRouteClicked(routes.data[index].climbingGymId,
                routes.data[index].id, _currentUserId, context),
            child: CachedNetworkImage(
              imageUrl: cover,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  SizedBox(child: Center(child: CircularProgressIndicator())),
              //height: 120,
              errorWidget: (context, url, error) =>
                  Image(image: AssetImage('assets/images/route-template.jpg')),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            //contentPadding: const EdgeInsets.symmetric(horizontal: 32),
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
              itemSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRouteGridFromSnapshotManager(
      context, AsyncSnapshot<List<RouteDTO>> routes, index) {
    String cover = routes.data[index].photos.length > 0
        ? routes.data[index].photos[0].photoUrl
        : "";
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () => _onRouteClicked(routes.data[index].climbingGymId,
                routes.data[index].id, _currentUserId, context),
            child: CachedNetworkImage(
              imageUrl: cover,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  SizedBox(child: Center(child: CircularProgressIndicator())),
              //height: 150,
              errorWidget: (context, url, error) =>
                  Image(image: AssetImage('assets/images/route-template.jpg')),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            //contentPadding: const EdgeInsets.symmetric(horizontal: 32),
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
              itemSize: 14.0,
            ),
            trailing: IconButton(
                //iconSize: 18,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.all(0),
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text('Delete route'),
                          content: const Text('Are you sure?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: CustomText(
                                  text: 'No',
                                  weight: FontWeight.w300,
                                  color: dark),
                            ),
                            TextButton(
                              onPressed: () {
                                _handleRouteDelete(
                                    context,
                                    routes.data[index].climbingGymId,
                                    routes.data[index].id);
                              },
                              child: CustomText(
                                  text: 'Yes, delete!', color: error),
                            ),
                          ],
                        )),
                tooltip: 'delete route',
                icon: Icon(Icons.delete)),
          ),
        ),
      ),
    );
  }

  Widget buildRouteGridFromSnapshotClimber(
      context, AsyncSnapshot<List<RouteDTO>> routes, index) {
    String cover = routes.data[index].photos.length > 0
        ? routes.data[index].photos[0].photoUrl
        : "";
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () => _onRouteClicked(routes.data[index].climbingGymId,
                routes.data[index].id, _currentUserId, context),
            child: CachedNetworkImage(
              imageUrl: cover,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  SizedBox(child: Center(child: CircularProgressIndicator())),
              //height: 150,
              errorWidget: (context, url, error) =>
                  Image(image: AssetImage('assets/images/route-template.jpg')),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            //contentPadding: const EdgeInsets.symmetric(horizontal: 32),
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
              itemSize: 14.0,
            ),
            trailing: FutureBuilder<bool>(
                future: _isFavourited(routes.data[index].id),
                builder: (context, boolVal) {
                  if (boolVal.connectionState == ConnectionState.done) {
                    if (boolVal.hasError) {
                      return Text("Error");
                    }
                    if (boolVal.hasData) {
                      _added = boolVal.data;
                      return FavouriteButton(
                          isAdded: _added,
                          onPressed: () {
                            handleAddFavourite(routes.data[index].id, _added);
                          });
                    } else {
                      return SizedBox(width: 1);
                    }
                  } else
                    return SizedBox(width: 1);
                }),
          ),
        ),
      ),
    );
  }

  Future<bool> _isFavourited(int routeId) async {
    try {
      DataPage res = await _routeEndpoint.getAllFavourites();
      bool _isInFavourites = false;
      if (res.content != null) {
        res.content.forEach((route) {
          if (route.id == routeId) {
            _isInFavourites = true;
          }
        });
      }
      return _isInFavourites;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<int> _getCurrentUserId() async {
    try {
      UserWithPersonalDataAccessLevelDTO res =
          await _userEndpoint.getUserPersonalDataAccessLevel();
      _currentUserId = res.id;
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
      if (res.content != null) {
        res.content.forEach((route) {
          routes.add(route);
        });
      }
      return routes;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  void _onRouteClicked(int gymId, int routeId, int currentUserId, context) {
    print('CURRENT USER ' + currentUserId.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RouteDetailsPage(
                gymId: gymId,
                routeId: routeId,
                currentUserId: currentUserId,
              )),
    );
  }

  void _handleAddRoute(context, gymId) {
    menuController.changeActiveItemTo(addRoutePageDisplayName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRoutePage(gymId: gymId),
      ),
    );
  }

  void _handleRouteDelete(context, gymId, routeId) async {
    try {
      var res = await _routeEndpoint.deleteRoute(gymId, routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Route removed!');
        Navigator.pop(context);
        setState(() {});
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Widget _buildAddRouteButton(context) {
    return InkWell(
      onTap: () => _handleAddRoute(context, widget.gymId),
      child: Container(
        decoration: BoxDecoration(
            color: active, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 18,
              color: Colors.white,
            ),
            CustomText(
              text: "Add",
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void handleGymStatus(status, gymId) async {
    if (status == GymStatusEnum.UNVERIFIED || status == GymStatusEnum.CLOSED) {
      ClimbingGymDTO res = await _climbingGymEndpoint.verifyGym(gymId);
      if (res.status == GymStatusEnum.VERIFIED) {
        setState(() {
          _isVerified = res.status == GymStatusEnum.VERIFIED ? true : false;
        });
      }
    } else if (status == GymStatusEnum.VERIFIED) {
      ClimbingGymDTO res = await _climbingGymEndpoint.closeGym(gymId);
      if (res.status == GymStatusEnum.CLOSED) {
        setState(() {
          _isVerified = res.status == GymStatusEnum.CLOSED ? false : true;
        });
      }
    }
  }

  void handleAddFavourite(routeId, added) async {
    if (added) {
      var res = await _routeEndpoint.removeRouteFromFavourites(routeId);
      if (res != null) {
        if (res.statusCode == 200) {
          setState(() {
            _added = !_added;
          });
        }
      }
    } else {
      var res = await _routeEndpoint.addRouteToFavourites(routeId);
      if (res != null) {
        if (res.statusCode == 200) {
          setState(() {
            _added = !_added;
          });
        }
      }
    }
  }

  Widget _parseGymEnum(data) {
    switch (data) {
      case GymStatusEnum.UNVERIFIED:
        return CustomText(text: "Unverified", color: Colors.amberAccent);
      case GymStatusEnum.VERIFIED:
        return CustomText(text: "Verified", color: active);
      case GymStatusEnum.CLOSED:
        return CustomText(text: "Closed", color: error);
    }
  }

  Widget _gymTitleWidget(snapshot) => CustomText(
    text: snapshot.data.gymName,
    size: 24,
    weight: FontWeight.bold,
  );

  Widget _gymSubtitleWidget(snapshot) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
          "${snapshot.data.gymDetailsDTO.street} ${snapshot.data.gymDetailsDTO.number}, ${snapshot.data.gymDetailsDTO.city}, ${snapshot.data.gymDetailsDTO.country}"),
      _parseGymEnum(snapshot.data.status),
    ],
  );

  Widget _gymTrailingWidgetAdmin(snapshot, context) => StatusSwitchButton(
      isVerified: _isVerified,
      onPressed: () {
        handleGymStatus(snapshot.data.status, snapshot.data.id);
      });

  Widget _gymTrailingWidgetManager(snapshot, context) => FutureBuilder<int>(
      future: _getCurrentUserId(),
      builder: (context, userId) {
        if (userId.hasError) {
          return Container();
        } else if (userId.hasData) {
          _currentUserId = userId.data;
          print('FIRST CURRNET' +_currentUserId.toString());
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Visibility(
                visible: _currentUserId == snapshot.data.ownerId,
                child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMaintainerToGymPage(
                                  gymId: widget.gymId),
                        ),
                      );
                    },
                    tooltip: 'add maintainer to gym',
                    icon: Icon(Icons.person_add)),
              ),
              Visibility(
                visible: _currentUserId == snapshot.data.ownerId,
                child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGymDetailsPage(
                              gymId: widget.gymId),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    tooltip: 'edit gym details',
                    icon: Icon(Icons.edit)),
              ),
            ],
          );
        } else {
          return SizedBox(
            width: 1,
          );
        }
      });

  Widget _gymDescriptionWidget(snapshot) => Container(
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 6),
            color: lightGrey.withOpacity(.1),
            blurRadius: 12)
      ],
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Description",
          size: 20,
          weight: FontWeight.bold,
        ),
        CustomText(text: "${snapshot.data.gymDetailsDTO.description}"),
      ],
    ),
  );

  Widget _gymRoutesWidget(snapshot, context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 6),
            color: lightGrey.withOpacity(.1),
            blurRadius: 12)
      ],
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Routes",
          size: 20,
          weight: FontWeight.bold,
        ),
        FutureBuilder<List<RouteDTO>>(
            future: _loadRoutes(widget.gymId),
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
                          crossAxisCount:
                          ResponsiveWidget.isSmallScreen(context)
                              ? 2
                              : ResponsiveWidget.isMediumScreen(
                              context)
                              ? 3
                              : ResponsiveWidget
                              .isLargeScreen(context)
                              ? 4
                              : 5,
                        ),
                        itemBuilder: (context, index) {
                          return buildRouteGridFromSnapshot(
                              context, routes, index);
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else
                return SizedBox(
                    child:
                    Center(child: CircularProgressIndicator()));
            })
      ],
    ),
  );

  Widget _gymRoutesWidgetManager(snapshot, context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Routes",
              size: 20,
              weight: FontWeight.bold,
            ),
            _buildAddRouteButton(context)
          ],
        ),
        FutureBuilder<List<RouteDTO>>(
            future: _loadRoutes(widget.gymId),
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
                          // childAspectRatio:
                          //     ((MediaQuery.of(context).size.width) /
                          //             (MediaQuery.of(context)
                          //                 .size
                          //                 .height)) *
                          //         1.4,
                          crossAxisCount:
                          ResponsiveWidget.isSmallScreen(context)
                              ? 2
                              : ResponsiveWidget.isMediumScreen(
                              context)
                              ? 3
                              : ResponsiveWidget
                              .isLargeScreen(context)
                              ? 4
                              : 5,
                        ),
                        itemBuilder: (context, index) {
                          return buildRouteGridFromSnapshotManager(
                              context, routes, index);
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else
                return SizedBox(
                    child:
                    Center(child: CircularProgressIndicator()));
            })
      ],
    ),
  );

  Widget _gymRoutesWidgetClimber(snapshot, context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 6),
            color: lightGrey.withOpacity(.1),
            blurRadius: 12)
      ],
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Routes",
          size: 20,
          weight: FontWeight.bold,
        ),
        FutureBuilder<List<RouteDTO>>(
            future: _loadRoutes(widget.gymId),
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
                          crossAxisCount:
                          ResponsiveWidget.isSmallScreen(context)
                              ? 2
                              : ResponsiveWidget.isMediumScreen(
                              context)
                              ? 3
                              : ResponsiveWidget
                              .isLargeScreen(context)
                              ? 4
                              : 5,
                        ),
                        itemBuilder: (context, index) {
                          return buildRouteGridFromSnapshotClimber(
                              context, routes, index);
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else
                return SizedBox(
                    child:
                    Center(child: CircularProgressIndicator()));
            })
      ],
    ),
  );
}
