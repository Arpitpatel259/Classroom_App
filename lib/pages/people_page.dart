// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Model/studentDataModel.dart';

class StudentClass extends StatefulWidget {
  const StudentClass({Key? key}) : super(key: key);

  @override
  State<StudentClass> createState() => _StudentClassState();
}

class _StudentClassState extends State<StudentClass> {
  bool isLoading = false;
  List<studentDataModel> list = [];

  var type = "";
  late SharedPreferences logindata;

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
    FirebaseDatabase.instance.ref("userSignUp").onValue.listen((snapshot) {
      if (snapshot != null &&
          snapshot.snapshot != null &&
          snapshot.snapshot.children != null) {
        list.clear();
        for (DataSnapshot snp in snapshot.snapshot.children) {
          if (snp.child("type").value.toString().contains(type.contains
            ("Student")?"Teacher":"Student")) {
            list.add(studentDataModel(
              key: snp.key.toString(),
              firstname: snp.child("firstname").value.toString(),
              lastname: snp.child("lastname").value.toString(),
              mobile: snp.child("mobile").value.toString(),
              unique_id: snp.child("unique id").value.toString(),
              type: snp.child("type").value.toString(),
            ));
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Students",
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
      body: Container(
        margin: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
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
                          child: Text("No Student Found Here!"),
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
              spreadRadius: 4,
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
              Positioned(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: Text("Name : ${list[index].firstname} ${list[index]
                      .lastname}",
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
                child: Text( "Enrollment : ${list[index].unique_id}",
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
                child: Text("Mobile No : ${list[index].mobile}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
