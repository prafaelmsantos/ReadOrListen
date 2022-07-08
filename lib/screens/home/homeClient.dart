import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/books/homeBooks.dart';
import 'package:read_or_listen/screens/profile/profile.dart';
import 'package:read_or_listen/screens/search/search.dart';
import 'package:read_or_listen/services/firestoreUsers.dart';
import 'package:read_or_listen/screens/biblioteca/homeBiblioteca.dart';
import 'package:read_or_listen/screens/audiobooks/homeAudiobooks.dart';

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

    //Firestore utilizador offline
    OfflineUser();

    //Sair FirebaseAuth
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/welcome", (Route<dynamic> route) => false);
  }

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    //Pagina Livros
    HomeBooksPage(),
    //Pagina Audiobooks
    HomeAudiobooksPage(),
    //Pagina Pesquisa
    SearchPage(),
    //Pagina Biblioteca
    HomeBibliotecaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black87,
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
                color: Colors.white,),
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
        backgroundColor: Colors.black87,
        title: const Text('Read Or Listen'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //muda o icon principal da navbar
        type: BottomNavigationBarType.fixed, //Não muda, fixa
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp),
            label: 'Livros',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset),
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
          onTap: (index) {
            setState(() {
              _selectedIndex = index; //muda de pagina
            });
          }
      ),
    );
  }
}
