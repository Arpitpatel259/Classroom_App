// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/main.dart';
import 'package:wissme/pages/about_us_page.dart';
import 'package:wissme/pages/complete_work.dart';
import 'package:wissme/pages/people_page.dart';
import '../Authentication/login_auth.dart';
import '../pages/setting_app.dart';

class NavigationDrawers extends StatefulWidget {
  const NavigationDrawers({super.key});

  @override
  State<NavigationDrawers> createState() => _NavigationDrawer();
}

class _NavigationDrawer extends State<NavigationDrawers> {
  late SharedPreferences logindata;

  String email = '';
  String name = '';
  String type = '';
  String pImage = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email') ?? '';
      name = logindata.getString('name') ?? '';
      type = logindata.getString('type') ?? '';
      pImage = logindata.getString('profileImageUrl') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = type.contains('Student');

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  onTap: () => _navigate(context, 0),
                ),
                _buildMenuItem(
                  icon: Icons.people_outline_rounded,
                  label: isStudent ? 'Teachers' : 'Students',
                  onTap: () => _navigate(context, 1),
                ),
                if (isStudent)
                  _buildMenuItem(
                    icon: Icons.task_alt_rounded,
                    label: 'Completed Work',
                    onTap: () => _navigate(context, 2),
                  ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => _navigate(context, 3),
                ),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About Us',
                  onTap: () => _navigate(context, 4),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                ),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: const Color(0xFFEF4444),
                  onTap: () => _navigate(context, 5),
                ),
              ],
            ),
          ),

          // Version footer
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'WissMe v1.0.0',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'U';

    return Container(
      width: double.infinity,
      color: const Color(0xFF1A73E8),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _showProfileModal(context),
            child: Hero(
              tag: 'profile-picture',
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: pImage.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    pImage,
                    fit: BoxFit.cover,
                  ),
                )
                    : Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            name.isNotEmpty ? name : 'User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),

          // Email
          Text(
            email,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              type.isNotEmpty ? type : 'Member',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xFF374151),
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      horizontalTitleGap: 4,
      minLeadingWidth: 20,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      hoverColor: const Color(0xFFEFF6FF),
    );
  }

  void _navigate(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentClass()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompleteWork()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutUsPage()),
        );
        break;
      case 5:
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to logout from WissMe?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () async {
                          await logindata.clear();
                          Navigator.pop(ctx);
                          Navigator.pushAndRemoveUntil(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Hero(
            tag: 'profile-picture',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: pImage.isNotEmpty
                  ? Image.network(
                pImage,
                width: 280,
                height: 280,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 280,
                height: 280,
                color: const Color(0xFF1A73E8),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}