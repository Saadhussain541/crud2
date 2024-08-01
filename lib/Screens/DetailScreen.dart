import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DetailScreen extends StatefulWidget {
  String id;
  DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream:  FirebaseFirestore.instance.collection('product').doc(widget.id).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator());
              }
            if(snapshot.hasError)
              {
                return const Center(
                  child: Text('There has some error'),
                );
              }
            if(snapshot.hasData)
              {
                var productData=snapshot.data!.data();
                bool isFavourite=productData?['wish_list'];
                if(productData!=null)
                  {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(productData['description']),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Favourite'),
                              const SizedBox(width: 15,),
                              IconButton(onPressed: () async{
                                FirebaseFirestore.instance.collection('product').doc(widget.id).update(
                                    {
                                      'wish_list':!isFavourite
                                    }
                                );

                              }, icon: isFavourite?const Icon(Icons.favorite):const Icon(Icons.favorite_border)

                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
                else
                  {
                    const Center(
                      child: Text('No Data found'),
                    );
                  }

              }
            return Container();
          },)
    );
  }
}
