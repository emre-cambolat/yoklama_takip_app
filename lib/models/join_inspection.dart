class JoinInspectionModel {
  static late String ogretmen;
  static late String ders;
  static late String fakulte;
  static late double fakulteLat;
  static late double fakulteLong;

  JoinInspectionModel.fromJson(Map<String, dynamic> json) {
    ogretmen = json['ogretmen'];
    ders = json['ders'];
    fakulte = json['fakulte'];
    fakulteLat = double.parse(json['fakultelat']);
    fakulteLong = double.parse( json['fakultelong']);
  }
}
