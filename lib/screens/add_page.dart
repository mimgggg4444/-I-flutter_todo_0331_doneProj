import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

    final title = titleController.text;
    final description = descriptController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    //submit updated to the server
    final url = 'https://api.nstack.in/v1/$id';
    final uri = Uri.parse(url);
    final respose = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (respose.statusCode == 200) {


      showSuccessMessage('creation success');
      print('creation success');
    } else {
      showErrorMessage('creation failed');
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final respose = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (respose.statusCode == 201) {
      titleController.text = '';
      descriptController.text = '';
      showSuccessMessage('creation success');
      print('creation success');
    } else {
      showErrorMessage('creation failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
