// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/Data/database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  // Take reference of the hive box
  final mybox = Hive.box("taskBox");
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    super.initState();

    // first time opening the app
    if (mybox.get('TODOLIST') == null) {
      db.createdataList();
    } else {
      db.loadData();
    }

  }

  //what's gonna happen when Check box Tapped
  void checkboxtap(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateData();
  }

  // new task controller
  TextEditingController newtaskcontroller = TextEditingController();

  // create new task while clicking on Floating action button
  Future createnewtask() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[500],
        content: Container(
          height: 150,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // for taking user input
              TextField(
                strutStyle: StrutStyle(height: 1.3),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                controller: newtaskcontroller,
                decoration: InputDecoration(
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 50,
                    ),
                  ),
                  hintText: "Add a new task",
                ),
              ),
              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // save button
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if(newtaskcontroller.text.isNotEmpty){
                          db.todoList.add([newtaskcontroller.text, false]);
                          newtaskcontroller.clear();
                          Navigator.of(context).pop();
                        }
                      });
                      db.updateData();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // cancel button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //delete func for deleting the task
  void deletefunc(int value) {
    setState(() {
      db.todoList.removeAt(value);
    });
    db.updateData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "${db.todoList[value][0]} deleted!!",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'TO DO APP',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
      backgroundColor: Colors.yellow[200],
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: createnewtask,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => deletefunc(index),
                    icon: Icons.delete,
                    backgroundColor: Colors.red.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[500],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Check Box
                    Checkbox(
                      value: db.todoList[index][1],
                      onChanged: (value) => checkboxtap(value, index),
                      activeColor: Colors.black87,
                    ),
                    // Task Name
                    Text(
                      db.todoList[index][0],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: db.todoList[index][1] == true
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
