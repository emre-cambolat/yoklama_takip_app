class StudentModel {
  static late int id;
  static late String adSoyad;
  static late String adSoyadBasHarf;
  static late String ePosta;
  static late String ogrenciNo;
  static late  String cihazId;

  // Ogrenci({this.id, this.adsoyad, this.eposta, this.ogrencino, this.cihazid});

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adSoyad = json['adsoyad'];
    ePosta = json['eposta'];
    ogrenciNo = json['ogrencino'];
    cihazId = json['cihazid'];
    adSoyadBasHarf = adSoyad.split(' ').first[0] + adSoyad.split(' ').last[0];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['adsoyad'] = this.adsoyad;
  //   data['eposta'] = this.eposta;
  //   data['ogrencino'] = this.ogrencino;
  //   data['cihazid'] = this.cihazid;
  //   return data;
  // }
}