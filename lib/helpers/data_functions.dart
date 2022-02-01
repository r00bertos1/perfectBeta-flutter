import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/routes/rating_dto.dart';
import 'package:perfectBeta/model/routes/route_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import '../main.dart';

//API
var _userEndpoint = new UserEndpoint(getIt.get());
var _climbingGymEndpoint = new ClimbingGymEndpoint(getIt.get());
var _routeEndpoint = new RouteEndpoint(getIt.get());

Future<int> getCurrentUserId() async {
  try {
    UserWithPersonalDataAccessLevelDTO res = await _userEndpoint.getUserPersonalDataAccessLevel();
    return res.id;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<List<RouteDTO>> loadRoutes(int gymId) async {
  try {
    DataPage res = await _routeEndpoint.getAllGymRoutes(gymId);
    List<RouteDTO> routes = [];
    if (res.content != null) {
      res.content.forEach((route) {
        routes.add(route);
      });
    }
    return routes;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<List<int>> loadUsersData(List<int> values) async {
  try {
    DataPage res = await _userEndpoint.getAllUsers();
    if (res != null) {
      if (res.content.isNotEmpty) {
        values[0] = 0;  //registered
        values[1] = 0;  //admin
        values[2] = 0;  //manager
        values[3] = 0;  //climber
        res.content.forEach((user) {
          if (user.isActive == true) {
            values[0] += 1;

            user.accessLevels.forEach((level) {
              if (level.accessLevel == "ADMINISTRATOR" &&
                  level.isActive == true) {
                values[1] += 1;
              }
              if (level.accessLevel == "MANAGER" && level.isActive == true) {
                values[2] += 1;
              }
              if (level.accessLevel == "CLIMBER" && level.isActive == true) {
                values[3] += 1;
              }
            });
          }
        });
      }
    }
    return values;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<List<int>> loadGymsAndRoutesData(List<int> values) async {
  try {
    DataPage gyms = await _climbingGymEndpoint.getVerifiedGyms();
    if (gyms != null) {
      if (gyms.content != null) {
        if (gyms.content.isNotEmpty) {
          values[0] = gyms.content.length;  //gyms
          values[1] = 0;  //routes
          for(ClimbingGymDTO gym in gyms.content) {
            values[0] += 1;
            DataPage routes = await _routeEndpoint.getAllGymRoutes(gym.id);
            if (routes.content != null) {
              if (routes.content.isNotEmpty) {
                values[1] += routes.content.length;
              }
            }
          }
        }
      }
    }
    return values;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<List<int>> loadGymsAndRoutesDataClimber(List<int> values) async {
  try {
    var _username = await secStore.getUsername();
    DataPage gyms = await _climbingGymEndpoint.getVerifiedGyms();
    if (gyms.content != null) {
      if (gyms.content.isNotEmpty) {
        values[0] = gyms.content.length;  //gyms
        values[1] = 0;  //routes
        values[2] = 0;  //your reviews
        values[3] = 0;  //fav routes

        for(ClimbingGymDTO gym in gyms.content) {
          DataPage routes = await _routeEndpoint.getAllGymRoutes(gym.id);
          if (routes.content != null) {
            if (routes.content.isNotEmpty) {
              values[1] += routes.content.length;

              for(RouteDTO route in routes.content) {
                List<RatingDTO> ratings = await _routeEndpoint.getRouteRatings(
                    route.id);
                if (ratings != null) {
                  if (ratings.isNotEmpty) {
                    for(RatingDTO rating in ratings) {
                      if (rating.username == _username) {
                        values[2] += 1;
                      }
                    }
                  }
                }
              }
            }
          }
        }
        DataPage fav = await _routeEndpoint.getAllFavourites();
        if (fav.content != null) {
          if (fav.content.isNotEmpty) {
            values[3] = fav.content.length;
          }
        }
      }
    }
    return values;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}

Future<List<int>> loadGymsAndRoutesDataManager(List<int> values) async {
  try {
    DataPage gyms = await _climbingGymEndpoint.getVerifiedGyms();
    if (gyms.content != null) {
      if (gyms.content.isNotEmpty) {
        values[0] = gyms.content.length;  //gyms
        values[1] = 0;  //owned gyms
        values[2] = 0;  //maintained gyms
        values[3] = 0;  //routes in owned gyms

        DataPage owned = await _climbingGymEndpoint.getAllOwnedGyms();
        if (owned.content != null) {
          if (owned.content.isNotEmpty) {
            values[1] = owned.content.length;

            for(ClimbingGymDTO gym in owned.content) {
              values[0] += 1;
              DataPage routes = await _routeEndpoint.getAllGymRoutes(gym.id);
              if (routes.content != null) {
                if (routes.content.isNotEmpty) {
                  values[3] += routes.content.length;
                }
              }
            }
          }
        }

        DataPage maintained = await _climbingGymEndpoint.getAllMaintainedGyms();
        if (maintained.content != null) {
          if (maintained.content.isNotEmpty) {
            values[2] = maintained.content.length;
          }
        }
      }
    }
    return values;
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}


