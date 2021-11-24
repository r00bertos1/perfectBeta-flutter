import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/helpers/reponsiveness.dart';
import 'package:perfectBeta/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Example without datasource
class GymsGrid extends StatelessWidget {
  final numbers = List.generate(16, (index) => '$index');
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 64,
        mainAxisSpacing: 64,
        crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 1 :
        ResponsiveWidget.isMediumScreen(context) ? 2 :
        ResponsiveWidget.isLargeScreen(context) ? 3 : 4,
      ),

      itemCount: numbers.length,
      itemBuilder: (context, index) {
        final item = numbers[index];

        return buildNumber(item);
      },
    );
  }

  Widget buildNumber(String number) => Container(
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
        //margin: EdgeInsets.only(bottom: 30),
        child: GridTile(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // CachedNetworkImage(
              //   imageUrl:
              //       "https://cdn.i-scmp.com/sites/default/files/d8/images/methode/2021/01/28/f1dcd6ba-6043-11eb-9099-aaa38b7b3943_image_hires_104555.jpg",
              //   fit: BoxFit.fill,
              //   placeholder: (context, url) => CircularProgressIndicator(
              //     color: active,
              //   ),
              //   errorWidget: (context, url, error) =>
              //       Image(image: AssetImage('images/gym-template.jpg')),
              // ),
              CachedNetworkImage(
                imageUrl:
                    "https://perfectbeta.s3.eu-north-1.amazonaws.com/photos/logo.png",
                fit: BoxFit.fill,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: active,
                ),
                errorWidget: (context, url, error) =>
                    Image(image: AssetImage('images/gym-template.jpg')),
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                // padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
                        child:
                          RatingBarIndicator(
                            rating: 4.5,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            // itemCount: 5,
                            itemSize: 20.0,
                          ),

                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                      title: Text('Spot Boulder caffe'),
                      subtitle: Text('Wersalska 47/75, 90-001 Łódź'),
                      trailing: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // setState(() {
                          //   // Toggle light when tapped.
                          //   _added = !_added;
                          // });
                        },
                        child: Icon(_added ? Icons.favorite : Icons.favorite_border),
                      ),
                    ),
                  ],
              ),
            ],
          ),
        ),
      );
}
// children: List.generate(16, (index) ){
//
// },
// child: Card(
//   child: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: <Widget>[
//       const ListTile(
//         leading: Icon(Icons.album),
//         title: Text('The Enchanted Nightingale'),
//         subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           TextButton(
//             child: const Text('BUY TICKETS'),
//             onPressed: () { /* ... */ },
//           ),
//           const SizedBox(width: 8),
//           TextButton(
//             child: const Text('LISTEN'),
//             onPressed: () { /* ... */ },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//     ],
//   ),
// ),
//}
