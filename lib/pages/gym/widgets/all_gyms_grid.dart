import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/route/my_routes/my_routes_page.dart';
import 'package:perfectBeta/service.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../gym_details_page.dart';

class AllGymsGrid extends StatefulWidget {
  static ApiClient _client = new ApiClient();

  @override
  State<AllGymsGrid> createState() => _AllGymsGridState();
}

class _AllGymsGridState extends State<AllGymsGrid> {
  bool _isVerified = false;
  UserWithPersonalDataAccessLevelDTO _gymOwner;

  // final ApiClient _client = new ApiClient();
  var _climbingGymEndpoint =
      new ClimbingGymEndpoint(AllGymsGrid._client.init());
  var _userEndpoint = new UserEndpoint(AllGymsGrid._client.init());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataPage>(
        future: _climbingGymEndpoint.getAllGyms(),
        builder: (context, snapshot) {
          print('Connection state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data.content.length,
                //padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing:
                      ResponsiveWidget.isSmallScreen(context) ? 32 : 64,
                  mainAxisSpacing:
                      ResponsiveWidget.isSmallScreen(context) ? 32 : 64,
                  crossAxisCount: ResponsiveWidget.isSmallScreen(context)
                      ? 1
                      : ResponsiveWidget.isMediumScreen(context)
                          ? 2
                          : ResponsiveWidget.isLargeScreen(context)
                              ? 3
                              : 4,
                ),
                itemBuilder: (context, index) {
                  return buildGymGridFromSnapshot(context, snapshot, index);
                },
              );
            } else {
              return Wrap(children: <Widget>[
                ElevatedButton(
                  child: Icon(
                    Icons.refresh,
                    semanticLabel: 'Refresh page',
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ]);
            }
          } else
            return SizedBox(child: Center(child: CircularProgressIndicator()));
        });
  }

  //For list
  void _onTileClicked(int index, int gymId, String gymName, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GymDetailsPage(gymId: gymId, gymName: gymName)),
    );
  }

  Widget buildGymGridFromSnapshot(context, snapshot, index) {
    _isVerified = snapshot.data.content[index].status == GymStatusEnum.VERIFIED ? true : false;
    return Container(
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
      child: GridTile(
        child: GestureDetector(
          onTap: () => _onTileClicked(index, snapshot.data.content[index].id,
              snapshot.data.content[index].gymName, context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    "https://perfectbeta.s3.eu-north-1.amazonaws.com/photos/logo.png",
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    Image(image: AssetImage('assets/images/gym-template.jpg')),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    isThreeLine: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                    title: Text("${snapshot.data.content[index].gymName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _parseGymEnum(snapshot.data.content[index].status),
                        FutureBuilder<UserWithPersonalDataAccessLevelDTO>(
                            future: _getGymOwner(
                                snapshot.data.content[index].ownerId),
                            builder: (context, ownerData) {
                              if (ownerData.hasError) {
                                return Text('Error: ${ownerData.error}');
                              }
                              if (ownerData.hasData) {
                                return CustomText(
                                    text: 'Owner: ' + ownerData.data.login ?? '',
                                    size: 12,
                                    weight: FontWeight.w300,
                                    color: lightGrey);
                              }
                              return Container();
                            }),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(text: _isVerified ? 'Close' : 'Verify'),
                        IconButton(onPressed: () {
                                handleGymStatus(snapshot.data.content[index].status, snapshot.data.content[index].id);
                            },
                            tooltip: _isVerified ? 'close gym' : 'verify gym',
                            icon: _isVerified ? Icon(Icons.block) : Icon(Icons.verified)),
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
  }

  void handleGymStatus(status, gymId) async {
      if (status == GymStatusEnum.UNVERIFIED || status == GymStatusEnum.CLOSED) {
        ClimbingGymDTO res = await _climbingGymEndpoint.verifyGym(gymId);
        if (res.status == GymStatusEnum.VERIFIED) {
          setState(() {
            _isVerified = res.status == GymStatusEnum.VERIFIED ? true : false;
          });
        }
      }
      else if (status == GymStatusEnum.VERIFIED) {
        ClimbingGymDTO res = await _climbingGymEndpoint.closeGym(gymId);
        if (res.status == GymStatusEnum.CLOSED) {
          setState(() {
            _isVerified = res.status == GymStatusEnum.CLOSED ? false : true;
          });
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

  Future<UserWithPersonalDataAccessLevelDTO> _getGymOwner(ownerId) async {
    try {
      UserWithPersonalDataAccessLevelDTO owner =
          await _userEndpoint.getUserById(ownerId);

      if (owner.login.isNotEmpty) {
        return owner;
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
