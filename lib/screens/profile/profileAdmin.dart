import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:read_or_listen/screens/home/homeAdmin.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/screens/profile/settings.dart';


const kTitleTextStyle = TextStyle(
  fontSize: 16,
  color: Color.fromRGBO(129, 165, 168, 1),
);

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({Key key}) : super(key: key);

  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  String uname = FirebaseAuth.instance.currentUser.displayName;
  String uemail = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid;

  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');

  Future<void> _homeNavigation() async {
      try {
        FirebaseFirestore.instance
            .collection("Utilizadores")
            .doc(FirebaseAuth.instance.currentUser.uid.toString())
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot['Funcao'] == "Admin") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminPage()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePageClient()));
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
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            _homeNavigation();
          },
          icon: Icon(Icons.arrow_back_ios,
            color: Colors.white,),
        ),
        centerTitle: true,
        title: Text(
          "Meu Perfil", style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder<DocumentSnapshot>(
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
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.black87,
                                  ),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: NetworkImage("${data['Foto']}"),
                                  )
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              uname,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Administrador",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(129, 165, 168, 1)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              uemail,
                              style: TextStyle(fontSize: 20,color: Colors.black87),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      );
                    }
                    return Text("A carregar...");
                  },
                ),
              ),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}

