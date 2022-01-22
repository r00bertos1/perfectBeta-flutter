import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/routes/route_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/gym_details.dart';
import 'package:perfectBeta/pages/users/all_users/widgets/user_all_info_card.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

import '../../route_details.dart';
import 'my_route_details_card.dart';

/// Example without datasource
class MyRoutesTable extends StatefulWidget {
  @override
  State<MyRoutesTable> createState() => _MyRoutesTableState();
}

class _MyRoutesTableState extends State<MyRoutesTable> {
  static ApiClient _client = new ApiClient();
  var _routeEndpoint = new RouteEndpoint(_client.init());
  var _climbingGymEndpoint = new ClimbingGymEndpoint(_client.init());

  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      //padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 30),
      child: FutureBuilder<List<RouteDTO>>(
          future: _loadFavouriteRoutes(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              //print(snapshot.data);
              List<RouteDTO> list = snapshot.data;
              return _createDataTable(list);
            } else {
              return SizedBox(
                  child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }

  DataTable2 _createDataTable(list) {
    return DataTable2(
        //smRatio: 0.4,
        //lmRatio: 2.0,
        columnSpacing: 12,
        horizontalMargin: 12,
        //border: TableBorder.all(),
        //minWidth: ResponsiveWidget.isSmallScreen(context) ? 400 : 600,
        columns: _createColumns(list),
        rows: _createRows(list),
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc);
  }

  List<DataColumn> _createColumns(List<RouteDTO> list) {
    return [
      DataColumn2(
        label: Text("Route name"),
        //size: ColumnSize.L,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.routeName.compareTo(a.routeName));
            } else {
              list.sort((a, b) => a.routeName.compareTo(b.routeName));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text('Gym'),
        //size: ColumnSize.S,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.climbingGymId.compareTo(a.climbingGymId));
            } else {
              list.sort((a, b) => a.climbingGymId.compareTo(b.climbingGymId));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text('Difficulty'),
        //size: ColumnSize.S,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.difficulty.compareTo(a.difficulty));
            } else {
              list.sort((a, b) => a.difficulty.compareTo(b.difficulty));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text('Rating'),
        //size: ColumnSize.M,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.avgRating.compareTo(a.avgRating));
            } else {
              list.sort((a, b) => a.avgRating.compareTo(b.avgRating));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
    ];
  }

  List<DataRow> _createRows(List<RouteDTO> list) {
    List<DataRow> rows = [];

    list.forEach((route) {
      rows.add(DataRow(
          //NOT WORKING!!!
          // onLongPress: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             RouteDetails(routeId: route.climbingGymId),
          //       ),
          //     ),
          cells: [
            DataCell(
              CustomText(
                text: "${route.routeName}",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RouteDetailsPage(routeId: route.climbingGymId),
                  ),
                );
              },
            ),
            DataCell(
              FutureBuilder<ClimbingGymWithDetailsDTO>(
                  future: _climbingGymEndpoint.getVerifiedGymById(route.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.hasData) {
                      return Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CustomText(text: "${snapshot.data.gymName}"));
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GymDetails(gymId: route.climbingGymId),
                  ),
                );
              },
            ),
            DataCell(
              CustomText(
                text: route.difficulty,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RouteDetailsPage(routeId: route.climbingGymId),
                  ),
                );
              },
            ),
            DataCell(
              RatingBarIndicator(
                rating: route.avgRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 12.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RouteDetailsPage(routeId: route.climbingGymId),
                  ),
                );
              },
            ),
          ]));
    });
    return rows;
  }

  Future<List<RouteDTO>> _loadFavouriteRoutes() async {
    try {
      DataPage res = await _routeEndpoint.getAllFavourites();
      List<RouteDTO> routes = [];
      res.content.forEach((route) {
        routes.add(route);
      });
      return routes;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
