import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

class FavouriteButton extends StatefulWidget {
  FavouriteButton({Key key, this.onPressed, this.isAdded}) : super(key: key);
  final Function() onPressed;
  final bool isAdded;

  @override
  _FavouriteButton createState() => _FavouriteButton();
}

class _FavouriteButton extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.onPressed();
        },
        tooltip: widget.isAdded ? 'remove from favourites' : 'add to favourites',
        icon: widget.isAdded ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        color: widget.isAdded ? error : null);
  }
}
