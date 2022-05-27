import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:read_or_listen/screens/home/home.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/screens/profile/settings.dart';


const kLargeTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
);
const kTitleTextStyle = TextStyle(
  fontSize: 16,
  color: Color.fromRGBO(129, 165, 168, 1),
);
const kSmallTextStyle = TextStyle(
  fontSize: 16,
);
class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


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
                MaterialPageRoute(builder: (context) => HomePage()));
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
        leading: IconButton(
          onPressed: () {
            _homeNavigation();

          },
          icon: Icon(Icons.arrow_back_ios,

            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Meu Perfil", style: TextStyle(color: Colors.black, fontSize: 24),),
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
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
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

                          ],
                        ),
                      );
                    }

                    return Text("A carregar...");
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                uname,
                style: kLargeTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                uemail,
                style: kTitleTextStyle,
              ),
              SizedBox(
                height: 50,
              ),
              Divider(height: 10,thickness: 1, color: Colors.black,),
              SizedBox(height: 15,),

              Padding(
                padding:  EdgeInsets.only(top: 3),
                child: Text("Minhas Fotografias", style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),),
              ),
              SizedBox(
                height: 40,
              ),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Fotos').where('Id_utilizador', isEqualTo:uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: Text('A carregar fotos...'));
                    if (snapshot.hasData && snapshot.data.docs.length == 0) {
                      return Center(child:Text("Ainda sem fotografias"));
                    }

                    return new GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return new SafeArea(
                          child:  Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              // color: Colors.green,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage("${document['Url']}"),
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

