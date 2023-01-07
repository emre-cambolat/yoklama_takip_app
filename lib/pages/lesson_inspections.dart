import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yoklama_takip/models/dateformat.dart';
import 'package:yoklama_takip/models/lesson_inspections.dart';
import 'package:yoklama_takip/services/api_service.dart';
import 'package:yoklama_takip/widgets/loading_listener.dart';

class LessonInspectionsUI extends StatefulWidget {
  const LessonInspectionsUI({
    super.key,
    required this.lessonId,
    required this.lessonName,
  });

  final String lessonId;
  final String lessonName;

  @override
  State<LessonInspectionsUI> createState() => _LessonInspectionsUIState();
}

class _LessonInspectionsUIState extends State<LessonInspectionsUI> {
  bool _isLoading = true;
  LessonInspections _lessonInspections = LessonInspections(status: -1, count: 0, data: []);


  @override
  void initState() {
    ApiServices.getLessonById(lessonId: widget.lessonId).then((value) {
      log("message");
      log(value.toString());
      _lessonInspections = LessonInspections.fromJson(value);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonName + " Yoklamaları"),
      ),
      body: LoadingListenerUI(
        isLoading: _isLoading,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          itemCount: _lessonInspections.data.length,
          itemBuilder: (context, index) {
            InspectionModel lesson = _lessonInspections.data[index];
            return Card(
              child: ListTile(
                title: Text(DateFormat.fromDatetime(lesson.tarih).dateformat),
                subtitle: Text(lesson.ogretmen),
                trailing: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: lesson.durum == 0
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                  ),
                  child: lesson.durum == 0
                      ? Text(
                          "Katılmadı",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          "Katıldı",
                          style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
