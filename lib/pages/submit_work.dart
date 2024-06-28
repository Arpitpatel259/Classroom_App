import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DataBase Work/InsertWork.dart';
import '../Model/DataModelPage.dart';
import '../constants.dart';
import 'package:file_picker/file_picker.dart';
import 'complete_work.dart'; // Import complete_work page

class SubmitWork extends StatefulWidget {
  final DataModelPage dataModelPage;

  SubmitWork({required this.dataModelPage});

  @override
  State<SubmitWork> createState() => _SubmitWorkState();
}

class _SubmitWorkState extends State<SubmitWork> {
  bool isLoading = false;
  bool isFileUploaded = false;
  late SharedPreferences logindata;
  var type = "";
  late File? selectedFile;
  late String fileName = "";
  String? fileUrl;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    type = logindata.getString("type") ?? "";

    await Firebase.initializeApp();
    setState(() {
      isLoading = false;
    });
  }

  // Function to handle file selection
  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }

  // Function to upload file to Firebase Storage and submit data to Realtime Database
  Future<void> submitWork() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a PDF file first.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences logindata = await SharedPreferences.getInstance();
      String userId = logindata.getString("userId") ?? "";
      String name = logindata.getString("name") ?? "";
      String email = logindata.getString("email") ?? "";
      String timestamp = DateTime.now().toString();

      // Initial file name
      String newFileName = fileName;
      int fileCount = 0;

      // Check if the file with the same name exists and add a digit if it does
      bool fileExists = true;
      while (fileExists) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_uploads/$userId/$newFileName');
        try {
          await storageRef.getDownloadURL();
          // If the above line does not throw an error, the file exists
          fileCount++;
          newFileName = "${fileName.split('.').first}_$fileCount.pdf";
        } catch (e) {
          // If an error is thrown, the file does not exist
          fileExists = false;
        }
      }

      // Upload file to Firebase Storage
      Reference finalStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_uploads/$userId/$newFileName');
      UploadTask uploadTask = finalStorageRef.putFile(selectedFile!);
      await uploadTask.whenComplete(() async {
        fileUrl = await finalStorageRef.getDownloadURL();

        // Submit data to Realtime Database
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
        String key = databaseRef.child("submitted_work").push().key ?? "";
        databaseRef.child("submitted_work").child(userId).child(key).set({
          'id': key,
          'name': name,
          'email': email,
          'enrollment': userId,
          'filename': newFileName,
          'url': fileUrl,
          'timestamp': timestamp,
          'work_class': widget.dataModelPage.className,
          'work_id': widget.dataModelPage.key,
          'work_title': widget.dataModelPage.workTitle,
        });

        DatabaseReference database = FirebaseDatabase.instance.reference();
        database.child("workTitle").child(widget.dataModelPage.key).update({
          'isSubmit': true,
        });

        setState(() {
          isLoading = false;
        });

        // Navigate to complete_work page after submission
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const complete_work(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('File uploaded and work submitted successfully!'),
          duration: Duration(seconds: 2),
        ));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload file and submit work: $e'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.dataModelPage;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Submit Work",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        getItemContainer(data),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget getItemContainer(DataModelPage data) {
    return GestureDetector(
      onTap: () {
        // Handle tap event
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                    const TextSpan(
                      text: 'Classname: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: data.className,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ])),
              const SizedBox(height: 10),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                    const TextSpan(
                      text: 'Title: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: data.workTitle,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ])),
              const SizedBox(height: 10),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                    const TextSpan(
                      text: 'Due By: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: data.endTime,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ])),
              const SizedBox(height: 10),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                    const TextSpan(
                      text: 'Instruction: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: data.workName,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ])),
              const SizedBox(height: 10),
              RichText(
                text: fileName.isEmpty
                    ? const TextSpan()
                    : TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Filename: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: fileName.isEmpty ? "" : fileName,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: selectFile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        // Adjust padding as needed
                        primary: Colors.orange,
                        // Background color
                        onPrimary: Colors.white,
                        // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.25), // Adjust border radius as needed
                        ),
                      ),
                      child: const Text(
                        'Select File',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.5,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: submitWork,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(defaultPadding),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.25),
                        ),
                      ),
                      child: const Text(
                        'Submit Work',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.5,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
