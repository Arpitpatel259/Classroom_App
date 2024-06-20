// ignore_for_file: avoid_print, must_be_immutable, use_key_in_widget_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wissme/main.dart';

import '../DataBase Work/InsertWork.dart';
import '../Model/DataModelPage.dart';
import '../constants.dart';

class EditAssignWork extends StatefulWidget {
  DataModelPage dataModelPage;

  EditAssignWork({required this.dataModelPage});

  @override
  State<EditAssignWork> createState() => _EditAssignWorkState();
}

class _EditAssignWorkState extends State<EditAssignWork> {
  List<DataModelPage> list = [];

  final workKey = GlobalKey<FormState>();
  var classController = TextEditingController();
  var workNameController = TextEditingController();
  var workTitleController = TextEditingController();
  var facultyController = TextEditingController();
  var dateInput = TextEditingController();

  Widget _buildWorkForm() {
    return Form(
      key: workKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* CLASS NAME FIELD*/
          const Text(
            'Class Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Class Name';
              }
              return null;
            },
            controller: classController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              hintText: 'Enter your Class Name',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* WORK NAME FIELD*/
          const Text(
            'Work Title',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Work Name';
              }
              return null;
            },
            controller: workNameController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              hintText: 'Enter your Work Title',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* WORK DETAILS FIELD*/
          const Text(
            'Work Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Work Details';
              }
              return null;
            },
            controller: workTitleController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.blue,
              ),
              hintText: 'Enter your Work Details',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* DUE DATE FIELD*/
          const Text(
            'Due Date',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextField(
            controller: dateInput,
            //editing controller of this TextField
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ), //icon of text field
              hintText: 'Select Due Date',
              hintStyle: TextStyle(color: Colors.black38), //label text of field
            ),
            readOnly: true,
            //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100));

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
                setState(() {
                  dateInput.text = formattedDate;
                });
              } else {}
            },
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /*You are a */
          const Text(
            'Faculty',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Faculty Name';
              }
              return null;
            },
            controller: facultyController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.mobile_friendly_sharp,
                color: Colors.blue,
              ),
              hintText: 'Enter your Faculty Name',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: () {
          if (workKey.currentState!.validate()) {
            workModule();
            setState(() {});
            if (classController.text.isNotEmpty &&
                workNameController.text.isNotEmpty &&
                workTitleController.text.isNotEmpty &&
                dateInput.text.isNotEmpty &&
                facultyController.text.isNotEmpty) {
              updateDataForWork(
                  widget.dataModelPage.key,
                  classController.text,
                  workNameController.text,
                  workTitleController.text,
                  dateInput.text,
                  facultyController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Work Not Assign Properly. Please Check Your Details!",
                  ),
                  backgroundColor: Colors.teal,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    disabledTextColor: Colors.white,
                    textColor: Colors.yellow,
                    onPressed: () {
                      //Do whatever you want
                    },
                  ),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.orange,
        ),
        child: const Text(
          'Update Assign Work',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  workModule() async {
    if (workTitleController.text.isNotEmpty) {
      try {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Work Assign Successfully.",
            ),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                //Do whatever you want
              },
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (kDebugMode) {
            print("Password Provided is too Weak");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Password Provided is too Weak",
              ),
              backgroundColor: Colors.teal,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Dismiss',
                disabledTextColor: Colors.white,
                textColor: Colors.yellow,
                onPressed: () {
                  //Do whatever you want
                },
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          if (kDebugMode) {
            print("Account Already exists");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Account Already exists",
              ),
              backgroundColor: Colors.teal,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Dismiss',
                disabledTextColor: Colors.white,
                textColor: Colors.yellow,
                onPressed: () {
                  //Do whatever you want
                },
              ),
            ),
          );
        }
      }
    } else {
      if (kDebugMode) {
        print("Password and Confirm Password doesn't match");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Password and Confirm Password doesn't match",
          ),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: Colors.yellow,
            onPressed: () {
              //Do whatever you want
            },
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classController.text = widget.dataModelPage.className;
    workNameController.text = widget.dataModelPage.workName;
    workTitleController.text = widget.dataModelPage.workTitle;
    facultyController.text = widget.dataModelPage.faculty;
    dateInput.text = widget.dataModelPage.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Update Assigned Work",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildWorkForm(),
                      _buildWorkButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
