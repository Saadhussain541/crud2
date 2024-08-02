import 'package:crud2/Auth/splash_loader_animation.dart';
import 'package:crud2/Controller/UserController/user_controller.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {

  UserController userController=UserController();

  @override
  Widget build(BuildContext context) {
    if(userController.currentUser.id==null)
      {
       return FutureBuilder(
            future: userController.checkUserSignInInfo(),
            builder: (context, snapshot) {

              if(snapshot.hasData)
                {
                  return Container(color: Colors.red,);
                }
              else
                {
                  return SplashLoaderAnimation();
                }
            },);

      }
    else
      {
        return Container(color: Colors.yellow,);
      }

  }
}
