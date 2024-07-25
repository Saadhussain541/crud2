import 'package:crud2/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
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

  final key=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login Screen',style: TextStyle(
                color: Colors.purple,
                fontSize: 30
              ),),
              SizedBox(height: 20,),
              Form(
                  key: key,
                  child: Column(children: [
                Customtextfield(
                    hintText: 'Enter your email',
                    label: 'Email',
                    controller: emailController,
                    validator: (value)
                {
                  if(value=='' || value==null)
                    {
                      return 'email is required';
                    }
                   if(isValidEmail(value))
                    {
                      return 'Email is inValid';
                    }
                   return null;
                }),
                    SizedBox(height: 20,),
                    Customtextfield(
                        hintText: 'Enter your password',
                        label: 'Password',
                        controller: emailController,
                        validator: (value)
                        {
                          if(value=='' || value==null)
                          {
                            return 'password is required';
                          }
                          if(isPasswordValid(value))
                          {
                            return 'password is inValid';
                          }
                          return null;
                        }),
              ],)),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){}, child: Text('Login')),
              SizedBox(height: 10,),
              TextButton(onPressed: (){

              }, child: Text('Register Accout | Sign Up'))
            ],
          ),
        ),
      ),
    );
  }
}
