// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Model/DataModelPage.dart';
import 'package:wissme/pages/EditAssignWork.dart';
import '../main.dart';
import '../pages/submit_work.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  List<DataModelPage> list = [];
  List<String> submittedWorkIdList = [];

  bool isLoading = false;
  late SharedPreferences logindata;
  var type = "";
  var userId = "";

  // Consistent Color Palette from Login/Register
  final Color primaryBlue = const Color(0xFF1A73E8);
  final Color darkText = const Color(0xFF1A1A2E);
  final Color bodyText = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  Future<void> getData() async {
    logindata = await SharedPreferences.getInstance();
    type = logindata.getString("type") ?? "";
    userId = logindata.getString("userId") ?? "";

    setState(() {
      isLoading = true;
    });

    await Firebase.initializeApp();

    // Fetch submitted work IDs
    FirebaseDatabase.instance
        .ref("submitted_work")
        .child(userId)
        .onValue
        .listen((snapshot) {
      if (snapshot.snapshot.exists) {
        submittedWorkIdList.clear();
        for (DataSnapshot snp in snapshot.snapshot.children) {
          submittedWorkIdList.add(snp.child("work_id").value.toString());
        }
      }
    });

    // Fetch work items
    FirebaseDatabase.instance.ref("workTitle").onValue.listen((snapshot) {
      if (snapshot.snapshot.exists) {
        list.clear();
        for (DataSnapshot snp in snapshot.snapshot.children) {
          if (!submittedWorkIdList.contains(snp.key.toString())) {
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
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primaryBlue,
      onRefresh: () async {
        await getData();
      },
      child: isLoading
          ? _buildLoadingState()
          : list.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _buildWorkCard(context, index);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF1A73E8),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_rounded, size: 64, color: borderColor),
          const SizedBox(height: 16),
          Text(
            "All caught up!",
            style: TextStyle(color: darkText, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "No pending work found for you.",
            style: TextStyle(color: bodyText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          if (type.contains("Student")) {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubmitWork(dataModelPage: list[index]),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Text(
                            list[index].className.toUpperCase(),
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (type.contains("Teacher"))
                          _buildTeacherActions(context, index),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      list[index].workTitle,
                      style: TextStyle(
                        color: darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      list[index].workName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: bodyText, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: borderColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: bodyText),
                    const SizedBox(width: 6),
                    Text(
                      "Due ${list[index].endTime}",
                      style: TextStyle(
                        color: bodyText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (type.contains("Teacher"))
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded, size: 16, color: bodyText),
                          const SizedBox(width: 4),
                          Text(
                            list[index].faculty,
                            style: TextStyle(color: bodyText, fontSize: 13),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherActions(BuildContext context, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(4),
          icon: Icon(Icons.edit_outlined, color: primaryBlue, size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAssignWork(dataModelPage: list[index]),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(4),
          icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
          onPressed: () => _showDeleteDialog(context, index),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Work?'),
        content: const Text('This action cannot be undone. Are you sure you want to remove this assignment?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              final databaseRef = FirebaseDatabase.instance.ref();
              await databaseRef.child("workTitle").child(list[index].key).remove();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
