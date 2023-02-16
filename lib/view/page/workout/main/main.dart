// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:fitween/global/number.dart';
// import 'package:fitween/global/theme.dart';
// import 'package:fitween/model/class/workout/handler.dart';
// import 'package:fitween/model/class/workout/inference.dart';
// import 'package:fitween/model/class/workout/isolate.dart';
// import 'package:fitween/model/enum/part.dart';
// import 'package:fitween/model/enum/workout.dart';
// import 'package:fitween/presenter/page/workout/main.dart';
// import 'package:fitween/presenter/widget/camera.dart';
// import 'package:fitween/presenter/widget/painter.dart';
// import 'package:fitween/view/page/workout/main/widget.dart';
// import 'package:fitween/view/widget/button/button.dart';
// import 'package:fitween/view/widget/painter/painter.dart';
// import 'package:fitween/view/widget/widget/app_bar.dart';
// import 'package:fitween/view/widget/widget/text.dart';
//
// class WorkoutMainPage extends StatefulWidget {
//   const WorkoutMainPage({Key? key}) : super(key: key);
//
//   @override
//   State<WorkoutMainPage> createState() => _WorkoutMainPageState();
// }
//
// class _WorkoutMainPageState extends State<WorkoutMainPage> {
//   bool doPredict = false;
//   late Size inferenceSize;
//   double widthRatio = 1.0;
//   double heightRatio = 1.0;
//
//   Map<Part, Inference>? inferences;
//   late ExerciseHandler handler;
//
//   late LimbPainter painter;
//
//   @override
//   void initState() {
//     super.initState();
//     initAsync();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     final cameraP = Get.find<CameraPresenter>();
//     final workoutMain = Get.find<WorkoutMain>();
//     workoutMain.init();
//     cameraP.cameraController!.dispose();
//   }
//
//   void initAsync() async {
//     final cameraP = Get.find<CameraPresenter>();
//     await cameraP.init();
//     await cameraP.cameraController!
//         .startImageStream(createIsolate);
//     handler = SquatHandler();
//     handler.init();
//     setState(() {});
//   }
//
//   void createIsolate(CameraImage imageStream) async {
//     if (doPredict) return;
//     doPredict = true;
//
//     IsolateData isolateData = IsolateData(
//       cameraImage: imageStream,
//       interpreterAddress: CameraPresenter.classifier.interpreter.address,
//     );
//
//     List inferenceList = await CameraPresenter
//         .isolate.inference(isolateData);
//
//     inferences = {
//       for (int i = 0; i < inferenceList.length; i++)
//         Part.values[i] : Inference.list(inferenceList[i])
//           ..adjustRatio(widthRatio, heightRatio)
//     };
//
//     Inference.saveHistory(inferences!);
//
//     if (!mounted) return;
//
//     switch (PainterPresenter.orientation) {
//       case Orientation.portrait:
//         inferenceSize = Size(
//           imageStream.width.toDouble(),
//           imageStream.height.toDouble(),
//         );
//         break;
//       case Orientation.landscape:
//         inferenceSize = Size(
//           imageStream.height.toDouble(),
//           imageStream.width.toDouble(),
//         );
//         break;
//     }
//
//     widthRatio = PainterPresenter.canvasSize.width / inferenceSize.width;
//     heightRatio = PainterPresenter.canvasSize.height / inferenceSize.height;
//
//     doPredict = false;
//     handler.checkLimbs(Inference.refinedInferences);
//
//     painter = LimbPainter(
//       inferences: Inference.refinedInferences,
//       limbs: handler.limbs,
//     );
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (inferences == null) return const Scaffold();
//
//     return GetBuilder<CameraPresenter>(
//       builder: (cameraP) {
//         return OrientationBuilder(
//           builder: (context, orientation) {
//             PainterPresenter.setOrientation(orientation);
//             return Scaffold(
//               extendBodyBehindAppBar: true,
//               appBar: FAppBar(
//                 title: '운동하기',
//                 actions: [
//                   IconButton(
//                     onPressed: () {
//                       cameraP.toggleDirection();
//                       initAsync();
//                     },
//                     icon: const Icon(Icons.camera_alt),
//                   ),
//                 ],
//                 color: Colors.transparent,
//               ),
//               body: GetBuilder<PainterPresenter>(
//                 builder: (painterP) {
//                   return Column(
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             CameraPainterView(painter: painter),
//                             if (painterP.stateText != null)
//                             const WorkoutStateWidget(),
//                             if (painterP.floatingMessage != null)
//                             const FloatingMessageWidget(),
//                             if (painterP.count > 0 && painterP.state == WorkoutState.stop)
//                             const ExerciseCompleteButton(),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             PCircledButton(
//                               onPressed: painterP.initWorkout,
//                               backgroundColor: FTheme.lightGrey,
//                               enabled: painterP.state == WorkoutState.workout,
//                               child: FText('취소', style: textTheme.titleLarge),
//                             ),
//                             FText(
//                               '${painterP.count} 개',
//                               style: textTheme.headlineMedium,
//                             ),
//                             if (painterP.state == WorkoutState.workout)
//                             PCircledButton(
//                               onPressed: painterP.workout,
//                               backgroundColor: FTheme.colorA,
//                               child: FText('중지', style: textTheme.titleLarge),
//                             ) else PCircledButton(
//                               onPressed: painterP.workout,
//                               backgroundColor: FTheme.colorB,
//                               child: FText('시작', style: textTheme.titleLarge),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
