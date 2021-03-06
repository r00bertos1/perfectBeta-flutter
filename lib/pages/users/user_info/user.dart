import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/pages/users/user_info/widgets/user_cards_small.dart';
import 'package:perfectBeta/pages/users/user_info/widgets/user_info_card_small.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
                UserInfoCardSmall(),
                UserCardsSmallScreen(),
          ],
        );
  }
}
