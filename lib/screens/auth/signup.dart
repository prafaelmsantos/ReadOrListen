import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/auth/login.dart';
import 'package:read_or_listen/screens/home/homeClient.dart';
import 'package:read_or_listen/services/firestoreUsers.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  String _email ='';
  String _password='';
  String _name='';
  TextEditingController passwordText = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<void> _createuser() async {
    final formState = _formKey.currentState;

    if(formState.validate()){

      formState.save();
      try {

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

        //Atualizar o nome
        //User updateUser = FirebaseAuth.instance.currentUser;
        //updateUser.updateProfile(displayName: _name);

        await FirebaseAuth.instance.currentUser.updateProfile(displayName: _name);
        //await FirebaseAuth.instance.currentUser.reload();

        print("User: $userCredential");

        //Guarda a informação no Firestore
        FirestoreUser(_name);

        //Firestore online
        OnlineUser();

        //Firestore ultimo acesso
        FirestoreUpdateLastLogin();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('O registo foi criado com sucesso')));
        //Definir rota
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const HomePageClient()));

      } on FirebaseAuthException catch(e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Erro!')));
      } catch (e){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('erro')));
        print("Error: $e");
      }
    }

  }

  bool hidePassword = true;
  bool hideConfirmPassword = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text("Criar conta",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                  const SizedBox(height: 20,),
                  Text("Crie uma conta gratuita",
                    style: TextStyle(
                        fontSize: 15,
                        color:Colors.grey[700]),)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Nome ( Primeiro e ultimo)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color:Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input){
                            if(input.isEmpty){
                              return 'Nome inválido!';
                            }
                          } ,
                          onSaved: (input) => _name =input,
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
                          'Email',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color:Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input){
                            if(input.isEmpty){
                              return 'Email inválido!';
                            }
                          } ,
                          onSaved: (input) => _email = input,
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
                              color:Colors.black87
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: passwordText,
                          obscureText: hidePassword,
                          validator: (input){
                            if(input.length<6){
                              return 'A password deve ter no minimo 6 caracteres.';
                            }
                          } ,
                          onSaved: (input) => _password =input,
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
                        const SizedBox(height: 20,),
                        const Text(
                          'Confirmar Password',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:Colors.black87
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          obscureText: hideConfirmPassword,
                          validator: (input){
                            if(input.length<6){
                              return 'A password deve ter no minimo 6 caracteres.';
                            }
                            if(input != passwordText.text){
                              return 'As password não são iguais';
                            }
                          } ,
                          //onSaved: (input) => _password=input,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () => setState(() {
                                    hideConfirmPassword = !hideConfirmPassword;
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
                ],
              ),
              Container(
                decoration:
                BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    _createuser();
                    //Navigator.of(context).pushReplacementNamed('/home');
                  },
                  color: Colors.red[900],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Criar conta", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
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
                          builder: (BuildContext context) => LoginPage(),
                        ),
                        );
                      },
                      child: Row(
                        children: const [
                          Text("Já tem uma conta?"),
                          Text(" Iniciar sessão", style:TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
