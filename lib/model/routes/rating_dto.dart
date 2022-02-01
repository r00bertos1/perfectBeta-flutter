class RatingDTO {
  final int id;
  final String comment;
  final String username;
  final double rate;
  final int routeId;
  final int userId;

  RatingDTO({this.id, this.comment, this.username, this.rate, this.routeId, this.userId});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "comment": this.comment,
      "username": this.username,
      "rate": this.rate,
      "routeId": this.routeId,
      "userId": this.userId,
    };
  }

  factory RatingDTO.fromJson(Map<String, dynamic> json) {
    return RatingDTO(
        id: json['id'],
        comment: json['comment'],
        username: json['username'],
        rate: json['rate'],
        routeId: json['routeId'],
        userId: json['userId']);
  }
}
