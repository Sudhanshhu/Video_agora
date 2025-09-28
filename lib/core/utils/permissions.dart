import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<void> requestAll() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }
}
