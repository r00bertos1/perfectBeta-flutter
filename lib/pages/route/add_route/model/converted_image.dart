class ConvertedImage {
  final int holdType;
  final int x1;
  final int x2;
  final int y1;
  final int y2;

  ConvertedImage({this.holdType, this.x1, this.x2, this.y1, this.y2});

  factory ConvertedImage.fromJson(Map<String, dynamic> json) {
    return ConvertedImage(
      holdType: json['hold_type'],
      x1: json['x1'],
      x2: json['x2'],
      y1: json['y1'],
      y2: json['y2'],
    );
  }
}