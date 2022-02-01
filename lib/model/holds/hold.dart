class HoldDTO {
  final int holdType;
  final int x1;
  final int x2;
  final int y1;
  final int y2;

  HoldDTO({this.holdType, this.x1, this.x2, this.y1, this.y2});

  Map<String, dynamic> toJson() => {
    'holdType': holdType,
    'x1': x1,
    'x2': x2,
    'y1': y1,
    'y2': y2
  };

  factory HoldDTO.fromJson(Map<String, dynamic> json) {
    return HoldDTO(
      holdType: json['hold_type'],
      x1: json['x1'],
      x2: json['x2'],
      y1: json['y1'],
      y2: json['y2'],
    );
  }
}