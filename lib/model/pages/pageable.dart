import 'package:perfectBeta/model/pages/sort.dart';

class Pageable {
  Sort sort;
  int offset;
  int pageNumber;
  int pageSize;
  bool paged;
  bool unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
        sort: Sort.fromJson(json['sort']),
        offset: json['offset'],
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        paged: json['paged'],
        unpaged: json['unpaged']);
  }
}
