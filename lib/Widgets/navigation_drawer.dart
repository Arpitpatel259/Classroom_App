// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/main.dart';
import 'package:wissme/pages/about_us_page.dart';
import 'package:wissme/pages/people_page.dart';

import '../Authentication/LoginAuth.dart';

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
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    home: const NavigationDrawers(),
  );
}

class NavigationDrawers extends StatefulWidget {
  const NavigationDrawers({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavigationDrawer createState() => _NavigationDrawer();
}

class _NavigationDrawer extends State<NavigationDrawers> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  late SharedPreferences logindata;
  late bool newuser;

  var email = "";
  var name = "";
  var type = "";

  @override
  void initState()  {
    super.initState();
    init();
  }

  init() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? false);
    email = logindata.getString("email") ?? "";
    name = logindata.getString("name") ?? "";
    type = logindata.getString("type") ?? "";
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  //buildSearchField(),
                  UserAccountsDrawerHeader(
                    accountName: Text("Name : $name"),
                    accountEmail: Text("Email : $email"),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          'https://picsum.photos/150/150',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'DashBoard',
                    icon: Icons.home,
                    onClicked: () => selectedItems(context, 0),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: type.contains("Student")?"Teacher":"Student",
                    icon: Icons.people,
                    onClicked: () => selectedItems(context, 1),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'About Us',
                    icon: Icons.info_outline,
                    onClicked: () => selectedItems(context, 2),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout_sharp,
                    onClicked: () => selectedItems(context, 3),
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
  }) {
    const color = Colors.white;
    const hovercolor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hovercolor,
      onTap: onClicked,
    );
  }

  selectedItems(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        {
          //Dashboard
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainPage()));
          break;
        }
      case 1:
        {
          //students
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const StudentClass()));
          break;
        }
      case 2:
        {
          //about us firebase login
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AboutUsPage()));
          break;
        }
      case 3:
        {
          showCupertinoDialog<String>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Alert'),
              content:
              const Text('Are you sure? You Want Logout From This App!'),
              actions: <Widget>[
                TextButton(
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
                  child: const Text('Ok'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancle'),
                ),
              ],
            ),
          );
        }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
