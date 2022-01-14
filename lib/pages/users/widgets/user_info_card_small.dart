import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/users/data/access_level_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserInfoCardSmall extends StatefulWidget {
  const UserInfoCardSmall({Key key}) : super(key: key);

  @override
  _UserInfoCardSmallState createState() => _UserInfoCardSmallState();
}

class _UserInfoCardSmallState extends State<UserInfoCardSmall> {
  static ApiClient _client = new ApiClient();
  var _userEndpoint = new UserEndpoint(_client.init());

  String _name = "";
  String _surname = "";
  List<AccessLevelDTO> _accessLevels = [];
  String _email = "";
  String _phoneNumber = "";
  String _accessLevelString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Card(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: active.withOpacity(.5),
                      borderRadius: BorderRadius.circular(80)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(80)),
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: light,
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: dark,
                      ),
                    ),
                  ),
                ),
                FutureBuilder<UserWithPersonalDataAccessLevelDTO>(
                    future: _userEndpoint.getUserPersonalDataAccessLevel(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        _accessLevelString = getAccessLevelsString(snapshot.data.accessLevels);
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: snapshot.data.personalData.name + ' ' + snapshot.data.personalData.surname, size: 20, weight: FontWeight.bold, color: dark),
                              GestureDetector(child: Text(snapshot.data.email), onLongPress: () {
                                HapticFeedback.vibrate();
                                Clipboard.setData(new ClipboardData(text: snapshot.data.email));
                                EasyLoading.showToast('Email copied to Clipboard!');
                              },),
                              GestureDetector(child: Text(snapshot.data.personalData.phoneNumber), onLongPress: () {
                                HapticFeedback.vibrate();
                                Clipboard.setData(new ClipboardData(text: snapshot.data.personalData.phoneNumber));
                                EasyLoading.showToast('Phone number copied to Clipboard!');
                              },),
                              SizedBox(height: 8,),
                              CustomText(text: _accessLevelString, size: 12, weight: FontWeight.w300, color: lightGrey),
                            ],
                        );
                      } else {
                        return SizedBox(child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getAccessLevelsString(List<AccessLevelDTO> levels) {
    String accessLevelsString = '';

    levels.forEach((level) {
      accessLevelsString += level.accessLevel.toCapitalized() + ' ';
    });
    return accessLevelsString.trim();
  }

  // void _loadPersonalData() async {
  //   try {
  //     UserWithPersonalDataAccessLevelDTO res =
  //         await _userEndpoint.getUserPersonalDataAccessLevel();
  //     if (res.isActive && res.isVerified) {
  //       _name = res.personalData.name ?? "";
  //       _surname = res.personalData.surname ?? "";
  //       _accessLevels = res.accessLevels ?? "";
  //       _email = res.email ?? "";
  //       _phoneNumber = res.personalData.phoneNumber ?? "";
  //       _accessLevelString = getAccessLevelsString(_accessLevels);
  //     }
  //   } catch (e, s) {
  //     print("Exception $e");
  //     print("StackTrace $s");
  //   }
  // }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
}

