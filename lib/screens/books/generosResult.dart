import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/books/homeBooks.dart';

import '../home/homeClient.dart';

class GenerosResultPage extends StatefulWidget {


  final String genero;

  const GenerosResultPage(this.genero, {Key key}) : super(key: key);


  @override
  State<GenerosResultPage> createState() => _GenerosResultPageState();
}

class _GenerosResultPageState extends State<GenerosResultPage> {


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

          const SizedBox(height: 10),
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(' Todos os resultados de Livros de género', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),),

            ],
          ),
          const SizedBox(height: 5),
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.genero, style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),),

            ],
          ),

          const SizedBox(height: 25),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance.collection('Livros').where('Genero',isEqualTo: widget.genero).snapshots(),
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


        ],
      ),

    );
  }
}
