import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/screens/reviews/clientReviewOnly.dart';
import 'package:read_or_listen/services/firestoreReviews.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ReviewsClient extends StatefulWidget {
  const ReviewsClient({Key key}) : super(key: key);

  @override
  _ReviewsClientState createState() => _ReviewsClientState();
}


class _ReviewsClientState extends State<ReviewsClient> {

  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');
  CollectionReference reviews = FirebaseFirestore.instance.collection('Reviews');
  String uid = FirebaseAuth.instance.currentUser.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            //_homeNavigation();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomePageClient()));
          },
          icon: Icon(Icons.arrow_back_ios,

            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Reviews", style: TextStyle(color: Colors.black, fontSize: 24),),
        actions: [
        ],
      ),
      body: Column(

        children: [
          SizedBox(height: 20,),
          Container(

            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: reviews.doc(uid).get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Algo correu mal!");
                    }

                    if (snapshot.hasData && !snapshot.data.exists) {
                      return IconButton(
                        onPressed: _showRatingAppDialog,
                        icon: Icon(Icons.add,
                          size: 38,
                          color: Colors.blueAccent,),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done) {

                      Map<String, dynamic> data = snapshot.data.data();
                      return Text('');

                    }
                    return Center(child: Text("A carregar..."));
                  },
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.blueAccent,
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: Text('Minha Review',style: TextStyle
                      (color: Colors.white,fontSize: 15),
                    ),
                    onPressed: () {
                      //_homeNavigation();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>ClientReviewOnly()));
                    }
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom:10.0, top: 10),
            child: Center(
              child: Container(
                child: Image(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                ),
                width: MediaQuery.of(context).size.width / 1.2 ,
              ),
            ),
          ),
          SizedBox(height: 20,),


          Divider(height: 10,thickness: 1, color: Colors.black,),



          //TODAS AS REVIEWS
          Flexible(
            child:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: Text('A carregar Reviews...'));
                return ListView(

                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return SafeArea(
                      child:  Padding(
                        padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.green,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
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

                                      SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(document['Nome'], style:
                                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),


                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(document['Data']+' '+document['Hora'], style: TextStyle(fontSize: 16, color: Colors.black54),),
                                      SizedBox(height: 5),
                                      RatingBarIndicator(

                                        direction: Axis.horizontal,
                                        rating: document['Avaliacao'],

                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),

                                      ),
                                      SizedBox(height: 15),
                                      Text(document['Conteudo'], style: TextStyle(fontSize: 18, color: Colors.black),),
                                      SizedBox(height: 25),


                                    ],
                                  ),
                                ),
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

  void _showRatingAppDialog() {

    final _ratingDialog = RatingDialog(

      image: Image.asset("assets/images/logo.png",height: 150,),

      commentHint: 'Deixe o seu comentario...',
      onCancelled: () => print('Cancelado'),
      onSubmitted: (response) {


          CreateReview(response.comment,response.rating.toDouble());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ReviewsClient()));


      },
    );

    showDialog(

      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}
