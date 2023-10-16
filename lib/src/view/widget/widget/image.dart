import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopImage extends StatelessWidget {
  const TopImage({
    super.key,
    required this.imageUrl,
    this.title,
  });

  final String imageUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image.asset(
          imageUrl,
          width: PageCont.size.width,
          height: PageCont.size.height * .25,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, object, stacktrace) {
            return Image.asset(
              ImageCont.emptyAssetPath,
              width: PageCont.size.width,
              height: PageCont.size.height * .25,
              fit: BoxFit.fitWidth,
            );
          },
        ),
        Container(
          width: PageCont.size.width,
          height: PageCont.size.height * .25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                FTheme.background.withOpacity(1.0),
                FTheme.background.withOpacity(.0),
              ],
            ),
          ),
        ),
        if (title != null)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0.w),
          child: FText(
            title!,
            style: FTheme.headlineMedium,
            maxLines: 0,
          ),
        ),
      ],
    );
  }
}