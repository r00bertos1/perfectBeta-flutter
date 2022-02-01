import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/constants/enums.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/data_functions.dart';
import 'package:perfectBeta/helpers/util_functions.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/model/holds/holds_details_dto.dart';
import 'package:perfectBeta/model/routes/photo_dto.dart';
import 'package:perfectBeta/model/routes/route_dto.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/routing/routes.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfectBeta/model/holds/hold.dart';
import 'dart:io';
import '../../../../main.dart';
final uploadImageURL = 'https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload';

class AddSteps extends StatefulWidget {
  const AddSteps({Key key, this.gymId}) : super(key: key);
  final int gymId;

  @override
  _AddStepsState createState() => _AddStepsState();
}

class _AddStepsState extends State<AddSteps> {
  Size safeAreaSize;
  int currentStep = 0;
  bool complete = false;

  //API
  var _routeEndpoint = new RouteEndpoint(getIt.get());

  //stepOne
  var _image;
  var _imageFile;
  String _imagePath = '';

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  //stepTwo
  bool _firstStepCompleted = false;
  bool _isScanned = false;
  String _holdsDetails = 'json';

  //stepThree
  final _routeNameController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _gym;
  List<ClimbingGymDTO> mergedGyms = [];
  List<DropdownMenuItem<String>> gyms = [];

  //to upload photos
  List<XFile> _imageXFileList = [];
  List<File> _finalImageFileList = [];
  List<PhotoDTO> _photos = [];

