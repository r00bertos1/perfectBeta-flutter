import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/climbing_gym_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/gym/gym_details.dart';
import 'package:perfectBeta/pages/route/add_route/add_route.dart';
import 'package:perfectBeta/pages/users/all_users/widgets/user_all_info_card.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

import '../add_maintainer_to_gym.dart';
import '../edit_gym_details.dart';

/// Example without datasource
class GymsTableManager extends StatefulWidget {
  static ApiClient _client = new ApiClient();
  @override
  State<GymsTableManager> createState() => _GymsTableManagerState();
}

class _GymsTableManagerState extends State<GymsTableManager> {
  var _userEndpoint = new UserEndpoint(GymsTableManager._client.init());
  var _climbingGymEndpoint =
      new ClimbingGymEndpoint(GymsTableManager._client.init());

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
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(20)),
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
                    decoration: BoxDecoration(
                        color: active, borderRadius: BorderRadius.circular(20)),
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
              list.sort(
                  (a, b) => b.status.toString().compareTo(a.status.toString()));
            } else {
              list.sort(
                  (a, b) => a.status.toString().compareTo(b.status.toString()));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: Text('Actions'),
        tooltip: 'add maintainer, edit gym details or add wall to gym',
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GymDetails(gymId: gym.id),
              ),
            );
          },
        ),
        DataCell(
          CustomText(
            text: "${gym.ownerId}",
          ),
          // FutureBuilder<UserWithPersonalDataAccessLevelDTO>(
          //     future: _userEndpoint.getUserById(gym.ownerId),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) {
          //         return Container();
          //       } else if (snapshot.hasData) {
          //         return Container(
          //             alignment: Alignment.center,
          //             width: double.maxFinite,
          //             padding: EdgeInsets.symmetric(vertical: 16),
          //             child: CustomText(text: "${snapshot.data.login}"));
          //       } else {
          //         return CircularProgressIndicator();
          //       }
          //     }),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GymDetails(gymId: gym.id),
              ),
            );
          },
        ),
        DataCell(
          _parseGymEnum(gym.status),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GymDetails(gymId: gym.id),
              ),
            );
          },
        ),
        DataCell(
          FutureBuilder<int>(
              future: _getCurrentUserId(),
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
                                  builder: (context) =>
                                      AddMaintainerToGymPage(gymId: gym.id),
                                ),
                              );
                            },
                            tooltip: 'add maintainer to gym',
                            icon: Icon(Icons.person_add)),
                      ),
                      Visibility(
                        visible: snapshot.data == gym.ownerId,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditGymDetailsPage(gymId: gym.id),
                                ),
                              );
                            },
                            tooltip: 'edit gym details',
                            icon: Icon(Icons.edit)),
                      ),
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            menuController.changeActiveItemTo(addRoutePageDisplayName);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddRoutePage(gymId: gym.id),
                              ),
                            );
                          },
                          tooltip: 'add route to gym',
                          icon: Icon(Icons.add)),
                      IconButton(
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
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
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
      child: FutureBuilder<List<ClimbingGymDTO>>(
          future: _loadOwnedGyms(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              //print(snapshot.data);
              List<ClimbingGymDTO> list = snapshot.data;
              return _createDataTable(list);
            } else {
              return SizedBox(
                  child: Center(child: CircularProgressIndicator()));
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
      child: FutureBuilder<List<ClimbingGymDTO>>(
          future: _loadMaintainedGyms(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              //print(snapshot.data);
              List<ClimbingGymDTO> list = snapshot.data;
              return _createDataTable(list);
            } else {
              return SizedBox(
                  child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
    setState(() {
      tableWidgets.clear();
      tableWidgets.add(table);
    });
  }

  Widget _parseGymEnum(data) {
    switch (data) {
      case GymStatusEnum.UNVERIFIED:
        return CustomText(text: "Unverified", color: Colors.amberAccent);
      case GymStatusEnum.VERIFIED:
        return CustomText(text: "Verified", color: active);
      case GymStatusEnum.CLOSED:
        return CustomText(text: "Closed", color: error);
    }
  }

  Future<List<ClimbingGymDTO>> _loadMaintainedGyms() async {
    try {
      DataPage res = await _climbingGymEndpoint.getAllMaintainedGyms();
      List<ClimbingGymDTO> gyms = [];
      if (res.content != null) {
        res.content.forEach((gym) {
          gyms.add(gym);
        });
      }
      return gyms;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<List<ClimbingGymDTO>> _loadOwnedGyms() async {
    try {
      DataPage res = await _climbingGymEndpoint.getAllOwnedGyms();
      List<ClimbingGymDTO> gyms = [];
      res.content.forEach((gym) {
        gyms.add(gym);
      });
      return gyms;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<int> _getCurrentUserId() async {
    try {
      UserWithPersonalDataAccessLevelDTO res =
          await _userEndpoint.getUserPersonalDataAccessLevel();
      return res.id;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
