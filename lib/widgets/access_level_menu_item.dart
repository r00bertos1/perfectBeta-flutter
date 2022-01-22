import 'package:flutter/material.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:get/get.dart';
import 'package:perfectBeta/constants/style.dart';
import 'custom_text.dart';

class AccessLevelMenuItem extends StatelessWidget {
  final String itemName;
  final Function onTap;

  const AccessLevelMenuItem({ Key key,@required this.itemName,@required this.onTap }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: onTap,
        onHover: (value){
          value ?
          accessLevelController.onHover(itemName) : accessLevelController.onHover("not hovering");
        },
        child: Obx(() => Container(
          color: accessLevelController.isHovering(itemName) ? lightGrey.withOpacity(.1) : Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: accessLevelController.returnIconFor(itemName),
              ),
              if(!accessLevelController.isActive(itemName))
                Flexible(child: CustomText(text: itemName , color: accessLevelController.isHovering(itemName) ? dark : lightGrey, overflow: TextOverflow.ellipsis,))
              else
                Flexible(child: CustomText(text: itemName , color:  dark , weight: FontWeight.bold, overflow: TextOverflow.ellipsis,))

            ],
          ),
        ))
    );
  }
}