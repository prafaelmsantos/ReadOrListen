import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ficha extends StatefulWidget {
  const Ficha({Key key}) : super(key: key);

  @override
  _FichaState createState() => _FichaState();
}

class _FichaState extends State<Ficha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ), centerTitle: true,
        title: Text(
         "Ficha Técnica", style: TextStyle(color: Colors.black, fontSize: 24),),

      ),
      body: Scaffold(

        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom:10.0, top: 10),
                      child: Center(
                        child: Container(
                          child: Image(
                            image: AssetImage(
                              'assets/images/logo1.png',
                            ),
                            width: 150,
                            height: 150,
                          ),
                          width: MediaQuery.of(context).size.width / 1.2 ,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                  ],
                ),

                Flexible(
                    child: ListView(

                        children: <Widget>[


                          Text('“Gaivotas Miguelito” é uma aplicação mobile adaptada para Android no seguimento da Unidade Curricular “Projeto e Desenvolvimento Informático” do segundo semestre do terceiro ano da licenciatura de Informática de Gestão na Coimbra Business School ISCAC.'
                          ),
                          SizedBox(height: 10,),
                          Text('Com o intuito de enriquecer e diferenciar a empresa “Gaivotas Miguelito” sediada na Praia de Mira, a presente aplicação foi desenvolvida especialmente para a mesma. Com a utilização da aplicação o utilizador poderá estar à espera de todas as funcionalidades necessárias durante a viagem à distância de um clique.'
                          ),
                          SizedBox(height: 10,),
                          Text('Consideramos que com o uso da aplicação “Gaivotas Miguelito” durante a experiência vai transmitir uma sensação de segurança, e todos os clientes vão conseguir desfrutar ainda mais daquilo que é uma viagem inesquecível.'
                          ),
                          SizedBox(height: 10,),
                          Text('Concluindo, este projeto foi realizado por 3 elementos fundamentais, Miguel Lopes, Marta Simões e Pedro Rafael Santos, com a supervisão e acompanhamento contínuo dos seguintes Docentes da Coimbra Business School ISCAC: António Trigo Ribeiro e Pedro Martins.'
                          ),


                        ],
                      ),

                      ),



              ],

            ),

          ),

        ),

      ),
    );
  }
}
