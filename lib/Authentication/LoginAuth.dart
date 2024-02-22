// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wissme/Authentication/forgetPassword.dart';
import 'package:wissme/Authentication/RegisterAuth.dart';
import 'package:wissme/main.dart';
import 'package:wissme/validation.dart';

import '../constants.dart';

Future<void> main() async {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  var email = "";
  var password = "";

  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //Email Text Field and Password Field
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Email';
              } else if (!value.isValidEmail) {
                return 'Please Enter Valid Email id';
              }
              return null;
            },
            controller: emailController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue,
              ),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(color: Colors.black38),
              errorStyle: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: defaultPadding),
          const Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Password';
              } else if (!value.isValidPassword) {
                return 'Please Enter Valid Password.';
              }
              return null;
            },
            obscureText: _isObscure,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            controller: passwordController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
              fillColor: Colors.white24,
              filled: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.blue,
              ),
              hintText: 'Enter your Password',
              hintStyle: const TextStyle(color: Colors.black38),
              errorStyle: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  //Forget Password Text Button
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const forgetPassword(
                studentKey: '',
              ),
            ),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15.0),
        ),
      ),
    );
  }

  //Login Button
  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              email = emailController.text;
              password = passwordController.text;
            });
            const CircularProgressIndicator();
            logindata.setBool('login', false);
            logindata.setString('email', email);
            logindata.setString('password', password);
            userLogin();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(defaultPadding), backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),

        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  //go to register text
  Widget _buildSignInWithText() {
    return const Column(
      children: <Widget>[
        Text(
          '-------------------- OR --------------------',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ],
    );
  }

  //go to register code
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Registration()),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential != null && userCredential.user != null) {
        FirebaseDatabase.instance
            .ref("userSignUp/${userCredential.user!.uid}")
            .onValue
            .listen((event) {
          logindata.setString(
              "email", event.snapshot.child("email").value.toString());
          logindata.setString(
              "type", event.snapshot.child("type").value.toString());
          logindata.setString(
              "name",
              "${event.snapshot.child("firstname").value} ${event.snapshot.child("lastname").value}");
          print(event.snapshot.child("email").value.toString());
          print(event.snapshot.child("type").value.toString());
          print("${event.snapshot.child("firstname").value} ${event.snapshot.child("lastname").value}");
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "You Have Been Logged In Successfully!",
          ),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: Colors.yellow,
            onPressed: () {
              //Do whatever you want
            },
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "No User Found for that Email",
            ),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                //Do whatever you want
              },
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Wrong Password Provided by You",
            ),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                //Do whatever you want
              },
            ),
          ),
        );
      } else if (e.code == 'wrong-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Wrong Email Provided by You",
            ),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                //Do whatever you want
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white12,
                      Colors.white12,
                      Colors.white12,
                      Colors.white12,
                    ],
                    stops: [0.1, 0.4, 0.6, 0.9],
                  ),
                ),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      _buildForm(),
                      _buildForgotPasswordBtn(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
