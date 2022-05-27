import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/books/homeBooks.dart';

import 'package:read_or_listen/screens/profile/profile.dart';

import 'package:read_or_listen/services/firestoreUsers.dart';


class HomePageClient extends StatefulWidget {
  const HomePageClient({Key key}) : super(key: key);

  @override
  _HomePageClientState createState() => _HomePageClientState();
}

class _HomePageClientState extends State<HomePageClient> {

  final String _userName = FirebaseAuth.instance.currentUser.displayName;
  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');


  Future<void>exitDialog(){
    return showDialog(context: context,
      builder: (context) => AlertDialog(title: const Text('Tem a certeza que pretende sair?'),
        actions: [
          MaterialButton(
              onPressed: (){
                _logoutuser();
              },
              child:const Text('Sim')
          ),
          MaterialButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child:const Text('Cancelar')
          ),

        ],
      ),
    );

  }

  Future<void> _logoutuser() async {

    //Firestore offline
    OfflineUser();

    //Sair FirebaseAuth
    await FirebaseAuth.instance.signOut();

    //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext contex) => Welcome()));
    //Navigator.popUntil(context, ModalRoute.withName('/welcome'));
    Navigator.pushNamedAndRemoveUntil(context, "/welcome", (Route<dynamic> route) => false);


  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[

    //Pagina Livros
    HomeBooksPage(),

    Text(
      'Audiobooks Page',
      //style: optionStyle,
    ),
    Text(
      'Procurar Page',
      //style: optionStyle,
    ),
    Text(
      'Biblioteca Page',
      //style: optionStyle,
    ),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: Column(
          children: [

            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              currentAccountPicture:FutureBuilder<DocumentSnapshot>(
                future: utilizadores.doc(uid).get(),
                builder:
                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data.exists) {
                    return const Text("Document does not exist");
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

                  return const Text("A carregar...");
                },
              ),
              accountName: Text(
                'Bem-vindo '+_userName,style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),

              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),),
              subtitle: const Text('Página principal'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const HomePageClient()));
                print('home');
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Minha conta',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),),
              subtitle: const Text('Perfil e definições de conta'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const Profile()));
                print('Conta');
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),),
              subtitle: const Text('Finalizar sessão'),
              onTap: () async {
                print('Sair');
                exitDialog();
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: const Text('Read Or Listen'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp),
            label: 'Livros',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack_outlined),
            label: 'Audiobooks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Procurar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Biblioteca',
          ),

        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white54 ,
        selectedItemColor: Colors.black,
        selectedFontSize: 20.0,
        unselectedFontSize: 18.0,
        onTap: _onItemTapped,

      ),


    );

  }
}
