import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/data_functions.dart';
import 'package:perfectBeta/helpers/util_functions.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/gym_details.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

import '../add_maintainer_to_gym.dart';

class GymsTableManager extends StatefulWidget {
  @override
  State<GymsTableManager> createState() => _GymsTableManagerState();
}

class _GymsTableManagerState extends State<GymsTableManager> {

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  final tableWidgets = List<Widget>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
            Wrap(
              spacing: 20,
              children: <Widget>[
                InkWell(
                  onTap: () => _buildOwnedGymsTable(),
                  child: Container(
                    decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: "Owned",
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _buildMaintainedGymsTable(),
                  child: Container(
                    decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: 150,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: "Maintained",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ] +
          tableWidgets,
    );
  }

  DataTable2 _createDataTable(list) {
    return DataTable2(
        smRatio: 0.5,
        lmRatio: 1.6,
        columnSpacing: 12,
        horizontalMargin: 12,
        //border: TableBorder.all(),
        minWidth: ResponsiveWidget.isSmallScreen(context) ? 500 : 600,
        columns: _createColumns(list),
        rows: _createRows(list),
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc);
  }

  List<DataColumn> _createColumns(List<ClimbingGymDTO> list) {
    return [
      DataColumn2(
        label: Text("Gym name"),
        size: ColumnSize.M,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.gymName.compareTo(a.gymName));
            } else {
              list.sort((a, b) => a.gymName.compareTo(b.gymName));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text("Owner"),
        size: ColumnSize.S,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.ownerId.compareTo(a.ownerId));
            } else {
              list.sort((a, b) => a.ownerId.compareTo(b.ownerId));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text('Status'),
        size: ColumnSize.S,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.status.toString().compareTo(a.status.toString()));
            } else {
              list.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: Text('Actions'),
        tooltip: 'add maintainer, or add wall to gym',
        //size: ColumnSize.L,
      ),
    ];
  }

  List<DataRow> _createRows(List<ClimbingGymDTO> list) {
    List<DataRow> rows = [];

    list.forEach((gym) {
      rows.add(DataRow(cells: [
        DataCell(
          CustomText(
            text: "${gym.gymName}",
          ),
        ),
        DataCell(
          CustomText(
            text: "${gym.ownerId}",
          ),
        ),
        DataCell(
          parseGymEnum(gym.status),
        ),
        DataCell(
          FutureBuilder<int>(
              future: getCurrentUserId(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  return Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Visibility(
                        visible: snapshot.data == gym.ownerId,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddMaintainerToGymPage(gymId: gym.id),
                                ),
                              );
                            },
                            tooltip: 'add maintainer to gym',
                            icon: Icon(Icons.person_add)),
                      ),
                      // Visibility(
                      //   visible: (snapshot.data == gym.ownerId) && (gym.status == GymStatusEnum.VERIFIED),
                      //   child: IconButton(
                      //       padding: EdgeInsets.all(0),
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) =>
                      //                 EditGymDetailsPage(gymId: gym.id),
                      //           ),
                      //         );
                      //       },
                      //       tooltip: 'edit gym details',
                      //       icon: Icon(Icons.edit)),
                      // ),
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            menuController.changeActiveItemTo(addRoutePageDisplayName);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddRoutePage(gymId: gym.id),
                              ),
                            );
                          },
                          tooltip: 'add route to gym',
                          icon: Icon(Icons.add)),
                      Visibility(
                        visible: (gym.status == GymStatusEnum.VERIFIED),
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GymDetails(gymId: gym.id),
                                ),
                              );
                            },
                            tooltip: 'view details',
                            icon: Icon(Icons.visibility)),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator.adaptive();
                }
              }),
        ),
      ]));
    });
    return rows;
  }

  void _buildOwnedGymsTable() {
    var table = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
        borderRadius: BorderRadius.circular(8),
      ),
      //padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 30),
      child: FutureBuilder<List<ClimbingGymDTO>>(
          future: loadOwnedGyms(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              //print(snapshot.data);
              List<ClimbingGymDTO> list = snapshot.data;
              return _createDataTable(list);
            } else {
              return SizedBox(child: Center(child: CircularProgressIndicator.adaptive()));
            }
          }),
    );
    setState(() {
      tableWidgets.clear();
      tableWidgets.add(table);
    });
  }

  void _buildMaintainedGymsTable() {
    var table = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
        borderRadius: BorderRadius.circular(8),
      ),
      //padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 30),
      child: FutureBuilder<List<ClimbingGymDTO>>(
          future: loadMaintainedGyms(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              //print(snapshot.data);
              List<ClimbingGymDTO> list = snapshot.data;
              return _createDataTable(list);
            } else {
              return SizedBox(child: Center(child: CircularProgressIndicator.adaptive()));
            }
          }),
    );
    setState(() {
      tableWidgets.clear();
      tableWidgets.add(table);
    });
  }
}
