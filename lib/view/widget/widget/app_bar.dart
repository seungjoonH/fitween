import 'package:fitween/presenter/model/user/info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/my/main.dart';
import 'package:fitween/presenter/page/my/setting/main.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';

class FAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FAppBar({
    Key? key,
    this.title,
    this.color,
    this.leading,
    this.actions,
  }) : super(key: key);

  final String? title;
  final Color? color;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalPresenter>(
      builder: (controller) {
        return AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: FTheme.black),
          backgroundColor: color,
          title: FText(title ?? '', style: textTheme.headlineMedium),
          leading: leading,
          actions: actions,
        );
      },
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalPresenter>(
      builder: (controller) {
        return AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: FTheme.white),
          title: const Align(
            alignment: Alignment.centerRight,
            child: MyNavigationButton(),
          ),
        );
      }
    );
  }
}

class MyNavigationButton extends StatelessWidget {
  const MyNavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(18.0);

    return Material(
      color: FTheme.colorB,
      borderRadius: radius,
      shadowColor: FTheme.darkGrey,
      child: InkWell(
        onTap: MyMain.toMyMain,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0, vertical: 5.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: FTheme.black,
              width: 1.5,
            ),
            borderRadius: radius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, color: FTheme.white),
              const SizedBox(width: 5.0),
              FText('마이 페이지', color: FTheme.white),
            ],
          ),
        ),
      ),
    );
  }
}


class CollectionMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CollectionMainAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return const FAppBar(
      title: '컬렉션',
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: GlobalPresenter.goBack,
      ),
      actions: [
        /*

        GetBuilder<CollectionMain>(
          builder: (controller) {
            return FTextButton(
              onPressed: controller.toggleMode,
              text: controller.mode == PageMode.view ? '편집' : '완료',
              style: textTheme.titleMedium,
              color: controller.mode == PageMode.view ? FTheme.black :  FTheme.colorB,
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            );
          },
        ),

        */
      ],
    );
  }
}


class MyMainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyMainAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  State<MyMainAppBar> createState() => _MyMainAppBarState();
}

class _MyMainAppBarState extends State<MyMainAppBar> {
  @override
  Widget build(BuildContext context) {

    return FAppBar(title: '마이 페이지',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            final userP = Get.find<UserInfoP>();
            if (await MySettingMain.toMySettingMain()) userP.update();
          },
        ),
      ],
    );
  }
}

class MySettingMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MySettingMainAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return const FAppBar(title: '설정',
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: GlobalPresenter.goBack,
      ),
      actions: [
        FTextButton(
          text: '앱 정보',
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          color: FTheme.darkGrey,
          onPressed: MySettingMain.showAppInfoDialog,
        ),
        // FTextButton(
        //   text: version,
        //   padding: EdgeInsets.symmetric(horizontal: 20.0),
        //   color: FTheme.darkGrey,
        //   onPressed: ReleaseNoteMain.toReleaseNoteMain,
        // ),
      ],
    );
  }
}

class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CameraAppBar({
    Key? key,
    this.title,
    this.color,
    this.leading,
    this.actions,
  }) : super(key: key);

  final String? title;
  final Color? color;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(110.0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalPresenter>(
      builder: (controller) {
        return AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: FTheme.black),
          backgroundColor: color,
          title: FText(title ?? '', style: textTheme.headlineMedium),
          leading: leading,
          actions: actions,
        );
      },
    );
  }
}