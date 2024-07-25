import 'package:crud2/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstNameController=TextEditingController();
  final lastNameController=TextEditingController();
  String selectedGender='Male';
  String selectedCountry='Pakistan';
  final phoneController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final CPasswordController=TextEditingController();
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
                          controller: firstNameController,
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
                          controller: lastNameController,
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
                  value: selectedGender,
                  onChanged: (value)
                {
                  setState(() {
                    selectedGender=value!;
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
                  value: selectedCountry,
                  onChanged: (value)
                  {
                    setState(() {
                      selectedCountry=value!;
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
                    controller: phoneController,
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
                    controller: emailController,
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
                    controller: passwordController,
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
                    controller: CPasswordController,
                    validator: (value)
                    {
                      if(value==''||value==null)
                      {
                        return 'confirm password is  required';
                      }
                    }),
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
