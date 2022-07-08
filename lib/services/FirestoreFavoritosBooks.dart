import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> FirestoreCreateFavoritosBooks (String livroId, String Capa, String Titulo, String Autor, String Id_favorito) async {
  //Vai buscar o id do utilizador currente.
  FirebaseAuth auth = FirebaseAuth.instance;
  String Id_utilizador =auth.currentUser.uid;

  // base de dados Favoritos
  CollectionReference favoritos = FirebaseFirestore.instance.collection('FavoritosLivros');

  return favoritos
      .doc(Id_favorito)
      .set({
    'Id_livro': livroId,
    'Capa': Capa,
    'Titulo': Titulo,
    'Autor': Autor,
    'Id_utilizador': Id_utilizador

  })
      .then((value) => print("Favorito criado no Firestore com sucesso!"))
      .catchError((error) => print("Erro a criar favorito: $error"));
}


Future<void>FirestoreFavoritoDeleteBook(String Id_favorito) async{
  CollectionReference favoritos = FirebaseFirestore.instance.collection('FavoritosLivros');

  return favoritos
      .doc(Id_favorito)
      .delete()
      .then((value) => print("Favorito apagado do Firestore com sucesso!"))
      .catchError((error) => print("Falha ao apagar a favorito no Firestore: $error"));

}