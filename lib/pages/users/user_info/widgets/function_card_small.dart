import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/style.dart';
import 'package:perfectBeta/widgets/custom_text.dart';


class FunctionCardSmall extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isError;
  final AlignmentGeometry alignment;

  const FunctionCardSmall({ Key key, this.title, this.onTap, this.icon, this.isError = false, this.alignment = Alignment.centerLeft}) : super(key: key);

  @override
  _FunctionCardSmall createState() => _FunctionCardSmall();

}

class _FunctionCardSmall extends State<FunctionCardSmall> {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: widget.onTap,
        child: Container(
          child: Row(
            children: [
              SizedBox(width:_width / 88),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(widget.icon, size: 22, color: !widget.isError ? dark : error),
              ),
              Flexible(child: CustomText(text: widget.title , color: !widget.isError ? lightGrey : error.withOpacity(.7)))
            ],
          ),
        ));
  }
}