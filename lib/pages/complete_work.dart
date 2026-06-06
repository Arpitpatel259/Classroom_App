import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/com_work_model_page.dart';
import '../main.dart';

class CompleteWork extends StatefulWidget {
  const CompleteWork({super.key});

  @override
  State<CompleteWork> createState() => _CompleteWorkState();
}

class _CompleteWorkState extends State<CompleteWork> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<ComWorkModelPage> list = [];

  var type = "";
  late SharedPreferences logindata;

  late AnimationController _appearanceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Design Tokens (Consistent with the rest of the app)
  final Color primaryBlue = const Color(0xFF1A73E8);
  final Color darkText = const Color(0xFF1A1A2E);
  final Color bodyText = const Color(0xFF6B7280);
  final Color backgroundColor = const Color(0xFFF7F8FA);
  final Color borderColor = const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _appearanceController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _appearanceController, curve: Curves.easeOutCubic));

    getData();
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    super.dispose();
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
        // Sort by timestamp descending (newest first)
        list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      if (mounted) {
        setState(() {
          isLoading = false;
          _appearanceController.forward();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false,
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
          title: const Text(
            "Completed Work",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.5),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: isLoading
            ? _buildLoadingState()
            : list.isEmpty
                ? _buildEmptyState()
                : _buildListView(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(color: primaryBlue, strokeWidth: 3),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 64, color: borderColor),
          const SizedBox(height: 16),
          Text(
            "No Submissions Yet",
            style: TextStyle(color: darkText, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Work you submit will appear here.",
            style: TextStyle(color: bodyText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildCompletedWorkCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildCompletedWorkCard(int index) {
    final work = list[index];
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
              // Potential Action: Open PDF URL if available
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "SUBMITTED",
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTimestamp(work.timestamp),
                        style: TextStyle(color: bodyText, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    work.workTitle,
                    style: TextStyle(
                      color: darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.school_outlined, "Class", work.workClass),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person_outline_rounded, "Student", work.name),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    children: [
                      Icon(Icons.picture_as_pdf_rounded, size: 18, color: Colors.redAccent.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          work.filename,
                          style: TextStyle(
                            color: darkText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: borderColor),
                    ],
                  ),
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
          style: TextStyle(color: bodyText, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: darkText, fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime dt = DateTime.parse(timestamp);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (e) {
      return timestamp;
    }
  }
}
