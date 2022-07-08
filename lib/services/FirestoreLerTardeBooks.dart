import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> FirestoreCreateLerTardeBooks(String livroId, String Capa, String Titulo, String Autor, String Id_lerTarde) async {
  //Vai buscar o id do utilizador currente.
  FirebaseAuth auth = FirebaseAuth.instance;
  String Id_utilizador =auth.currentUser.uid;

  // base de dados Ler mais tarde
  CollectionReference lerTarde = FirebaseFirestore.instance.collection('LerTardeLivros');

  return lerTarde
      .doc(Id_lerTarde)
      .set({
    'Id_livro': livroId,
    'Capa': Capa,
    'Titulo': Titulo,
    'Autor': Autor,
    'Id_utilizador': Id_utilizador

  })
      .then((value) => print("Ler mais tarde criado no Firestore com sucesso!"))
      .catchError((error) => print("Erro a criar Ler mais tarde: $error"));
}


Future<void>FirestoreLerTardeDeleteBook(String Id_lerTarde) async{
  CollectionReference lerTarde = FirebaseFirestore.instance.collection('LerTardeLivros');

  return lerTarde
      .doc(Id_lerTarde)
      .delete()
      .then((value) => print("Ler mais tarde apagado do Firestore com sucesso!"))
      .catchError((error) => print("Falha ao apagar a ler mais tarde no Firestore: $error"));

}