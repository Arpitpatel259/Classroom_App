// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Model/studentDataModel.dart';
import '../main.dart';

class StudentClass extends StatefulWidget {
  const StudentClass({super.key});

  @override
  State<StudentClass> createState() => _StudentClassState();
}

class _StudentClassState extends State<StudentClass> {
  bool isLoading = false;
  List<studentDataModel> list = [];
  var type = "";
  late SharedPreferences logindata;

  // Design Tokens (Consistent with Login/Register/Main)
  final Color primaryBlue = const Color(0xFF1A73E8);
  final Color darkText = const Color(0xFF1A1A2E);
  final Color bodyText = const Color(0xFF6B7280);
  final Color backgroundColor = const Color(0xFFF7F8FA);
  final Color borderColor = const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() => isLoading = true);

    logindata = await SharedPreferences.getInstance();
    type = logindata.getString("type") ?? "";

    await Firebase.initializeApp();

    // Listen for Realtime Database changes
    FirebaseDatabase.instance.ref("userSignUp").onValue.listen((snapshot) {
      if (snapshot.snapshot.exists) {
        list.clear();
        String searchType = type.contains("Student") ? "Teacher" : "Student";

        for (DataSnapshot snp in snapshot.snapshot.children) {
          String userType = snp.child("type").value.toString();

          if (userType.contains(searchType)) {
            list.add(studentDataModel(
              key: snp.key.toString(),
              firstname: snp.child("firstname").value.toString(),
              lastname: snp.child("lastname").value.toString(),
              mobile: snp.child("mobile").value.toString(),
              unique_id: snp.child("unique id").value.toString(),
              type: userType,
              email: snp.child("email").value.toString(),
            ));
          }
        }
      }
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayTitle = type.contains("Student") ? "Teachers" : "Students";

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
            ),
          ),
          title: Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: isLoading
            ? _buildLoadingState()
            : list.isEmpty
            ? _buildEmptyState(displayTitle)
            : _buildListView(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: primaryBlue,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildEmptyState(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 64, color: borderColor),
          const SizedBox(height: 16),
          Text(
            "No $title Found",
            style: TextStyle(
              color: darkText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "The directory is currently empty.",
            style: TextStyle(color: bodyText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildPersonCard(index);
      },
    );
  }

  Widget _buildPersonCard(int index) {
    final person = list[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              // Potential action: View profile or Start Chat
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: primaryBlue.withValues(alpha: 0.1),
                        child: Text(
                          person.firstname[0].toUpperCase(),
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${person.firstname} ${person.lastname}",
                              style: TextStyle(
                                color: darkText,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              person.type,
                              style: TextStyle(
                                color: primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: borderColor),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _buildInfoRow(Icons.badge_outlined, "ID", person.unique_id),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.phone_android_rounded, "Mobile", person.mobile),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.alternate_email_rounded, "Email", person.email),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: bodyText),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            color: bodyText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: darkText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
