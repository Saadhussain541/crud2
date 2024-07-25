import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2/Screens/DetailScreen.dart';
import 'package:crud2/Screens/UpdateScreen.dart';
import 'package:crud2/Screens/wistListScreen.dart';
import 'package:flutter/material.dart';
class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  String? search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WishListScreen(),));
          }, icon: Icon(Icons.favorite))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value)
                {
                  setState(() {
                    search=value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Search"),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: Icon(Icons.search)
                ),

              ),
              SizedBox(height: 20,),
              StreamBuilder(
                stream:search==''|| search==null?FirebaseFirestore.instance.collection('product').snapshots():
                FirebaseFirestore.instance.collection('product').where('product_name',isGreaterThanOrEqualTo: '$search').where('product_name',isLessThanOrEqualTo: search! + '\uf8ff').snapshots()
                ,
                builder: (context, snapshot) {
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
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String id=snapshot.data!.docs[index].id;
                          String pname=snapshot.data!.docs[index]['product_name'];
                          String pprice=snapshot.data!.docs[index]['product_price'];
                          String pqty=snapshot.data!.docs[index]['product_qty'];
                          String pcat=snapshot.data!.docs[index]['product_category'];
                          String pImg=snapshot.data!.docs[index]["product_image"];
                          bool isFavourite=snapshot.data!.docs[index]["wish_list"];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(id: id,),));
                            },
                            child: Stack(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 65,
                                              backgroundImage: NetworkImage('$pImg'),
                                            ),
                                            const SizedBox(width: 20,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('$pname'),
                                                Text('$pprice'),
                                                Text('$pqty'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.warning,
                                                  animType: AnimType.rightSlide,
                                                  title: 'Dialog Title',
                                                  desc: 'Dialog description here.............',
                                                  btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                              await FirebaseFirestore.instance.collection('product').doc(id).delete();
                                              },
                                              ).show();



                                            }, icon: Icon(Icons.delete)),
                                            IconButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScreen(
                                                productCategory: pcat,
                                                productId: id,
                                                productName: pname,
                                                productPrice: pprice,
                                                productQty: pqty,
                                                productImage: pImg,
                                              ),));
                                            }, icon: Icon(Icons.edit)),
                                          ],
                                        )



                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right:5,
                                    top:5,
                                    child: IconButton(onPressed: () async{
                                      FirebaseFirestore.instance.collection('product').doc(id).update(
                                        {
                                          'wish_list':!isFavourite
                                        }
                                      );

                                    }, icon: isFavourite?Icon(Icons.favorite):Icon(Icons.favorite_border)

                                    ))
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
