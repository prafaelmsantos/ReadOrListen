import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:read_or_listen/screens/profile/settings.dart';
import 'package:read_or_listen/services/FirestoreLocations.dart';
import 'package:read_or_listen/services/firestoreReviews.dart';
import 'package:read_or_listen/services/firestoreSos.dart';
import 'package:read_or_listen/services/firestoreUsers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({Key key}) : super(key: key);

  @override
  _SettingsUIState createState() => _SettingsUIState();
}



class _SettingsUIState extends State<SettingsUI> {


  String _email ='';
  String _name='';


  String uid = FirebaseAuth.instance.currentUser.uid;
  String uname = FirebaseAuth.instance.currentUser.displayName;
  String uemail = FirebaseAuth.instance.currentUser.email;

  User user = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');



  String imageUrl;
  var file;
  final _firebaseStorage = FirebaseStorage.instance;


  //ALERTA de BEM SUCEDIDO
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Operação Bem-Sucedida!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Os seus dados foram atualizados com sucesso!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: const Text('OK')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  uploadImage() async {
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {

      //Selecionar Imagem
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      file = File(image.path);
    }

    var snapshot = await _firebaseStorage.ref()
        .child(uid.toString())
        .putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl;
    });
    if (imageUrl!=null){


      //Atualizar foto da review
      FirestoreReviewFoto(imageUrl);

      //Atualizar foto do pedido de sos
      FirestoreSosFoto(imageUrl);

          utilizadores
          .doc(uid)
          .update({'Foto': imageUrl})
          .then((value) => print("Foto atualizada com sucesso"))
          .catchError((error) => print("Falha a atualizar a foto: $error"));
     return _showDialog();


    }

  }


  Future<void> _updateuser() async {


    final formState = _formKey.currentState;

    if(formState.validate()){

      formState.save();


      await FirebaseAuth.instance.currentUser.updateProfile(displayName: _name);

      //var user = firebase.auth().currentUser;
      user.updateEmail(_email);

      //Atualizar nome da review
      FirestoreReviewNome(_name);

      //Atualizar nome no pedido de sos
      FirestoreSosNome(_name);


      //await FirebaseAuth.instance.currentUser.reload();

          utilizadores
          .doc(uid)
          .update({'Nome': _name, 'Email':_email})
          .then((value) => print("Utilizador atualizado"))
          .catchError((error) => print("Falha a atualizar: $error"));
          return _showDialog();
    }

  }
  Future<void> _deleteUser() async {

    try {

      //Apagar no Firebase Auth
      await FirebaseAuth.instance.currentUser.delete();

      //Apagar Utilizador no Firestore
      FirestoreUserDelete(uid);

      //Apagar Localizacao no Firestore
      FirestoreLocationDelete(uid);

      //Apagar Pedido SOS no Firestore
      FirestoreSosDelete(uid);


      Navigator.pushNamedAndRemoveUntil(context, "/welcome", (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }

  }

  Future<void>deleteDialog(){
    return showDialog(context: context,
      builder: (context) => new AlertDialog(title: Text('Tem a certeza que pretende apagar a conta?'),
        actions: [
          MaterialButton(
              onPressed: (){
                _deleteUser();
              },
              child:Text('Sim')
          ),
          MaterialButton(
              onPressed: (){
                //Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsUI()));
              },
              child:Text('Cancelar')
          ),

        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SettingsPage()));
          },
          icon: Icon(Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Dados Pessoais", style: TextStyle(color: Colors.black, fontSize: 24),),
      ),
      body: Scaffold(

        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: utilizadores.doc(uid).get(),
                      builder:
                          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                        if (snapshot.hasError) {
                          return Text("Algo correu mal");
                        }

                        if (snapshot.hasData && !snapshot.data.exists) {
                          return Text("Não existe nenhum dado");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data.data();
                          return Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Theme.of(context).backgroundColor
                                      ),

                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("${data['Foto']}"),
                                      )
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 45,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                        child:IconButton(
                                          onPressed: () {
                                            uploadImage();
                                          },
                                          icon: Icon(Icons.edit,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        }

                        return Text("A carregar...");
                      },
                    ),

                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          Text(
                            'Nome',

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:Colors.black87,
                            ),

                          ),
                          SizedBox(
                            height: 10,
                          ),

                          TextFormField(
                            initialValue: uname,


                            validator: (input){
                              if(input.isEmpty){
                                return 'Nome inválido!';
                              }
                            } ,
                            onSaved: (input) => _name =input,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0,
                                    horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[400]
                                  ),

                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[400])
                                )
                            ),

                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            'Email',

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:Colors.black87,
                            ),

                          ),
                          SizedBox(
                            height: 10,
                          ),

                          TextFormField(
                            initialValue: uemail,
                            validator: (input){
                              if(input.isEmpty){
                                return 'Nome inválido!';
                              }
                            } ,
                            onSaved: (input) => _email =input,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0,
                                    horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[400]
                                  ),

                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[400])
                                )
                            ),

                          ),


                        ],
                      ),
                    ),


                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  decoration:
                  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),

                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      _updateuser();

                    },
                    color: Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),

                    ),
                    child: Text(
                      "Editar conta", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,

                    ),
                    ),

                  ),

                ),
                SizedBox(height: MediaQuery.of(context).size.height/10,),

                MaterialButton(
                  onPressed: () {
                    deleteDialog();
                  },
                  child: Text(
                    "Apagar conta", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                    decoration: TextDecoration.underline,


                  ),
                  ),
                ),

              ],

            ),

          ),

        ),

      ),
    );
  }
}
