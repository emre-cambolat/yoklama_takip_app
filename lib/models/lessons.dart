class Lessons {
  // Lessons({
  //   required this.status,
  //   required this.count,
  //   required this.data,
  // });

  static int status = -1;
  static int count = 0;
  static List<LessonModel> data = [];

  Lessons.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    count = json["count"];
    data = List<LessonModel>.from(
        json["data"].map((x) => LessonModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LessonModel {
  LessonModel({
    required this.id,
    required this.tarih,
    required this.fakulte,
    required this.dersId,
    required this.ders,
    required this.ogretmen,
  });

  int id;
  DateTime tarih;
  String fakulte;
  int dersId;
  String ders;
  String ogretmen;

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json["id"],
        tarih: DateTime.parse(json["tarih"]),
        fakulte: json["fakulte"],
        dersId: json["dersid"],
        ders: json["ders"],
        ogretmen: json["ogretmen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tarih": tarih.toIso8601String(),
        "fakulte": fakulte,
        "dersid": dersId,
        "ders": ders,
        "ogretmen": ogretmen,
      };
}
