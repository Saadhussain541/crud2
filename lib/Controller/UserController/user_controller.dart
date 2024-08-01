import 'package:achievement_view/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2/Interfaces/Auth/register_service.dart';
import 'package:crud2/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserController
{
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<bool> registerUser(String email,String password,String firstName,String lastName,String phone)async
  {
    final RegisterService registerService=RegisterService();
    MyUser user=MyUser();
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserCredential loginResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        user.id = authResult.user!.uid;
        user.email = authResult.user!.email;
        user.password = password; //para password
        user.phone =phone;
        user.firstName = firstName;
        user.lastName = lastName;

        firestore.collection('users').doc(authResult.user!.uid).set({
          "uid": user.id,
          "email": user.email,
          "password": user.password,
          "gender": user.gender,
          "country": user.country,
          'acountCreated': Timestamp.now(),
          "phone": user.phone,
          "firstname": user.firstName,
          "lastname": user.lastName
        });
      }
      return true;
    }
    on FirebaseAuthException catch(e)
    {
      print(e.code.toString());
      return false;

    }
  }

  Future<bool> loginUser(String email,String password,BuildContext context) async
  {

    try
        {
          UserCredential loginAuth=await auth.signInWithEmailAndPassword(email: email, password: password);
          AchievementView(
            title: 'User Login',
            color: Colors.green,
            icon: Icon(Icons.emoji_emotions),

          ).show(context);

          return true;

        }
     on FirebaseAuthException catch(e)
    {
      AchievementView(
        title: e.code.toString(),
        color: Colors.red,
        icon: Icon(Icons.error_outline),
      ).show(context);
      return false;
    }

  }

  bool isValidEmail(String email) {
    // Simple validation using regex
    String emailPattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regex pattern for valid email
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    // Check if password is at least 8 characters long
    if (password.length < 8) {
      return false;
    }

    // Check if password contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    // Check if password contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    // Check if password contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    // Check if password contains at least one special character
    // You can define what special characters are allowed based on your requirements
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    // If all criteria are met, return true
    return true;
  }

}