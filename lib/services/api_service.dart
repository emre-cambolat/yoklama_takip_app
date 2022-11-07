import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yoklama_takip/models/inspection.dart';
import 'package:yoklama_takip/models/ogrenci.dart';

class ApiServices {
  static String _token = "";
  static String get token => _token;
  static String loginStatusText = "";

  static Future<Map<String, String>> login({
    required String user,
    required String pass,
  }) async {
    String _responseBody = await _postRequest(
      url: ApiAddress.LOGIN,
      body: {'kullaniciAdi': user.trim(), 'sifre': pass.trim()},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        _token = _decodeResponse["token"];
        Ogrenci.fromJson(_decodeResponse["ogrenci"]);
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
    String _responseBody = await _postRequest(
      url: ApiAddress.OGRENCI_DUZENLE,
      headers: {'token': token},
      body: {'cihazid': deviceId},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        Ogrenci.cihazid = deviceId;
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
    String _responseBody = await _postRequest(
      url: ApiAddress.YOKLAMA_BILGISI,
      headers: {'token': token},
      body: {'yoklamakodu': inspectionCode, 'cihazid': deviceId},
    );
    if (_responseBody == "-1") {
      return {'status': "-1", 'text': "İnternet bağlantınızı kontrol ediniz."};
    } else if (_responseBody != "0") {
      var _decodeResponse = jsonDecode(_responseBody);
      if (_decodeResponse["status"] == 1) {
        Inspection.fromJson(_decodeResponse["data"]);
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

  static Future<Map<String, String>> joinTheInspection({
    required String deviceId,
    required String inspectionCode,
  }) async {
    String _responseBody = await _postRequest(
      url: ApiAddress.YOKLAMA_BILGISI,
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

  static Future<String> _postRequest({
    required Uri url,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    // log(body.toString());
    bool isConnect = await isInternetConnection();
    log(isConnect.toString());
    if (!isConnect) {
      return "-1";
    }
    http.Response response = await http.post(
      url,
      body: body,
      headers: headers,
      encoding: encoding,
    );
    // log(response.body);
    if (response.statusCode == 200) {
      var _body = await response.body;
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
  static String _endPoint = "https://yoklamatakip.emrecambolat.com/api/";
  static String _login = "login";
  static String _ogrenciDuzenle = "ogrenci/duzenle";
  static String _yoklamayaKatil = "yoklama/katil";
  static String _yoklamaBilgisi = "yoklama/bilgi";
  static String _ogrenciYoklamalar = "ogrenci/yoklamalar";

  static Uri get LOGIN => Uri.parse(Uri.encodeFull(_endPoint + _login));
  static Uri get OGRENCI_DUZENLE =>
      Uri.parse(Uri.encodeFull(_endPoint + _ogrenciDuzenle));
  static Uri get YOKLAMAYA_KATIL =>
      Uri.parse(Uri.encodeFull(_endPoint + _yoklamayaKatil));
  static Uri get YOKLAMA_BILGISI =>
      Uri.parse(Uri.encodeFull(_endPoint + _yoklamaBilgisi));
  static Uri get OGRENCI_YOKLAMALAR =>
      Uri.parse(Uri.encodeFull(_endPoint + _ogrenciYoklamalar));
}
