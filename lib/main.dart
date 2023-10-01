// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Pages/Home.dart';

void main(List<String> args) async {

  // Initialize the Hive
  await Hive.initFlutter();

  // Create A Hive box
  var mybox = await Hive.openBox("taskBox");

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
    ),
  );
}
