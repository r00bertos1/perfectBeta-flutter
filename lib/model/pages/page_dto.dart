import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/model/pages/pageable.dart';
import 'package:perfectBeta/model/pages/sort.dart';
import 'package:perfectBeta/model/routes/route_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';

class DataPage {
  List<dynamic> content;
  Pageable pageable;
  bool last;
  int totalPages;
  int totalElements;
  int size;
  int number;
  Sort sort;
  int numberOfElements;
  bool first;
  bool empty;

  DataPage(
      {this.content,
      this.pageable,
      this.last,
      this.totalPages,
      this.totalElements,
      this.size,
      this.number,
      this.sort,
      this.numberOfElements,
      this.first,
      this.empty});

  factory DataPage.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List;
    List<dynamic> contentList;
    if (list.isNotEmpty) {
      if (list[0].containsKey("gymName")) {
        contentList = list.map((i) => ClimbingGymDTO.fromJson(i)).toList();
      } else if (list[0].containsKey("routeName")) {
        contentList = list.map((i) => RouteDTO.fromJson(i)).toList();
      } else if (list[0].containsKey("login")) {
        contentList = list.map((i) => UserWithPersonalDataAccessLevelDTO.fromJson(i)).toList();
      }
    }

    return DataPage(
        content: contentList,
        pageable: Pageable.fromJson(json['pageable']),
        last: json['last'],
        totalPages: json['totalPages'],
        totalElements: json['totalElements'],
        size: json['size'],
        number: json['number'],
        sort: Sort.fromJson(json['sort']),
        numberOfElements: json['numberOfElements'],
        first: json['first'],
        empty: json['empty']);
  }
}
