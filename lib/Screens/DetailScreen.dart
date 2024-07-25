import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DetailScreen extends StatefulWidget {
  String id;
  DetailScreen({required this.id});

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
                return Center(child: CircularProgressIndicator());
              }
            if(snapshot.hasError)
              {
                return Center(
                  child: Text('There has some error'),
                );
              }
            if(snapshot.hasData)
              {
                var productData=snapshot.data!.data();
                if(productData!=null)
                  {
                    return Center(
                      child: Text(productData['description']),
                    );
                  }
                else
                  {
                    Center(
                      child: Text('No Data found'),
                    );
                  }

              }
            return Container();
          },)
    );
  }
}
