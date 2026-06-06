import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  final Color primaryBlue = const Color(0xFF1A73E8);
  final Color darkText = const Color(0xFF1A1A2E);
  final Color bodyText = const Color(0xFF6B7280);
  final Color backgroundColor = const Color(0xFFF7F8FA);
  final Color borderColor = const Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
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
            onPressed: () =>
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false,
                ),
          ),
          title: const Text(
            "About Developer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Connect with me"),
                    _buildContactCard(),
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryBlue.withValues(alpha: 0.2), width: 2),
            ),
            child: const CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/images/img_arpit_182.jpg'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Arpit Vekariya',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: darkText,
              fontFamily: 'Pacifico',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Flutter Developer'.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: primaryBlue,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
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

  Widget _buildContactCard() {
    return Container(
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
      child: Column(
        children: [
          _buildContactTile(
            icon: Icons.language_rounded,
            title: 'Portfolio Blog',
            subtitle: 'arpit-blog.epizy.com',
            onTap: () => _launchURL('http://arpit-blog.epizy.com'),
          ),
          _buildDivider(),
          _buildContactTile(
            icon: Icons.phone_android_rounded,
            title: 'Phone',
            subtitle: '+91 92650 32740',
            onTap: () => _launchURL('tel:+919265032740'),
          ),
          _buildDivider(),
          _buildContactTile(
            icon: Icons.mail_outline_rounded,
            title: 'Email',
            subtitle: 'aj.vekariya123@gmail.com',
            onTap: () => _launchURL('mailto:aj.vekariya123@gmail.com'),
          ),
          _buildDivider(),
          _buildContactTile(
            icon: Icons.code_rounded,
            title: 'GitHub',
            subtitle: 'github.com/Arpitpatel259',
            onTap: () => _launchURL('https://github.com/Arpitpatel259'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: subtitle));
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied: $subtitle'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryBlue, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: bodyText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new_rounded, color: borderColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 70, endIndent: 16, color: borderColor);
  }

  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text(
            "Made with ❤️ using Flutter",
            style: TextStyle(color: Color(0xFFADB5BD),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            "WissMe v1.0.0",
            style: TextStyle(color: Color(0xFFADB5BD), fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}