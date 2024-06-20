// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Model/DataModelPage.dart';
import 'package:wissme/pages/EditAssignWork.dart';
import '../main.dart';

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
        // Add your onTap functionality here
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade700,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
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
                      icon: const Icon(Icons.edit, color: Colors.white),
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
                list[index].workTitle,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                list[index].workName,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                list[index].endTime,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list[index].faculty,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (type.contains("Teacher"))
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        showCupertinoDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text('Alert'),
                            content: const Text(
                                'Are you sure? You Want To Delete This Work!'),
                            actions: <Widget>[
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
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
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
