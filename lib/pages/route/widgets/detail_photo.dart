import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:photo_view/photo_view.dart';

class DetailPhoto extends StatefulWidget {
  final String tag;
  final String url;

  DetailPhoto({Key key, @required this.tag, @required this.url})
      : assert(tag != null),
        assert(url != null),
        super(key: key);

  @override
  _DetailPhotoState createState() => _DetailPhotoState();
}

class _DetailPhotoState extends State<DetailPhoto> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold (
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: light),
              imageProvider: NetworkImage(widget.url),
            //   CachedNetworkImage(
            //   imageUrl: widget.url,
            //   placeholder: (context, url) => Center(
            //       child: Container(
            //           width: 32,
            //           height: 32,
            //           child: new CircularProgressIndicator.adaptive())),
            //   errorWidget: (context, url, error) => Icon(Icons.error),
            // ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}