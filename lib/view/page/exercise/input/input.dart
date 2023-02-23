// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:get/get.dart' as gett;
// import 'package:native_exif/native_exif.dart';
// import 'package:fitween/global/theme.dart';
// import 'package:fitween/model/enum/activity_type.dart';
// import 'package:fitween/presenter/page/exercise/input.dart';
// import 'package:fitween/view/widget/button/button.dart';
// import 'package:fitween/view/widget/widget/app_bar.dart';
// import 'package:fitween/view/widget/widget/card.dart';
// import 'package:fitween/view/widget/widget/text.dart';
// import 'package:super_banners/super_banners.dart';
// import 'package:dio/dio.dart';
//
// class ExerciseInputPage extends StatefulWidget {
//   const ExerciseInputPage({super.key});
//
//   @override
//   State<ExerciseInputPage> createState() => _ExerciseInputPageState();
// }
//
// class _ExerciseInputPageState extends State<ExerciseInputPage> {
//
//   bool textScanning = false;
//   XFile? imageFile;
//   String scannedText = '';
//   Exif? exif;
//   ExifLatLong? coordinates;
//   double? distance;
//   String myLocation = '';
//   String address = "";
//
//
//   String googleApikey = "AIzaSyBrAdaZUxs-rN6KR2ExrqpKQHnZBRH0uQ4";
//
//   @override
//   void initState(){
//     super.initState();
//   }
//
//   //유저의 현재 위치
//   Future<geo.Position> getUserCurrentLocation() async {
//     await geo.Geolocator.requestPermission().then((value){
//     }).onError((error, stackTrace) async {
//       await geo.Geolocator.requestPermission();
//       print("ERROR"+error.toString());
//     });
//     return await geo.Geolocator.getCurrentPosition();
//   }
//
//   //위도와 경도를 영문주소로 변환
//   void convertToAddress(double lat, double long, String apikey) async {
//     Dio dio = Dio();  //initilize dio package
//     String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";
//
//     Response response = await dio.get(apiurl) as Response; //send get request to API URL
//
//     if(response.statusCode == 200){ //if connection is successful
//       Map data = response.data; //get response data
//       if(data["status"] == "OK"){ //if status is "OK" returned from REST API
//         if(data["results"].length > 0){ //if there is atleast one address
//           Map firstresult = data["results"][0]; //select the first address
//
//           address = firstresult["formatted_address"]; //get the address
//
//           //you can use the JSON data to get address in your own format
//
//           setState(() {
//             //refresh UI
//           });
//         }
//       }else{
//         print(data["error_message"]);
//       }
//     }else{
//       print("error while fetching geoconding data");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (gett.Get.arguments == null) return const Scaffold();
//     ActivityType type = gett.Get.arguments;
//
//     Map<ActivityType, List<String>> messages = {
//       ActivityType.calorie: ['오늘 ', '참은 음식', '을 선택해주세요.'],
//       ActivityType.distance: ['어디서', ' 출발', '했나요'],
//       // ActivityType.distance: ['오늘', ' 달린 거리', '를 입력해주세요.'],
//       ActivityType.height: ['오늘 ', '오른 층 수', '를 입력해주세요.'],
//       ActivityType.weight: ['오늘 ', '운동한 횟수', '를 입력해주세요.'],
//     };
//
//     Map<ActivityType, String> hints = {
//       ActivityType.calorie: '',
//       ActivityType.distance: '분 입력',
//       ActivityType.height: '층 수 입력',
//       ActivityType.weight: '회 입력',
//     };
//
//     Map<ActivityType, String> riveAssets = {
//       ActivityType.calorie: 'assets/rive/input/537-1015-sport-charts.riv',
//       ActivityType.distance: 'assets/rive/input/jogger.riv',
//       ActivityType.height:
//           'assets/rive/input/1738-3431-raster-graphics-example.riv',
//       ActivityType.weight: 'assets/rive/input/lumberjack_squats.riv',
//     };
//
//     Map<ActivityType, String> riveArtboard = {
//       ActivityType.calorie: 'New Artboard',
//       ActivityType.distance: 'Joggers',
//       ActivityType.height: 'New Artboard',
//       ActivityType.weight: 'Squat',
//     };
//
//     Map<ActivityType, String> riveAnimations = {
//       ActivityType.calorie: '',
//       ActivityType.distance: 'Jog',
//       ActivityType.height: 'Animation 1',
//       ActivityType.weight: 'Demo',
//     };
//
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         appBar: FAppBar(title: '${type.kr} 입력'),
//         body: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   FTexts(
//                     messages[type]!,
//                     alignment: MainAxisAlignment.start,
//                     colors: [FTheme.black, type.color, FTheme.black],
//                     style: textTheme.displaySmall,
//                     space: false,
//                   ),
//                   FText(
//                     '하쿠나님?',
//                     style: textTheme.displaySmall,
//                   ),
//                   const SizedBox(height: 20.0),
//                   // GetBuilder<ExerciseInput>(
//                   //   builder: (controller) {
//                   //     return PInputField(
//                   //       controller: controller.inputCont,
//                   //       hintText: controller.hintText ?? hints[type]!,
//                   //       keyboardType: TextInputType.number,
//                   //       invalid: controller.invalid,
//                   //       hintColor: controller.hintText == null
//                   //           ? FTheme.darkGrey : FTheme.colorB,
//                   //     );
//                   //   }
//                   // ),
//                   PCard(
//                     onPressed: () {
//                       getUserCurrentLocation().then((value) async {
//                         convertToAddress(value.latitude, value.longitude, googleApikey);
//                       });
//
//                     },
//                       rounded: true,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           FText(
//                             '현재 내 위치 기반으로 할래요!',
//                             color: FTheme.colorB,
//                             style: textTheme.titleMedium,
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Icon(Icons.my_location, color: FTheme.colorA,),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               FText('내 위치:', color: FTheme.colorA, style: textTheme.titleMedium,),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Container(
//                                 width: 180,
//                                   child: FText(address, color: FTheme.black, style: textTheme.titleSmall, maxLines: 3,))
//                             ],
//                           )
//                         ],
//                       )),
//                   Row(
//                     children: [
//                       PCard(
//                           rounded: true,
//                           child: Column(
//                             children: [
//                               FText(
//                                 '내 위치\n사진 업로드',
//                                 maxLines: 2,
//                                 style: textTheme.titleLarge,
//                                 color: FTheme.colorC,
//                               ),
//                               Image.asset('assets/image/page/input/streetView.png', width: 100,)
//                             ],
//                           )),
//                       PCard(
//                         padding: EdgeInsets.zero,
//                           rounded: true,
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 top:0,
//                                 right: 0,
//                                 child: CornerBanner(
//                                     bannerColor: FTheme.colorB,
//                                     bannerPosition: CornerBannerPosition.topRight,
//                                     child: FText('Beta')),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(20.0.r),
//                                 child: Column(
//                                   children: [
//                                     FText(
//                                       '내 주소\n인식하기',
//                                       maxLines: 2,
//                                       style: textTheme.titleLarge,
//                                       color: FTheme.colorC,
//                                     ),
//                                     Image.asset('assets/image/page/input/destinationView.png', width: 100,)
//                                   ],
//                                 ),
//                               )
//
//                             ],
//                           ))
//                     ],
//                   )
//                 ],
//               ),
//               // Expanded(
//               //   child: Padding(
//               //     padding: const EdgeInsets.all(20.0),
//               //     child: RAnimation(
//               //       rName: riveAssets[type]!,
//               //       abName: riveArtboard[type]!,
//               //       aName: riveAnimations[type]!,
//               //     ),
//               //   ),
//               // ),
//               gett.GetBuilder<ExerciseInput>(
//                 builder: (controller) {
//                   return PButton(
//                     onPressed: () => controller.completeButtonPressed(type),
//                     text: '선택 완료',
//                     stretch: true,
//                     backgroundColor: type.color,
//                     textColor: FTheme.black,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
