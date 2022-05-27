import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void>FirestoreLocation (double Latitude, double Longitude) async{
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser.uid.toString();
  String uname= auth.currentUser.displayName.toString();



  CollectionReference users = FirebaseFirestore.instance.collection('Localizacoes');
  users
      .doc(uid)
      .set({'Nome':uname,'Longitude':Longitude,'Latitude':Latitude})
      .then((value) => print("Localização criada no Firestore"))
      .catchError((error) => print("Falha a criar no Firestore: $error"));

}

Future<void>FirestoreLocationDelete(String uid) async{


  CollectionReference reviews = FirebaseFirestore.instance.collection('Localizacoes');
  return reviews
      .doc(uid)
      .delete()
      .then((value) => print("Localização apagada!"))
      .catchError((error) => print("Falha a apagar a localizacao: $error"));

}
