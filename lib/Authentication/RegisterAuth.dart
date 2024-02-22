// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wissme/constants.dart';
import 'package:wissme/Authentication/LoginAuth.dart';
import 'package:wissme/validation.dart';

import '../DataBase Work/InsertData.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  var email = "";
  var password = "";
  var confirmPassword = "";

  String type = "none";

  bool _isObscure = true;
  bool _isObscure1 = true;

  final formKey = GlobalKey<FormState>();
  var firstController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();
  var enrollController = TextEditingController();
  var organizationController = TextEditingController();
  var passwordController = TextEditingController();
  var cPasswordController = TextEditingController();

  Widget _buildSignUpForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* FIRST NAME FIELD*/
          const Text(
            'First Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter First Name';
              } else if (!val.isValidName) {
                return 'Please Enter Valid First Name';
              }
              return null;
            },
            controller: firstController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              hintText: 'Enter your First Name',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* LAST NAME FIELD*/
          const Text(
            'Last Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Last Name';
              } else if (!val.isValidName) {
                return 'Please Enter Valid Last Name';
              }
              return null;
            },
            controller: lastnameController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              hintText: 'Enter your Last Name',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* EMAIL ID FIELD*/
          const Text(
            'Email Id',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Email';
              } else if (!val.isValidEmail) {
                return 'Please Enter Valid Email Id';
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
                Icons.email_outlined,
                color: Colors.blue,
              ),
              hintText: 'Enter your Email Id',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* MOBILE NUMBER FIELD*/
          const Text(
            'Mobile No',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Mobile No';
              } else if (!val.isValidPhone) {
                return 'Please Enter Valid Mobile No';
              }
              return null;
            },
            controller: mobileController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.mobile_friendly_sharp,
                color: Colors.blue,
              ),
              hintText: 'Enter your Mobile No',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /*You are a */
          const Text(
            'User Type',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          InputDecorator(
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.keyboard_option_key,
                color: Colors.blue,
              ),
            ),
            child: DropdownButton(
              value: type,
              items: const [
                DropdownMenuItem(
                  value: "none",
                  child: Text("Select option"),
                ),
                DropdownMenuItem(
                  value: "Student",
                  child: Text("Student"),
                ),
                DropdownMenuItem(
                  value: "Teacher",
                  child: Text("Teacher"),
                ),
              ],
              onChanged: (value) {
                type = value.toString();
                setState(() {});
              },
              isDense: true,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans', //Font color
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              dropdownColor: Colors.white,
              underline: Container(),
              isExpanded: true,
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* UNIQUE ID FIELD*/
          const Text(
            'Unique Id',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Unique Id';
              } else if (!val.isValidUniqueId) {
                return 'Please Enter Valid Unique Id';
              }
              return null;
            },
            controller: enrollController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.inbox,
                color: Colors.blue,
              ),
              hintText: 'Enter your Unique Id',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* ORGANIZATION FIELD*/
          const Text(
            'Organization',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Organization';
              } else if (!val.isValidOrgName) {
                return 'Please Enter Valid Organization Name';
              }
              return null;
            },
            controller: organizationController,
            decoration: const InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people_alt_outlined,
                color: Colors.blue,
              ),
              hintText: 'Enter your Organization',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* PASSWORD FILED*/
          const Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            obscureText: _isObscure,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Password';
              } else if (!val.isValidPassword) {
                return 'Please Enter Valid Password';
              }
              return null;
            },
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
                Icons.password_sharp,
                color: Colors.blue,
              ),
              hintText: 'Enter your Password',
              hintStyle: const TextStyle(color: Colors.black38),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          /* CONFIRM PASSWORD FILED*/
          const Text(
            'Confirm Password',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            obscureText: _isObscure1,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please Enter Confirm Password';
              } else if (!val.isValidPassword) {
                return 'Please Enter Valid Confirm Password';
              }
              return null;
            },
            controller: cPasswordController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure1 ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure1 = !_isObscure1;
                    });
                  }),
              fillColor: Colors.white24,
              filled: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.password_sharp,
                color: Colors.blue,
              ),
              hintText: 'Enter Confirm Password',
              hintStyle: const TextStyle(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            setState(() {
              email = emailController.text;
              password = passwordController.text;
              confirmPassword = cPasswordController.text;
            });
            if (firstController.text.isNotEmpty &&
                lastnameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                mobileController.text.isNotEmpty &&
                enrollController.text.isNotEmpty &&
                organizationController.text.isNotEmpty &&
                type.isNotEmpty &&
                passwordController.text.isNotEmpty &&
                cPasswordController.text.isNotEmpty &&
                (passwordController.text == cPasswordController.text)) {
              registration();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Registered Unsuccessfully. Please Check Your Details!",
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
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15.0), backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),

        child: const Text(
          'Sign Up',
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

  Future<bool> CheckOrg() async {
    print(organizationController.text);
    bool b = false;
    DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child(organizationController.text)
        .child("key")
        .get();

    b = (dataSnapshot != null);

    print("Data ${b}");
    return b;
  }

  registration() async {
    if (passwordController.text == cPasswordController.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (kDebugMode) {
          print(userCredential);
        }
        //print(userCredential.user!.uid);
        insertDataRegister(
            userCredential.user!.uid,
            firstController.text,
            lastnameController.text,
            emailController.text,
            mobileController.text,
            enrollController.text,
            organizationController.text,
            type.toString(),
            passwordController.text,
            cPasswordController.text);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Registered Successfully. Please Login..",
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
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (kDebugMode) {
            print("Password Provided is too Weak");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Password Provided is too Weak",
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
        } else if (e.code == 'email-already-in-use') {
          if (kDebugMode) {
            print("Account Already exists");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Account Already exists",
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
    } else {
      if (kDebugMode) {
        print("Password and Confirm Password doesn't match");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Password and Confirm Password doesn't match",
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
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildSignUpForm(),
                      _buildSignUpButton(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an Account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
