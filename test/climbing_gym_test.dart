// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:perfectBeta/api/api_client.dart';
// import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
// import 'package:perfectBeta/constants/enums.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:perfectBeta/model/gyms/climbing_gym_with_details_dto.dart';
//
// class MockApiClient extends Mock implements ApiClient {}
//
// void main() {
//   test('Get climbing gym by id', () async {
//     final mockApiClient = MockApiClient().init();
//     final mockClimbingGymEndpoint = ClimbingGymEndpoint(mockApiClient);
//     // when(() => mockClimbingGymEndpoint.getGymById(-3))
//     //     .thenAnswer((_) => Future.value(climbingGymWithDetailsDTO));
//
//     // run
//     ClimbingGymWithDetailsDTO climbingGym = await mockClimbingGymEndpoint.getGymById(-3);
//     // verify
//     expect(climbingGym, ClimbingGymWithDetailsDTO(id: -3, ownerId: -1, gymName: 'testGym_verified', status: GymStatusEnum.VERIFIED,));
//   });
// }
