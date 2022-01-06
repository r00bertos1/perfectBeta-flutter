import 'package:perfectBeta/dto/routes/photo_dto.dart';

class RouteDTO {
  //TODO: add id to DTOs
  final String routeName;
  final String difficulty;
  final String description;
  final String holdsDetails;
  final double avgRating;
  final int climbingGymId;
  final List<PhotoDTO> photos;

  RouteDTO({
    this.routeName,
    this.difficulty,
    this.description,
    this.holdsDetails,
    this.avgRating,
    this.climbingGymId,
    this.photos,
  });

  // RouteDTO.withPhotos({
  //   this.routeName,
  //   this.difficulty,
  //   this.description,
  //   this.holdsDetails,
  //   this.avgRating,
  //   this.climbingGymId,
  //   this.photos,
  // });

  factory RouteDTO.fromJson(Map<String, dynamic> json) {
    var list = json['photos'] as List;
    print(list.runtimeType);
    List<PhotoDTO> photosList = list.map((i) => PhotoDTO.fromJson(i)).toList();

    return RouteDTO(
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
