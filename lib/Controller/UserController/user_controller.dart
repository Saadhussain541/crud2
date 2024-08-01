import 'package:crud2/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController
{
  FirebaseAuth auth=FirebaseAuth.instance;
  void registerUser(String email,String password)async
  {
    MyUser user=MyUser();

    UserCredential authResult=await auth.createUserWithEmailAndPassword(email: email, password: password);
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