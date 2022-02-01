import 'package:perfectBeta/model/routes/photo_dto.dart';

class RouteDTO {
  final int id;
  final String routeName;
  final String difficulty;
  final String description;
  final String holdsDetails;
  final double avgRating;
  final int climbingGymId;
  final List<PhotoDTO> photos;

  RouteDTO({
    this.id,
    this.routeName,
    this.difficulty,
    this.description,
    this.holdsDetails,
    this.avgRating,
    this.climbingGymId,
    this.photos,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['routeName'] = this.routeName;
    data['difficulty'] = this.difficulty;
    data['description'] = this.description;
    data['holdsDetails'] = this.holdsDetails;
    data['avgRating'] = this.avgRating;
    data['climbingGymId'] = this.climbingGymId;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory RouteDTO.fromJson(Map<String, dynamic> json) {
    var list = json['photos'] as List;
    List<PhotoDTO> photosList = list.map((i) => PhotoDTO.fromJson(i)).toList();

    return RouteDTO(
      id: json['id'],
      routeName: json['routeName'],
      difficulty: json['difficulty'],
      description: json['description'],
      holdsDetails: json['holdsDetails'],
      avgRating: json['avgRating'],
      climbingGymId: json['climbingGymId'],
      photos: photosList,
    );
  }
}
