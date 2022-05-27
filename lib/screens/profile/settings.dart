import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/profile/password.dart';
import 'package:read_or_listen/screens/profile/privacy.dart';
import 'package:read_or_listen/screens/profile/profile.dart';
import 'package:read_or_listen/screens/profile/profileAdmin.dart';
import 'editProfile.dart';
import 'profile.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Future<void> _homeNavigation() async {

    try {
      FirebaseFirestore.instance
          .collection("Utilizadores")
          .doc(FirebaseAuth.instance.currentUser.uid.toString())
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot['Funcao'] == "Admin") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>ProfileAdmin()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Profile()));
        }
      });
    } catch (e) {
      print(e.message);

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            _homeNavigation();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Definições", style: TextStyle(color: Colors.black, fontSize: 24),),
      ),
      body: Container(

        padding: EdgeInsets.symmetric(vertical:20,horizontal: 25),
        child: ListView(
          children: [

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Conta",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                  'Alterar dados pessoais',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),

              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsUI()));
                print('Alterar dados pessoais');
              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              title: Text(
                'Alterar Password',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),

              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UPassword()));
                print('Alterar Password');
              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              title: Text(
                'Privacidade e Segurança',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),

              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Privacy()));
                print('Privacidade e Segurança');
              },
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),

            SizedBox(
              height: 50,
            ),

          ],
        ),
      ),
    );
  }
}
