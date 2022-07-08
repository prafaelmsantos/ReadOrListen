import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/audiobooks/homeAudiobooks.dart';
import 'package:read_or_listen/screens/audiobooks/audiobookDetails.dart';

import '../home/homeClient.dart';

class GenerosResultAudioPage extends StatefulWidget {


  final String genero;

  const GenerosResultAudioPage(this.genero, {Key key}) : super(key: key);


  @override
  State<GenerosResultAudioPage> createState() => _GenerosResultAudioPageState();
}

class _GenerosResultAudioPageState extends State<GenerosResultAudioPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            //_homeNavigation();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const HomePageClient()));
          },
          icon: const Icon(Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Audiobooks", style: TextStyle(color: Colors.white, fontSize: 28),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(' Todos os resultados de Livros de género', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding( padding: const EdgeInsets.only(top: 5),
                child: Text(widget.genero, style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),),
              ),
            ],
          ),
          const SizedBox(height: 25),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Audiobooks').where('Genero',isEqualTo: widget.genero).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const Center(child: Text('A carregar audiobooks...'));
                final document = snapshot.requireData;

                return ListView.builder(
                    itemCount: document.size,
                    itemBuilder: (context, index) {
                      return SafeArea(
                        child:  Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            onPressed: () {
                              String livroId = snapshot.data.docs[index].id;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => AudiobookDetailsPage(livroId)));
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
