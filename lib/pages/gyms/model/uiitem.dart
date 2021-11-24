import 'package:perfectBeta/pages/gyms/model/gym.dart';
import 'package:flutter/material.dart';

class Uiitem extends StatelessWidget {
  final Gym gym;
  Uiitem(this.gym);

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
      elevation: 10.0,
      child: InkWell(
        splashColor: Colors.orange,
        onTap: () {
          print(gym.id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.asset(
                'assets/images/build.jpeg',
                fit: BoxFit.scaleDown,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.gym.name,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                    maxLines: 1,
                  ),
                  SizedBox(height: 0.0),
                  Text(
                    gym.location,
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}