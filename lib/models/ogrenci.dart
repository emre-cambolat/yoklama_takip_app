class Ogrenci {
  static late int id;
  static late String adsoyad;
  static late String eposta;
  static late String ogrencino;
  static late  String cihazid;

  // Ogrenci({this.id, this.adsoyad, this.eposta, this.ogrencino, this.cihazid});

  Ogrenci.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adsoyad = json['adsoyad'];
    eposta = json['eposta'];
    ogrencino = json['ogrencino'];
    cihazid = json['cihazid'];
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