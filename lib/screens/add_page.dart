import 'package:flutter/material.dart';
import 'package:flutter_todo_0331/services/todo_service.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? '수정' : '추가',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: '제목'),
          ),
          TextField(
            controller: descriptController,
            decoration: InputDecoration(hintText: '내용'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? '업데이트' : '저장',
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('업데이트 오류');
      return;
    }
    final id = todo['_id'];

    //submit updated to the server
    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      showSuccessMessage(context, message: 'Updation success');
      print('Updation success');
    } else {
      showErrorMessage(context, message: 'creation failed');
    }
  }

  Future<void> submitData() async {
    //submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptController.text = '';
      showSuccessMessage(context, message: 'creation success');
    } else {
      showErrorMessage(context, message: 'creation failed');
    }
  }

  Map get body {
    // get the data from form
    final title = titleController.text;
    final description = descriptController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
