class StudentModel {
  static late int id;
  static late String adSoyad;
  static late String adSoyadBasHarf;
  static late String ePosta;
  static late String ogrenciNo;
  static late  String cihazId;

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adSoyad = json['adsoyad'];
    ePosta = json['eposta'];
    ogrenciNo = json['ogrencino'];
    cihazId = json['cihazid'];
    adSoyadBasHarf = adSoyad.split(' ').first[0] + adSoyad.split(' ').last[0];
  }
}