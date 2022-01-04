class Sort {
  bool unsorted;
  bool sorted;
  bool empty;

  Sort({this.unsorted, this.sorted, this.empty});

  // Sort.fromJson(Map<String, dynamic> json) {
  //   unsorted = json['unsorted'];
  //   sorted = json['sorted'];
  //   empty = json['empty'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['unsorted'] = this.unsorted;
  //   data['sorted'] = this.sorted;
  //   data['empty'] = this.empty;
  //   return data;
  // }

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
        unsorted: json['unsorted'],
        sorted: json['sorted'],
        empty: json['empty']);
  }
}