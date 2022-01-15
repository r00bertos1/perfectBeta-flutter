import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';

//API
ApiClient _client = new ApiClient();
var _userEndpoint = new UserEndpoint(_client.init());

Future<List<int>> loadUsersData(List<int> values) async {
  try {
    DataPage res = await _userEndpoint.getAllUsers();
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
      return values;
    }
  } catch (e, s) {
    print("Exception $e");
    print("StackTrace $s");
  }
}
