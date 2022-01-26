import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/pages/route/add_route/util/steps_params.dart';
import 'package:perfectBeta/pages/route/add_route/widgets/step_progress_view.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:perfectBeta/pages/route/add_route/model/converted_image.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

final uploadImageURL =
    'https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload';

class StepTwo extends StatefulWidget {
  final Size safeAreaSize;
  final int currentPage;
  final Function(int) onDataChange;
  final String imagePath;
  const StepTwo(
      {Key key,
      @required this.safeAreaSize,
      @required this.currentPage,
      @required this.onDataChange,
      @required this.imagePath})
      : super(key: key);

  @override
  _StepTwo createState() => _StepTwo();
}

class _StepTwo extends State<StepTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          height: ResponsiveWidget.isSmallScreen(context) ? 100 : 150,
          child: _getStepProgress()),
      Expanded(
        child: Container(
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
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    text: "Holds",
                    color: lightGrey,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.imagePath}'),
                // child: widget.imagePath.isEmpty
                //     ? buildFutureBuilder(widget.imagePath)
                //     : Text("Image path is empty"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

// Container buildContainer(context) {
//   return Container(
//     margin: ResponsiveWidget.isSmallScreen(context)
//         ? const EdgeInsets.only(top: 0.0)
//         : const EdgeInsets.only(top: 20.0),
//     child: ElevatedButton(
//       //style: _buttonStyle,
//       onPressed: _image != null ? () => _submit(stepController.page) : null,
//       child: Text('Continue'),
//     ),
//   );
// }

// FutureBuilder<List<ConvertedImage>> buildFutureBuilder2() {
//   return FutureBuilder<List<ConvertedImage>>(
//     future: widget.convertedImage,
//     builder: (context, snapshot) {
//       print("snapshot");
//       print(snapshot.data);
//       if (snapshot.hasData) {
//         return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GridView.builder(
//                 itemCount: snapshot.data.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                 ),
//                 itemBuilder: (BuildContext context, int i) {
//                   return Card(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(width: 0.5, color: Colors.grey)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: <Widget>[
//                             Text(snapshot.data[i].holdType.toString())
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }));
//       } else if (snapshot.hasError) {
//         return Text("${snapshot.error}");
//       }
//
//       // By default, show a loading spinner.
//       return CircularProgressIndicator.adaptive();
//     },
//   );
// }
  Future<List<ConvertedImage>> convertImage(imagePath) async {
    var uri = Uri.parse(uploadImageURL);
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          "true", // Required for cookies, authorization headers with HTTPS
    };

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('image',
        File(imagePath).readAsBytes().asStream(), File(imagePath).lengthSync());

    request.files.add(multipartFile);
    request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            if (response.statusCode == 200) {
              print("Uploaded! ");
              print('response.body ' + response.body);
              List jsonResponse = json.decode(response.body);
              return jsonResponse
                  .map((item) => new ConvertedImage.fromJson(item))
                  .toList();
            } else {
              print(response.statusCode);
              return <ConvertedImage>[];
            }
            //return <ConvertedImage>[];
            //return ConvertedImage.fromJson(jsonDecode(response.body));
          });
        })
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }

  FutureBuilder<List<ConvertedImage>> buildFutureBuilder(imagePath) {
    return FutureBuilder<List<ConvertedImage>>(
        future: convertImage(imagePath),
        builder: (context, snapshot) {
          // if (snapshot.connectionState != ConnectionState.done) {
          //   // return: show loading widget
          // }
          if (snapshot.hasData) {
            List<ConvertedImage> holdsData = snapshot.data ?? [];
            return Text(holdsData.toString());
            // return ListView.builder(
            // itemCount: users.length,
            // itemBuilder: (context, index) {
            // User user = users[index];
            // return new ListTile(
            // leading: CircleAvatar(
            // backgroundImage: AssetImage(user.profilePicture),
            // ),
            // trailing: user.icon,
            // title: new Text(user.name),
            // onTap: () {
            // Navigator.push(context,
            // new MaterialPageRoute(builder: (context) => new Home()));
            // },
            // );
            // });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator.adaptive();
        });
  }

// FutureBuilder<ConvertedImage> buildFutureBuilder() {
//   return FutureBuilder<ConvertedImage>(
//     future: _convertedImage,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return DataTable2(
//             columnSpacing: 12,
//             horizontalMargin: 12,
//             minWidth: 600,
//             columns: [
//               DataColumn2(
//                 label: Text("Hold type"),
//                 size: ColumnSize.L,
//               ),
//               DataColumn(
//                 label: Text('x1'),
//               ),
//               DataColumn(
//                 label: Text('x2'),
//               ),
//               DataColumn(
//                 label: Text('y1'),
//               ),
//               DataColumn(
//                 label: Text('y2'),
//               ),
//             ],
//             rows: List<DataRow>.generate(
//                 7,
//                 (index) => DataRow(cells: [
//                       DataCell(CustomText(text: "1")),
//                       DataCell(CustomText(text: "łódź")),
//                       DataCell(Container(
//                         decoration: BoxDecoration(
//                           color: light,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: active, width: .5),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: Icon(
//                           Icons.delete,
//                           //color: Colors.deepOrange,
//                           size: 18,
//                         ),
//                       )),
//                     ])));
//       } else if (snapshot.hasError) {
//         return Text('${snapshot.error}');
//       }
//
//       return const CircularProgressIndicator.adaptive();
//     },
//   );
// }
  StepProgressView _getStepProgress() {
    return StepProgressView(
      StepsParams.stepsText,
      widget.currentPage,
      StepsParams.stepProgressViewHeight,
      widget.safeAreaSize.width,
      StepsParams.stepCircleRadius,
      StepsParams.activeColor,
      StepsParams.inactiveColor,
      StepsParams.headerStyle,
      StepsParams.stepStyle,
      decoration: BoxDecoration(color: light),
    );
  }
}
