import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AtualizarBooksAdmin extends StatefulWidget {
  const AtualizarBooksAdmin({Key key}) : super(key: key);

  @override
  _AtualizarBooksAdminState createState() => _AtualizarBooksAdminState();
}

class _AtualizarBooksAdminState extends State<AtualizarBooksAdmin> {

  final formKeyBook = GlobalKey<FormState>();
  TextEditingController booktitle = TextEditingController();
  TextEditingController authorname = TextEditingController();
  TextEditingController resumobook = TextEditingController();
  TextEditingController npagbook = TextEditingController();
  TextEditingController generobook = TextEditingController();
  TextEditingController editbook = TextEditingController();
  TextEditingController databook = TextEditingController();
  TextEditingController downloadsbook = TextEditingController();

  Future<void> _update([DocumentSnapshot data]) async{

    booktitle.text = data['Titulo'];
    authorname.text = data['Autor'];
    resumobook.text = data['Resumo'];
    databook.text = data['datalancamento'];
    npagbook.text = data['numpaginas'];
    generobook.text = data['Genero'];
    downloadsbook.text = data['Downloads'].toString();
    editbook.text = data['Editor'];

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
              key: formKeyBook,
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: TextFormField(
                        controller: booktitle,
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
                        controller: authorname,
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
                        controller: resumobook,
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
                        controller: databook,
                        decoration: InputDecoration(labelText: "Escreva o data de lançamento"),
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
                        controller: generobook,
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
                        controller: downloadsbook,
                        decoration: InputDecoration(labelText: "Escreva a quantidade de downloads"),
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
                        controller: editbook,
                        decoration: InputDecoration(labelText: "Escreva o Editor"),
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
                          await await FirebaseFirestore.instance.collection("Livros")
                              .doc(data.id)
                              .update({
                            "Titulo": booktitle.text,
                            "Autor": authorname.text,
                            'Resumo': resumobook.text,
                            'datalancamento': databook.text,
                            'numpaginas': npagbook.text,
                            'Genero': generobook.text,
                            'Downloads': downloadsbook.text,
                            'Editor': editbook.text,
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
        content: Text('O livro foi apagado com suscesso')));
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
              stream: FirebaseFirestore.instance.collection("Livros").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child:  Text('A carregar livros...'));
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