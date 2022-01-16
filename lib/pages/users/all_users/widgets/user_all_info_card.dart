import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/users/data/access_level_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserAllInfoCard extends StatefulWidget {
  const UserAllInfoCard({Key key, @required this.data})
      : assert(data != null),
        super(key: key);

  final UserWithPersonalDataAccessLevelDTO data;

  @override
  _UserAllInfoCardState createState() => _UserAllInfoCardState();
}

class _UserAllInfoCardState extends State<UserAllInfoCard>{
  static ApiClient _client = new ApiClient();
  var _userEndpoint = new UserEndpoint(_client.init());

  //get _fieldValues => _onGenerateFields(widget.data);

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          !ResponsiveWidget.isSmallScreen(context) ? Row(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80)),
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
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _onGenerateFields(widget.data),
              )
            ],
          )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: active.withOpacity(.5),
                    borderRadius: BorderRadius.circular(80)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80)),
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
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _onGenerateFields(widget.data),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                  color: active, borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CustomText(
                text: "Close",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getAccessLevelsString(List<AccessLevelDTO> levels) {
    String accessLevelsString = '';

    levels.forEach((level) {
      if (level.isActive == true) {
        accessLevelsString += level.accessLevel.toCapitalized() + ' ';
      }
    });
    return accessLevelsString.trim();
  }

  List<Widget> _onGenerateFields(UserWithPersonalDataAccessLevelDTO data) {
    String _accessLevelString = getAccessLevelsString(data.accessLevels);

    final _fieldValues = [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Active'),
          Switch(
            onChanged: (bool value) {
              toggleSwitch(value, data.id);
            },
            value: data.isActive,
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: !ResponsiveWidget.isSmallScreen(context) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                      text:
                      data.personalData.name ?? '',
                      size: 20,
                      weight: FontWeight.bold,
                      color: dark),
                  SizedBox(
                    width: 4,
                  ),
                  CustomText(
                      text:
                      data.personalData.surname  ?? '',
                      size: 20,
                      weight: FontWeight.bold,
                      color: dark),
                  if (ResponsiveWidget.isSmallScreen(context)) IconButton(
                    icon: data.isVerified ? Icon(Icons.verified) : Icon(Icons.block),
                    color: data.isVerified ? active : error,
                    onPressed: () {},
                  ),
                ],
              ),
              CustomText(
                  text: '${data.login} (${data.id.toString()})',
                  size: 12,
                  weight: FontWeight.w300,
                  color: lightGrey),
            ],
          ),
          if (!ResponsiveWidget.isSmallScreen(context)) IconButton(
            icon: data.isVerified ? Icon(Icons.verified) : Icon(Icons.block),
            color: data.isVerified ? active : error,
            onPressed: () {},
          ),
        ],
      ),
      GestureDetector(
        child: Text(data.email ?? ''),
        onLongPress: () {
          HapticFeedback.vibrate();
          Clipboard.setData(new ClipboardData(text: data.email));
          EasyLoading.showToast('Email copied to Clipboard!');
        },
      ),
      GestureDetector(
        child: Text(data.personalData.phoneNumber ?? ''),
        onLongPress: () {
          HapticFeedback.vibrate();
          Clipboard.setData(
              new ClipboardData(text: data.personalData.phoneNumber));
          EasyLoading.showToast('Phone number copied to Clipboard!');
        },
      ),
      SizedBox(
        height: 8,
      ),
      CustomText(
          text: _accessLevelString,
          size: 12,
          weight: FontWeight.w300,
          color: lightGrey),
      CustomText(
          text: (data.personalData.gender == true)
              ? 'Country: ${data.personalData.language} Gender: Male'
              : 'Country: ${data.personalData.language} Gender: Female',
          size: 12,
          weight: FontWeight.w300,
          color: lightGrey),
    ];
    return _fieldValues;
  }

  void toggleSwitch(bool value, userId) async {
    if (value == true) {
      var res = await _userEndpoint.activateUser(userId);
      if(res.isActive == true) {
        setState(() {
          textValue = 'Activated';
        });
      }
      print('Switch Button is ON');
    } else {
      var res = await _userEndpoint.deactivateUser(userId);
      if(res.isActive == false) {
        setState(() {
          textValue = 'Deactivated';
        });
      }
    }
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
