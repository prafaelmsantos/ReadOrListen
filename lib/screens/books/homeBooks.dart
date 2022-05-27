import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/books/allBooks.dart';
import 'package:read_or_listen/screens/books/generosResult.dart';


class HomeBooksPage extends StatefulWidget {
  const HomeBooksPage({Key key}) : super(key: key);

  @override
  State<HomeBooksPage> createState() => _HomeBooksPageState();
}

class _HomeBooksPageState extends State<HomeBooksPage> {

  final List<String> generos = <String>['Terror', 'Ação', 'Comédia', 'Romance','Literário','Ficção Cientifica'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25,),
          const Text(
            ' Livros ',style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          ),
          const SizedBox(height: 10),
          const Text(
            ' Top Livros mais lidos ',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          ),

          const SizedBox(height: 25),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance.collection('Livros').orderBy('Downloads', descending: true).limit(5).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Center(child: Text('A carregar Livros...'));
                final document = snapshot.requireData;

                return ListView.builder(
                  itemCount: document.size,
                    itemBuilder: (context, index) {
                      return SafeArea(
                        child:  Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            //width: MediaQuery.of(context).size.width/1.2,

                            // color: Colors.green,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Text(' # ${index+1}', style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 25.0, right: 15.0),
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage("${document.docs[index]['Capa']}"),
                                                )
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 10,),
                                            Text(document.docs[index]['Titulo'], style:
                                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(document.docs[index]['Autor'], style:
                                            const TextStyle(fontSize: 18, color: Colors.black),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),

                                    const SizedBox(height: 10,),
                                  ],
                                ),

                              ],
                            ),
                          ),

                        ),
                      );
                    }
                );
              },
            ),
          ),
          const SizedBox(height: 5,),
          Column(
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const AllBooksPage()));
                },
                child: Row(
                  children: const [
                    Text('Ver mais livros ', style:
                    TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.black,
                        size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          const Text(
            ' Géneros ',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          ),
          const SizedBox(height: 5,),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [

                //Terror
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultPage('Terror')));
                  },
                  child: Row(
                    children: const [
                      Text('Terror', style:
                      TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black,
                          size: 15),
                    ],
                  ),
                ),

                //Romance
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultPage('Romance')));
                  },
                  child: Row(
                    children: const [
                      Text('Romance', style:
                      TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black,
                          size: 15),
                    ],
                  ),
                ),

                //Poesia
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultPage('Poesia')));
                  },
                  child: Row(
                    children: const [
                      Text('Poesia', style:
                      TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black,
                          size: 15),
                    ],
                  ),
                ),

                //Comedia
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultPage('Comédia')));
                  },
                  child: Row(
                    children: const [
                      Text('Comédia', style:
                      TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black,
                          size: 15),
                    ],
                  ),
                ),

                //Ação
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultPage('Ação')));
                  },
                  child: Row(
                    children: const [
                      Text('Ação', style:
                      TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black,
                          size: 15),
                    ],
                  ),
                ),

                //Autoajuda
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultPage('Autoajuda')));
                  },
                  child: Row(
                    children: const [
                      Text('Autoajuda', style:
                      TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black,
                          size: 15),
                    ],
                  ),
                ),

              ],

          ),
          ),


          const SizedBox(height: 5,),





        ],
      ),

    );
  }
}