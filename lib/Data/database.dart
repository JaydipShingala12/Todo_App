import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {

  List todoList = [];

  // reference of our box
  final mybox = Hive.box("taskBox");

  // first time user open the App

  void createdataList() {
    todoList = [
      ['1st Task', false],
      ['2nd Task', false],
    ];
  }

  // load the data from database
  void loadData() {
    todoList = mybox.get('TODOLIST');
  }

  // update the database
  void updateData() {
    mybox.put('TODOLIST', todoList);
  }
}
