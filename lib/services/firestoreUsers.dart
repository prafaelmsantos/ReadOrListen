import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future<void>FirestoreUser (String displayName) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  var today = FirebaseAuth.instance.currentUser.metadata.creationTime;
  var _creationTime = today.add(new Duration(hours: 1));

  var _lastlogin = FirebaseAuth.instance.currentUser.metadata.lastSignInTime;
  var _lastSignInTime = _lastlogin.add(new Duration(hours: 1));


  String uid = auth.currentUser.uid.toString();
  String uemail = auth.currentUser.email.toString();
  String udateCreation = DateFormat('dd-MM-yyyy  kk:mm').format(_creationTime);
  String ulastLogin = DateFormat('dd-MM-yyyy  kk:mm').format(_lastSignInTime);
  String ufotoDefault = 'https://firebasestorage.googleapis.com/v0/b/readorlisten-7fac2.appspot.com/o/logo1.png?alt=media&token=ccd1f444-987d-4fe0-8180-e4cb3c8f5455';




  CollectionReference users = FirebaseFirestore.instance.collection('Utilizadores');
  users
      .doc(uid)
      .set({'Email':uemail,'Nome':displayName,'Id':uid,'Criado':udateCreation,'Funcao':'Cliente', 'Foto':ufotoDefault, 'ultimoLogin':ulastLogin})
      .then((value) => print("Utilizador criado no Firestore"))
      .catchError((error) => print("Falha a criar utilizador no Firestore: $error"));

}

Future<void>OnlineUser() async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();


  CollectionReference users = FirebaseFirestore.instance.collection('Utilizadores');
  return users
      .doc(uid)
      .update({'Estado':'Online'})
      .then((value) => print("Utilizador online"))
      .catchError((error) => print("Falha a atualizar o estado do utilizador: $error"));

}

Future<void>OfflineUser() async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();
  
  CollectionReference users = FirebaseFirestore.instance.collection('Utilizadores');
  return users
      .doc(uid)
      .update({'Estado':'Offline'})
      .then((value) => print("Utilizador offline"))
      .catchError((error) => print("Falha a atualizar o estado do utilizador: $error"));

}

Future<void>FirestoreUserDelete(String uid) async{


  CollectionReference sos = FirebaseFirestore.instance.collection('Utilizadores');
  return sos
      .doc(uid)
      .delete()
      .then((value) => print("Utilizador apagado com sucesso!"))
      .catchError((error) => print("Falha a apagar o utilizador: $error"));

}

Future<void>FirestoreUpdateLastLogin() async{

  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();

  var _lastlogin = FirebaseAuth.instance.currentUser.metadata.lastSignInTime;
  var _lastSignInTime = _lastlogin.add(new Duration(hours: 1));
  String ulastLogin = DateFormat('dd-MM-yyyy  kk:mm').format(_lastSignInTime);


  CollectionReference users = FirebaseFirestore.instance.collection('Utilizadores');
  return users
      .doc(uid)
      .update({'ultimoLogin':ulastLogin})
      .then((value) => print("Ultimo login Atualizado"))
      .catchError((error) => print("Falha a atualizar o ultimo login: $error"));

}



