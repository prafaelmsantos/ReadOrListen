import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/reviews/reviewsClient.dart';
import 'package:read_or_listen/services/firestoreReviews.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ClientReviewOnly extends StatefulWidget {
  const ClientReviewOnly({Key key}) : super(key: key);

  @override
  _ClientReviewOnlyState createState() => _ClientReviewOnlyState();
}


class _ClientReviewOnlyState extends State<ClientReviewOnly> {

    CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');
  CollectionReference reviews = FirebaseFirestore.instance.collection('Reviews');
  String uid = FirebaseAuth.instance.currentUser.uid;
  var idReview;

    Future<void> _showDialog(idReview) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Apagar Review?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('A sua review será apagada permanentemente do sistema.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Center(child: Text('Sim')),
                onPressed: () {
                  FirestoreReviewDelete(idReview);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ClientReviewOnly()));
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
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            //_homeNavigation();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ReviewsClient()));
          },
          icon: Icon(Icons.arrow_back_ios,

            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "A minha review", style: TextStyle(color: Colors.black, fontSize: 24),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              SizedBox(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                 //  child: Text("A minha review"),
                  ),
                ),
              ),

            ],
          ),
          Flexible(
            child: FutureBuilder<DocumentSnapshot>(
              future: reviews.doc(uid).get(),
              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                if (snapshot.hasError) {
                  return Text("Algo correu mal!");
                }

                if (snapshot.hasData && !snapshot.data.exists) {
                  return Center(child:Text("Sem nenhuma review"));
                }

                if (snapshot.connectionState == ConnectionState.done) {

                  Map<String, dynamic> data = snapshot.data.data();

                  return SafeArea(
                    child:  Padding(
                      padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        // color: Colors.green,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("${data['Foto']}"),
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
                                        Text(data['Nome'], style:
                                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),


                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(data['Data']+' '+data['Hora'], style: TextStyle(fontSize: 16, color: Colors.black54),),
                                    SizedBox(height: 10),
                                    RatingBarIndicator(

                                      direction: Axis.horizontal,
                                      rating: data['Avaliacao'],

                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),

                                    ),
                                    SizedBox(height: 12),
                                    Text(data['Conteudo'], style: TextStyle(fontSize: 18, color: Colors.black),),
                                    SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:15.0, top: 20),
                              child: IconButton(icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                  size: 35),
                                onPressed: () {
                                _showDialog(uid);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    ),
                  );
                }
                return Center(child: Text("A carregar..."));
              },
            ),
          ),
        ],
      ),
    );
  }
}
