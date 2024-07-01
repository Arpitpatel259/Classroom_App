import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/main.dart';
import 'package:wissme/pages/about_us_page.dart';
import 'package:wissme/pages/complete_work.dart';
import 'package:wissme/pages/people_page.dart';

import '../Authentication/LoginAuth.dart';
import '../pages/setting_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = 'WissMe';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.blueGrey.shade50,
        ),
        home: const NavigationDrawers(),
      );
}

class NavigationDrawers extends StatefulWidget {
  const NavigationDrawers({Key? key}) : super(key: key);

  @override
  _NavigationDrawer createState() => _NavigationDrawer();
}

class _NavigationDrawer extends State<NavigationDrawers> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  late SharedPreferences logindata;
  late bool newuser;

  var email = "";
  var name = "";
  var type = "";
  var userId = "";
  var pImage = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      newuser = (logindata.getBool('login') ?? false);
      email = logindata.getString("email") ?? "";
      name = logindata.getString("name") ?? "";
      type = logindata.getString("type") ?? "";
      userId = logindata.getString("userId") ?? "";
      pImage = logindata.getString("profileImageUrl") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    accountName: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro',
                        ),
                        children: [
                          const TextSpan(
                            text: 'Welcome, ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: name,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SF Pro',
                            ),
                          ),
                        ],
                      ),
                    ),
                    accountEmail: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'CustomFont',
                        ),
                        children: [
                          const TextSpan(
                            text: 'Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: email,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SF Pro',
                            ),
                          ),
                        ],
                      ),
                    ),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _buildProfileModal(context),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Hero(
                        tag: 'profile-picture',
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: pImage.isNotEmpty
                                ? Image.network(
                                    pImage,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    child: const Center(
                                      child: Icon(
                                        Icons.account_circle,
                                        size: 72, // adjust size as needed
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'DashBoard',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SF Pro',
                    ),
                    icon: Icons.home,
                    onClicked: () => selectedItems(context, 0),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: type.contains("Student") ? "Teacher" : "Student",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SF Pro',
                    ),
                    icon: Icons.people,
                    onClicked: () => selectedItems(context, 1),
                  ),
                  const SizedBox(height: 24),
                  type.contains("Student")
                      ? buildMenuItem(
                          text: 'Completed Work',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'SF Pro',
                          ),
                          icon: Icons.work_history,
                          onClicked: () => selectedItems(context, 2),
                        )
                      : const SizedBox(),
                  type.contains("Student")
                      ? const SizedBox(height: 24)
                      : const SizedBox(),
                  buildMenuItem(
                    text: 'Setting',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SF Pro',
                    ),
                    icon: Icons.settings,
                    onClicked: () => selectedItems(context, 3),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'About Us',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SF Pro',
                    ),
                    icon: Icons.info_outline,
                    onClicked: () => selectedItems(context, 4),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Logout',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SF Pro',
                    ),
                    icon: Icons.logout_sharp,
                    onClicked: () => selectedItems(context, 5),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
    required TextStyle style,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  selectedItems(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
          break;
        }
      case 1:
        {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const StudentClass()),
          );
          break;
        }
      case 2:
        {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const complete_work()),
          );
          break;
        }
      case 3:
        {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
          break;
        }
      case 4:
        {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AboutUsPage()),
          );
          break;
        }
      case 5:
        {
          showCupertinoDialog<String>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Alert'),
              content:
                  const Text('Are you sure you want to logout from this app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    logindata.setBool('login', true);
                    logindata.remove("email");
                    await logindata.clear();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
          break;
        }
    }
  }

  Widget _buildProfileModal(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Hero(
            tag: 'profile-picture',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: ClipOval(
                child: pImage.isNotEmpty
                    ? Image.network(
                        pImage,
                        fit: BoxFit.cover,
                        width: 300,
                        height: 300,
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 250,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
