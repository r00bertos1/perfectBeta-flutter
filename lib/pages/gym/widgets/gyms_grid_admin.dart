import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/helpers/data_functions.dart';
import 'package:perfectBeta/helpers/util_functions.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/pages/gym/widgets/status_switch_button.dart';
import 'package:perfectBeta/service.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../../../main.dart';
import '../gym_details.dart';

class GymsGridAdmin extends StatefulWidget {
  @override
  State<GymsGridAdmin> createState() => _GymsGridAdminState();
}

class _GymsGridAdminState extends State<GymsGridAdmin> {
  UserWithPersonalDataAccessLevelDTO _gymOwner;
  bool _isVerified = false;

  var _climbingGymEndpoint = new ClimbingGymEndpoint(getIt.get());
  var _userEndpoint = new UserEndpoint(getIt.get());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClimbingGymDTO>>(
        future: _loadGyms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                },
                child: GridView.builder(
                  itemCount: snapshot.data.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: ResponsiveWidget.isSmallScreen(context) ? 32 : 64,
                    mainAxisSpacing: ResponsiveWidget.isSmallScreen(context) ? 32 : 64,
                    crossAxisCount: ResponsiveWidget.isSmallScreen(context)
                        ? 1
                        : ResponsiveWidget.isMediumScreen(context)
                            ? 2
                            : ResponsiveWidget.isLargeScreen(context)
                                ? 3
                                : 4,
                    // childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    //     ((MediaQuery.of(context).size.height - kToolbarHeight- 24) / 8),
                  ),
                  itemBuilder: (context, index) {
                    return buildGymGridFromSnapshot(context, snapshot.data, index);
                  },
                ),
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
            return SizedBox(child: Center(child: CircularProgressIndicator.adaptive()));
        });
  }

  Widget buildGymGridFromSnapshot(context, List<ClimbingGymDTO> data, int index) {
    _isVerified = data[index].status == GymStatusEnum.VERIFIED ? true : false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: active.withOpacity(.4), width: .5),
          boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GymDetails(gymId: data[index].id)),
            ),
            child: Image(fit: BoxFit.cover, image: AssetImage('assets/images/gym-template.jpg')),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            //contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            title: Text("${data[index].gymName}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                parseGymEnum(data[index].status),
                FutureBuilder<UserWithPersonalDataAccessLevelDTO>(
                    future: _getGymOwner(data[index].ownerId),
                    builder: (context, ownerData) {
                      if (ownerData.hasError) {
                        return Text('Error: ${ownerData.error}');
                      }
                      if (ownerData.hasData) {
                        return CustomText(text: 'Owner: ' + ownerData.data.login ?? '', size: 12, weight: FontWeight.w300, color: lightGrey);
                      }
                      return Container();
                    }),
              ],
            ),
            trailing: StatusSwitchButton(
                textColor: Colors.white,
                isVerified: _isVerified,
                onPressed: () {
                  handleGymStatus(data[index].status, data[index].id);
                }),
          ),
        ),
      ),
    );
  }

  Future<UserWithPersonalDataAccessLevelDTO> _getGymOwner(ownerId) async {
    try {
      UserWithPersonalDataAccessLevelDTO owner = await _userEndpoint.getUserById(ownerId);

      if (owner.login.isNotEmpty) {
        return owner;
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<List<ClimbingGymDTO>> _loadGyms() async {
    try {
      DataPage res = await _climbingGymEndpoint.getAllGyms();
      List<ClimbingGymDTO> gyms = [];
      if (res.content != null) {
        res.content.forEach((gym) {
          gyms.add(gym);
        });
      }
      return gyms;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
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
}
