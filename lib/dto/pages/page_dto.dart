import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/dto/pages/pageable.dart';
import 'package:perfectBeta/dto/pages/sort.dart';
import 'package:perfectBeta/dto/routes/route_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';

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

  // GymPage.fromJson(Map<String, dynamic> json) {
  //   if (json['content'] != null) {
  //     content = <Content>[];
  //     json['content'].forEach((v) {
  //       content!.add(new Content.fromJson(v));
  //     });
  //   }
  //   pageable = json['pageable'] != null
  //       ? new Pageable.fromJson(json['pageable'])
  //       : null;
  //   last = json['last'];
  //   totalPages = json['totalPages'];
  //   totalElements = json['totalElements'];
  //   size = json['size'];
  //   number = json['number'];
  //   sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
  //   numberOfElements = json['numberOfElements'];
  //   first = json['first'];
  //   empty = json['empty'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.content != null) {
  //     data['content'] = this.content!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.pageable != null) {
  //     data['pageable'] = this.pageable!.toJson();
  //   }
  //   data['last'] = this.last;
  //   data['totalPages'] = this.totalPages;
  //   data['totalElements'] = this.totalElements;
  //   data['size'] = this.size;
  //   data['number'] = this.number;
  //   if (this.sort != null) {
  //     data['sort'] = this.sort!.toJson();
  //   }
  //   data['numberOfElements'] = this.numberOfElements;
  //   data['first'] = this.first;
  //   data['empty'] = this.empty;
  //   return data;
  // }

  factory DataPage.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List;
    //print(list.toString());
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
