import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firestoreReviews.dart';

class ReviewsAdmin extends StatefulWidget {
  const ReviewsAdmin({Key key}) : super(key: key);

  @override
  _ReviewsAdminState createState() => _ReviewsAdminState();
}

class _ReviewsAdminState extends State<ReviewsAdmin> {

  var idReview;
  Future<void> _showDialog(idReview) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tem a certeza que pretende eliminar?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('A Review será apagada permanentemente do sistema.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Sim')),
              onPressed: () {
                FirestoreReviewDelete(idReview);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Center(child: const Text('Cancelar')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 25,),

          Flexible(
            child:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child:  Text('A carregar Reviews...'));
                return ListView(

                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return  SafeArea(
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height/6.5,
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.green,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("${document['Foto']}"),
                                      )
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          Text(document['Nome'], style:
                                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),


                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Text(document['Conteudo'], style: TextStyle(fontSize: 15, color: Colors.black),),


                                    ],
                                  ),
                                ),
                              ),
                              IconButton(icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                  size: 35),
                                onPressed: () {
                                _showDialog(document.id) ;
                                // _showDialog('${document.id}');
                              },
                              ),
                            ],
                          ),
                        ),

                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),



        ],
      ),
    );
  }
}
