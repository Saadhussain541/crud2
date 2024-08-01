import 'package:crud2/Auth/signUp.dart';
import 'package:crud2/Controller/UserController/user_controller.dart';
import 'package:crud2/Interfaces/Auth/login_services.dart';
import 'package:crud2/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  LoginServices loginServices=LoginServices();

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
                    controller: loginServices.emailController,
                    validator: (value)
                {
                  if(value=='' || value==null)
                    {
                      return 'email is required';
                    }
                   if(UserController().isValidEmail(value))
                    {
                      return 'Email is inValid';
                    }
                   return null;
                }),
                    SizedBox(height: 20,),
                    Customtextfield(
                        hintText: 'Enter your password',
                        label: 'Password',
                        controller: loginServices.passwordController,
                        validator: (value)
                        {
                          if(value=='' || value==null)
                          {
                            return 'password is required';
                          }
                          if(UserController().isPasswordValid(value))
                          {
                            return 'password is inValid';
                          }
                          return null;
                        }),
              ],)),
              SizedBox(height: 20,),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple
                      ),
                      onPressed: (){
                        UserController().loginUser(loginServices.emailController.text.toString(), loginServices.passwordController.text.toString(), context);

                      }, child: Text('Login',style: TextStyle(color: Colors.white),))),
              SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));

              }, child: Text('Register Accout | Sign Up'))
            ],
          ),
        ),
      ),
    );
  }
}
