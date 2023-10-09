import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChallengeDetailPage extends FPage {
  const ChallengeDetailPage({super.key});

  @override
  FPageState<ChallengeDetailPage> createState() => _ChallengeDetailPageState();
}

class _ChallengeDetailPageState extends FPageState<ChallengeDetailPage> {

  @override
  ChallengeDetailPageCont get cont => ChallengeDetailPageCont.to;

  Widget _buildImageBackgroundWidget(BuildContext context) {
    return Obx(() {
      String imageUrl = cont.challenge!.defaultImageUrl;
      return Hero(
        tag: imageUrl,
        child: GestureDetector(
          onTap: Get.back,
          child: Stack(
            children: [
              Image.asset(
                imageUrl,
                height: PageCont.size.height * .7,
                fit: BoxFit.fitHeight,
                errorBuilder: (context, object, stacktrace) {
                  return Image.asset(
                    ImageCont.emptyAssetPath,
                    height: PageCont.size.height * .7,
                    fit: BoxFit.fitHeight,
                  );
                },
              ),
              Positioned.fill(
                child: Container(
                  color: FTheme.achro5.withOpacity(.4),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChallengeInfoWidget(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText(
          cont.challenge!.title,
          style: FTheme.headlineMedium,
          maxLines: 0,
        ),
        SizedBox(height: 10.0.h),
        FText(
          cont.challenge!.getDetailDescription(),
          style: FTheme.titleMedium,
          color: FTheme.comment,
          maxLines: 0,
        ),
      ],
    ));
  }

  Widget _buildChallengeButtonWidget(BuildContext context) {
    Color leftButtonColor = FTheme.text;
    Color rightButtonColor = cont.challenge!.type.color;

    if (!cont.isBookmarkedChallenge) {
      if (cont.isBookmarkedTypeOfChallenge) {
        leftButtonColor = FTheme.unselected;
        rightButtonColor = FTheme.unselected;
      }
    }

    if (cont.isBookmarkedChallenge) {
      return FButton(
        text: cont.goPartyText,
        backgroundColor: rightButtonColor,
        onPressed: cont.goToMyPartyButtonPressed,
        stretch: true,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FButton(
            text: cont.joinPartyText,
            backgroundColor: leftButtonColor,
            stretch: true,
          ),
        ),
        SizedBox(width: 20.0.w),
        Expanded(
          child: FButton(
            text: cont.createPartyText,
            backgroundColor: rightButtonColor,
            stretch: true,
            onPressed: cont.isBookmarkedTypeOfChallenge
                ? null : cont.createPartyButtonPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildModalBottomSheetWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0.r, .0, 20.0.r, 50.0.r),
      decoration: BoxDecoration(
        color: FTheme.backgroundAlt,
        border: Border.all(color: FTheme.outline),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0.r)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0.h),
            width: 100.0.h, height: 10.0.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0.r),
              color: FTheme.bar,
            ),
          ),
          _buildChallengeInfoWidget(context),
          SizedBox(height: 30.0.h),
          _buildChallengeButtonWidget(context),
        ],
      ),
    );
  }

  @override
  void initState() {
    cont.initState(reload: true);
    super.initState();
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.challenge == null) return Container();
      return Stack(
        children: [
          Positioned.fill(child: _buildImageBackgroundWidget(context)),
          Positioned(
            bottom: .0, left: .0, right: .0,
            child: _buildModalBottomSheetWidget(context),
          ),
        ],
      );
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: false,
      extendBodyBehindAppBar: true,
      appBar: FAppBar(),
      body: _buildBody(context),
    );
  }

}
