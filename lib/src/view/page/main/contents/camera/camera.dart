import 'package:camera/camera.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

abstract class CameraPage extends FPage {
  const CameraPage({super.key});
}

abstract class CameraPageState<T extends CameraPage> extends FPageState<CameraPage> {

  CameraCont get cameraCont => CameraCont.to;
  @override
  CameraPageCont get cont;

  @override
  void initState() {
    super.initState();
    if (mounted) setState(() => _opacity = .0);
    delay(2.s, () { _opacity = 1.0; if (mounted) setState(() {}); });
    cont.initState();
    cont.initAsync();
  }

  @override
  void dispose() {
    cameraCont.disposeAll();
    cont.disposeAll();
    super.dispose();
  }

  double get _size => 70.0;
  double get _iconSize => _size / 1.5;

  Widget buildMessageWidget(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 130.0.h),
      margin: EdgeInsets.symmetric(horizontal: 20.0.w),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0.w,
        vertical: 20.0.h,
      ),
      decoration: BoxDecoration(
        color: ThemeCont.achro5.withOpacity(.25),
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      child: FText(
        cont.message,
        style: ThemeCont.to.headlineMedium,
        color: ThemeCont.colorA,
        bold: true,
        maxLines: 2,
      ),
    );
  }

  Widget buildStartButton(BuildContext context) {
    return SizedBox(
      width: _size,
      child: cont.stage.showStart ? FIconButton(
        icon: const Icon(Icons.play_arrow_rounded),
        iconColor: ThemeCont.achro95,
        backgroundColor: ThemeCont.colorA,
        size: _size,
        iconSize: _iconSize,
        onPressed: cont.startButtonPressed,
      ) : Container(),
    );
  }

  Widget buildPauseStopButton(BuildContext context) {
    return SizedBox(
      width: _size,
      child: Builder(builder: (_) {
        if (cont.stage.showPause) {
          return FIconButton(
            icon: const Icon(Icons.pause_rounded),
            iconColor: ThemeCont.achro95,
            backgroundColor: ThemeCont.colorD,
            size: _size,
            iconSize: _iconSize,
            onPressed: cont.pauseButtonPressed,
          );
        }
        else if (cont.stage.showStop) {
          return FIconButton(
            icon: const Icon(Icons.stop_rounded),
            iconColor: ThemeCont.achro95,
            backgroundColor: ThemeCont.colorB,
            size: _size,
            iconSize: _iconSize,
            onPressed: cont.stopButtonPressed,
          );
        }
        return Container();
      }),
    );
  }

  Widget buildCountButton(BuildContext context) {
    return Obx(() => FButton(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w,
        vertical: 20.0.w,
      ),
      border: false,
      backgroundColor: cont.stage.countButtonColor,
      onPressed: cont.countButtonPressed,
      child: Container(
        width: 120.0.w,
        alignment: Alignment.center,
        child: FText(
          '${cont.count}',
          style: ThemeCont.to.largeText,
          color: ThemeCont.achro95,
        ),
      ),
    ));
  }

  Widget buildConvertCameraButton(BuildContext context) {
    return SizedBox(
      width: _size,
      child: cont.stage.showConvert ? FIconButton(
        icon: const Icon(Icons.cameraswitch),
        iconColor: ThemeCont.achro95,
        backgroundColor: ThemeCont.achro50,
        size: _size,
        iconSize: _iconSize,
        onPressed: cont.convertCameraButtonPressed,
      ) : Container(),
    );
  }

  Widget buildButtonView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildPauseStopButton(context),
          buildCountButton(context),
          buildConvertCameraButton(context),
        ],
      ),
    );
  }

  Widget buildSecondCountingWidget(BuildContext context) {
    return Obx(() {
      if (!cont.stage.isDetecting || !cont.humanDetected) return Container();
      return Center(
        child: FText(
          '${cont.seconds}',
          style: ThemeCont.to.veryLargeText,
          color: ThemeCont.colorD,
        ),
      );
    });
  }

  double _opacity = .0;

  Widget _buildEmptyCameraWidget(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: 500.ms,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.no_photography,
                  size: 60.0.r,
                  color: ThemeCont.achro95,
                ),
                SizedBox(height: 20.0.h),
                FText(
                  cameraCont.cameraDisabledText,
                  maxLines: 0,
                  align: TextAlign.center,
                  color: ThemeCont.achro95,
                ),
              ],
            ),
            Positioned(
              top: 10.0.r,
              right: 10.0.r,
              child: FIconButton(
                icon: const Icon(Icons.error),
                iconColor: Colors.black,
                onPressed: cameraCont.showErrorDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCameraView(BuildContext context) {
    return Obx(() {
      if (!cameraCont.isCameraAvailable) {
        return _buildEmptyCameraWidget(context);
      }
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: cameraCont.top,
            bottom: cameraCont.bottom,
            left: cameraCont.left,
            right: cameraCont.right,
            child: CustomPaint(
              foregroundPainter: cont.painter,
              child: CameraPreview(
                cameraCont.cameraController!,
              ),
            ),
          ),
          Positioned(
            left: .0, right: .0,
            top: 80.0.h,
            child: buildMessageWidget(context),
          ),
          buildStartButton(context),
          Positioned(
            left: .0, right: .0,
            bottom: 40.0.h,
            child: buildButtonView(context),
          ),
          buildSecondCountingWidget(context),
        ],
      );
    });
  }

  bool get autoPadding => false;
}
