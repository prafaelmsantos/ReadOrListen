import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/auth/passwordReset.dart';
import 'package:read_or_listen/screens/auth/signup.dart';
import 'package:read_or_listen/screens/home/homeAdmin.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/services/firestoreUsers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  String _email ='';
  String _password='';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference utilizadores = FirebaseFirestore.instance.collection('Utilizadores');

  Future<void> _loginuser() async {
    final formState = _formKey.currentState;

    if(formState.validate()){
      formState.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        print("User: $userCredential");

        //Firestore utilizador online
        OnlineUser();

        //Firestore Ultimo Acesso utilizador
        FirestoreUpdateLastLogin();

        FirebaseAuth auth = FirebaseAuth.instance;
        String _uid = auth.currentUser.uid;
        FirebaseFirestore.instance.collection('Utilizadores').doc(_uid).get().then((data) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('O login foi iniciado com sucesso')));
          if(data['Funcao'] == 'Admin'){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AdminPage()));
            print('Home Page');
          }else{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const HomePageClient()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showDialog('Nenhum utilizador encontrado para esse e-mail.');
        } else if (e.code == 'wrong-password') {
          _showDialog('Password incorreta para este utilizador');
        }
      }
    }
  }

  Future<void> _showDialog(String erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro ao iniciar sessão!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(erro),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),
        ),
      ),
      body:SingleChildScrollView(
        child:SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text("Iniciar sessão",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20,),
                    Text("Inicie a sessão com a sua conta",
                      style: TextStyle(
                          fontSize: 15,
                          color:Colors.grey[700]),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color:Colors.black87,),
                            ),
                            const SizedBox(
                              height: 10,),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (input){
                                if(input.isEmpty){
                                  return 'Email inválido!';
                                }
                              } ,
                              onSaved: (input) => _email =input,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0,
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
                            const SizedBox(height: 20,),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color:Colors.black87),
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              obscureText: hidePassword,
                              validator: (input){
                                if(input.length<6){
                                  return 'A password deve ter no minimo 6 caracteres.';
                                }
                              } ,
                              onSaved: (input) {
                                _password =input;
                                },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      hidePassword = !hidePassword;
                                    }),icon: const Icon(Icons.visibility)),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0,
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
                      const SizedBox(height: 10,),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const PasswordReset(),
                          ),
                          );
                        },
                        child: const Text(
                          "Esqueceu-se da palavra passe?", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black,),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration:
                    BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        ),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        _loginuser();
                      },
                      color: Colors.red[900],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Iniciar sessão", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const SignupPage(),
                        ),
                        );
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Não tem uma conta?'
                          ),
                          Text(
                            ' Crie uma!', style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 100),
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.fitHeight
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    ),
    );
  }
}

