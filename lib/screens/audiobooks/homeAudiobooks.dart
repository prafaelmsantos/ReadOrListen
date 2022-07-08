import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/audiobooks/allAudiobooks.dart';
import 'package:read_or_listen/screens/audiobooks/generosResultAudio.dart';
import 'package:read_or_listen/screens/audiobooks/audiobookDetails.dart';


class HomeAudiobooksPage extends StatefulWidget {
  const HomeAudiobooksPage({Key key}) : super(key: key);

  @override
  State<HomeAudiobooksPage> createState() => _HomeAudiobooksPageState();
}

class _HomeAudiobooksPageState extends State<HomeAudiobooksPage> {

  final List<String> generos = <String>['Terror', 'Ação', 'Comédia', 'Romance','Novela','Poesia'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 4.0),
            child: Text(
              ' Audiobooks ',style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: Colors.black,),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 4.0),
            child: Text(
                'Top Audiobooks Mais Ouvidos',
                style: TextStyle(fontSize: 25)),
          ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Audiobooks').orderBy('Downloads', descending: true).limit(5).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Center(child: Text('A carregar Audiobooks...'));
                final document = snapshot.requireData;

                return ListView.builder(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: document.size,
                    itemBuilder: (context, index) {
                      return SafeArea(
                        child:  Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            height: 80,
                            onPressed: () {
                              String audiobookId = snapshot.data.docs[index].id;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => AudiobookDetailsPage(audiobookId)));
                            },
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10,),
                                            Text(document.docs[index]['Titulo'], style:
                                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(document.docs[index]['Autor'], style:
                                            const TextStyle(fontSize: 16, color: Colors.grey),
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

          Column(
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const AllAudiobooksPage()));
                },
                child: Row(
                  children: const [
                    Text('Ver mais aubiobooks ', style:
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
            color: Colors.black,),
          ),
          const SizedBox(height: 5,),
          Container(
            child: ListView(
              physics: new NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                //Terror
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultAudioPage('Terror')));
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

                //Acao
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultAudioPage('Romance')));
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

                //Romance
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultAudioPage('Romance')));
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

                //Comedia
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultAudioPage('Comédia')));
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

                //Novela
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const GenerosResultAudioPage('Novela')));
                  },
                  child: Row(
                    children: const [
                      Text('Novela', style:
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
                        builder: (BuildContext context) => const GenerosResultAudioPage('Poesia')));
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
              ],
            ),
          ),
          const SizedBox(height: 5,),
        ],
      ),
      ),
    );
  }
}