class Sort {
  bool unsorted;
  bool sorted;
  bool empty;

  Sort({this.unsorted, this.sorted, this.empty});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
        unsorted: json['unsorted'],
        sorted: json['sorted'],
        empty: json['empty']);
  }
}