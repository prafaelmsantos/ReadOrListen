import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({Key key}) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Expension Panel'),
          actions: [IconButton(icon: Icon(Icons.notification_important), onPressed: () {})],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Text('Nome do Livro', style: TextStyle(fontSize: 30)),
              Text('Autor do Livro', style: TextStyle(fontSize: 15, color: Colors.grey)),
              Image.asset(
                  'assets/images/exemplo.jpg',
                  height: 200,
                  width: 100),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    IconButton(
                      icon: const Icon(Icons.favorite_outline),
                      tooltip: 'Favoritos',
                      onPressed: () { },),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Ler mais tarde',
                      onPressed: () { },)
                  ]
              ),
              ListView(
                  shrinkWrap: true,
                  children: <Widget> [
                    ExpansionTile(title: Text('Resumo'),
                      backgroundColor: Colors.blueGrey.shade50,
                      iconColor: Colors.grey,
                      textColor: Colors.black,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8)),
                        Text('0', style: TextStyle(/*fontSize: 12,*/ color: Colors.grey)),
                      ],
                    ),
                    ExpansionTile(title: Text('Características'),
                      backgroundColor: Colors.blueGrey.shade50,
                      iconColor: Colors.grey,
                      textColor: Colors.black,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8)),
                        Text('1', style: TextStyle(/*fontSize: 12,*/ color: Colors.grey)),

                      ],
                    ),
                    ExpansionTile(title: Text('Disponibilidade nas bibliotecas parceiras'),
                      backgroundColor: Colors.blueGrey.shade50,
                      iconColor: Colors.grey,
                      textColor: Colors.black,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20)),
                        Text('Most swatches have colors from 100 to 900 in increments of one hundred, plus the color 50. The smaller the number, the more pale the color. The greater the number, the darker the color. The accent swatches', style: TextStyle(/*fontSize: 12,*/ color: Colors.grey)),
                      ],
                    )
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
