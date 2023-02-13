import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/presenter/page/register.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PButton(
              onPressed: HomeP.toHome,
              text: 'Home',
            ),
            const SizedBox(height: 20.0),
            PButton(
              onPressed: FriendP.toFriend,
              text: 'Friend',
            ),
            SizedBox(height: 20.0),
            PButton(
              onPressed: RegisterP.toRegister,
              text: 'Register',
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
