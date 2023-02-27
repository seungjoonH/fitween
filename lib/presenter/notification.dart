import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fitween/presenter/firebase/firebase.dart';

class NotificationP extends GetxController {
  @override
  void onInit() async {
    // 첫 빌드시, 권한 확인
    await m.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    // authenticated 된 상태인지 아닌지 확인
    _getToken();
    _onMessage();
    super.onInit();
  }
  // 디바이스 고유 토큰 가져오기
  void _getToken() async {
    // String? token = await m.getToken();
    // try {
    //   print(token);
    // } catch(e) {}
  }

  /// * 안드로이드에서 foreground 알림 위한 flutter_local_notification 라이브러리 *
  // channel 생성 (알림을 따로 전달해줄 채널을 직접 생성)
  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  // 생성한 채널을 우리 메인 채널로 정해줄 플러그인을 만들어준다.
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _onMessage() async {
    /// * local_notification 관련한 플러그인 활용 *
    // 위에서 생성한 channel 을 플러그인 통해 메인 채널로 설정한다.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var iOSInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 플러그인을 초기화하여 추가 설정을 해준다.
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: iOSInitializationSettings,
        ),
        // onSelectNotification: (String? payload) async {}
      );

    /// * onMessage 설정 *
    // 1. 콘솔에서 발송하는 메시지를 message 파라미터로 받아온다.
    // 메시지가 올 때마다 listen 내부 콜백이 실행
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // android 일 때만 flutterLocalNotification 을 대신 보여준다
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description
            ),
          ),

          // 넘겨줄 데이터가 있으면 아래 코드 사용.
          // payload: message.data['argument']
        );
      }
      // 개발 확인 용으로 print 구문 추가
      // print('foreground 상황에서 메시지를 받았다.');
      // 데이터 유무 확인
      // print('Message data: ${message.data}');
      // notification 유무 확인
      // if (message.notification != null) {
      //   print('Message also contained a notification: ${message.notification!.body}');
      // }
    });
  }
}