import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/widgets/custom_text.dart';

class StatusSwitchButton extends StatefulWidget {
  StatusSwitchButton({Key key, this.onPressed, this.isVerified, this.textColor}) : super(key: key);
  final Function() onPressed;
  final bool isVerified;
  final Color textColor;

  @override
  _StatusSwitchButton createState() => _StatusSwitchButton();
}

class _StatusSwitchButton extends State<StatusSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(text: widget.isVerified ? 'Close' : 'Verify', color: widget.textColor ?? null,),
        IconButton(
            onPressed: () {
              widget.onPressed();
            },
            tooltip: widget.isVerified ? 'close gym' : 'verify gym',
            icon: widget.isVerified ? Icon(Icons.block) : Icon(Icons.verified)),
      ],
    );
  }
}
