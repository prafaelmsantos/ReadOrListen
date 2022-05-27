import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future<void>FirestoreCreatePhoto (String urlFoto) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid;
  String uemail = auth.currentUser.email;
  String uname = auth.currentUser.displayName;

  var today = new DateTime.now();
  var dateTimeNow = today.add(new Duration(hours: 1));

  String _dateCreation = DateFormat('dd-MM-yyyy HH:mm').format(dateTimeNow);


  CollectionReference photos = FirebaseFirestore.instance.collection('Fotos');
  photos
      .doc()
      .set({'Email':uemail,'Nome':uname,'Id_utilizador':uid,'Criado':_dateCreation,'Url':urlFoto, 'Valido':'Nao'})
      .then((value) => print("Foto criada no Firestore com sucesso!"))
      .catchError((error) => print("Falha a criar foto no Firestore: $error"));

}

Future<void>FirestorePhotoDelete(String uid) async{


  CollectionReference photo = FirebaseFirestore.instance.collection('Fotos');
  return photo
      .doc(uid)
      .delete()
      .then((value) => print("Foto apagada com sucesso!"))
      .catchError((error) => print("Falha a apagar a foto: $error"));

}

Future<void>FirestorePhotoValidar(String uid) async{

  CollectionReference photo = FirebaseFirestore.instance.collection('Fotos');
  return photo
      .doc(uid)
      .update({'Valido':'Sim'})
      .then((value) => print("Review validada com sucesso!"))
      .catchError((error) => print("Falha a validar a foto!: $error"));

}

Future<void>FirestorePhotoNaoValidar(String uid) async{

  CollectionReference photo = FirebaseFirestore.instance.collection('Fotos');
  return photo
      .doc(uid)
      .update({'Valido':'Nao'})
      .then((value) => print("Foto não validada com sucesso!"))
      .catchError((error) => print("Falha a não validar a foto!: $error"));

}