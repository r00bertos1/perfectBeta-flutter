import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../main.dart';

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

Future<bool> handleAddFavourite(int routeId, bool added) async {
  if (added) {
    var res = await _routeEndpoint.removeRouteFromFavourites(routeId);
    if (res != null) {
      if (res.statusCode == 200) {
        return true;
      }
    }
    return false;
  } else {
    var res = await _routeEndpoint.addRouteToFavourites(routeId);
    if (res != null) {
      if (res.statusCode == 200) {
        return true;
      }
    }
    return false;
  }
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

void handleAddRoute(BuildContext context, int gymId) {
  menuController.changeActiveItemTo(addRoutePageDisplayName);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddRoutePage(gymId: gymId),
    ),
  );
}

Future<bool> handleRouteDelete(BuildContext context, int gymId, int routeId) async {
  try {
    var res = await _routeEndpoint.deleteRoute(gymId, routeId);
    if (res.statusCode == 200) {
      EasyLoading.showSuccess('Route removed!');
      Navigator.pop(context);
      return true;
    }
    return false;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}