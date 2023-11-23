import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class WeightCameraPage extends CameraPage {
  const WeightCameraPage({super.key});

  @override
  CameraPageState<WeightCameraPage> createState() => _WeightCameraPageState();
}

class _WeightCameraPageState extends CameraPageState<WeightCameraPage> {
  @override
  WeightCameraPageCont get cont => WeightCameraPageCont.to;

  Widget _buildBody(BuildContext context) {
    return buildCameraView(context);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: autoPadding,
      extendBodyBehindAppBar: true,
      appBar: FAppBar(),
      body: _buildBody(context),
    );
  }

}
