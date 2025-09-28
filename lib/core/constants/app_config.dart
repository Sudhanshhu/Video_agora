// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/toast.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  AgoraConfigModel? _config;

  final _firestore = FirebaseFirestore.instance;

  AgoraConfigModel? get config => _config;

  /// Fetches the latest data once
  Future<void> loadInitialConfig() async {
    final snapshot =
        await _firestore.collection('appConfig').doc('agora').get();

    if (snapshot.exists) {
      _config = AgoraConfigModel.fromMap(snapshot.data()!);
    }
  }

  /// Listens for changes in real-time
  void listenForUpdates() {
    _firestore
        .collection('appConfig')
        .doc('agora')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _config = AgoraConfigModel.fromMap(snapshot.data()!);
      }
    });
  }

  /// Getters for easy access
  String get appId => _config?.appId ?? '';
  String get token => _config?.token ?? '';
  String get channel => _config?.channel ?? '';
  String get certificate => _config?.primaryCertificate ?? '';
}

class AgoraConfigModel {
  final String appId;
  final String token;
  final String channel;
  final String primaryCertificate;

  AgoraConfigModel({
    required this.appId,
    required this.token,
    required this.channel,
    required this.primaryCertificate,
  });

  factory AgoraConfigModel.fromMap(Map<String, dynamic> map) {
    return AgoraConfigModel(
      appId: map['appId'],
      token: map['token'],
      channel: map['channel'],
      primaryCertificate: map['primaryCertificate'],
    );
  }
}

Future<FsAgoraUser?> fetchTokenFromFs(int userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('agoraUser')
      .doc('$userId')
      .get();

  if (snapshot.exists) {
    final data = FsAgoraUser.fromMap(snapshot.data()!);
    return data;
  } else {
    fToast("No data found for $userId", type: AlertType.warning);
    return null;
  }
}

class FsAgoraUser {
  final String token;
  final int userId;
  FsAgoraUser({
    required this.token,
    required this.userId,
  });

  factory FsAgoraUser.fromMap(Map<String, dynamic> map) {
    return FsAgoraUser(
      token: map['token'],
      userId: map['userId'],
    );
  }
}
