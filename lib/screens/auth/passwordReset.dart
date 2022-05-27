import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  String _email ='';


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _passwordReset() async {
    final formState = _formKey.currentState;

    if(formState.validate()){

      formState.save();
      try {

       await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);

       print('Foi enviado para o email para criar uma nova password!');


        //Definir rota
        //Navigator.of(context).pushReplacementNamed('/login');

      } on FirebaseAuthException catch(e) {
        print("Error: $e");
      } catch (e){
        print("Error: $e");
      }
    }

  }

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
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),


        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 450,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Recuperar sua conta',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Insira sua conta de acesso que vamos enviar um email para redefinir a palavra passe.",
                    style: TextStyle(
                        fontSize: 15,
                        color:Colors.grey[700]),)

                ],
              ),
              Column(

                children: <Widget>[

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[

                        Text(
                          'Email',

                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color:Colors.black87,
                          ),

                        ),
                        SizedBox(
                          height: 10,
                        ),

                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input){
                            if(input.isEmpty){
                              return 'Email inválido!';
                            }
                          } ,
                          onSaved: (input) => _email =input,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0,
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
                    border: Border(
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

                    _passwordReset();
                    //Navigator.of(context).pushReplacementNamed('/home');
                  },
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),

                  ),
                  child: Text(
                    "Recuperar password", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,

                  ),
                  ),

                ),

              ),


            ],

          ),


        ),

      ),

    );
  }
}
