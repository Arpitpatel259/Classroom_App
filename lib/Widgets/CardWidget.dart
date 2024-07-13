// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Model/DataModelPage.dart';
import 'package:wissme/pages/EditAssignWork.dart';
import '../main.dart';
import '../pages/complete_work.dart';
import '../pages/showAll_work.dart';
import '../pages/submit_work.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  List<DataModelPage> list = [];

  bool isLoading = false;
  late SharedPreferences logindata;
  var type = "";

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
    FirebaseDatabase.instance.ref("workTitle").onValue.listen((snapshot) {
      if (snapshot.snapshot.exists) {
        list.clear();
        for (DataSnapshot snp in snapshot.snapshot.children) {
          list.add(DataModelPage(
            key: snp.key.toString(),
            className: snp.child("classname").value.toString(),
            workName: snp.child("workname").value.toString(),
            workTitle: snp.child("worktitle").value.toString(),
            endTime: snp.child("endtime").value.toString(),
            faculty: snp.child("faculty").value.toString(),
          ));
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : list.isEmpty
                    ? const Center(
                        child: Text("No Work Found Here!"),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return getItemContainer(context, index);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget getItemContainer(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        if (type.contains("Student")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitWork(dataModelPage: list[index]),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
            left: 10,
            right: 10,
            top: index == 0 ? 10 : 5,
            bottom: index == list.length - 1 ? 10 : 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list[index].className,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  if (type.contains("Teacher"))
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.amberAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAssignWork(
                              dataModelPage: list[index],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Title: ${list[index].workTitle}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Due by: ${list[index].endTime}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (type.contains("Teacher"))
                    Text(
                      'Faculty: ${list[index].faculty}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (type.contains("Teacher"))
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.amberAccent),
                      onPressed: () {
                        showCupertinoDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                            title: const Text('Alert'),
                            content: const Text(
                                'Are you sure? You Want To Delete This Work!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final databaseRef =
                                      FirebaseDatabase.instance.ref();
                                  await databaseRef
                                      .child("workTitle")
                                      .child(list[index].key)
                                      .remove();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage()),
                                  );
                                },
                                child: const Text('Ok'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
