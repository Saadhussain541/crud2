import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2/Widgets/CustomTextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ShowData.dart';
class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final pname=TextEditingController();
  final pprice=TextEditingController();
  final pqty=TextEditingController();
  String selectedCategory='cat1';
  File? pImage;
  Uint8List? webImage;

  bool isLoading=false;
  final key=GlobalKey<FormState>();

  void userImage() async
  {
    try
        {
          if(kIsWeb)
            {
              setState(() {
                isLoading=true;
              });
              UploadTask uploadTask=FirebaseStorage.instance.ref().child('ProductImage').putData(webImage!);
              TaskSnapshot taskSnapshot=await uploadTask;
              String productImage=await taskSnapshot.ref.getDownloadURL();
              addData(productImage);
              pname.text='';
              pqty.text='';
              pprice.text='';
              setState(() {
                isLoading=false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Data')));
            }
          else
            {
              UploadTask uploadTask=FirebaseStorage.instance.ref().child('ProductImage').putFile(pImage!);
              TaskSnapshot taskSnapshot=await uploadTask;
              String productImage=await taskSnapshot.ref.getDownloadURL();
              addData(productImage);
            }

        }
        catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  
  void addData(String? image) async
  {
    await FirebaseFirestore.instance.collection('product').add({
      'product_name':pname.text.toString(),
      'product_qty':pqty.text.toString(),
      'product_price':pprice.text.toString(),
      'product_image':image,
      'product_category':selectedCategory

    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: key,
                  child: Column(
                children: [
                  GestureDetector(
                    onTap: () async
                    {
                      if(kIsWeb)
                        {
                          XFile? pickImage=await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(pickImage!=null)
                            {
                              var convertedImage=await pickImage.readAsBytes();
                              setState(() {
                                webImage=convertedImage;
                              });
                            }
                          else
                            {
                              XFile? pickImage= await ImagePicker().pickImage(source: ImageSource.gallery);
                              if(pickImage!=null)
                                {
                                  File convertedFile=File(pickImage.path);
                                  setState(() {
                                    pImage=convertedFile;
                                  });
                                }

                            }

                        }

                    },
                    child: kIsWeb?CircleAvatar(
                      radius: 100,
                      backgroundImage: webImage!=null?MemoryImage(webImage!):null,

                    ):CircleAvatar(
                      radius: 100,
                      backgroundImage: pImage!=null?FileImage(pImage!):null,

                    ),
                  ),
                  SizedBox(height: 30,),
                  Customtextfield(hintText: 'Enter your product name',
                      label: 'Product Name',
                      controller: pname,
                      validator: (value)
                  {
                    if(value==null||value=='')
                      {
                        return 'Product name is required';
                      }
                  }),


                  SizedBox(height: 30,),
                  Customtextfield(hintText: 'Enter your product price',
                      label: 'Product Price',
                      controller: pprice,
                      validator: (value)
                      {
                        if(value==null||value=='')
                        {
                          return 'Product price is required';
                        }
                      }),
                  SizedBox(height: 30,),
                  Customtextfield(hintText: 'Enter your product quantity',
                      label: 'Product Quantity',
                      controller: pqty,
                      validator: (value)
                      {
                        if(value==null||value=='')
                        {
                          return 'Product quantity is required';
                        }
                      }),
                  SizedBox(height: 30,),
                  DropdownButtonFormField(
                    value: selectedCategory,
                    onChanged: (value)
                    {
                      setState(() {
                        selectedCategory=value!;
                      });
                    },
                      items: ['cat1','cat2','cat3'].map((String value){
                        return DropdownMenuItem(child: Text(value),value: value,);
                      }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder()
                    ),
                      )

                ],
              )),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                if(key.currentState!.validate())
                  {
                    userImage();
                  }
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Fill All Fields')));
                  }


              }, child: isLoading?CircularProgressIndicator():Text('Add Data')),

              SizedBox(height: 30,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowData(),));
              }, child: Text('Show Data'))
            ],
          ),
        ),
      ),
    );
  }
}
