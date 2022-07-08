import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:read_or_listen/screens/audio/audio_file.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/services/FirestoreFavoritosAudiobooks.dart';
import 'package:read_or_listen/services/FirestoreLerTardeAudiobooks.dart';
import 'package:read_or_listen/services/firestoreReviewsAudio.dart';

class AudiobookDetailsPage extends StatefulWidget {

  final String audiobookId;

  const AudiobookDetailsPage(this.audiobookId, { Key key}) : super(key: key);

  @override
  State<AudiobookDetailsPage> createState() => _AudiobookDetailsPageState();
}

class _AudiobookDetailsPageState extends State<AudiobookDetailsPage> {
  AudioPlayer advancedPlayer;

  @override
  void initState(){
    super.initState();
    advancedPlayer = AudioPlayer();
  }


  String uid = FirebaseAuth.instance.currentUser.uid;

  //Apagar Review
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
                    builder: (BuildContext context) => AudiobookDetailsPage(widget.audiobookId)));
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
          backgroundColor: Colors.black87,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              advancedPlayer.stop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const HomePageClient()));
            },
            icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('Audiobooks').doc(widget.audiobookId).get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Algo correu mal!");
              }
              if (snapshot.hasData && !snapshot.data.exists) {
                return const Center(child:Text("Sem nenhum Audiobook"));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();

                return Column(
                  children: <Widget> [
                    const SizedBox(height: 15,),
                    Text(data['Titulo'], style: const TextStyle(fontSize: 35)),
                    const SizedBox(height: 5,),
                    Text(data['Autor'], style: const TextStyle(fontSize: 15, color: Colors.grey)),
                    const SizedBox(height: 10,),
                    Image.network(
                        "${data['Capa']}",
                        height: 250,
                        width: 250
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          //Botao favorito
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('FavoritosAudio').doc(widget.audiobookId+uid).get(),
                            builder:
                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshots) {
                              if (snapshots.hasError) {
                                return const Text("Algo correu mal!");
                              }
                              if (snapshots.hasData && !snapshots.data.exists) {
                                return IconButton(
                                  icon: const Icon(Icons.favorite_outline),
                                  tooltip: 'Favoritos',
                                  onPressed: () {
                                    setState(() {
                                      String id_audiobook = snapshot.data.id;
                                      String capa = data['Capa'];
                                      String titulo = data['Titulo'];
                                      String autor = data['Autor'];
                                      String id_favorito = widget.audiobookId+uid;

                                      FirestoreCreateFavoritosAudiobooks(id_audiobook, capa, titulo, autor, id_favorito);
                                      print("favoritos");
                                    });

                                  },);
                              }

                              if (snapshot.connectionState == ConnectionState.done) {

                                return IconButton(
                                  icon: const Icon(Icons.favorite_outlined),
                                  color: Colors.black,
                                  tooltip: 'Favoritos',
                                  onPressed: () {
                                    setState(() {
                                      String id_favorito = widget.audiobookId+uid;

                                      FirestoreFavoritoDeleteAudiobook(id_favorito);
                                      print("favoritos");
                                    });
                                  },);
                              }
                              return Center(child: Text("A carregar..."));
                            },
                          ),

                          //Botao ler mais tarde
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('LerTardeAudio').doc(widget.audiobookId+uid).get(),
                            builder:
                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotx) {
                              if (snapshotx.hasError) {
                                return const Text("Algo correu mal!");
                              }

                              if (snapshotx.hasData && !snapshotx.data.exists) {
                                return IconButton(
                                  icon: const Icon(Icons.add),
                                  tooltip: 'LerTarde',
                                  onPressed: () {
                                    setState(() {
                                      String id_audiobook = snapshot.data.id;
                                      String capa = data['Capa'];
                                      String titulo = data['Titulo'];
                                      String autor = data['Autor'];
                                      String id_lerTarde = widget.audiobookId+uid;

                                      FirestoreCreateLerTardeAudiobooks(id_audiobook, capa, titulo, autor, id_lerTarde);
                                    });

                                  },);
                              }

                              if (snapshot.connectionState == ConnectionState.done) {

                                return IconButton(
                                  icon: const Icon(Icons.close),
                                  color: Colors.black,
                                  tooltip: 'Ler mais tarde',
                                  onPressed: () {
                                    setState(() {
                                      String id_lerTarde = widget.audiobookId+uid;

                                      FirestoreLerTardeDeleteAudiobook(id_lerTarde);
                                      print("ler mais tarde");
                                    });
                                  },);
                              }
                              return Center(child: Text("A carregar..."));
                            },
                          ),
                        ]
                    ),
                    Padding(padding: EdgeInsets.only(top: 30),
                        child: AudioFile(advancedPlayer: advancedPlayer, audiobookId: widget.audiobookId, audiopath: data['Audio'])),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    ListView(
                        physics: new NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget> [
                          ExpansionTile(title: const Text('Resumo'),
                            backgroundColor: Colors.blueGrey.shade50,
                            iconColor: Colors.grey,
                            textColor: Colors.black,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(1)),
                                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Text(data['Resumo'], style: const TextStyle(/*fontSize: 12,*/ color: Colors.grey), textAlign:TextAlign.justify)),
                            ],
                          ),
                          ExpansionTile(title: const Text('Características'),
                            backgroundColor: Colors.blueGrey.shade50,
                            iconColor: Colors.grey,
                            textColor: Colors.black,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(1)),
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Text('Género:  ' + data['Genero'], style: const TextStyle(/*fontSize: 12,*/ color: Colors.grey), textAlign:TextAlign.justify)),
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Text('Duração:  ' + data['Tempo'], style: const TextStyle(/*fontSize: 12,*/ color: Colors.grey), textAlign:TextAlign.justify)),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                            child: Text('A minha Review', style: TextStyle(fontSize: 18, color: Colors.black),),
                          ),
                          //Adicionar review
                          Container(
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance.collection('Reviews').doc(uid+widget.audiobookId).get(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotb) {
                                    if (snapshotb.hasError) {
                                      return const Text("Algo correu mal!");
                                    }

                                    if (snapshotb.hasData && !snapshotb.data.exists) {
                                      return ElevatedButton.icon(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.black87),
                                        ),
                                        onPressed: _showRatingAppDialog,
                                        icon: Icon(Icons.add,
                                          size: 28,
                                          color: Colors.white,),
                                        label: Text('Adiciona a tua review', style: TextStyle(fontSize: 16, color: Colors.white)),
                                      );
                                    }

                                    if (snapshotb.connectionState == ConnectionState.done) {
                                      return const Text('');
                                    }
                                    return Center(child: Text("A carregar..."));
                                  },
                                ),
                              ],
                            ),
                          ),
                          //My review
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('Reviews').doc(uid+widget.audiobookId).get(),
                            builder:
                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotz) {
                              if (snapshotz.hasError) {
                                return const Text("Algo correu mal!");
                              }

                              if (snapshotz.hasData && !snapshotz.data.exists) {
                                return const Center(child:Text(""));
                              }

                              if (snapshotz.connectionState == ConnectionState.done) {
                                Map<String, dynamic> myreview = snapshotz.data.data();

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 62, right: 15.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage("${myreview['Foto']}"),
                                            )
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10,),
                                        Text(myreview['Nome'], style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(myreview['Data']+' '+myreview['Hora'], style: TextStyle(fontSize: 16, color: Colors.black54),),
                                        SizedBox(height: 5),
                                        RatingBarIndicator(
                                          direction: Axis.horizontal,
                                          rating: myreview['Avaliacao'],
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(myreview['Conteudo'], style: TextStyle(fontSize: 18, color: Colors.black),),
                                        SizedBox(height: 25),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: IconButton(icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                          size: 35),
                                        onPressed: () {
                                          //Apagar review
                                          _showDialog(uid+widget.audiobookId);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Center(child: Text("A carregar..."));
                            },
                          ),
                          //Todas as Reviews
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text('Todas as Reviews', style: TextStyle(fontSize: 18, color: Colors.black),),
                          ),
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('Reviews').where('Id_audiobook',isEqualTo: widget.audiobookId).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotr) {
                                if (!snapshotr.hasData) return const Center(child: Text('A carregar reviews...'));
                                final document = snapshotr.requireData;

                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: document.size,
                                    itemBuilder: (context, index) {
                                      return SafeArea(
                                        child:  Padding(
                                          padding: const EdgeInsets.all(4.0),
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
                                                                image: NetworkImage("${document.docs[index]['Foto']}"),
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          const SizedBox(height: 10,),
                                                          Text(document.docs[index]['Nome'], style:
                                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Text(document.docs[index]['Data']+' '+document.docs[index]['Hora'], style: TextStyle(fontSize: 16, color: Colors.black54),),
                                                          SizedBox(height: 5),
                                                          RatingBarIndicator(
                                                            direction: Axis.horizontal,
                                                            rating: document.docs[index]['Avaliacao'],
                                                            itemCount: 5,
                                                            itemSize: 20,
                                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                            itemBuilder: (context, _) => Icon(
                                                              Icons.star,
                                                              color: Colors.amber,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15),
                                                          Text(document.docs[index]['Conteudo'], style: TextStyle(fontSize: 18, color: Colors.black),),
                                                          SizedBox(height: 25),
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
                                      );
                                    }
                                );
                              },
                            ),
                          ),
                        ]
                    ),
                  ],
                );
              }
              return Center(child: Text("A carregar..."));
            },
          ),
        ),
      );
  }

  //Caixa para adicionar review
  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      title: const Text(''),
      message: Text('Deixe a sua opinião...'),
      image: Image.asset("assets/images/logo.png",height: 150,),
      submitButtonText: 'Enviar',
      commentHint: 'Deixe o seu comentario...',
      onCancelled: () => print('Cancelado'),
      onSubmitted: (response) {
        //criar review
        CreateReview(response.comment,response.rating.toDouble(),widget.audiobookId);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AudiobookDetailsPage(widget.audiobookId)));
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}
