import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('product').snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting)
                    {
                      return CircularProgressIndicator();
                    }
                  if(snapshot.hasError)
                    {
                      return Center(
                        child: Icon(Icons.error,color: Colors.red,size: 30,),
                      );
                    }
                  if(snapshot.hasData)
                    {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 65,
                                    backgroundImage: NetworkImage('${snapshot.data!.docs[index]["product_image"]}'),
                                  ),
                                  SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data!.docs[index]['product_name']}'),
                                      Text('${snapshot.data!.docs[index]['product_price']}'),
                                      Text('${snapshot.data!.docs[index]['product_qty']}'),
                                    ],
                                  )
                                ],
                              ),
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
