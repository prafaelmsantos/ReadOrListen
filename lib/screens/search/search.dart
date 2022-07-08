import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/audiobooks/audiobookDetails.dart';
import 'package:read_or_listen/screens/books/bookDetails.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 1,
        title: Container(
          height: 45,
          child: Card(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey,),
              hintText: 'Search...',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              ),
            onChanged: (val) {
              setState(() {
                name = val.toLowerCase();
              });
            },
          ),
        ), ),
      ),
      body: SingleChildScrollView(
         child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, bottom: 20),
            child: const Text('Livros', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
            Container(
              height: 350,
              child: StreamBuilder<QuerySnapshot>(
              stream: (name != "" && name != null)
                ? FirebaseFirestore.instance
                .collection('Livros')
                .where("searchIndex", arrayContains: name)
                .snapshots()
                : FirebaseFirestore.instance.collection("Livros").snapshots(),
              builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(

                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return RawMaterialButton(
                      onPressed: () {
                        String livroId = snapshot.data.docs[index].id;
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => BookDetailsPage(livroId)));
                      },
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                              child:Image.network(
                                data['Capa'],
                                width: 80,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                  data['Titulo'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  data['Autor'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
              );
            },
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, bottom: 20),
            child: const Text('Audiobooks', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 350,
            child: StreamBuilder<QuerySnapshot>(
              stream: (name != "" && name != null)
                  ? FirebaseFirestore.instance
                  .collection('Audiobooks')
                  .where("searchIndex", arrayContains: name)
                  .snapshots()
                  : FirebaseFirestore.instance.collection("Audiobooks").snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      return RawMaterialButton(
                        onPressed: () {
                        String audiobookId = snapshot.data.docs[index].id;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AudiobookDetailsPage(audiobookId)));
                        },
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                              child:Image.network(
                                data['Capa'],
                                width: 80,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    data['Titulo'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  data['Autor'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