  bool _submitted = false;
  final _addRouteDetailsFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _routeNameController.dispose();
    _difficultyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  next() {
    currentStep + 1 != getSteps().length ? goTo(currentStep + 1) : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQD = MediaQuery.of(context);
    safeAreaSize = mediaQD.size;
    return Theme(
      data: Theme.of(context).copyWith(
        backgroundColor: error,
        colorScheme: ColorScheme.light(primary: active),
      ),
      child: Stepper(
        type: StepperType.horizontal,
        elevation: 0,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          final isLastStep = currentStep == getSteps().length - 1;
          if (currentStep == 0) {
            //_submit(_imagePath);
            setState(() {
              currentStep += 1;
              _firstStepCompleted = true;
            });
          } else if (isLastStep) {
            setState(() => _submitted = true);
          } else {
            setState(() => currentStep += 1);
          }
        },
        //onStepTapped: (step) => setState(() => currentStep = step),
        onStepCancel: currentStep == 0 ? null : () => setState(() => currentStep -= 1),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = currentStep == getSteps().length - 1;
          return Container(
              margin: ResponsiveWidget.isSmallScreen(context) ? const EdgeInsets.only(top: 0.0) : const EdgeInsets.only(top: 20.0),
              child: currentStep == 0
                  ? ElevatedButton(
                      onPressed: () => _image != null ? details.onStepContinue() : null,
                      child: Text('Continue'),
                    )
                  : currentStep == 1
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: Text('Back'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                onPressed: _isScanned != true ? details.onStepContinue : null,
                                child: Text('Continue'),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: Text('Back'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_addRouteDetailsFormKey.currentState.validate()) {
                                    _handleAddRoute().then((val) => val ? Navigator.of(context).popAndPushNamed(rootRoute) : null);
                                  }
                                },
                                child: Text('Finish'),
                              ),
                            ),
                          ],
                        ));
        },
      ),
    );
  }

  List<Step> getSteps() => [
        _stepOne(),
        _stepTwo(),
        _stepThree(),
      ];

  Step _stepOne() => Step(
        state: currentStep <= 0 ? StepState.indexed : StepState.complete,
        isActive: currentStep >= 0,
        title: Text(currentStep == 0 ? "Add Photo" : ""),
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
            boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: _image == null,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16, top: 8),
                      child: CustomText(
                        text: 'Add your climbing wall photo',
                        color: lightGrey,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _image != null
                      ? Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: kIsWeb
                                  ? Container(
                                      child: _image,
                                      width: ResponsiveWidget.isSmallScreen(context) ? safeAreaSize.width : safeAreaSize.width,
                                      height: ResponsiveWidget.isSmallScreen(context) ? safeAreaSize.height - 500 : 600,
                                    )
                                  : Image.file(_image,
                                      width: ResponsiveWidget.isSmallScreen(context) ? safeAreaSize.width : safeAreaSize.width,
                                      height: ResponsiveWidget.isSmallScreen(context) ? safeAreaSize.height - 500 : 600,
                                      fit: BoxFit.cover),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(color: lightGrey),
                                width: ResponsiveWidget.isSmallScreen(context) ? safeAreaSize.width : safeAreaSize.width,
                                height: ResponsiveWidget.isSmallScreen(context) ? safeAreaSize.height - 500 : 600,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: dark,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: kIsWeb ? Text('Select photo form filesystem') : Text('Take a photo or choose from gallery'),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      );

  Step _stepTwo() {
    return Step(
        state: currentStep <= 1 ? StepState.indexed : StepState.complete,
        isActive: currentStep >= 1,
        title: Text(currentStep == 1 ? "Verify holds" : ""),
        content: (_firstStepCompleted == false) ? buildColumn() : buildFutureBuilder());
  }

  Step _stepThree() => Step(
        state: currentStep <= 2 ? StepState.indexed : StepState.complete,
        isActive: currentStep >= 2,
        title: Text(currentStep == 2 ? "Details" : ""),
        content: Form(
          key: _addRouteDetailsFormKey,
          child: Container(
            //constraints: BoxConstraints(maxWidth: 400),
            //padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Add more photos (optional)",
                  //size: 20,
                  //weight: FontWeight.bold,
                ),
                _buildImageGrid(),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    String pattern = r'(^[A-Za-zÀ-ÖØ-öø-ÿżźćńółęąśŻŹĆĄŚĘŁÓŃ0-9\s]{2,50}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Please enter route name';
                    } else if (value.length < 2) {
                      return 'Name must be at least 2 characters long';
                    } else if (value.length > 50) {
                      return 'Name cannot be longer than 50 characters';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid route name (no special characters)';
                    }
                    return null;
                  },
                  controller: _routeNameController,
                  decoration: InputDecoration(
                      errorMaxLines: 3,
                      labelText: "Route Name",
                      hintText: "Enter route name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    String pattern = r'(^(\d[abc][+-]|\d[abc]|\d[+-]|\d){0,1}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Please enter difficulty';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid difficulty in Fontainebleau grading system, eg. 5, 5+, 6a, 6c+';
                    }
                    return null;
                  },
                  controller: _difficultyController,
                  decoration: InputDecoration(
                      errorMaxLines: 3,
                      labelText: "Difficulty",
                      hintText: "Enter route difficulty",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    String pattern = r'(^[^<>%\$#@!%&*;{}]{0,300}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    } else if (value.length > 300) {
                      return 'Description cannot be longer than 300 characters';
                    } else if (!regExp.hasMatch(value)) {
                      return "Description cannot have special characters (eg. \$#@!% )";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      errorMaxLines: 3,
                      labelText: "Description",
                      hintText: "Enter gym description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<ClimbingGymDTO>>(
                    future: getMaintainedAndOwnedGyms(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error");
                        }
                        if (snapshot.hasData) {
                          mergedGyms = snapshot.data;
                          gyms = putGymsIntoDropdown(mergedGyms);
                          _gym = widget.gymId != null ? widget.gymId.toString() : snapshot.data[0].id.toString();
                          return DropdownButtonFormField(
                            isExpanded: true,
                            validator: (value) => value == null ? "Select a gym" : null,
                            hint: Text(
                              'Select gym',
                            ),
                            decoration: InputDecoration(labelText: "Gym", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                            onChanged: (value) {
                              //_gym = gyms[value].value;
                              _gym = value;
                              // setState(() {
                              //   selectedItemName =
                              //       dropDownItemsMap[_selectedItem].itemName;
                              // });
                              // setState(() {
                              //   _gym = value;
                              // });
                            },
                            value: _gym,
                            items: gyms,
                          );
                        } else {
                          return Text("No data");
                        }
                      } else
                        return SizedBox(child: Center(child: CircularProgressIndicator.adaptive()));
                    }),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Create Data'),
      ],
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
                child: kIsWeb
                    ? Wrap(
                        children: <Widget>[
                          ListTile(
                              leading: new Icon(Icons.photo_library),
                              title: new Text('File system'),
                              onTap: () {
                                _imgFromSource(ImageSourceType.gallery);
                                Navigator.of(context).pop();
                              })
                        ],
                      )
                    : Wrap(
                        children: <Widget>[
                          ListTile(
                              leading: new Icon(Icons.photo_library),
                              title: new Text('Photo Library'),
                              onTap: () {
                                _imgFromSource(ImageSourceType.gallery);
                                Navigator.of(context).pop();
                              }),
                          ListTile(
                            leading: new Icon(Icons.photo_camera),
                            title: new Text('Camera'),
                            onTap: () {
                              _imgFromSource(ImageSourceType.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )),
          );
        });
  }

  FutureBuilder<HoldsDetailsDTO> buildFutureBuilder() {
    return FutureBuilder<HoldsDetailsDTO>(
        future: getHoldDataFromImage(_imageFile),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              width: 1,
            );
          } else if (snapshot.hasData) {
            //snapshot.data.holdsDetails[0].holdType
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                      boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: kIsWeb
                        ? Image.network(_imageFile.path)
                        : Image.file(
                            File(_imageFile.path),
                          )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                    boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      CustomText(
                        text: "Holds",
                        color: lightGrey,
                        weight: FontWeight.bold,
                      ),
                      _createHoldsDataTable(snapshot.data.holdsDetails),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                  boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 30),
                child: Center(
                    child: Column(
                  children: [
                    CustomText(
                      text: 'Processing image. Please wait...',
                      size: 14,
                      color: lightGrey,
                    ),
                    SizedBox(height: 10,),
                    CircularProgressIndicator.adaptive(),
                  ],
                )));
          }
        });
  }

  DataTable2 _createHoldsDataTable(List<HoldDTO> list) {
    return DataTable2(
      //smRatio: 0.4,
      //lmRatio: 2.0,
      columnSpacing: 12,
      horizontalMargin: 12,
      //border: TableBorder.all(),
      minWidth: ResponsiveWidget.isSmallScreen(context) ? 500 : 600,
      columns: _createColumns(list),
      rows: _createRows(list),
      //sortColumnIndex: _currentSortColumn,
      //sortAscending: _isSortAsc
    );
  }

  List<DataColumn> _createColumns(List<HoldDTO> list) {
    return [
      DataColumn2(
        label: Text("Hold number"),
        size: ColumnSize.S,
      ),
      DataColumn2(
        label: Text('x1'),
        size: ColumnSize.M,
      ),
      DataColumn2(
        label: Text('x2'),
        size: ColumnSize.M,
      ),
      DataColumn2(
        label: Text('y1'),
        size: ColumnSize.M,
      ),
      DataColumn2(
        label: Text('y2'),
        size: ColumnSize.S,
      ),
      DataColumn2(
        label: Text('Remove'),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> _createRows(List<HoldDTO> list) {
    List<DataRow> rows = [];

    list.forEach((hold) {
      rows.add(DataRow(cells: [
        DataCell(
          CustomText(
            text: "${(list.indexOf(hold) + 1).toString()}",
          ),
        ),
        DataCell(
          CustomText(
            text: "${hold.x1}",
          ),
        ),
        DataCell(
          CustomText(
            text: "${hold.x2}",
          ),
        ),
        DataCell(
          CustomText(
            text: "${hold.y1}",
          ),
        ),
        DataCell(
          CustomText(
            text: "${hold.y2}",
          ),
        ),
        DataCell(
          IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.all(0),
              onPressed: () => {},
              tooltip: 'delete hold',
              icon: Icon(Icons.delete)),
        ),
      ]));
    });
    return rows;
  }

  Widget _buildImageGrid() {
    if (_imageXFileList != null) {
      return GridView.builder(
        itemCount: _imageXFileList.length + 1,
        padding: const EdgeInsets.symmetric(vertical: 15),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: ResponsiveWidget.isSmallScreen(context) ? 10 : 20,
          mainAxisSpacing: ResponsiveWidget.isSmallScreen(context) ? 10 : 20,
          // childAspectRatio: MediaQuery.of(context).size.width /
          //     (MediaQuery.of(context).size.height),
          crossAxisCount: ResponsiveWidget.isSmallScreen(context)
              ? 3
              : ResponsiveWidget.isMediumScreen(context)
                  ? 4
                  : ResponsiveWidget.isLargeScreen(context)
                      ? 6
                      : 8,
        ),
        itemBuilder: (context, index) {
          return _buildImageGridTiles(context, index);
        },
      );
    } else {
      return InkWell(
        onTap: () => _multiImgFromSource(),
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(99)),
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildImageGridTiles(context, index) {
    return index != _imageXFileList.length
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: lightGrey.withOpacity(.4), width: .5),
                boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  GridTile(
                    child: kIsWeb ? Image.network(_imageXFileList[index].path) : Image.file(File(_imageXFileList[index].path)),
                  ),
                  Positioned(
                    right: 5.0,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 25,
                        color: error,
                      ),
                      onTap: () {
                        setState(
                          () {
                            _imageXFileList.removeAt(index);
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () => _multiImgFromSource(),
            child: FittedBox(
              child: Container(
                decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(99)),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  // Future<void> retrieveLostData() async {
  //   final LostDataResponse response = await _picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       _imageFile = response.file;
  //       _imageXFileList = response.files;
  //     });
  //   } else {
  //     String _retrieveDataError = response.exception.code;
  //   }
  // }

  Future<bool> _handleAddRoute() async {
    try {
      List<String> list = await getLinksListFromAllImages(_imageXFileList, _finalImageFileList);
      for (String link in list) {
        PhotoDTO photoDTO = new PhotoDTO(photoUrl: link);
        print('PHOTO:' + photoDTO.photoUrl);
        _photos.add(photoDTO);
      }
      RouteDTO routeData = new RouteDTO(
          routeName: _routeNameController.text.trim() ?? "",
          difficulty: _difficultyController.text.trim() ?? "",
          description: _descriptionController.text.trim() ?? "",
          climbingGymId: int.parse(_gym),
          holdsDetails: _holdsDetails ?? "json",
          photos: _photos ?? []);
      menuController.changeActiveItemTo(overviewPageDisplayName);
      var res = await _routeEndpoint.addWallToGym(routeData);
      if (res != null) {
        if (res.statusCode == 200) {
          EasyLoading.showSuccess('Route ${routeData.routeName} added!');
          return true;
        }
      }
      return false;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future _imgFromSource(type) async {
    try {
      if (kIsWeb) {
        var source = type == ImageSourceType.camera ? ImageSource.camera : ImageSource.gallery;
        XFile image = await _picker.pickImage(source: source, imageQuality: 100, preferredCameraDevice: CameraDevice.front);
        setState(() {
          _image = Image.network(image.path);
          _imagePath = image.path;
          _imageFile = image;
        });
      } else {
        var source = type == ImageSourceType.camera ? ImageSource.camera : ImageSource.gallery;
        XFile image = await _picker.pickImage(source: source, imageQuality: 100, preferredCameraDevice: CameraDevice.front);
        setState(() {
          _image = File(image.path);
          _imagePath = image.path;
          _imageFile = image;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future _multiImgFromSource() async {
    try {
      List<XFile> images = await _picker.pickMultiImage(maxWidth: 1000, maxHeight: 1000);
      setState(() {
        _imageXFileList = images;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
}
