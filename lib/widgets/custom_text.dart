import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextOverflow overflow;

  const CustomText({Key key, this.text, this.size, this.color, this.weight, this.overflow}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      text,style: TextStyle(fontSize: size ?? 16, color: color ?? Colors.black, fontWeight: weight ?? FontWeight.normal, overflow: overflow ?? TextOverflow.ellipsis),
    );
  }
}
