import 'package:perfectBeta/dto/gyms/pages/sort.dart';

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

  // Pageable.fromJson(Map<String, dynamic> json) {
  //   sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
  //   offset = json['offset'];
  //   pageNumber = json['pageNumber'];
  //   pageSize = json['pageSize'];
  //   paged = json['paged'];
  //   unpaged = json['unpaged'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.sort != null) {
  //     data['sort'] = this.sort!.toJson();
  //   }
  //   data['offset'] = this.offset;
  //   data['pageNumber'] = this.pageNumber;
  //   data['pageSize'] = this.pageSize;
  //   data['paged'] = this.paged;
  //   data['unpaged'] = this.unpaged;
  //   return data;
  // }

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
