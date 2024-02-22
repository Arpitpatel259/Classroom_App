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
    isLoading = true;

      logindata = await SharedPreferences.getInstance();
      type = logindata.getString("type") ?? "";

    await Firebase.initializeApp();
    FirebaseDatabase.instance.ref("workTitle").onValue.listen((snapshot) {
      //print(snapshot.toString());
      if (snapshot != null &&
          snapshot.snapshot != null &&
          snapshot.snapshot.children != null) {
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
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.only(
            left: 10,
            right: 10,
            top: index == 0 ? 10 : 10,
            bottom: index == list.length - 1 ? 10 : 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Positioned(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: Text(
                    list[index].className,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if(type.contains("Teacher"))
              Positioned(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAssignWork(
                              dataModelPage: list[index],
                            ),
                          ));
                    },
                  ),
                ),
              ),
            ]),
            Positioned(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: Text(
                  list[index].workTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: Text(
                  list[index].workName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: Text(
                  list[index].endTime,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: Text(
                    list[index].faculty,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if(type.contains("Teacher"))
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
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
                                databaseRef
                                    .child("workTitle")
                                    .child(list[index].key)
                                    .remove();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainPage()));
                              },
                              child: const Text('Ok'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancle'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
