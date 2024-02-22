// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wissme/constants.dart';
import 'package:wissme/validation.dart';

// ignore: camel_case_types
class forgetPassword extends StatefulWidget {
  const forgetPassword({Key? key, required this.studentKey}) : super(key: key);

  final String studentKey;

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

// ignore: camel_case_types
class _forgetPasswordState extends State<forgetPassword> {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  var emailId = "";

  //update data
  @override
  void initState() {
    super.initState();
  }

  //Email Text Field and Password Field
  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //email id
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
        ],
      ),
    );
  }

  //Forget Button
  Widget _buildForgetBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        // ignore: avoid_print
        onPressed: () {
          if (formKey.currentState!.validate()) {
            setState(() {
              emailId = emailController.text;
            });
            resetPassword();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.orange,
        ),
        child: const Text(
          'Reset Password',
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

  //mail sending function
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailId);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Password Reset Email has been sent! Please Login',
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'No user found for that email.',
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
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      _buildForm(),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      _buildForgetBtn(),
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
