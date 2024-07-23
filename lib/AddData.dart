import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(child: Column(
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
                  child: kIsWeb?CircleAvatar():CircleAvatar(),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: pname,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Product Name'),
                    hintText: "Enter your product name",
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: pprice,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Product Price'),
                    hintText: "Enter your product price",
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: pqty,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Product Stock'),
                    hintText: "Enter your product stock",
                  ),
                ),
                SizedBox(height: 30,),
                DropdownButtonFormField(
                  onChanged: (value)
                  {
                    setState(() {
                      selectedCategory!=value;
                    });
                  },
                    items: ['cat1','cat2','cat3'].map((String value){
                      return DropdownMenuItem(child: Text(value),value: value,);
                    }).toList(),
                    )

              ],
            )),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){}, child: Text('Add Data'))
          ],
        ),
      ),
    );
  }
}
