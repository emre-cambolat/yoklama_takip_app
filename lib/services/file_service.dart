import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureFileService {
  static final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  static FlutterSecureStorage get storage => _storage;

  static Future<bool> checkUserInfo() async {
    String? value = await _storage.read(key: "user");
    if (value != null) {
      log("kullanıcı var");
      return true;
    }
    log("kullanıcı yok");
    return false;
  }

  static Future<Map<String, String>> readUserInfo() async {
    Map<String, String> value = await _storage.readAll();
    return value;
  }

  static Future<void> writeUserInfo({required String user, required String pass}) async {
    await _storage.write(key: "user", value: user);
    await _storage.write(key: "pass", value: pass);
  }

  static Future<void> exitUser() async {
    await _storage.deleteAll();
  }

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}

