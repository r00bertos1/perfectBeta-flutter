class PhotoDTO{
  String photoUrl;
  int routeId;

  PhotoDTO({this.photoUrl, this.routeId});

  Map<String, dynamic> toJson() {
    return {
      "photoUrl": this.photoUrl,
      "routeId": this.routeId,
    };
  }

  factory PhotoDTO.fromJson(Map<String, dynamic> json) {
    return PhotoDTO(photoUrl: json['photoUrl'], routeId: json['routeId']);
  }
}
