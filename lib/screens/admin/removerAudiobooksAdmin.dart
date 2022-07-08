import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoverAudiobooksAdmin extends StatefulWidget {
  const RemoverAudiobooksAdmin({Key key}) : super(key: key);

  @override
  _RemoverAudiobooksAdminState createState() => _RemoverAudiobooksAdminState();
}

class _RemoverAudiobooksAdminState extends State<RemoverAudiobooksAdmin> {

  var idAudiobook;
  Future<void> _showDialog(idAudiobook) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tem a certeza que pretende eliminar?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('O livro será apagado permanentemente do sistema.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Sim')),
              onPressed: () {
                _delete(idAudiobook);
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

  Future<void> _delete(String idAudiobook) async{
    await FirebaseFirestore.instance.collection("Audiobooks").doc(idAudiobook).delete();

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
            child:  FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("Audiobooks").get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child:  Text('A carregar audiobooks...'));
                final List<DocumentSnapshot> arrData = snapshot.data.docs;
                return ListView(
                  children: arrData.map((data) {
                    return  SafeArea(
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
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
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 7),
                                            child: Text(data['Titulo'], style:
                                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Text(data['Autor'], style: TextStyle(fontSize: 15, color: Colors.black),),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                  size: 35),
                                onPressed: () {
                                  _showDialog(data.id) ;
                                },
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