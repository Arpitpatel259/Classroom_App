import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Model/com_work_model_page.dart';


class ShowallWork extends StatefulWidget {
  const ShowallWork({super.key});

  @override
  State<ShowallWork> createState() => _ShowallWorkState();
}

class _ShowallWorkState extends State<ShowallWork> {
  bool isLoading = false;
  List<ComWorkModelPage> list = [];

  var type = "";
  late SharedPreferences logindata;
  String fileName = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    String userId = logindata.getString("userId") ?? "";
    type = logindata.getString("type") ?? "";

    await Firebase.initializeApp();

    // Submitted By Personal User
    FirebaseDatabase.instance
        .ref("submitted_work")
        .child(userId)
        .onValue
        .listen((snapshot) {
      if (snapshot.snapshot.exists) {
        list.clear();
        for (DataSnapshot snp in snapshot.snapshot.children) {
          list.add(ComWorkModelPage(
            key: snp.key.toString(),
            workClass: snp.child("work_class").value.toString(),
            name: snp.child("name").value.toString(),
            timestamp: snp.child("timestamp").value.toString(),
            workTitle: snp.child("work_title").value.toString(),
            filename: snp.child("filename").value.toString(),
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
        title: const Text(
          "All Work",
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
                    child: list.isEmpty
                        ? const Center(
                            child: Text("No Work Submitted Yet!"),
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
    return GestureDetector(
      onTap: () {}, // Call openPDF on tap
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
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
              Text(
                "Name: ${list[index].name}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
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
                      text: list[index].workClass,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Work Title: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: list[index].workTitle,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Time: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: list[index].timestamp,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 1, // Limit to one line
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(
                            text: 'File: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: list[index].filename,
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Adjust the width as neede
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
