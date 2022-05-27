import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
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
          "Privacidade e Segurança", style: TextStyle(color: Colors.black, fontSize: 24),),

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
                    SizedBox(height: 10,),

                    SizedBox(height: 20,),
                  ],
                ),

                Flexible(
                    child: ListView(

                        children: <Widget>[

                          Text('A sua privacidade é importante para nós. É política da empresa '
                              '“Gaivotas Miguelito” respeitar a sua privacidade em relação a qualquer '
                              'informação pessoal que possamos recolher na aplicação “Gaivotas Miguelito”.'
                          ),
                          SizedBox(height: 10,),
                          Text('Solicitamos informações pessoais apenas quando realmente precisamos delas '
                              'para lhe fornecer o melhor serviço. Fazemo-lo por meios justos e legais, com '
                              'o seu conhecimento e consentimento. Também informamos a razão de recolhermos e '
                              'como será usado.'
                          ),
                          SizedBox(height: 10,),
                          Text('Apenas retemos as informações recolhidas pelo tempo necessário para fornecer o '
                              'serviço solicitado. Quando armazenamos dados, protegemos dentro de meios comercialmente '
                              'aceitáveis para evitar perdas e roubos, bem como acesso, divulgação, cópia, uso ou modificação '
                              'não autorizados.'
                          ),
                          SizedBox(height: 10,),
                          Text('Não compartilhamos informações de identificação pessoal publicamente ou com terceiros, '
                              'exceto quando exigido por lei.'
                          ),
                          SizedBox(height: 10,),
                          Text('O nosso site pode ter links para sites externos que não são operados por nós. Esteja ciente '
                              'de que não temos controle sobre o conteúdo e práticas desses sites e não podemos aceitar '
                              'responsabilidade por suas respetivas políticas de privacidade.'
                          ),
                          SizedBox(height: 10,),
                          Text('Ainda assim, cada utilizador é livre para recusar a nossa solicitação de informações pessoais, '
                              'entendendo que talvez não possamos fornecer alguns dos serviços desejados.'
                          ),
                          SizedBox(height: 10,),
                          Text('O uso continuado da nossa aplicação será considerado como aceitação de nossas práticas em torno '
                              'de privacidade e informações pessoais. Se, ainda assim, tiver alguma dúvida sobre como lidamos com '
                              'dados do utilizador e informações pessoais, entre em contacto connosco via email '
                              'gaivotasmiguelito@gmail.com ou contacto telefónico xxxx.'
                          ),
                          SizedBox(height: 20,),
                          Text('Compromisso do Utilizador',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, ),
                          ),
                          SizedBox(height: 10,),
                          Text('O utilizador da aplicação compromete-se a fazer uso adequado dos conteúdos e da informação '
                              'que a empresa “Gaivotas Miguelito” oferece na aplicação e com caráter enunciativo, mas não limitativo:'
                          ),
                          SizedBox(height: 10,),
                          Text('    A) Não se envolver em atividades que sejam ilegais ou contrárias à boa-fé a à ordem pública;'),
                          SizedBox(height: 10,),
                          Text('    B) Não difundir propaganda ou conteúdo de natureza racista, xenofóbica, ou casas de apostas '
                              'legais (ex.: Betano), jogos de sorte e azar, qualquer tipo de pornografia ilegal, de apologia '
                              'ao terrorismo ou contra os direitos humanos;'),
                          SizedBox(height: 10,),
                          Text('    C) Não causar danos aos sistemas físicos (hardwares) e lógicos (softwares) da empresa “Gaivotas Miguelito”, '
                              'dos seus fornecedores ou terceiros, para introduzir ou disseminar vírus informáticos ou quaisquer outros '
                              'sistemas de hardware ou software que sejam capazes de causar danos anteriormente mencionados.'),
                          SizedBox(height: 10,),
                          Text('Mais informações:'),
                          SizedBox(height: 10,),
                          Text('Esperemos que esteja esclarecido e, como mencionado anteriormente, se houver algo que não tem certeza se '
                              'precisa ou não, geralmente é mais seguro deixar os cookies ativados, caso interaja com um dos recursos que '
                              'usa em nosso site.'),
                          SizedBox(height: 20,),
                          Text('Esta política é efetiva a partir de junho/2021.',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, ),
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
