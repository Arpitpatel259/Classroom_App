import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SharedPreferences logindata;
  late String userId = "";

  var email = "";
  var name = "";
  var enrollment = "";
  var mobileno = "";
  var organization = "";
  var type = "";
  late String profileImageUrl = "";
  bool notificationsEnabled = true;

  // Design Tokens
  final Color primaryBlue = const Color(0xFF1A73E8);
  final Color darkText = const Color(0xFF1A1A2E);
  final Color bodyText = const Color(0xFF6B7280);
  final Color backgroundColor = const Color(0xFFF7F8FA);
  final Color borderColor = const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userId = logindata.getString("userId") ?? "";
      name = logindata.getString("name") ?? "";
      email = logindata.getString("email") ?? "";
      enrollment = logindata.getString("enrollment") ?? "";
      mobileno = logindata.getString("mobile") ?? "";
      organization = logindata.getString("organization") ?? "";
      type = logindata.getString("type") ?? "";
      profileImageUrl = logindata.getString("profileImageUrl") ?? "";
      notificationsEnabled = logindata.getBool("notificationsEnabled") ?? true;
    });
  }

  File? _imageFile;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      HapticFeedback.mediumImpact();
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadProfileImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Account Information"),
                  _buildAccountCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Preferences"),
                  _buildPreferencesCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Application"),
                  _buildAppInfoTile(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: primaryBlue.withValues(alpha: 0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/images/app_icon.png')
                    as ImageProvider),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 18,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: darkText),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              type.toUpperCase(),
              style: TextStyle(
                  fontSize: 10, color: primaryBlue, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 24),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: bodyText,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.person_outline_rounded, "Full Name", name),
          _buildDivider(),
          _buildInfoRow(Icons.mail_outline_rounded, "Email Address", email),
          _buildDivider(),
          _buildInfoRow(Icons.phone_android_rounded, "Mobile Number", mobileno),
          _buildDivider(),
          _buildInfoRow(Icons.badge_outlined, "Enrollment ID", enrollment),
          _buildDivider(),
          _buildInfoRow(Icons.business_rounded, "Organization", organization),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
              logindata.setBool("notificationsEnabled", val);
            },
            secondary: Icon(Icons.notifications_none_rounded, color: primaryBlue),
            title: Text("Push Notifications", style: TextStyle(color: darkText, fontSize: 15, fontWeight: FontWeight.w600)),
            subtitle: Text("Stay updated with assignments", style: TextStyle(color: bodyText, fontSize: 12)),
            activeThumbColor: primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: primaryBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: bodyText, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(color: darkText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 54, endIndent: 16, color: borderColor);
  }

  Widget _buildAppInfoTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAppInfoBottomSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                      Icons.info_outline_rounded, color: primaryBlue, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "App Information",
                    style: TextStyle(color: darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: borderColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadProfileImage() async {
    String fileName = '${userId}_profile.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child(
        'profile_images/$fileName');

    try {
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await snapshot.ref.getDownloadURL();

      await logindata.setString("profileImageUrl", downloadURL);

      if (!mounted) return;
      setState(() {
        profileImageUrl = downloadURL;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Upload failed'), backgroundColor: Colors.red),
      );
    }
  }

  void _showAppInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: borderColor,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Text("WissMe", style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkText)),
                const SizedBox(height: 8),
                Text("Version 1.0.0",
                    style: TextStyle(color: bodyText, fontSize: 14)),
                const SizedBox(height: 24),
                _buildDialogItem(
                    Icons.code_rounded, "Developer", "Kanudo Creation"),
                _buildDialogItem(Icons.description_outlined, "About",
                    "Built for seamless communication between users and organizations."),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Close", style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  Widget _buildDialogItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: bodyText),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 13,
                    color: bodyText,
                    fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(
                    fontSize: 15, color: darkText, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
