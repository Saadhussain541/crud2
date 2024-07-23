import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../Widgets/CustomTextField.dart';
import 'ShowData.dart';
class UpdateScreen extends StatefulWidget {
  String productId;
  String productName;
  String productPrice;
  String productQty;
  String productCategory;
String productImage;

  UpdateScreen({required this.productImage,required this.productPrice,
  required this.productName, required this.productQty, required this.productCategory,
    required this.productId
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    // TODO: implement initState
    pname.text=widget.productName;
    pprice.text=widget.productPrice;
    pqty.text=widget.productQty;
    selectedCategory=widget.productCategory;
    super.initState();
  }
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
        UploadTask uploadTask=FirebaseStorage.instance.ref().child('ProductImage').child(const Uuid().v1()).putData(webImage!);
        TaskSnapshot taskSnapshot=await uploadTask;
        String productImage=await taskSnapshot.ref.getDownloadURL();
        updateData(image: productImage);
        pname.text='';
        pqty.text='';
        pprice.text='';
        setState(() {
          isLoading=false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Data')));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowData(),));
      }
      else
      {
        UploadTask uploadTask=FirebaseStorage.instance.ref().child('ProductImage').putFile(pImage!);
        TaskSnapshot taskSnapshot=await uploadTask;
        String productImage=await taskSnapshot.ref.getDownloadURL();
        updateData(image: productImage);
      }

    }
    catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void updateData({String? image}) async
  {
    Map<String,dynamic> data={
      'product_name':pname.text.toString(),
      'product_qty':pqty.text.toString(),
      'product_price':pprice.text.toString(),
      'product_image':image,
      'product_category':selectedCategory
    };
    await FirebaseFirestore.instance.collection('product').doc(widget.productId).update(data);



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
                          backgroundImage: webImage!=null?MemoryImage(webImage!):NetworkImage(widget.productImage),

                        ):CircleAvatar(
                          radius: 100,
                          backgroundImage: pImage!=null?FileImage(pImage!):NetworkImage(widget.productImage),

                        ),
                      ),
                      const SizedBox(height: 30,),
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


                      const SizedBox(height: 30,),
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
                      const SizedBox(height: 30,),
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
                      const SizedBox(height: 30,),
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
                        decoration: const InputDecoration(
                            border: OutlineInputBorder()
                        ),
                      )

                    ],
                  )),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                if(key.currentState!.validate())
                {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Dialog Title',
                    desc: 'Dialog description here.............',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                     userImage();


                    },
                  ).show();

                }
                else
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Fill All Fields')));
                }


              }, child: isLoading?const CircularProgressIndicator():const Text('Update Data')),

            ],
          ),
        ),
      ),
    );
  }
}
