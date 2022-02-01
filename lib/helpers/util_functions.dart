import 'package:perfectBeta/service.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/model/holds/holds_details_dto.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/users/data/access_level_dto.dart';
import 'package:perfectBeta/pages/users/all_users/widgets/user_all_info_card.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../main.dart';
import 'dart:io';
import 'handlers.dart';

//API
var _routeEndpoint = new RouteEndpoint(getIt.get());

Widget parseGymEnum(GymStatusEnum data) {
  switch (data) {
    case GymStatusEnum.UNVERIFIED:
      return CustomText(text: "Unverified", color: Colors.amberAccent);
    case GymStatusEnum.VERIFIED:
      return CustomText(text: "Verified", color: active);
    case GymStatusEnum.CLOSED:
      return CustomText(text: "Closed", color: error);
  }
  return SizedBox.shrink();
}

Future<bool> isFavourited(int routeId) async {
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

Future<HoldsDetailsDTO> getHoldDataFromImage(imageFile) async {
  BaseOptions dioOptions = BaseOptions(
    connectTimeout: 100000,
    receiveTimeout: 100000,
  );
  var _pythonEndpoint = new PythonEndpoint(new Dio(dioOptions));
  try {
    HoldsDetailsDTO holdsData;
    var res = await _pythonEndpoint.scanImage(imageFile);
    if (res != null) {
      if (res.statusCode == 200) {
        final jsonResponse = json.decode(res.data);
        holdsData = new HoldsDetailsDTO.fromJson(jsonResponse);
      }
    }
    return holdsData;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

List<DropdownMenuItem<String>> putGymsIntoDropdown(List<ClimbingGymDTO> mergedGyms) {
  List<DropdownMenuItem<String>> gymItems = [];
  mergedGyms.forEach((mergedGym) {
    gymItems.add(DropdownMenuItem(
        child: Text(
          "${mergedGym.gymName}",
          overflow: TextOverflow.ellipsis,
        ),
        value: '${mergedGym.id}'));
  });
  return gymItems;
}

Future<List<String>> getLinksListFromAllImages(imageList, fileList) async {
  //Add converted image with holds to _fileList
  for (XFile image in imageList) {
    var imagesTemporary = File(image.path);
    fileList.add(imagesTemporary);
  }
  var list = await handleImagesUpload(fileList);
  return list;
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
