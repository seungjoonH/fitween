import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// global variables
// 파이어베이스 계정 관련 인스턴스
final a = FirebaseAuth.instance;

// 파이어베이스 데이터베이스 관련 인스턴스
final f = FirebaseFirestore.instance;

// 파이어베이스 저장소 관련 인스턴스
final s = FirebaseStorage.instance;

// 파이어 베이스 알림 관련 인스턴스
final m = FirebaseMessaging.instance;