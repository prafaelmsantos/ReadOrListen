import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:read_or_listen/screens/auth/signup.dart';
import 'package:read_or_listen/screens/auth/login.dart';


class Welcome extends StatefulWidget {
  const Welcome({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(

          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox(
                height: 150,
              ),


              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png")
                    )
                ),
              ),

              const SizedBox(
                height: 50,
              ),


              Column(
                children: <Widget>[
                  // the login button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));

                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text(
                      "Iniciar sessão",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ),
                  // creating the signup button
                  const SizedBox(height:20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupPage()));

                    },
                    color: Colors.red[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text(
                      "Criar conta",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ),
                DoubleBackToCloseApp(
                        snackBar: const SnackBar(
                          content: Text('Pressione novamente para sair!'),
                        ),
                        child: Center(
                          child: MaterialButton(

                            onPressed:(){

                              WidgetsBinding.instance.handlePopRoute;

                          }
                          ),
                        ),
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
