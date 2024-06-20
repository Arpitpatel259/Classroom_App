// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wissme/Model/AboutDataModel.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool isLoading = false;
  List<AboutDataModel> list = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    isLoading = true;

    await Firebase.initializeApp();
    FirebaseDatabase.instance
        .ref("Project_Participate")
        .onValue
        .listen((snapshot) {
      if (snapshot != null &&
          snapshot.snapshot != null &&
          snapshot.snapshot.children != null) {
        list.clear();
        for (DataSnapshot snp in snapshot.snapshot.children) {
          list.add(AboutDataModel(
            key: snp.key.toString(),
            name: snp.child("name").value.toString(),
            email: snp.child("email").value.toString(),
            enrollment: snp.child("enrollment").value.toString(),
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "About Us",
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
                          child: Text("No Data Found Here!"),
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
                child: Text(
                  list[index].name,
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
                  list[index].enrollment,
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
                  list[index].email,
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
