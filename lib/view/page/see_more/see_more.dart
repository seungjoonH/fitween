import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/page/see_more/see_more.dart';
import 'package:fitween/view/page/see_more/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();

    return Scaffold(
      appBar: FAppBar(
        title: '더보기',
        actions: [
          IconButton(
            onPressed: AuthP.fLogout,
            icon: Icon(Icons.logout, size: 20.0.r),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: refreshCont,
        onRefresh: () async {
          try {
            await SeeMoreP.init();
            refreshCont.refreshCompleted();
          } catch (e) {
            refreshCont.refreshFailed();
          }
        },
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 100));
          refreshCont.loadComplete();
        },
        header: const MaterialClassicHeader(
          color: FTheme.black,
          backgroundColor: FTheme.surface,
          offset: 40.0,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w,
              vertical: 28.0.h,
            ),
            child: Column(
              children: [
                const BadgeManagementCard(),
                SizedBox(height: 20.0.h),
                const GoalEditCard(),
                SizedBox(height: 20.0.h),
                const InfoEditCard(),
                SizedBox(height: 100.0.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const FBottomNavigationBar(),
    );
  }
}
