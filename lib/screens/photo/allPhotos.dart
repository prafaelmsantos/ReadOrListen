import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:read_or_listen/screens/home/home.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/screens/photo/photoCliente.dart';
import 'package:read_or_listen/screens/photo/uploadFoto.dart';


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
class AllPhotos extends StatefulWidget {
  const AllPhotos({Key key}) : super(key: key);

  @override
  _AllPhotosState createState() => _AllPhotosState();
}

class _AllPhotosState extends State<AllPhotos> {



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
          "Fotografias Gaivotas Miguelito", style: TextStyle(color: Colors.black, fontSize: 20),),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadFoto()));
                  },
                    icon: Icon(Icons.add,
                      size: 38,
                      color: Colors.blueAccent,),
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.blueAccent,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Text('Minhas fotografias',style: TextStyle
                        (color: Colors.white,fontSize: 15),
                      ),
                      onPressed: () {
                        //_homeNavigation();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>PhotoClient()));
                      }
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  Padding(
                    padding: const EdgeInsets.only(bottom:10.0, top: 10),
                    child: Center(
                      child: Container(
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
                              image: AssetImage("assets/images/logo1.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),

                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Gaivotas Miguelito",
                style: kLargeTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "+351 913 958 257",
                style: kTitleTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "gaivotasmiguelito@gmail.com",
                style: kTitleTextStyle,
              ),
              SizedBox(
                height: 40,
              ),
              Divider(
                height: 2,
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Fotos').where('Valido', isEqualTo: 'Sim').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: Text('A carregar fotos...'));
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

