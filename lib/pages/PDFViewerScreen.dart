import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFViewerScreen extends StatefulWidget {
  final String fileName;

  PDFViewerScreen({required this.fileName});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? fileUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    try {
      SharedPreferences logindata = await SharedPreferences.getInstance();
      String userId = logindata.getString("userId") ?? "";

      // Reference to the file
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_uploads/$userId/${widget.fileName}');

      // Get the file URL
      final url = await ref.getDownloadURL();

      setState(() {
        fileUrl = url;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : fileUrl != null
            ? PDFView(
          filePath: fileUrl!,
        )
            : Text('Failed to load PDF'),
      ),
    );
  }
}
