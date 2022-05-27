import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

class UPassword extends StatefulWidget {
  const UPassword({Key key}) : super(key: key);

  @override
  _UPasswordState createState() => _UPasswordState();
}

class _UPasswordState extends State<UPassword> {

  String _password='';
  TextEditingController passwordText = TextEditingController();


  String uid = FirebaseAuth.instance.currentUser.uid;
  String uname = FirebaseAuth.instance.currentUser.displayName;
  String uemail = FirebaseAuth.instance.currentUser.email;



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');



  Future<void> _updatePassword() async {


    final formState = _formKey.currentState;

    if(formState.validate()){

      formState.save();

      User user = FirebaseAuth.instance.currentUser;

      //var user = firebase.auth().currentUser;
      user.updatePassword(_password);


    }

  }
  bool showPassword = true;
  bool showConfirmPassword = true;


  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Password?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('A sua palavra-passe será alterada.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Sim')),
              onPressed: () {
                _updatePassword();
                Navigator.pop(context);
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

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Alterar Password", style: TextStyle(color: Colors.black, fontSize: 24),),

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
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[


                          Text(
                            'Nova password',

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
                            obscureText: showPassword,
                            controller: passwordText,

                            validator: (input){
                              if(input.length<6){
                                return 'A password deve ter no minimo 6 caracteres.';
                              }
                            } ,
                            //onSaved: (input) => _email =input,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      showPassword = !showPassword;
                                    }),icon: Icon(Icons.visibility)),
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
                            height: 10,
                          ),
                          Text(
                            'Repetir password',

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

                            obscureText: showConfirmPassword,

                            validator: (input){
                              if(input.length<6){
                                return 'A password deve ter no minimo 6 caracteres.';
                              }
                              if(input != passwordText.text){
                                return 'As password não são iguais';
                              }
                            } ,
                            onSaved: (input) => _password =input,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      showConfirmPassword = !showConfirmPassword;
                                    }),icon: Icon(Icons.visibility)),
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
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(50),

                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                    _showDialog();


                    },
                    color: Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),

                    ),
                    child: Text(
                      "Editar password", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,

                    ),
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
