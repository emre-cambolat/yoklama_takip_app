import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

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

// // Read all values
//   Map<String, String> allValues = await storage.readAll();

// // Delete value
//   await storage.delete(key: "key");

// // Delete all
//   await storage.deleteAll();

// // Write value
//   await storage.write(key: "key", value: value);

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}

// class FileService {
//   Future<String> _getDirPath() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return dir.path;
//   }

//   Future<dynamic> readFavories() async {
//     final dirPath = await _getDirPath();
//     final myFile = await File('$dirPath/favories.txt').create(recursive: true);
//     final data = await myFile.readAsString(encoding: utf8);
//     log("okunan favori:" + data);
//     if (data.isNotEmpty) {}
//     return data;
//   }

//   Future<void> writeFavories() async {
//     final _dirPath = await _getDirPath();
//     final _myFile = File('$_dirPath/favories.txt');
//     await _myFile.writeAsString(jsonEncode(""));
//   }
// }
