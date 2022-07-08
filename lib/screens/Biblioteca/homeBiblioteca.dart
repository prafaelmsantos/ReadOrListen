import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/audiobooks/audiobookDetails.dart';
import 'package:read_or_listen/screens/books/bookDetails.dart';

class HomeBibliotecaPage extends StatefulWidget {
  const HomeBibliotecaPage({Key key}) : super(key: key);

  @override
  State<HomeBibliotecaPage> createState() => _HomeBibliotecaPageState();
}

class _HomeBibliotecaPageState extends State<HomeBibliotecaPage> {

  String uid = FirebaseAuth.instance.currentUser.uid;


  Container Favoritos_Book(String livroId, String imageVal, String Name, String Author) {
    return Container(
      width: 160,
      child: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => BookDetailsPage(livroId)));
        },
        child: Wrap(
          children: <Widget> [
            Image.network(imageVal,
                height: 225),
            ListTile(
              title: Text(Name),
              subtitle: Text(Author),
            ),
          ],
        ),
      ),
    );
  }

  Container Ler_TardeBook(String livroId, String imageVal, String Name, String Author) {
    return Container(
      width: 160,
      child: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => BookDetailsPage(livroId)));
        },
        child: Wrap(
          children: <Widget> [
            Image.network(imageVal,
                height: 225),
            ListTile(
              title: Text(Name),
              subtitle: Text(Author),
            ),
          ],
        ),
      ),
    );
  }


  Container Favoritos_Audiobook(String audiobookId, String imageVal, String Name, String Author) {
    return Container(
      width: 160,
      child: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AudiobookDetailsPage(audiobookId)));
        },
        child: Wrap(
          children: <Widget> [
          Image.network(imageVal,
          height: 225),
            ListTile(
              title: Text(Name),
              subtitle: Text(Author),
            ),
          ],
        ),
      ),
    );
  }

  Container Ler_TardeAudiobook(String audiobookId, String imageVal, String Name, String Author) {
    return Container(
      width: 160,
      child: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AudiobookDetailsPage(audiobookId)));
        },
        child: Wrap(
          children: <Widget> [
            Image.network(imageVal,
                height: 225),
            ListTile(
              title: Text(Name),
              subtitle: Text(Author),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
                    child: const Text('Livros', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ),

                  //FAVORITOS
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
                    child: const Text('Favoritos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.only(left: 16,),
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget> [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('FavoritosLivros').where(
                              'Id_utilizador', isEqualTo: uid).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (snapshot.hasError) {
                              return const Text("Algo correu mal!");
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('A carregar favoritos...'));
                            }

                            return Row(
                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                return Row(
                                  children: [
                                    Favoritos_Book(document['Id_livro'],"${document['Capa']}", document['Titulo'], document['Autor']),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  //Ler mais tarde
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
                    child: const Text('Ler mais tarde', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.only(left: 16,),
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget> [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('LerTardeLivros').where(
                              'Id_utilizador', isEqualTo: uid).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (snapshot.hasError) {
                              return const Text("Algo correu mal!");
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('A carregar livros...'));
                            }
                            return Row(
                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                return Row(
                                  children: [
                                    Favoritos_Book(document['Id_livro'],"${document['Capa']}", document['Titulo'], document['Autor']),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
                    child: const Text('Audiobooks', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ),

                  //Favoritos
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
                    child: const Text('Favoritos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.only(left: 16,),
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget> [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('FavoritosAudio').where(
                              'Id_utilizador', isEqualTo: uid).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (snapshot.hasError) {
                              return const Text("Algo correu mal!");
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('A carregar favoritos...'));
                            }

                            return Row(
                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                return Row(
                                  children: [
                                    Favoritos_Audiobook(document['Id_audiobook'], "${document['Capa']}", document['Titulo'], document['Autor']),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
                    child: const Text('Ouvir mais tarde', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.only(left: 16,),
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget> [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('LerTardeAudio').where(
                              'Id_utilizador', isEqualTo: uid).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (snapshot.hasError) {
                              return const Text("Algo correu mal!");
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('A carregar ler mais tarde...'));
                            }

                            return Row(
                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                return Row(
                                  children: [
                                    Favoritos_Audiobook(document['Id_audiobook'],"${document['Capa']}", document['Titulo'], document['Autor']),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        );
  }
}
