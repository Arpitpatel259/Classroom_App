// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

final databaseRef = FirebaseDatabase.instance.ref();

var classController = TextEditingController();
var workTitleController = TextEditingController();
var workNameController = TextEditingController();
var endTimeController = TextEditingController();
var facultyController = TextEditingController();

void insertDataForWork(
  String classname,
  String worktitle,
  String workname,
  String endtime,
  String faculty,
) {
  String? key = databaseRef.child("workTitle").push().key;
  databaseRef.child("workTitle").child(key!).set({
    'id': key,
    'classname': classname,
    'worktitle': worktitle,
    'workname': workname,
    'endtime': endtime,
    'faculty': faculty,
    'isSubmit': false, // Default value for isSubmit field
  });

  // Clear controllers after inserting data
  classController.clear();
  workTitleController.clear();
  workNameController.clear();
  endTimeController.clear();
  facultyController.clear();
}

void updateDataForWork(
  String key,
  String classname,
  String worktitle,
  String workname,
  String endtime,
  String faculty,
) {
  databaseRef.child("workTitle").child(key).set({
    'id': key,
    'classname': classname,
    'worktitle': worktitle,
    'workname': workname,
    'endtime': endtime,
    'faculty': faculty,
  });
}
