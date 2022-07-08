import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/admin/adicionarAudiobooksAdmin.dart';
import 'package:read_or_listen/screens/admin/atualizarAudiobooksAdmin.dart';
import 'package:read_or_listen/screens/admin/atualizarBooksAdmin.dart';
import 'package:read_or_listen/screens/admin/removerAudiobooksAdmin.dart';
import 'package:read_or_listen/screens/admin/removerBooksAdmin.dart';
import 'package:read_or_listen/screens/admin/reviewsAdmin.dart';
import 'package:read_or_listen/screens/admin/adicionarBooksAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_or_listen/screens/admin/usersAdmin.dart';
import 'package:read_or_listen/screens/profile/profileAdmin.dart';
import 'package:read_or_listen/services/firestoreUsers.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final String _userName = FirebaseAuth.instance.currentUser.displayName;
  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');


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
                    builder: (BuildContext context) => AdminPage()));
              },
              child:Text('Cancelar')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black87,),
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
                    'Bem-vindo '+ _userName,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,),
                  ),
                  accountEmail: Text('Administração',style: TextStyle(
                    color: Colors.white,),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Inicio',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,),
                  ),
                  subtitle: Text('Página principal'),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AdminPage()));
                    print('home');
                  },
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text('Minha conta',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,),
                  ),
                  subtitle: Text('Perfil e definições de conta'),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ProfileAdmin()));
                    print('Conta');
                  },
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,),
                  ),
                  subtitle: Text('Finalizar sessão'),
                  onTap: () async {
                    print('Sair');
                    exitDialog();
                  },
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: const Text('Administração', style: const TextStyle(color: Colors.white)),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.menu_book_sharp), text: 'Livros'),
                Tab(icon: Icon(Icons.headset), text: 'Audiobooks'),
                Tab(icon: Icon(Icons.account_circle_outlined), text: 'Utilizadores',),
                Tab(icon: Icon(Icons.rate_review_outlined), text: 'Reviews'),
              ],
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              //Livros
              Container(
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        toolbarHeight: 10,
                        toolbarTextStyle: const TextStyle(color: Colors.black),
                        backgroundColor: Colors.black87,
                        leading: const IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                            //esconder button
                            color: Colors.transparent,
                          ),
                        ),

                        bottom: const TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          tabs: [
                            Tab( text: 'Adicionar',),
                            Tab( text: 'Atualizar'),
                            Tab( text: 'Remover'),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Container(
                            child: AdicionarBooksAdmin(),
                          ),
                          Container(
                            child: AtualizarBooksAdmin(),
                          ),
                          Container(
                            child: RemoverBooksAdmin(),
                          ),
                        ],
                      ),
                    ),
                  )
              ),

              //Audio
              Container(
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        toolbarHeight: 10,
                        toolbarTextStyle: const TextStyle(color: Colors.black),
                        backgroundColor: Colors.black87,
                        leading: const IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                            //esconder button
                            color: Colors.transparent,
                          ),
                        ),

                        bottom: const TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          tabs: [
                            Tab( text: 'Adicionar',),
                            Tab( text: 'Atualizar'),
                            Tab( text: 'Remover'),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Container(
                            child: AdicionarAudiobooksAdmin(),
                          ),
                          Container(
                            child: AtualizarAudiobooksAdmin(),
                          ),
                          Container(
                             child: RemoverAudiobooksAdmin(),
                          ),
                        ],
                      ),
                    ),
                  )
              ),

              Container(
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 10,
                      toolbarTextStyle: const TextStyle(color: Colors.black),
                      backgroundColor: Colors.black87,
                      leading: const IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                          //esconder button
                          color: Colors.transparent,
                        ),
                      ),
                      bottom: const TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        tabs: [
                          Tab( text: 'Online',),
                          Tab( text: 'Offline'),
                          Tab( text: 'Todos'),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        Container(
                          child: OnlineUsers(),
                        ),
                        Container(
                          child: OfflineUsers(),
                        ),
                        Container(
                          child: UsersAdmin(),
                        ),
                      ],
                    ),
                  ),
                )
              ),
              Container(
                child: ReviewsAdmin(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

