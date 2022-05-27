import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


Future<void> FirestoreCreateSos (String displayName) async {


      FirebaseAuth auth = FirebaseAuth.instance;
      String uid =auth.currentUser.uid;
      CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');
      CollectionReference sos = FirebaseFirestore.instance.collection('Sos');

      var today = new DateTime.now();
      var dateTimeNow = today.add(new Duration(hours: 1));

      String _dateCreation = DateFormat('dd-MM-yyyy').format(dateTimeNow);
      String _timeCreation = DateFormat('HH:mm').format(dateTimeNow);


      utilizadores.doc(uid).get().then((data) {

        String ufoto;
        ufoto= data['Foto'] ;

        sos
            .doc(uid)
            .set({'Nome':displayName,'Data':_dateCreation,'Hora':_timeCreation,'Foto':ufoto})
            .then((value) => print("Sos criado no Firestore"))
            .catchError((error) => print("Falha a criar o Sos no Firestore: $error"));


      });

}

Future<void>FirestoreSosNome(String Nome) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();


  CollectionReference sos = FirebaseFirestore.instance.collection('Sos');
  return sos
      .doc(uid)
      .update({'Nome':Nome})
      .then((value) => print("Sos atualizada"))
      .catchError((error) => print("Falha a atualizar. Não existe uma SOS: $error"));

}

Future<void>FirestoreSosFoto(String Foto) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();


  CollectionReference sos = FirebaseFirestore.instance.collection('Sos');
  return sos
      .doc(uid)
      .update({'Foto':Foto})
      .then((value) => print("Sos atualizada com sucesso!"))
      .catchError((error) => print("Falha a atualizar. Não existe nenhuma sos: $error"));

}

Future<void>FirestoreSosDelete(String uid) async{


  CollectionReference sos = FirebaseFirestore.instance.collection('Sos');
  return sos
      .doc(uid)
      .delete()
      .then((value) => print("Sos apagada com sucesso!"))
      .catchError((error) => print("Falha a apagar a Sos: $error"));

}