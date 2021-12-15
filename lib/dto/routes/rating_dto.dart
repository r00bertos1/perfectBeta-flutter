class RatingDTO {
  final String comment;
  final double rate;
  final int routeId;
  final int userId;

  RatingDTO({
    this.comment,
    this.rate,
    this.routeId,
    this.userId
  });

  factory RatingDTO.fromJson(Map<String, dynamic> json) {
    return RatingDTO(
      comment: json['comment'],
      rate: json['rate'],
      routeId: json['routeId'],
      userId: json['userId']
    );
  }
}
