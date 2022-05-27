import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


Future<void>FirestoreReviewNome(String Nome) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();


  CollectionReference users = FirebaseFirestore.instance.collection('Reviews');
  return users
      .doc(uid)
      .update({'Nome':Nome})
      .then((value) => print("Review atualizada"))
      .catchError((error) => print("Falha a atualizar. Não existe review: $error"));

}

Future<void>FirestoreReviewFoto(String Foto) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();


  CollectionReference users = FirebaseFirestore.instance.collection('Reviews');
  return users
      .doc(uid)
      .update({'Foto':Foto})
      .then((value) => print("Review atualizada"))
      .catchError((error) => print("Falha a atualizar. Não existe review: $error"));

}

Future<void>FirestoreReviewDelete(String uid) async{


  CollectionReference reviews = FirebaseFirestore.instance.collection('Reviews');
  return reviews
      .doc(uid)
      .delete()
      .then((value) => print("Review apagada!"))
      .catchError((error) => print("Falha a apagar a review: $error"));

}

Future<void> CreateReview(String _conteudo, double _avaliacao) async {

  CollectionReference reviews = FirebaseFirestore.instance.collection('Reviews');
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');

      FirebaseAuth auth = FirebaseAuth.instance;
      String uid =auth.currentUser.uid;
      String uname = auth.currentUser.displayName;

      var today = new DateTime.now();
      var dateTimeNow = today.add(new Duration(hours: 1));

      String _dateCreation = DateFormat('dd-MM-yyyy').format(dateTimeNow);
      String _timeCreation = DateFormat('HH:mm').format(dateTimeNow);


      utilizadores.doc(uid).get().then((data) {

        String ufoto;
        ufoto= data['Foto'] ;

        reviews
            .doc(uid)
            .set({'Nome':uname,'Conteudo':_conteudo,'Foto':ufoto,'Data':_dateCreation,'Hora':_timeCreation, 'Avaliacao':_avaliacao})
            .then((value) => print("Review criada no Firestore"))
            .catchError((error) => print("Falha a criar uma review no Firestore: $error"));


      });


}


