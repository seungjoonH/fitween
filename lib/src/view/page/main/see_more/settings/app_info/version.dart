import 'package:fitween/main.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VersionPage extends FPage {
  const VersionPage({Key? key}) : super(key: key);

  @override
  FWidgetState<FWidget> createState() => _VersionPageState();
}

class _VersionPageState extends FPageState<VersionPage> {

  @override
  VersionPageCont get cont => VersionPageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      backgroundColor: ThemeCont.colorA,
      extendBodyBehindAppBar: true,
      appBar: FAppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FAppIcon(
              border: true,
              backgroundColor: ThemeCont.achro95,
            ),
            SizedBox(height: 10.0.h),
            FText(
              'Fitween',
              color: ThemeCont.achro95,
              style: ThemeCont.to.titleLarge,
              bold: true,
            ),
            SizedBox(height: 10.0.h),
            const FTextTag(
              version,
              backgroundColor: ThemeCont.achro95,
              textColor: ThemeCont.achro40,
            ),
            SizedBox(height: 10.0.h),
            FText(
              cont.message,
              color: ThemeCont.achro95,
              style: ThemeCont.to.labelLarge,
              maxLines: 3,
            ),
            SizedBox(height: 40.0.h),
            FButton(
              text: cont.patchNoteButtonText,
              textColor: ThemeCont.achro95,
              backgroundColor: ThemeCont.achro40,
              onPressed: cont.patchNoteButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}