import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/photo/allPhotos.dart';
import 'package:read_or_listen/services/firestorePhoto.dart';

class PhotoClient extends StatefulWidget {
  const PhotoClient({Key key}) : super(key: key);

  @override
  _PhotoClientState createState() => _PhotoClientState();
}

class _PhotoClientState extends State<PhotoClient> {


  CollectionReference fotos = FirebaseFirestore.instance.collection('Fotos');
  String uid = FirebaseAuth.instance.currentUser.uid;

  Future<void> _showDialog(idFoto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagar fotografia?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('A sua fotografia será apagada permanentemente do sistema.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Sim')),
              onPressed: () {
                FirestorePhotoDelete(idFoto);
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
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            //_homeNavigation();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AllPhotos()));
          },
          icon: Icon(Icons.arrow_back_ios,

            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Minhas fotos", style: TextStyle(color: Colors.black, fontSize: 24),),
        actions: [
        ],
      ),
      body: Column(

        children: [
          SizedBox(height: 20,),
          Container(

            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: fotos.doc(uid).get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Algo correu mal!");
                    }

                    if (snapshot.hasData && !snapshot.data.exists) {


                    }

                    if (snapshot.connectionState == ConnectionState.done) {

                      Map<String, dynamic> data = snapshot.data.data();
                      return Text('');

                    }
                    return Center(child: Text("A carregar..."));
                  },
                ),

              ],
            ),
          ),


          //TODAS AS Fotos
          Flexible(
            child: new StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Fotos').where(
                  'Id_utilizador', isEqualTo: uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: new Text('A carregar fotos...'));
                return new ListView(

                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return new SafeArea(
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("${document['Url']}"),

                                      )

                                  ),
                                ),
                              ),

                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [



                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    IconButton(icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                        size: 35),
                                      onPressed: () {
                                        _showDialog(document.id) ;

                                      },
                                    ),
                                    SizedBox(height: 5),

                                  ],
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
}
