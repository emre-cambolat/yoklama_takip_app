class LessonInspections {
    LessonInspections({
        required this.status,
        required this.count,
        required this.data,
    });

    int status = -1;
    int count = 0;
    List<InspectionModel> data = [];

    factory LessonInspections.fromJson(Map<String, dynamic> json) => LessonInspections(
        status: json["status"],
        count: json["count"],
        data: List<InspectionModel>.from(json["data"].map((x) => InspectionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class InspectionModel {
    InspectionModel({
        required this.id,
        required this.tarih,
        required this.fakulte,
        required this.ders,
        required this.ogretmen,
        required this.durum,
    });

    int id;
    DateTime tarih;
    String fakulte;
    String ders;
    String ogretmen;
    int durum;

    factory InspectionModel.fromJson(Map<String, dynamic> json) => InspectionModel(
        id: json["id"],
        tarih: DateTime.parse(json["tarih"]),
        fakulte: json["fakulte"],
        ders: json["ders"],
        ogretmen: json["ogretmen"],
        durum: json["durum"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tarih": tarih.toIso8601String(),
        "fakulte": fakulte,
        "ders": ders,
        "ogretmen": ogretmen,
        "durum": durum,
    };
}
