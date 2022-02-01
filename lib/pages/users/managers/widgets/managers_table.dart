import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/api/providers/manager_endpoint.dart';
import 'package:perfectBeta/api/providers/user_endpoint.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/users/managers/widgets/manager_info_card.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import '../../../../main.dart';

class ManagersTable extends StatefulWidget {
  @override
  State<ManagersTable> createState() => _ManagersTableState();
}

class _ManagersTableState extends State<ManagersTable> {
  var _userEndpoint = new UserEndpoint(getIt.get());
  var _managerEndpoint = new ManagerEndpoint(getIt.get());

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

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
      child: FutureBuilder<List<UserWithPersonalDataAccessLevelDTO>>(
          future: _loadUsers(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              //print(snapshot.data);
              List<UserWithPersonalDataAccessLevelDTO> list = snapshot.data;
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
        smRatio: 0.4,
        lmRatio: 2.0,
        columnSpacing: 12,
        horizontalMargin: 12,
        //border: TableBorder.all(),
        minWidth: ResponsiveWidget.isSmallScreen(context) ? 600 : 600,
        columns: _createColumns(list),
        rows: _createRows(list),
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc);
  }

  List<DataColumn> _createColumns(
      List<UserWithPersonalDataAccessLevelDTO> list) {
    return [
      DataColumn2(
        label: Text('ID'),
        tooltip: 'ID of manager account',
        size: ColumnSize.S,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.id.compareTo(a.id));
            } else {
              list.sort((a, b) => a.id.compareTo(b.id));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text("Username"),
        size: ColumnSize.M,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.login.compareTo(a.login));
            } else {
              list.sort((a, b) => a.login.compareTo(b.login));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text('Email'),
        size: ColumnSize.L,
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              list.sort((a, b) => b.email.compareTo(a.email));
            } else {
              list.sort((a, b) => a.email.compareTo(b.email));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn2(
        label: Text('Active'),
        tooltip: 'this will disable/enable manager access level',
        size: ColumnSize.S,
      ),
      DataColumn2(
        label: Text('Verified'),
        tooltip: 'is user account verified',
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> _createRows(List<UserWithPersonalDataAccessLevelDTO> list) {
    List<DataRow> rows = [];

    list.forEach((user) {
      user.accessLevels.forEach((level) {
        if(level.accessLevel == 'MANAGER') {
          rows.add(DataRow(
            //NOT WORKING!!!
            // onLongPress: () {
            //   _showDetails(context, user);
            // },
              color: (user.login[0] == '#')
                  ? MaterialStateProperty.all<Color>(lightGrey.withOpacity(0.2))
                  : null,
              cells: [
                DataCell(
                  CustomText(
                      text: "${user.id}",
                      color: (user.login[0] == '#') ? lightGrey : null),
                  onTap: () {
                    _showDetails(context, user);
                  },
                ),
                DataCell(
                  CustomText(
                      text: user.login,
                      color: (user.login[0] == '#') ? lightGrey : null),
                  onTap: () {
                    _showDetails(context, user);
                  },
                ),
                DataCell(
                  CustomText(
                      text: user.email,
                      color: (user.login[0] == '#') ? lightGrey : null),
                  onTap: () {
                    _showDetails(context, user);
                  },
                ),
                DataCell(Switch.adaptive(
                  onChanged: (bool value) {
                    toggleSwitch(value, user);
                  },
                  value: level.isActive,
                )),
                DataCell(
                  Icon(
                    user.isVerified ? Icons.verified : Icons.block,
                    color: user.isVerified ? active : error,
                  ),
                  onTap: () {
                    _showDetails(context, user);
                  },
                ),
              ]));
        }
      });
    });
    return rows;
  }

  void toggleSwitch(bool value,UserWithPersonalDataAccessLevelDTO user) async {
    if (value == true) {
      var res = await _managerEndpoint.activateManager(user.id);
      res.accessLevels.forEach((level) {
        if(level.accessLevel == 'MANAGER' && level.isActive == true) {
          setState(() {
            textValue = 'Manager activated';
          });
        }
      });
    } else {
      var res = await _managerEndpoint.deactivateManager(user.id);
      res.accessLevels.forEach((level) {
        if(level.accessLevel == 'MANAGER' && level.isActive == false) {
          setState(() {
            textValue = 'Manager deactivated';
          });
        }
      });
    }
  }

  Future<List<UserWithPersonalDataAccessLevelDTO>> _loadUsers() async {
    try {
      DataPage res = await _userEndpoint.getAllUsers();
      List<UserWithPersonalDataAccessLevelDTO> users = [];
      res.content.forEach((user) {
        users.add(user);
      });
      return users;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  void _showDetails(BuildContext context,
          UserWithPersonalDataAccessLevelDTO data) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => ManagerInfoCard(
          data: data,
        ),
      );
}
