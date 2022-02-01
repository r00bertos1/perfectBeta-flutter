import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/util_functions.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../main.dart';

class UserInfoCardSmall extends StatefulWidget {
  const UserInfoCardSmall({Key key}) : super(key: key);

  @override
  _UserInfoCardSmallState createState() => _UserInfoCardSmallState();
}

class _UserInfoCardSmallState extends State<UserInfoCardSmall> {
  var _userEndpoint = new UserEndpoint(getIt.get());

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
                SizedBox(width: 20,),
                FutureBuilder<UserWithPersonalDataAccessLevelDTO>(
                    future: _userEndpoint.getUserPersonalDataAccessLevel(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        _accessLevelString = getAccessLevelsString(snapshot.data.accessLevels);
                        return Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                        text:
                                        snapshot.data.personalData.name ?? '',
                                        size: 20,
                                        weight: FontWeight.bold,
                                        color: dark),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    CustomText(
                                        text:
                                        snapshot.data.personalData.surname ?? '',
                                        size: 20,
                                        weight: FontWeight.bold,
                                        color: dark),
                                  ],
                                ),
                                GestureDetector(child: Text(snapshot.data.email ?? '', overflow: TextOverflow.ellipsis), onLongPress: () {
                                  HapticFeedback.vibrate();
                                  Clipboard.setData(new ClipboardData(text: snapshot.data.email));
                                  EasyLoading.showToast('Email copied to Clipboard!');
                                },),
                                GestureDetector(child: Text(snapshot.data.personalData.phoneNumber ?? '', overflow: TextOverflow.ellipsis), onLongPress: () {
                                  HapticFeedback.vibrate();
                                  Clipboard.setData(new ClipboardData(text: snapshot.data.personalData.phoneNumber));
                                  EasyLoading.showToast('Phone number copied to Clipboard!');
                                },),
                                SizedBox(height: 8,),
                                CustomText(text: _accessLevelString, size: 12, weight: FontWeight.w300, color: lightGrey),
                              ],
                          ),
                        );
                      } else {
                        return SizedBox(child: Center(child: CircularProgressIndicator.adaptive()));
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
}

