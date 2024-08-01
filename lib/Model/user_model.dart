import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser
{
  String? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? country;
  String? phone;
  String? email;
  String? password;
  Timestamp? createdTime;

  MyUser(
      {this.id,
      this.firstName,
      this.lastName,
      this.gender='Male',
      this.country='Pakistan',
      this.phone,
      this.email,
      this.password,
      this.createdTime
      });
}