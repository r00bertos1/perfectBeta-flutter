import 'hold.dart';

class HoldsDetailsDTO {
  final List<HoldDTO> holdsDetails;

  HoldsDetailsDTO({
    this.holdsDetails,
  });

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.holdsDetails != null) {
  //     data['holdsDetails'] = this.holdsDetails.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }

  factory HoldsDetailsDTO.fromJson(List<dynamic> json) {
    List<HoldDTO> holdsDetails = json.map((i)=>HoldDTO.fromJson(i)).toList();

    return new HoldsDetailsDTO(
      holdsDetails: holdsDetails,
    );
  }
}