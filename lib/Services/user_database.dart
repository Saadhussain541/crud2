import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2/Model/user_model.dart';

class UserDatabase
{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<bool> createUserInDb(MyUser user) async
  {
    try
        {
         await firestore.collection('users').doc(user.id).set({
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
          return true;

        }
    catch(e)
    {
      return false;
    }
  }

  Future<MyUser> getUserById(String uid) async
  {
    MyUser myUser=MyUser();
    DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await firestore.collection('users').doc(uid).get();
    myUser.id=documentSnapshot.data()!['uid'];
    myUser.phone=documentSnapshot.data()!['phone'];
    myUser.country=documentSnapshot.data()!['country'];
    myUser.firstName=documentSnapshot.data()!['firstname'];
    myUser.gender=documentSnapshot.data()!['gender'];
    myUser.lastName=documentSnapshot.data()!['lastname'];
    myUser.password=documentSnapshot.data()!['password'];
    myUser.createdTime=documentSnapshot.data()!['acountCreated'];
    myUser.email=documentSnapshot.data()!['email'];


    return myUser;


  }

}