import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/data_functions.dart';
import 'package:perfectBeta/helpers/util_functions.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/routes/rating_dto.dart';
import 'package:perfectBeta/model/routes/route_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/gym/gym_details.dart';
import 'package:perfectBeta/pages/gym/widgets/favourite_button.dart';
import 'package:perfectBeta/pages/route/widgets/detail_photo.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../main.dart';
import 'edit_route_details.dart';

class RouteDetailsPage extends StatefulWidget {
  final int gymId;
  final int routeId;
  final int currentUserId;

  const RouteDetailsPage({Key key, this.gymId, this.routeId, this.currentUserId}) : super(key: key);

  @override
  _RouteDetailsPageState createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  var _routeEndpoint = new RouteEndpoint(getIt.get());
  var _userEndpoint = new UserEndpoint(getIt.get());

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
                      if (routeDataSnapshot.connectionState == ConnectionState.done) {
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
                                  child: _buildRouteDetailsListViewManager(routeDataSnapshot, context));
                            case 'CLIMBER':
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildRouteDetailsListViewClimber(routeDataSnapshot, context));
                            case 'ADMIN':
                            default:
                              return RefreshIndicator(
                                  // ignore: missing_return
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                  child: _buildRouteDetailsListView(routeDataSnapshot, context));
                          }
                        } else {
                          return Text("No data");
                        }
                      } else
                        return SizedBox(child: Center(child: CircularProgressIndicator()));
                    });
              }
          }
        });
  }

  Widget _buildRouteDetailsListViewManager(AsyncSnapshot<RouteDTO> snapshot, context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: _routeTitleWidget(snapshot),
              subtitle: _routeSubtitleWidget(snapshot),
              trailing: _routeTrailingWidgetManager(snapshot, context),
            ),
            SizedBox(
              height: 10,
            ),
            _carouselPhotosWidget(context),
            SizedBox(
              height: 20,
            ),
            _descriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            // _holdsWidget(snapshot),
            // SizedBox(
            //   height: 20,
            // ),
            _ratingsWidgetManager(snapshot, context),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDetailsListViewClimber(AsyncSnapshot<RouteDTO> snapshot, context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: _routeTitleWidget(snapshot),
              subtitle: _routeSubtitleWidget(snapshot),
              trailing: _routeTrailingWidgetClimber(snapshot, context),
            ),
            SizedBox(
              height: 10,
            ),
            _carouselPhotosWidget(context),
            SizedBox(
              height: 20,
            ),
            _descriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            // _holdsWidget(snapshot),
            // SizedBox(
            //   height: 20,
            // ),
            _ratingsWidgetClimber(snapshot, context),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDetailsListView(AsyncSnapshot<RouteDTO> snapshot, context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: _routeTitleWidget(snapshot),
              subtitle: _routeSubtitleWidget(snapshot),
            ),
            SizedBox(
              height: 10,
            ),
            _carouselPhotosWidget(context),
            SizedBox(
              height: 20,
            ),
            _descriptionWidget(snapshot),
            SizedBox(
              height: 20,
            ),
            // _holdsWidget(snapshot),
            // SizedBox(
            //   height: 20,
            // ),
            _ratingsWidget(snapshot, context),
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
      if (res != null) {
        if (res.content != null) {
          res.content.forEach((route) {
            if (route.id == routeId) {
              _selectedRoute = route;
              route.photos.forEach((photo) => photoList.add(photo.photoUrl));
            }
          });
        }
      }
      return _selectedRoute;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<bool> _handleRouteDelete(context, gymId, routeId) async {
    try {
      var res = await _routeEndpoint.deleteRoute(gymId, routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Route removed!');
        //int count = 0;
        //Navigator.of(context).popUntil((_) => count++ >= 2);
        Navigator.of(context).pop();
        return true;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => GymDetails(gymId: gymId),
        //   ),
        // );
        //setState(() {});
      }
      return false;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<bool> _handleRatingDeleteManager(context, routeId) async {
    try {
      var res = await _routeEndpoint.deleteRatingByOwnerOrMaintainer(routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Rating removed!');
        Navigator.of(context).pop();
        return true;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => GymDetails(gymId: gymId),
        //   ),
        // );
        //setState(() {});
      }
      return false;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<bool> _handleRatingDeleteClimber(context, routeId) async {
    try {
      var res = await _routeEndpoint.deleteOwnRating(routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Rating removed!');
        Navigator.of(context).pop();
        return true;
      }
      return false;
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

  Widget _buildAddRateButton(context) {
    return InkWell(
      onTap: () => _showRatingAppDialog(),
      child: Container(
        decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
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

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      starColor: Colors.amber,
      title: Text(
        'Rate this route',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        'Tap a star to set your rating. You can also add comment if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // image: Image.asset("assets/images/devs.jpg",
      //   height: 100,),
      submitButtonText: 'Submit',
      commentHint: 'Your thoughts about this route',
      //onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        _handleRatingAdd(response, widget.routeId);
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  Future<void> _handleRatingAdd(RatingDialogResponse response, int routeId) async {
    try {
      RatingDTO ratingDTO = new RatingDTO(rate: response.rating, comment: response.comment);
      var res = await _routeEndpoint.addRatingToRoute(routeId, ratingDTO);
      if (res != null) {
        if (res.statusCode == 200) {
          EasyLoading.showSuccess('Rating added!');
          setState(() {});
          //Navigator.of(context).pop();
        }
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Widget _buildRouteImageHero(List<String> photoList) => Hero(
        tag: _tag,
        child: Center(
            child: Image.network(
          photoList.isNotEmpty ? photoList[0] : '',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
              (loadingProgress == null) ? child : SizedBox(child: Center(child: CircularProgressIndicator.adaptive())),
          errorBuilder: (context, error, stackTrace) => Image(
            image: AssetImage('assets/images/route-template.jpg'),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        )),
      );

  Widget _buildRouteImageSliderHero(String photo) => Hero(
        tag: _tag,
        child: Center(
            child: Image.network(
          photo,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
              (loadingProgress == null) ? child : SizedBox(child: Center(child: CircularProgressIndicator.adaptive())),
          errorBuilder: (context, error, stackTrace) => Image(
            image: AssetImage('assets/images/route-template.jpg'),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        )),
      );

  Widget _routeTitleWidget(snapshot) => Wrap(
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
            decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(99)),
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
      );

  Widget _routeSubtitleWidget(snapshot) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // CustomText(
          //   text: snapshot.data.avgRating.toString(),
          // ),
          RatingBarIndicator(
            rating: snapshot.data.avgRating,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            // itemCount: 5,
            itemSize: 16.0,
          ),
          FutureBuilder<List<RatingDTO>>(
              future: _routeEndpoint.getRouteRatings(snapshot.data.id),
              builder: (context, ratingData) {
                if (ratingData.connectionState == ConnectionState.done) {
                  if (ratingData.hasError) {
                    return Text("Error");
                  }
                  if (ratingData.hasData) {
                    if (ratingData.data.length > 0) {
                      return CustomText(
                        size: 14,
                        text: "(${ratingData.data.length.toString()} reviews)",
                      );
                    } else {
                      return SizedBox(width: 1);
                    }
                  } else {
                    return SizedBox(width: 1);
                  }
                } else
                  return SizedBox(width: 1);
              }),
        ],
      );

  Widget _routeTrailingWidgetManager(AsyncSnapshot<RouteDTO> snapshot, context) => Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                var _routeInfo = snapshot.data;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditRouteDetailsPage(routeData: _routeInfo),
                  ),
                ).then((_) => setState(() {}));
              },
              tooltip: 'edit route details',
              icon: Icon(Icons.edit)),
          IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.all(0),
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: const Text('Delete route'),
                        content: const Text('Are you sure?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: CustomText(text: 'No', weight: FontWeight.w300, color: dark),
                          ),
                          TextButton(
                            onPressed: () {
                              _handleRouteDelete(context, snapshot.data.climbingGymId, snapshot.data.id).then((_) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GymDetails(gymId: snapshot.data.climbingGymId),
                                    ),
                                  ));
                            },
                            child: CustomText(text: 'Yes, delete!', color: error),
                          ),
                        ],
                      )),
              tooltip: 'delete route',
              icon: Icon(Icons.delete)),
        ],
      );

  Widget _routeTrailingWidgetClimber(snapshot, context) => FutureBuilder<bool>(
      future: isFavourited(snapshot.data.id),
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
      });

  Widget _carouselPhotosWidget(context) => Visibility(
      visible: photoList.isNotEmpty,
      child: photoList.length > 1
          ? CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
              ),
              items: photoList
                  .map((photo) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return DetailPhoto(url: photo, tag: _tag);
                              }));
                            },
                            child: _buildRouteImageSliderHero(photo),
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
                  border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                  boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailPhoto(url: photoList[0], tag: _tag);
                    }));
                  },
                  child: _buildRouteImageHero(photoList),
                ),
              ),
            ));

  Widget _descriptionWidget(snapshot) => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
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
      );

  Widget _ratingsWidgetManager(snapshot, context) => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
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
            SizedBox(
              height: 10,
            ),
            _ratingListWidgetManager(snapshot, context)
          ],
        ),
      );

  Widget _ratingListWidgetManager(snapshot, context) => FutureBuilder<List<RatingDTO>>(
      future: _routeEndpoint.getRouteRatings(snapshot.data.id),
      builder: (context, ratingData) {
        if (ratingData.connectionState == ConnectionState.done) {
          if (ratingData.hasError) {
            return Text("Error");
          }
          if (ratingData.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ratingData.data == null ? 0 : ratingData.data.length,
                    itemBuilder: (context, index) {
                      final item = ratingData.data[index];
                      return Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: CustomText(
                            text: ratingData.data[index].username,
                            size: 14,
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBarIndicator(
                                rating: ratingData.data[index].rate,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                // itemCount: 5,
                                itemSize: 16.0,
                              ),
                              ratingData.data[index].comment != null
                                  ? CustomText(
                                      overflow: TextOverflow.visible,
                                      text: ratingData.data[index].comment,
                                      size: 16,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          trailing: IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.all(0),
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        title: const Text('Delete rating'),
                                        content: const Text('Are you sure?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: CustomText(text: 'No', weight: FontWeight.w300, color: dark),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _handleRatingDeleteManager(context, ratingData.data[index].id).then((_) => setState(() {}));
                                            },
                                            child: CustomText(text: 'Yes, delete!', color: error),
                                          ),
                                        ],
                                      )),
                              tooltip: 'delete route',
                              icon: Icon(Icons.delete)),
                        ),
                      );
                    }),
              ],
            );
          } else {
            return SizedBox(width: 1);
          }
        } else
          return SizedBox(width: 1);
      });

  Widget _ratingsWidgetClimber(snapshot, context) => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Ratings and comments",
                  size: 20,
                  weight: FontWeight.bold,
                ),
                _buildAddRateButton(context)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _ratingListWidgetClimber(snapshot, context)
          ],
        ),
      );

  Widget _ratingListWidgetClimber(snapshot, context) => FutureBuilder<List<RatingDTO>>(
      future: _routeEndpoint.getRouteRatings(snapshot.data.id),
      builder: (context, ratingData) {
        if (ratingData.connectionState == ConnectionState.done) {
          if (ratingData.hasError) {
            return Text("Error");
          }
          if (ratingData.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ratingData.data == null ? 0 : ratingData.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: CustomText(
                              text: ratingData.data[index].username,
                              size: 14,
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBarIndicator(
                                  rating: ratingData.data[index].rate,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  // itemCount: 5,
                                  itemSize: 16.0,
                                ),
                                ratingData.data[index].comment != null
                                    ? CustomText(
                                        overflow: TextOverflow.visible,
                                        text: ratingData.data[index].comment,
                                        size: 16,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            trailing: FutureBuilder(
                                future: getCurrentUserId(),
                                builder: (context, userIdData) {
                                  if (ratingData.connectionState == ConnectionState.done) {
                                    if (userIdData.hasError) {
                                      return Text("Error");
                                    }
                                    if (userIdData.hasData) {
                                      return Visibility(
                                        visible: userIdData.data == ratingData.data[index].userId,
                                        child: IconButton(
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.all(0),
                                            onPressed: () => showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      title: const Text('Delete rating'),
                                                      content: const Text('Are you sure?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: CustomText(text: 'No', weight: FontWeight.w300, color: dark),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            _handleRatingDeleteClimber(context, ratingData.data[index].id)
                                                                .then((_) => setState(() {}));
                                                          },
                                                          child: CustomText(text: 'Yes, delete!', color: error),
                                                        ),
                                                      ],
                                                    )),
                                            tooltip: 'delete route',
                                            icon: Icon(Icons.delete)),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  } else
                                    return SizedBox.shrink();
                                })),
                      );
                    }),
              ],
            );
          } else {
            return SizedBox(width: 1);
          }
        } else
          return SizedBox(width: 1);
      });

  Widget _ratingsWidget(snapshot, context) => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
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
            SizedBox(
              height: 10,
            ),
            _ratingListWidget(snapshot, context)
          ],
        ),
      );

  Widget _ratingListWidget(snapshot, context) => FutureBuilder<List<RatingDTO>>(
      future: _routeEndpoint.getRouteRatings(snapshot.data.id),
      builder: (context, ratingData) {
        if (ratingData.connectionState == ConnectionState.done) {
          if (ratingData.hasError) {
            return Text("Error");
          }
          if (ratingData.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ratingData.data == null ? 0 : ratingData.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: CustomText(
                            text: ratingData.data[index].username,
                            size: 14,
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBarIndicator(
                                rating: ratingData.data[index].rate,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                // itemCount: 5,
                                itemSize: 16.0,
                              ),
                              ratingData.data[index].comment != null
                                  ? CustomText(
                                      overflow: TextOverflow.visible,
                                      text: ratingData.data[index].comment,
                                      size: 16,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          } else {
            return SizedBox(width: 1);
          }
        } else
          return SizedBox(width: 1);
      });
}
