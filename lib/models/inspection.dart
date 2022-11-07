class Inspection {
  static late String ogretmen;
  static late String ders;
  static late String fakulte;
  static late double fakultelat;
  static late double fakultelong;

  Inspection.fromJson(Map<String, dynamic> json) {
    ogretmen = json['ogretmen'];
    ders = json['ders'];
    fakulte = json['fakulte'];
    fakultelat = double.parse(json['fakultelat']);
    fakultelong = double.parse( json['fakultelong']);
  }
}
