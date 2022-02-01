import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/routes/route_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/gym_details.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../../../../main.dart';
import '../../route_details.dart';

class MyRoutesTable extends StatefulWidget {
  @override
  State<MyRoutesTable> createState() => _MyRoutesTableState();
}

class _MyRoutesTableState extends State<MyRoutesTable> {
  var _routeEndpoint = new RouteEndpoint(getIt.get());
  var _climbingGymEndpoint = new ClimbingGymEndpoint(getIt.get());

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
                  child: Center(child: CircularProgressIndicator.adaptive()));
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
        minWidth: ResponsiveWidget.isSmallScreen(context) ? 500 : 600,
        columns: _createColumns(list),
        rows: _createRows(list),
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc);
  }

  List<DataColumn> _createColumns(List<RouteDTO> list) {
    return [
      DataColumn2(
        label: Text("Route name"),
        size: ColumnSize.L,
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
        size: ColumnSize.L,
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
        size: ColumnSize.S,
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
        size: ColumnSize.M,
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
      DataColumn2(
        label: Text('Actions'),
        size: ColumnSize.S,
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
                        RouteDetailsPage(routeId: route.id),
                  ),
                );
              },
            ),
            DataCell(
              FutureBuilder<ClimbingGymWithDetailsDTO>(
                  future: _climbingGymEndpoint.getVerifiedGymById(route.climbingGymId),
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
                      return CircularProgressIndicator.adaptive();
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
                        RouteDetailsPage(routeId: route.id),
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
                        RouteDetailsPage(routeId: route.id),
                  ),
                );
              },
            ),
            DataCell(
              IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.all(0),
                  onPressed: () => _handleRouteDelete(context, route.id),
                  tooltip: 'delete route from favourites',
                  icon: Icon(Icons.delete)),
            ),
          ]));
    });
    return rows;
  }

  Future<List<RouteDTO>> _loadFavouriteRoutes() async {
    try {
      DataPage res = await _routeEndpoint.getAllFavourites();
      List<RouteDTO> routes = [];
      if (res.content != null) {
        res.content.forEach((route) {
          routes.add(route);
        });
      }
      return routes;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  void _handleRouteDelete(context, routeId) async {
    try {
      var res = await _routeEndpoint.removeRouteFromFavourites(routeId);
      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Route removed!');
        setState(() {});
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
