import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yoklama_takip/models/join_inspection.dart';
import 'package:yoklama_takip/models/lessons.dart';
import 'package:yoklama_takip/models/student.dart';
import 'package:yoklama_takip/models/lesson_inspections.dart';

import 'file_service.dart';

class ApiServices {
  static String _token = "";
  static String get token => _token;
  static String loginStatusText = "";

  static Future<Map<String, String>> login({
    required String user,
    required String pass,
  }) async {
    String _responseBody = await _sendRequest(
      url: ApiAddress.LOGIN,
      body: {'kullaniciAdi': user.trim(), 'sifre': pass.trim()},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        _token = _decodeResponse["token"];
        StudentModel.fromJson(_decodeResponse["ogrenci"]);
      }
      log(_decodeResponse.toString());
      return {
        'status': _decodeResponse["status"].toString(),
        'text': _decodeResponse["text"]
      };
    }
    return {'status': "0", 'text': "İstek gönderimi başarısız"};
  }

  static Future<Map<String, String>> studentUpdate({
    required String deviceId,
  }) async {
    String _responseBody = await _sendRequest(
      url: ApiAddress.OGRENCI_DUZENLE,
      headers: {'token': token},
      body: {'cihazid': deviceId},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        StudentModel.cihazId = deviceId;
      }
      log(_decodeResponse.toString());
      return {
        'status': _decodeResponse["status"].toString(),
        'text': _decodeResponse["text"]
      };
    }
    return {'status': "0", 'text': "İstek gönderimi başarısız"};
  }

  static Future<Map<String, String>> getInspectionInfo({
    required String deviceId,
    required String inspectionCode,
  }) async {
    String _responseBody = await _sendRequest(
      url: ApiAddress.YOKLAMA_BILGISI,
      headers: {'token': token},
      body: {'yoklamakodu': inspectionCode, 'cihazid': deviceId},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        JoinInspectionModel.fromJson(_decodeResponse["data"]);
        // Cihazdan konumu al. API'dan gelen konum ile yay çizip hesapla.
        // Eğer konum dışındaysa return 0 gönder. Değilse joinTheInspection metoduna istek gönder
        await joinTheInspection(
            deviceId: deviceId, inspectionCode: inspectionCode);
      }
      log(_decodeResponse.toString());
      return {
        'status': _decodeResponse["status"].toString(),
        'text': _decodeResponse["text"]
      };
    }
    return {'status': "0", 'text': "İstek gönderimi başarısız"};
  }

  static Future<Map<String, String>> getStudentLessons() async {
    String _responseBody = await _sendRequest(
      isGetRequest: true,
      url: ApiAddress.OGRENCI_YOKLAMALAR,
      headers: {'token': token},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        Lessons.fromJson(_decodeResponse);
      }
      log(_decodeResponse.toString());
      return {
        'status': _decodeResponse["status"].toString(),
        // 'text': _decodeResponse["text"]
      };
    }
    return {'status': "0", 'text': "İstek gönderimi başarısız"};
  }

  static Future<Map<String, dynamic>> getLessonById(
      {required String lessonId}) async {
    String _responseBody = await _sendRequest(
      url: ApiAddress.OGRENCI_DERS_YOKLAMALARI,
      headers: {'token': token},
      body: {'dersid': lessonId},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);

      if (_decodeResponse["status"] == 1) {
        log(_decodeResponse.toString());

        return _decodeResponse;
      }
      return {
        'status': _decodeResponse["status"].toString(),
        // 'text': _decodeResponse["text"]
      };
    }
    return {'status': "0", 'text': "İstek gönderimi başarısız"};
  }

  static Future<Map<String, String>> joinTheInspection({
    required String deviceId,
    required String inspectionCode,
  }) async {
    String _responseBody = await _sendRequest(
      url: ApiAddress.YOKLAMAYA_KATIL,
      headers: {'token': token},
      body: {'yoklamakodu': inspectionCode, 'cihazid': deviceId},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        return {
          'status': _decodeResponse["status"].toString(),
          'text': _decodeResponse["text"]
        };
      }
      log(_decodeResponse.toString());
      return {
        'status': _decodeResponse["status"].toString(),
        'text': _decodeResponse["text"]
      };
    }
    return {'status': "0", 'text': "İstek gönderimi başarısız"};
  }

  static Future<String> _sendRequest({
    required Uri url,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool isGetRequest = false,
  }) async {
    // log(body.toString());
    bool isConnect = await isInternetConnection();
    log(isConnect.toString());
    if (!isConnect) {
      return "-1";
    }
    http.Response response = isGetRequest
        ? await http.get(
            url,
            headers: headers,
          )
        : await http.post(
            url,
            body: body,
            headers: headers,
            encoding: encoding,
          );
    // log(response.body);
    if (response.statusCode == 200) {
      var _body = await response.body;
      if (jsonDecode(_body)["status"] == "4") {
        Map<String, String> _userInfo = await SecureFileService.readUserInfo();
        await login(
          user: _userInfo["user"]!,
          pass: _userInfo["pass"]!,
        );
      }
      return _body;
    } else {
      log("İstek gönderme başarısız. Hata Kodu: (${response.statusCode})");
    }
    return "0";
  }

  static Future<bool> isInternetConnection() async {
    bool status = false;
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        status = true;
      }
    } catch (_) {
      log(_.toString());
      status = false;
    } finally {
      return status;
    }
  }
}

class ApiAddress {
  static const String _endPoint = "https://yoklamatakip.emrecambolat.com/api/";
  static const String _login = "login";
  static const String _ogrenciDuzenle = "ogrenci/duzenle";
  static const String _yoklamayaKatil = "yoklama/katil";
  static const String _yoklamaBilgisi = "yoklama/bilgi";
  static const String _ogrenciYoklamalar = "ogrenci/yoklamalar";
  static const String _ogrenciDersYoklamalari = "ogrenci/dersYoklamalar";

  static Uri get LOGIN => Uri.parse(Uri.encodeFull(_endPoint + _login));
  static Uri get OGRENCI_DUZENLE =>
      Uri.parse(Uri.encodeFull(_endPoint + _ogrenciDuzenle));
  static Uri get YOKLAMAYA_KATIL =>
      Uri.parse(Uri.encodeFull(_endPoint + _yoklamayaKatil));
  static Uri get YOKLAMA_BILGISI =>
      Uri.parse(Uri.encodeFull(_endPoint + _yoklamaBilgisi));
  static Uri get OGRENCI_YOKLAMALAR =>
      Uri.parse(Uri.encodeFull(_endPoint + _ogrenciYoklamalar));
  static Uri get OGRENCI_DERS_YOKLAMALARI =>
      Uri.parse(Uri.encodeFull(_endPoint + _ogrenciDersYoklamalari));
}
