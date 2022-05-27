import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';

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
        backgroundColor: Colors.red[900],
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            //_homeNavigation();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const HomePageClient()));
          },
          icon: const Icon(Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Livros", style: TextStyle(color: Colors.black, fontSize: 28),),
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
                return ListView(

                  children: snapshot.data.docs.map((DocumentSnapshot document) {

                    return SafeArea(
                      child:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
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

                                      Padding(
                                        padding: const EdgeInsets.only(left: 25.0, right: 15.0),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage("${document['Capa']}"),
                                              )
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(height: 10,),
                                          Text(document['Titulo'], style:
                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(document['Autor'], style:
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
