import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:yoklama_takip/models/lessons.dart';
import 'package:yoklama_takip/pages/lesson_inspections.dart';
import 'package:yoklama_takip/services/api_service.dart';
import 'package:yoklama_takip/utils/navigation_helper.dart';
import 'package:yoklama_takip/widgets/loading_listener.dart';

class MyLessonsUI extends StatefulWidget {
  const MyLessonsUI({super.key});

  @override
  State<MyLessonsUI> createState() => _MyLessonsUIState();
}

class _MyLessonsUIState extends State<MyLessonsUI> {
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    ApiServices.getStudentLessons().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Derslerim"),
      ),
      body: LoadingListenerUI(
        isLoading: _isLoading,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          itemCount: Lessons.data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(Lessons.data[index].ders),
                subtitle: Text(Lessons.data[index].ogretmen),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  NavigatorHelper.push(context,
                      child: LessonInspectionsUI(
                        lessonId: Lessons.data[index].dersId.toString(),
                        lessonName: Lessons.data[index].ders,
                      ));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
