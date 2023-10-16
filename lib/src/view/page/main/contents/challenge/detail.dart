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
              Container(
                height: PageCont.size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      FTheme.achro95,
                      FTheme.achro5.withOpacity(.4),
                    ],
                    stops: const [.0, .6],
                  ),
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
          style: FTheme.titleSmall,
          color: FTheme.outline,
          maxLines: 0,
        ),
      ],
    ));
  }

  Widget _buildChallengeButtonWidget(BuildContext context) {
    return Obx(() {
      Color leftButtonColor = FTheme.text;
      Color rightButtonColor = cont.challenge!.type.color;

      if (cont.isBookmarkedChallenge) {
        return FButton(
          text: cont.goToMyPartyText,
          backgroundColor: rightButtonColor,
          onPressed: cont.goToMyPartyButtonPressed,
          stretch: true,
        );
      }

      if (cont.isAppliedChallenge) {
        return FButton(
          text: cont.goToAppliedPartyText,
          backgroundColor: rightButtonColor,
          onPressed: cont.goToAppliedPartyButtonPressed,
          stretch: true,
        );
      }

      if (cont.isBookmarkedTypeOfChallenge
          || cont.isAppliedTypeOfChallenge) {
        leftButtonColor = FTheme.unselected;
        rightButtonColor = FTheme.unselected;
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FButton(
              text: cont.searchPartyText,
              backgroundColor: leftButtonColor,
              stretch: true,
              onPressed: cont.searchPartyButtonPressed,
            ),
          ),
          SizedBox(width: 15.0.w),
          Expanded(
            child: FButton(
              text: cont.createPartyText,
              backgroundColor: rightButtonColor,
              stretch: true,
              onPressed: cont.createPartyButtonPressed,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildModalBottomSheetWidget(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: FTheme.outline),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        FTheme.backgroundAlt.withOpacity(.9),
                        BlendMode.modulate,
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: FTheme.backgroundAlt.withOpacity(.9),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20.0.h),
                            width: 100.0.w, height: 10.0.h,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.0.r),
                              backgroundBlendMode: BlendMode.clear,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0.h),
                  width: 100.0.w, height: 10.0.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: FTheme.outline),
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w, vertical: 50.0.h,
          ),
          child: Column(
            children: [
              _buildChallengeInfoWidget(context),
              SizedBox(height: 30.0.h),
              _buildChallengeButtonWidget(context),
            ],
          ),
        ),
      ],
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


class HandlerClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: Offset(size.width * .5, 10.0.h),
      width: 100.0.w,
      height: 10.0.h,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}