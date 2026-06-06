import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DataModelPage.dart';
import 'package:file_picker/file_picker.dart';
import 'complete_work.dart';

class SubmitWork extends StatefulWidget {
  final DataModelPage dataModelPage;

  const SubmitWork({super.key, required this.dataModelPage});

  @override
  State<SubmitWork> createState() => _SubmitWorkState();
}

class _SubmitWorkState extends State<SubmitWork> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late SharedPreferences logindata;
  String type = "";
  File? selectedFile;
  String fileName = "";
  String? fileUrl;

  late AnimationController _appearanceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Design Tokens (Consistent with Login/Register/Main)
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

    _appearanceController.forward();
    _getData();
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    setState(() => isLoading = true);
    logindata = await SharedPreferences.getInstance();
    type = logindata.getString("type") ?? "";
    await Firebase.initializeApp();
    setState(() => isLoading = false);
  }

  void selectFile() async {
    HapticFeedback.mediumImpact();
    FilePickerResult? result = await FilePicker.pickFiles(
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

  Future<void> submitWork() async {
    if (selectedFile == null) {
      _showSnackBar('Please select a PDF file first.', isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      String userId = logindata.getString("userId") ?? "";
      String name = logindata.getString("name") ?? "";
      String email = logindata.getString("email") ?? "";
      String timestamp = DateTime.now().toString();

      String newFileName = fileName;
      int fileCount = 0;

      // Smart file naming logic
      bool fileExists = true;
      while (fileExists) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_uploads/$userId/$newFileName');
        try {
          await storageRef.getDownloadURL();
          fileCount++;
          String baseName = fileName.contains('.') ? fileName.split('.').first : fileName;
          newFileName = "${baseName}_$fileCount.pdf";
        } catch (e) {
          fileExists = false;
        }
      }

      Reference finalStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_uploads/$userId/$newFileName');
      UploadTask uploadTask = finalStorageRef.putFile(selectedFile!);
      
      await uploadTask.whenComplete(() async {
        fileUrl = await finalStorageRef.getDownloadURL();

        DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
        String key = databaseRef.child("submitted_work").push().key ?? "";
        await databaseRef.child("submitted_work").child(userId).child(key).set({
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

        await databaseRef.child("workTitle").child(widget.dataModelPage.key).update({
          'isSubmit': true,
        });

        if (!mounted) return;
        setState(() => isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompleteWork()),
        );

        _showSnackBar('Work submitted successfully!');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar('Failed to submit work: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Submit Work",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.5),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAssignmentCard(),
                      const SizedBox(height: 32),
                      _buildSectionLabel("Upload Document"),
                      const SizedBox(height: 12),
                      _buildUploadZone(),
                      const SizedBox(height: 48),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryBlue, strokeWidth: 3),
          const SizedBox(height: 20),
          Text("Processing...", style: TextStyle(color: bodyText, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: bodyText,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildAssignmentCard() {
    final data = widget.dataModelPage;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  data.className.toUpperCase(),
                  style: TextStyle(color: primaryBlue, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Icon(Icons.timer_outlined, size: 16, color: bodyText),
              const SizedBox(width: 4),
              Text(
                "Due: ${data.endTime}",
                style: TextStyle(color: bodyText, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            data.workTitle,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkText, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Text(
            data.workName,
            style: TextStyle(fontSize: 15, color: bodyText, height: 1.5),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: primaryBlue.withValues(alpha: 0.1),
                child: Icon(Icons.person, size: 14, color: primaryBlue),
              ),
              const SizedBox(width: 8),
              Text(
                data.faculty,
                style: TextStyle(color: darkText, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadZone() {
    return GestureDetector(
      onTap: selectFile,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: selectedFile != null ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedFile != null ? const Color(0xFF10B981) : primaryBlue.withValues(alpha: 0.2),
            width: 2,
            style: selectedFile != null ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: selectedFile == null ? _buildEmptyFileState() : _buildSelectedFileState(),
      ),
    );
  }

  Widget _buildEmptyFileState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 40, color: primaryBlue),
        const SizedBox(height: 12),
        Text(
          "Click to select PDF",
          style: TextStyle(color: darkText, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          "Only PDF files are supported",
          style: TextStyle(color: bodyText, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSelectedFileState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(color: darkText, fontSize: 15, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Ready to submit",
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              selectedFile = null;
              fileName = "";
            }),
            icon: Icon(Icons.refresh_rounded, color: bodyText),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    bool isEnabled = selectedFile != null;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? submitWork : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          disabledBackgroundColor: borderColor,
          elevation: isEnabled ? 2 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          'Submit Assignment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isEnabled ? Colors.white : bodyText,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
