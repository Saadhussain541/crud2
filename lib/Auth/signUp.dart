import 'package:achievement_view/achievement_view.dart';
import 'package:crud2/Auth/login.dart';
import 'package:crud2/Controller/UserController/user_controller.dart';
import 'package:crud2/Interfaces/Auth/register_service.dart';
import 'package:crud2/Model/user_model.dart';
import 'package:crud2/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final RegisterService registerService=RegisterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign Up',style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 30
                ),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Customtextfield(
                          hintText: "Enter your first name",
                          label: 'First Name',
                          controller: registerService.firstNameController,
                          validator: (value)
                      {
                        if(value==''||value==null)
                          {
                            return 'first name is  required';
                          }
                      }),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Customtextfield(
                          hintText: "Enter your last name",
                          label: 'Last Name',
                          controller: registerService.lastNameController,
                          validator: (value)
                          {
                            if(value==''||value==null)
                            {
                              return 'last name is  required';
                            }
                          }),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                DropdownButtonFormField(
                  value: MyUser().gender,
                  onChanged: (value)
                {
                  setState(() {
                    MyUser().gender=value!;
                  });
                },
                  items: ['Male','Female','Other'].map((String value){
                    return DropdownMenuItem(child: Text(value),value: value,);
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),

                ),
                SizedBox(height: 20,),
                DropdownButtonFormField(
                  value: MyUser().country,
                  onChanged: (value)
                  {
                    setState(() {
                      MyUser().country=value!;
                    });
                  },
                  items: ['Pakistan','Iran','Saudia Arabia'].map((String value){
                    return DropdownMenuItem(child: Text(value),value: value,);
                  }).toList(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),

                ),
                SizedBox(height: 20,),
                Customtextfield(
                    hintText: "Enter your phone name",
                    label: 'Phone',
                    controller: registerService.phoneController,
                    validator: (value)
                    {
                      if(value==''||value==null)
                      {
                        return 'phone is  required';
                      }
                    }),
                SizedBox(height: 20,),
                Customtextfield(
                    hintText: "Enter your email",
                    label: 'Email',
                    controller:registerService.emailController,
                    validator: (value)
                    {
                      if(value==''||value==null)
                      {
                        return 'email is  required';
                      }
                    }),
                SizedBox(height: 20,),
                Customtextfield(
                    hintText: "Enter your password",
                    label: 'Password',
                    controller: registerService.passwordController,
                    validator: (value)
                    {
                      if(value==''||value==null)
                      {
                        return 'password is  required';
                      }
                    }),
                SizedBox(height: 20,),
                Customtextfield(
                    hintText: "Enter your confirm password",
                    label: 'Confirm Password',
                    controller: registerService.cPasswordController,
                    validator: (value)
                    {
                      if(value==''||value==null)
                      {
                        return 'confirm password is  required';
                      }
                    }),
                SizedBox(height: 30,),
                SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple
                        ),
                        onPressed: (){
                          if(registerService.passwordController.text==registerService.cPasswordController.text)
                            {
                              try
                                  {
                                    UserController().registerUser(registerService.emailController.text.toString(), registerService.passwordController.text.toString(),
                                      registerService.firstNameController.text.toString(),
                                      registerService.lastNameController.text.toString(),
                                      registerService.phoneController.text.toString()
                                    );
                                    AchievementView(
                                        title: 'Success',
                                        subTitle: 'Account Created',
                                        icon: Icon(Icons.emoji_emotions,color: Colors.white,),
                                        color: Colors.green
                                    ).show(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                  }
                                  catch(e)
                          {
                            print(e);
                          }
                            }
                          else
                            {
                              AchievementView(
                                title: 'Error',
                                subTitle: 'Password is invliad',
                                icon: Icon(Icons.error,color: Colors.white,),
                                color: Colors.red
                              ).show(context);
                            }

                        }, child: Text('Sign Up',style: TextStyle(color: Colors.white),))),
                SizedBox(height: 10,),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

                }, child: Text('Already Accout | Sign In'))
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
