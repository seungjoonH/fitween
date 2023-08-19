import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FScaffold extends Scaffold {
  const FScaffold({
    super.key,
    super.appBar,
    super.body,
    super.drawer,
    super.drawerScrimColor,
    super.backgroundColor,
    super.extendBodyBehindAppBar,
    this.autoPadding = true,
    this.bottomWidget,
    this.bottomPadding,
  });

  final bool autoPadding;
  final Widget? bottomWidget;
  final double? bottomPadding;

  EdgeInsets get _padding => EdgeInsets.symmetric(
    horizontal: 28.0.w, vertical: 28.0.h,
  );

  EdgeInsets get _bottomWidgetPadding => _padding.copyWith(
    bottom: bottomPadding ?? 80.0.h,
  );

  Widget get _portraitBody => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Positioned.fill(
        left: autoPadding ? _padding.left : .0,
        right: autoPadding ? _padding.right : .0,
        top: autoPadding ? _padding.top : .0,
        bottom: autoPadding ? _padding.bottom : .0,
        child: super.body ?? Container(),
      ),
      if (bottomWidget != null)
      SizedBox(
        height: PageCont.size.height * .35,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: _bottomWidgetPadding,
              child: bottomWidget!,
            ),
          ],
        ),
      ),
    ],
  );

  Widget get _landscapeBody => Stack(
    alignment: Alignment.bottomRight,
    children: [
      Positioned.fill(
        left: autoPadding ? _padding.left : .0,
        right: autoPadding ? _padding.right : .0,
        top: autoPadding ? _padding.top : .0,
        bottom: autoPadding ? _padding.bottom : .0,
        child: super.body ?? Container(),
      ),
      if (bottomWidget != null)
        IntrinsicHeight(
        child: Container(
          width: PageCont.size.width * .5,
          padding: _bottomWidgetPadding,
          child: bottomWidget!,
        ),
      ),
    ],
  );

  @override
  Widget? get body => SizedBox(
    width: PageCont.size.width,
    height: PageCont.size.height,
    child: PageCont.isPortrait
        ? _portraitBody
        : _landscapeBody,
  );
}

class FRefreshScaffold extends FScaffold {
  const FRefreshScaffold({
    super.key,
    super.appBar,
    super.body,
    super.drawer,
    super.drawerScrimColor,
    super.autoPadding,
    super.bottomWidget,
    super.bottomPadding,
    required this.refreshController,
    required this.onRefresh,
  });

  final RefreshController refreshController;
  final Future Function() onRefresh;

  @override
  Widget? get body => SmartRefresher(
    controller: refreshController,
    onRefresh: () async {
      await onRefresh();
      refreshController.refreshCompleted();
    },
    onLoading: () async {
      await delay(100.ms);
      refreshController.loadComplete();
    },
    header: MaterialClassicHeader(
      color: FTheme.textAlt,
      backgroundColor: FTheme.surface,
      offset: 40.0.h,
    ),
    child: super.body,
  );
}

class FKeyboardUsableScaffold extends StatelessWidget {
  const FKeyboardUsableScaffold({
    super.key,
    this.autoPadding = true,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.drawer,
    this.drawerScrimColor,
    this.bottomWidget,
  });

  final bool autoPadding;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Drawer? drawer;
  final Color? drawerScrimColor;
  final Widget? bottomWidget;

  bool _keyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: FScaffold(
        autoPadding: autoPadding,
        backgroundColor: backgroundColor,
        appBar: appBar,
        body: body,
        bottomWidget: bottomWidget,
        bottomPadding: _keyboardVisible(context)
            ? 20.0.h : null,
      ),
    );
  }
}