import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountPage extends FPage {
  const AccountPage({super.key});

  @override
  FPageState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends FPageState<AccountPage> {
  @override
  AccountPageCont get cont => AccountPageCont.to;

  double get imageSize => 200.0.r;

  Widget _buildAccountImageWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0.r),
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              cont.imageUrl!,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  ImageCont.emptyAssetPath,
                  fit: BoxFit.cover,
                  width: imageSize,
                  height: imageSize,
                );
              },
            ),
            Container(color: ThemeCont.achro5.withOpacity(.2)),
            Positioned(
              right: 10.0.r, bottom: 10.0.r,
              child: FLoginTypeTag(type: cont.type),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoWidget(BuildContext context) {
    return Column(
      children: [
        FText(cont.name, bold: true),
        SizedBox(height: 5.0.h),
        FText(
          cont.email,
          style: ThemeCont.to.commentStyle,
          color: ThemeCont.to.comment,
        ),
      ],
    );
  }

  Widget _buildAutoLoginButtonWidget(BuildContext context) {
    return DarkPressableWidget(
      onPressed: cont.onChanged,
      child: Obx(() => Row(
        children: [
          Checkbox(
            value: cont.autoLoginAllowed,
            onChanged: (_) => cont.onChanged(),
            activeColor: ThemeCont.colorA,
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0.w),
            child: FText(
              cont.autoLoginText,
              color: ThemeCont.colorA,
              bold: true,
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: Column(
        children: [
          _buildAccountImageWidget(context),
          SizedBox(height: 20.0.h),
          _buildAccountInfoWidget(context),
          SizedBox(height: 20.0.h),
          _buildAutoLoginButtonWidget(context),

        ],
      ),
      bottomWidget: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FTextButton(
            stretch: true,
            text: cont.logoutButtonText,
            textColor: ThemeCont.error,
            onPressed: cont.logoutButtonPressed,
          ),
          // SizedBox(height: 10.0.h),
          // FButton(
          //   stretch: true,
          //   text: cont.deleteAccountButtonText,
          //   backgroundColor: ThemeCont.error,
          //   onPressed: cont.deleteAccountButtonPressed,
          // ),
        ],
      ),
    );
  }
}
