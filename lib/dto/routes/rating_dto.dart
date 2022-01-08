class RatingDTO {
  final int id;
  final String comment;
  final double rate;
  final int routeId;
  final int userId;

  RatingDTO({this.id, this.comment, this.rate, this.routeId, this.userId});

  factory RatingDTO.fromJson(Map<String, dynamic> json) {
    return RatingDTO(
        id: json['id'],
        comment: json['comment'],
        rate: json['rate'],
        routeId: json['routeId'],
        userId: json['userId']);
  }
}
