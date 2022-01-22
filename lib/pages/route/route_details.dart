import 'package:flutter/cupertino.dart';
import 'package:perfectBeta/api/api_client.dart';
import 'package:perfectBeta/api/providers/route_endpoint.dart';

class RouteDetailsPage extends StatefulWidget {
  final int routeId;

  const RouteDetailsPage({Key key, this.routeId}) : super(key: key);

  @override
  _RouteDetailsPageState createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {

  static ApiClient _client = new ApiClient();
  var _routeEndpoint = new RouteEndpoint(_client.init());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () { Navigator.pop(context); },
        child: Container());
  }
}
