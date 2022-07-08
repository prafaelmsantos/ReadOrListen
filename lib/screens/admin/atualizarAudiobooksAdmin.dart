import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AtualizarAudiobooksAdmin extends StatefulWidget {
  const AtualizarAudiobooksAdmin({Key key}) : super(key: key);

  @override
  _AtualizarAudiobooksAdminState createState() => _AtualizarAudiobooksAdminState();
}

class _AtualizarAudiobooksAdminState extends State<AtualizarAudiobooksAdmin> {

  final formKeyAudio = GlobalKey<FormState>();
  TextEditingController audioname = TextEditingController();
  TextEditingController artistname = TextEditingController();
  TextEditingController downloadsaudio = TextEditingController();
  TextEditingController resumoaudio = TextEditingController();
  TextEditingController lengthaudio = TextEditingController();
  TextEditingController generoaudio = TextEditingController();

  Future<void> _update([DocumentSnapshot data]) async{

    audioname.text = data['Titulo'];
    artistname.text = data['Autor'];
    resumoaudio.text = data['Resumo'];
    lengthaudio.text = data['Tempo'];
    generoaudio.text = data['Genero'];
    downloadsaudio.text = data['Downloads'].toString();

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKeyAudio,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: audioname,
                        decoration: InputDecoration(labelText: "Escreva o Titulo"),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Campo vazio";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: artistname,
                        decoration: InputDecoration(labelText: "Escreva o Autor"),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Campo vazio";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: resumoaudio,
                        decoration: InputDecoration(labelText: "Escreva o Resumo"),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Campo vazio";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: downloadsaudio,
                        decoration: InputDecoration(labelText: "Escreva a quantidade de donwloads"),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Campo vazio";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: generoaudio,
                        decoration: InputDecoration(labelText: "Escreva o Género"),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Campo vazio";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: lengthaudio,
                        decoration: InputDecoration(labelText: "Escreva a duração do audio"),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Campo vazio";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      child: const Text( 'Atualizar'),
                      onPressed: () async {

                        await await FirebaseFirestore.instance.collection("Audiobooks")
                            .doc(data.id)
                            .update({
                          "Titulo": audioname.text,
                          "Autor": artistname.text,
                          'Resumo': resumoaudio.text,
                          'Tempo': lengthaudio.text,
                          'Genero': generoaudio.text,
                          'Downloads': downloadsaudio.text,
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('O audiobook foi apagado com suscesso')));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: //Livros
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 25,),
          Container(
            width:500,
            height: 500,
            child:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Audiobooks").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child:  Text('A carregar audiobooks...'));
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot data =
                      snapshot.data.docs[index];
                      return  Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("${data['Capa']}"),
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(data['Titulo'], style:
                                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Text(data['Autor'], style: TextStyle(fontSize: 15, color: Colors.black),),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 35),
                              onPressed: () {
                                _update(data);
                              },
                            ),
                          ],
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