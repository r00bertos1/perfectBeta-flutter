import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/routes/route_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/gym/add_maintainer_to_gym.dart';
import 'package:perfectBeta/pages/gym/edit_gym_details.dart';
import 'package:perfectBeta/pages/gym/gym_details.dart';
import 'package:perfectBeta/pages/gym/widgets/favourite_button.dart';
import 'package:perfectBeta/pages/route/widgets/detail_photo.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

import 'edit_route_details.dart';

class RouteDetailsPage extends StatefulWidget {
  final int gymId;
  final int routeId;
  final int currentUserId;
  static ApiClient _client = new ApiClient();

  const RouteDetailsPage(
      {Key key, this.gymId, this.routeId, this.currentUserId})
      : super(key: key);

  @override
  _RouteDetailsPageState createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  var _routeEndpoint = new RouteEndpoint(RouteDetailsPage._client.init());
  var _climbingGymEndpoint =
      new ClimbingGymEndpoint(RouteDetailsPage._client.init());

  List<String> photoList = [];
  var _tag = 'imageHero';
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: secStore.getAccessLevel(),
        builder: (context, accessLevelSnapshot) {
          switch (accessLevelSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (accessLevelSnapshot.hasError) {
                return new Text('Error: ${accessLevelSnapshot.error}');
              } else {
                return FutureBuilder<RouteDTO>(
                    future: _loadRouteData(widget.gymId, widget.routeId),
                    builder: (context, routeDataSnapshot) {
                      if (routeDataSnapshot.connectionState ==
                          ConnectionState.done) {
                        if (routeDataSnapshot.hasError) {
                          return Text("Error");
                        }
                        if (routeDataSnapshot.hasData) {
                          switch (accessLevelSnapshot.data) {
                            case 'MANAGER':
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildRouteDetailsListViewManager(
                                      routeDataSnapshot, context));
                            case 'CLIMBER':
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildRouteDetailsListViewClimber(
                                      routeDataSnapshot, context));
                            case 'ADMIN':
                            default:
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildRouteDetailsListView(
                                      routeDataSnapshot, context));
                          }
                        } else {
                          return Text("No data");
                        }
                      } else
                        return SizedBox(
                            child: Center(child: CircularProgressIndicator()));
                    });
              }
          }
        });
  }

  Widget _buildRouteDetailsListViewManager(
      AsyncSnapshot<RouteDTO> snapshot, context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Wrap(
                spacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    snapshot.data.routeName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(99)),
                    alignment: Alignment.center,
                    width: 40,
                    height: 30,
                    //padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: snapshot.data.difficulty,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              subtitle: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CustomText(
                    text: snapshot.data.avgRating.toString(),
                  ),
                  RatingBarIndicator(
                    rating: snapshot.data.avgRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    // itemCount: 5,
                    itemSize: 16.0,
                  ),
                ],
              ),
              trailing: FutureBuilder<ClimbingGymWithDetailsDTO>(
                  future: _climbingGymEndpoint.getVerifiedGymById(widget.gymId),
                  builder: (context, gymData) {
                    if (gymData.hasError) {
                      return Container();
                    } else if (gymData.hasData) {
                      return Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: [
                          Visibility(
                            visible:
                                gymData.data.ownerId == widget.currentUserId,
                            child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRouteDetailsPage(
                                          routeData: snapshot.data),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                                tooltip: 'edit route details',
                                icon: Icon(Icons.edit)),
                          ),
                          Visibility(
                            visible:
                                gymData.data.ownerId == widget.currentUserId,
                            child: IconButton(
                              //iconSize: 18,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.all(0),
                                onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                            _handleRouteDelete(
                                                context,
                                                snapshot.data.climbingGymId,
                                                snapshot.data.id);
                                          },
                                          child: CustomText(
                                              text: 'Yes, delete!',
                                              color: error),
                                        ),
                                      ],
                                    )),
                                tooltip: 'delete route',
                                icon: Icon(Icons.delete)),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        width: 1,
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: photoList.isNotEmpty,
                child: photoList.length > 1
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: 250.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                        ),
                        items: photoList
                            .map((photo) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: lightGrey.withOpacity(.4),
                                        width: .5),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 6),
                                          color: lightGrey.withOpacity(.1),
                                          blurRadius: 12)
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return DetailPhoto(
                                              url: photo, tag: _tag);
                                        }));
                                      },
                                      child: Hero(
                                        tag: _tag,
                                        child: Center(
                                            child: Image.network(photo,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: lightGrey.withOpacity(.4), width: .5),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 6),
                                  color: lightGrey.withOpacity(.1),
                                  blurRadius: 12)
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DetailPhoto(
                                    url: photoList[0], tag: _tag);
                              }));
                            },
                            child: Hero(
                              tag: _tag,
                              child: Center(
                                  child: Image.network(photoList[0],
                                      fit: BoxFit.cover, width: 1000)),
                            ),
                          ),
                        ),
                      )),
            SizedBox(
              height: 20,
            ),
            Container(
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
                  CustomText(text: "${snapshot.data.description}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
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
                    text: "Holds",
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                  //TODO: table with holds from json data
                  CustomText(text: "${snapshot.data.holdsDetails}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
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
                    text: "Ratings and comments",
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                  //TODO: ratings list with future
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDetailsListViewClimber(
      AsyncSnapshot<RouteDTO> snapshot, context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Wrap(
                spacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    snapshot.data.routeName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(99)),
                    alignment: Alignment.center,
                    width: 40,
                    height: 30,
                    //padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: snapshot.data.difficulty,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              subtitle: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CustomText(
                    text: snapshot.data.avgRating.toString(),
                  ),
                  RatingBarIndicator(
                    rating: snapshot.data.avgRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    // itemCount: 5,
                    itemSize: 16.0,
                  ),
                ],
              ),
              trailing: FutureBuilder<bool>(
                  future: _isFavourited(snapshot.data.id),
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
                              handleAddFavourite(snapshot.data.id, _added);
                            });
                      } else {
                        return SizedBox(width: 1);
                      }
                    } else
                      return SizedBox(width: 1);
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: photoList.isNotEmpty,
                child: photoList.length > 1
                    ? CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration:
                    Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                  ),
                  items: photoList
                      .map((photo) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: lightGrey.withOpacity(.4),
                          width: .5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 6),
                            color: lightGrey.withOpacity(.1),
                            blurRadius: 12)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                                return DetailPhoto(
                                    url: photo, tag: _tag);
                              }));
                        },
                        child: Hero(
                          tag: _tag,
                          child: Center(
                              child: Image.network(photo,
                                  height: MediaQuery.of(context)
                                      .size
                                      .height,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: lightGrey.withOpacity(.4), width: .5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 6),
                            color: lightGrey.withOpacity(.1),
                            blurRadius: 12)
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                              return DetailPhoto(
                                  url: photoList[0], tag: _tag);
                            }));
                      },
                      child: Hero(
                        tag: _tag,
                        child: Center(
                            child: Image.network(photoList[0],
                                fit: BoxFit.cover, width: 1000)),
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
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
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Description",
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                  CustomText(text: "${snapshot.data.description}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
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
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Holds",
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                  //TODO: table with holds from json data
                  CustomText(text: "${snapshot.data.holdsDetails}"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDetailsListView(
      AsyncSnapshot<RouteDTO> snapshot, context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Wrap(
                spacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    snapshot.data.routeName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(99)),
                    alignment: Alignment.center,
                    width: 40,
                    height: 30,
                    //padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: snapshot.data.difficulty,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              subtitle: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CustomText(
                    text: snapshot.data.avgRating.toString(),
                  ),
                  RatingBarIndicator(
                    rating: snapshot.data.avgRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    // itemCount: 5,
                    itemSize: 16.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: photoList.isNotEmpty,
                child: photoList.length > 1
                    ? CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration:
                    Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                  ),
                  items: photoList
                      .map((photo) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: lightGrey.withOpacity(.4),
                          width: .5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 6),
                            color: lightGrey.withOpacity(.1),
                            blurRadius: 12)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                                return DetailPhoto(
                                    url: photo, tag: _tag);
                              }));
                        },
                        child: Hero(
                          tag: _tag,
                          child: Center(
                              child: Image.network(photo,
                                  height: MediaQuery.of(context)
                                      .size
                                      .height,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: lightGrey.withOpacity(.4), width: .5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 6),
                            color: lightGrey.withOpacity(.1),
                            blurRadius: 12)
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                              return DetailPhoto(
                                  url: photoList[0], tag: _tag);
                            }));
                      },
                      child: Hero(
                        tag: _tag,
                        child: Center(
                            child: Image.network(photoList[0],
                                fit: BoxFit.cover, width: 1000)),
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
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
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Description",
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                  CustomText(text: "${snapshot.data.description}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
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
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Holds",
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                  //TODO: table with holds from json data
                  CustomText(text: "${snapshot.data.holdsDetails}"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<RouteDTO> _loadRouteData(gymId, routeId) async {
    try {
      DataPage res = await _routeEndpoint.getAllGymRoutes(gymId);
      photoList.clear();
      RouteDTO _selectedRoute;
      if (res.content != null) {
        res.content.forEach((route) {
          if (route.id == routeId) {
            _selectedRoute = route;
            route.photos.forEach((photo) => photoList.add(photo.photoUrl));
          }
        });
      }
      return _selectedRoute;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  void _handleRouteDelete(context, gymId, routeId) async {
    try {
      var res = await _routeEndpoint.deleteRoute(gymId, routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Route removed!');
        //Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GymDetails(gymId: gymId),
          ),
        );
        setState(() {});
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
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
}
