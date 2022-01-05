import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/pages/my_routes/my_routes_page.dart';
import 'package:perfectBeta/service.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GymsDetailsRoutes extends StatelessWidget {
  //Passed from GymGrid class
  final int gymId;
  bool _added = false;

  static ApiClient _client = new ApiClient();
  var _climbingGymEndpoint = new ClimbingGymEndpoint(_client.init());
  var _routeEndpoint = new RouteEndpoint(_client.init());

  GymsDetailsRoutes({Key key, this.gymId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClimbingGymWithDetailsDTO>(
        future: _climbingGymEndpoint.getVerifiedGymById(gymId),
        builder: (context, snapshot) {
          print('Connection state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.hasData) {
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //padding: const EdgeInsets.all(16),
                      children: <Widget>[
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          title: RatingBarIndicator(
                            rating: 4.5,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            // itemCount: 5,
                            itemSize: 20.0,
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
                            child:
                                Icon(_added ? Icons.favorite : Icons.favorite_border),
                          ),
                        ),
                        CustomText(
                            text: "${snapshot.data.gymDetailsDTO.description}"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: active.withOpacity(.4), width: .5),
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
                              FutureBuilder<GymPage>(
                                  future: _routeEndpoint.getAllGymRoutes(gymId),
                                  builder: (context, snapshot) {
                                    print(
                                        'Connection state: ${snapshot.connectionState}');
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
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
                                                ResponsiveWidget.isSmallScreen(
                                                        context)
                                                    ? 20
                                                    : 64,
                                            mainAxisSpacing:
                                                ResponsiveWidget.isSmallScreen(
                                                        context)
                                                    ? 20
                                                    : 64,
                                            childAspectRatio: ((MediaQuery.of(context).size.width) /
                                                (MediaQuery.of(context).size.height)) * 1.4,
                                            crossAxisCount: ResponsiveWidget
                                                    .isSmallScreen(context)
                                                ? 2
                                                : ResponsiveWidget.isMediumScreen(
                                                        context)
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
                                          child: Center(
                                              child: CircularProgressIndicator()));
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Text("No data");
            }
          } else
            return SizedBox(child: Center(child: CircularProgressIndicator()));
        });
  }

  void _onRouteClicked(int index, context) {
    // Navigator.push(
    //   context,
    //   //MaterialPageRoute(builder: (context) => GymDetails(index)),
    //   MaterialPageRoute(builder: (context) => MyRoutesPage()),
    // );
  }

  Widget buildRouteGridFromSnapshot(context, snapshot, index) => Container(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(color: active.withOpacity(.4), width: .5),
        //   boxShadow: [
        //     BoxShadow(
        //         offset: Offset(0, 6),
        //         color: lightGrey.withOpacity(.1),
        //         blurRadius: 12)
        //   ],
        //   borderRadius: BorderRadius.circular(8),
        // ),
        //margin: EdgeInsets.only(bottom: 30),
        child: GridTile(

          child: GestureDetector(
            onTap: () => _onRouteClicked(index, context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: snapshot.data.content[index].photos.length > 0 ? "${snapshot.data.content[index].photos[0].photoUrl}" : "test",
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
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(left: 0, right: 0, top: 0),
                    //   child: RatingBarIndicator(
                    //     rating: snapshot.data.content[index].avgRating,
                    //     itemBuilder: (context, index) => Icon(
                    //       Icons.star,
                    //       color: Colors.amber,
                    //     ),
                    //     // itemCount: 5,
                    //     itemSize: 20.0,
                    //   ),
                    // ),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 0),
                      title: Text("${snapshot.data.content[index].routeName}", overflow: TextOverflow.ellipsis,),
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
}
