// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

final databaseRef = FirebaseDatabase.instance.ref();

var firstController = TextEditingController();
var lastnameController = TextEditingController();
var emailController = TextEditingController();
var mobileController = TextEditingController();
var enrollController = TextEditingController();
var organizationController = TextEditingController();
var passwordController = TextEditingController();
var cPasswordController = TextEditingController();

void insertDataRegister(
    String id,
    String firstname,
    String lastname,
    String email,
    String mobile,
    String unique,
    String organization,
    String type,
    String password,
    String cPassword) {
  /*String? key =
      databaseRef
          .child("userSignUp")
          .push()
          .key;*/
  databaseRef.child("userSignUp").child(id).set({
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'mobile': mobile,
    'unique id': unique,
    'organization': organization,
    'type': type,
    'password': password,
    'confirm password': cPassword,
  });
  firstController.clear();
  lastnameController.clear();
  emailController.clear();
  mobileController.clear();
  enrollController.clear();
  organizationController.clear();
  if (passwordController.text == cPasswordController.text) {
    passwordController.clear();
    cPasswordController.clear();
  }
}
