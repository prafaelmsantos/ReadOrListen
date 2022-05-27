import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/admin/admin.dart';

import 'package:read_or_listen/screens/profile/profileAdmin.dart';
import 'package:read_or_listen/services/firestoreUsers.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _userName = FirebaseAuth.instance.currentUser.displayName;
  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');


  //String _dateLastSigned = DateFormat('MM-dd-yyyy – kk:mm').format(FirebaseAuth.instance.currentUser.metadata.lastSignInTime);

  Future<void>exitDialog(){
    return showDialog(context: context,
      builder: (context) => AlertDialog(title: Text('Tem a certeza que pretende sair?'),
        actions: [
          MaterialButton(
              onPressed: (){
                _logoutuser();
              },
              child:const Text('Sim')
          ),
          MaterialButton(
              onPressed: (){
                //Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              },
              child:Text('Cancelar')
          ),

        ],
      ),
    );

  }

  Future<void> _logoutuser() async {

    //Firestore offline
    OfflineUser();
    await FirebaseAuth.instance.signOut();
    //Navigator.of(context).pushReplacementNamed('/welcome');
    Navigator.pushNamedAndRemoveUntil(context, "/welcome", (Route<dynamic> route) => false);

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [

            UserAccountsDrawerHeader(
              currentAccountPicture:FutureBuilder<DocumentSnapshot>(
                future: utilizadores.doc(uid).get(),
                builder:
                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data.exists) {
                    return Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data.data();
                    return Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    //color: Theme.of(context).backgroundColor
                                ),

                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("${data['Foto']}"),
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Text("A carregar...");
                },
              ),
              accountName: Text(
                  'Bem-vindo '+_userName,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),

              ),
              accountEmail: Text('Administração',style: TextStyle(
                color: Colors.black,
              ),),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  ),),
              subtitle: Text('Página principal'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
                print('home');
              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Minha conta',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),),
              subtitle: Text('Perfil e definições de conta'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ProfileAdmin()));
                print('Conta');
              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),

            ListTile(
              leading: Icon(Icons.admin_panel_settings_rounded),
              title: Text('Administração',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AdminPage()));

                print('Administração');

              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),),
              subtitle: Text('Finalizar sessão'),
              onTap: () async {
                print('Sair');
               // _logoutuser();
                exitDialog();

              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("GM - Administração",
          style: TextStyle(color: Colors.black, fontSize: 24),),
      ),
      //body:
    );

  }
}