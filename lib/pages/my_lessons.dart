import 'package:flutter/material.dart';
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
            LessonModel _model = Lessons.data[index];
            return _ListItem(model: _model);
          },
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key? key,
    required LessonModel model,
  }) : _model = model, super(key: key);

  final LessonModel _model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_model.ders),
        subtitle: Text(_model.ogretmen),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          NavigatorHelper.push(
            context,
            child: LessonInspectionsUI(
              lessonId: _model.dersId.toString(),
              lessonName: _model.ders,
            ),
          );
        },
      ),
    );
  }
}
