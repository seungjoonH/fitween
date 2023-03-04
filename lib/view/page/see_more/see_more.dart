import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/view/page/see_more/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';
import 'package:flutter/material.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(
        title: '더보기',
        actions: [
          IconButton(
            onPressed: AuthP.fLogout, icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: const [
              BadgeManagementCard(),
              SizedBox(height: 20.0),
              GoalEditCard(),
              SizedBox(height: 20.0),
              InfoEditCard(),
              SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FBottomNavigationBar(),
    );
  }
}
