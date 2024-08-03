import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2/Widgets/CustomTextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../Controller/UserController/user_controller.dart';
import '../Model/user_model.dart';
class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final nameController=TextEditingController();
  final priceController=TextEditingController();
  File? pImage;
  Uint8List? webImg;

  bool isLoading=false;
  void productImage() async
  {
    setState(() {
      isLoading=true;
    });
    if(kIsWeb)
      {
        UploadTask uploadTask=FirebaseStorage.instance.ref().child('Product_Images').child(Uuid().v4()).putData(webImg!);
        TaskSnapshot taskSnapshot=await uploadTask;
        String getImageUrl=await taskSnapshot.ref.getDownloadURL();
        productData(getImageUrl);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data submit')));
      }
    else
      {
        UploadTask uploadTask=FirebaseStorage.instance.ref().child('ProductImage').child(Uuid().v4()).putFile(pImage!);
        TaskSnapshot taskSnapshot=await uploadTask;
        String getImageUrl=await taskSnapshot.ref.getDownloadURL();
        productData(getImageUrl);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data submit')));
      }
    setState(() {
      isLoading=false;
    });
  }
  
  void productData(String imageUrl) async
  {
    await FirebaseFirestore.instance.collection('product1').add({
      'id':Uuid().v1(),
      'name':nameController.text.toString(),
      'price':priceController.text.toString(),
      'image':imageUrl
    });
  }
  String? search;
  ProductService pservices = ProductService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async
                {
                 if(kIsWeb)
                   {
                     XFile? pickImage=await ImagePicker().pickImage(source: ImageSource.gallery);
                     if(pickImage!=null)
                       {
                         var convertedFile=await pickImage.readAsBytes();
                         setState(() {
                           webImg=convertedFile;
                         });
                       }


                   }
                 else
                   {
                     XFile? pickImage=await ImagePicker().pickImage(source: ImageSource.gallery);
                     if(pickImage!=null)
                       {
                         File convertedFile=File(pickImage.path);
                         setState(() {
                           pImage=convertedFile;
                         });
                       }
                   }
                },
                child:kIsWeb?CircleAvatar(radius: 65,
                backgroundImage: webImg!=null?MemoryImage(webImg!):null,
                  backgroundColor: Colors.green.shade100,
                ):
                CircleAvatar(
                  radius: 65,
                backgroundImage: pImage!=null?FileImage(pImage!):null,
                ),
              ),
              SizedBox(height: 20,),
              Customtextfield(hintText: 'Enter your product name', label: 'Product Name',
                  controller: nameController, validator: (value)
              {
                return 'Product name is required';
              }),
              SizedBox(height: 20,),
              Customtextfield(hintText: 'Enter your product price', label: 'Product Price',
                  controller: priceController, validator: (value)
                  {
                    return 'Product price is required';
                  }),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                productImage();
              }, child: isLoading?CircularProgressIndicator():Text('Add Data')),

              SizedBox(height: 30,),
              TextFormField(
                onChanged: (value)
                {
                  setState(() {
                    search=value;
                  });
                },
                decoration: InputDecoration(
                  label: Text('Search'),
                  floatingLabelBehavior: FloatingLabelBehavior.never

                ),
              ),
              // StreamBuilder(
              //   stream: search==''||search==null?FirebaseFirestore.instance.collection('product1').snapshots():
              //   FirebaseFirestore.instance.collection('product1').where('name',isGreaterThanOrEqualTo: search).where('name',isLessThanOrEqualTo: '${search}\uf8ff').snapshots(),
              //
              //     builder: (context, snapshot) {
              //
              //      if(ConnectionState.waiting==snapshot.connectionState)
              //        {
              //          return CircularProgressIndicator();
              //        }
              //      if(snapshot.hasError)
              //        {
              //          return Text('Error');
              //
              //        }
              //      if(snapshot.hasData)
              //        {
              //          int data_len=snapshot.data!.docs.length;
              //          return Expanded(
              //            child: ListView.builder(
              //              itemCount: data_len,
              //              shrinkWrap: true,
              //              itemBuilder: (context, index) {
              //                String pName=snapshot.data!.docs[index]['name'];
              //                String pPrice=snapshot.data!.docs[index]['price'];
              //                String pImage=snapshot.data!.docs[index]['image'];
              //                return Card(
              //                  child: Padding(
              //                    padding: const EdgeInsets.all(8.0),
              //                    child: Row(
              //                      children: [
              //                        CircleAvatar(
              //                          radius: 40,
              //                          backgroundImage: NetworkImage('$pImage'),
              //                        ),
              //                        SizedBox(width: 20,),
              //                        Column(
              //                          crossAxisAlignment: CrossAxisAlignment.start,
              //                          children: [
              //                            Text('$pName'),
              //                            Text('$pPrice')
              //                          ],
              //                        )
              //                      ],
              //                    ),
              //                  ),
              //                );
              //              },),
              //          );
              //        }
              //       return Container();
              //     },)

              StreamBuilder(
                stream: search == null ? pservices.getAllProduct() : pservices.getProduct(search!),

                builder: (context, AsyncSnapshot<List<ProductModel>>snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return const CircularProgressIndicator();
                  }
                  if(snapshot.hasError)
                  {
                    return const Center(
                      child: Icon(Icons.error,color: Colors.red,size: 30,),
                    );
                  }
                  if(snapshot.hasData)
                  {

                    var dataLength = snapshot.data!.length;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount:dataLength,
                      itemBuilder: (context, index) {
                        ProductModel pData = snapshot.data![index];
                        return GestureDetector(
                          onTap: (){
                          },
                          child: Stack(
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 20,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(pData.name!),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },);
                  }
                  return Container();
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}
