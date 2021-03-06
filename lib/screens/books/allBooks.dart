import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/screens/books/bookDetails.dart';

import 'homeBooks.dart';


class AllBooksPage extends StatefulWidget {
  const AllBooksPage({Key key}) : super(key: key);

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const HomePageClient()));
          },
          icon: const Icon(Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Livros", style: TextStyle(color: Colors.white, fontSize: 28),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 35,),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Livros').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Center(child: Text('A carregar Livros...'));
                final document = snapshot.requireData;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: document.size,
                    itemBuilder: (context, index) {
                    return SafeArea(
                      child:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: MaterialButton(
                          height: 80,
                          onPressed: () {
                            String livroId = snapshot.data.docs[index].id;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => BookDetailsPage(livroId)));
                          },
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10,),
                                          Text(document.docs[index]['Titulo'], style:
                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(document.docs[index]['Autor'], style:
                                          const TextStyle(fontSize: 18, color: Colors.grey),
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
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
