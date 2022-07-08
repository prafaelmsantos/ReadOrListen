import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdicionarBooksAdmin extends StatefulWidget {
  const AdicionarBooksAdmin({Key key}) : super(key: key);

  @override
  _AdicionarBooksAdminState createState() => _AdicionarBooksAdminState();
}

class _AdicionarBooksAdminState extends State<AdicionarBooksAdmin> {

  //Book
  final formKeyBook = GlobalKey<FormState>();
  TextEditingController booktitle = TextEditingController();
  TextEditingController authorname = TextEditingController();
  TextEditingController resumobook = TextEditingController();
  TextEditingController npagbook = TextEditingController();
  TextEditingController generobook = TextEditingController();
  TextEditingController editbook = TextEditingController();
  TextEditingController databook = TextEditingController();
  TextEditingController downloadsbook = TextEditingController();
  PlatformFile pickedFileImgBook;
  PlatformFile pickedFilePdf;
  UploadTask uploadTaskImgBook;
  UploadTask uploadTaskPdf;

  Future<void> UploadBook(String booktitle, String authorname) async {
    //Image
    final path = 'books/capas/${pickedFileImgBook.name}';
    final file = File(pickedFileImgBook.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTaskImgBook = ref.putFile(file);
    print('Done');

    //Pdf
    final pathpdf = 'books/pdfs/${pickedFilePdf.name}';
    final filepdf = File(pickedFilePdf.path);
    final refpdf = FirebaseStorage.instance.ref().child(pathpdf);
    uploadTaskPdf = refpdf.putFile(filepdf);
    print('Done');

    //Pesquisa searchIndex
    List<String> splitlistTitle = booktitle.split(" ");
    List<String> splitlistAuthor = authorname.split(" ");

    List<String> indexList = [];

    //Percorre o titulo e faz uma lista de caracteres
    for(int i = 0; i < splitlistTitle.length; i++){
      for(int j = 0; j < splitlistTitle[i].length + 1; j++){
        indexList.add(splitlistTitle[i].substring(0, j).toLowerCase());
      }
    }

    //Percorre o autor e faz uma lista de caracteres
    for(int i = 0; i < splitlistAuthor.length; i++){
      for(int j = 0; j < splitlistAuthor[i].length + 1; j++){
        indexList.add(splitlistAuthor[i].substring(0, j).toLowerCase());
      }
    }

    if(formKeyBook.currentState.validate()) {
      //Url da imagem selecionada
      final snapshot = await uploadTaskImgBook.whenComplete(() {});
      final urlImg = await snapshot.ref.getDownloadURL();

      //Url do pdf selecionado
      final snapshotpdf = await uploadTaskPdf.whenComplete(() {});
      final urlPdf = await snapshotpdf.ref.getDownloadURL();

      //Upload tudo para a Firebase
      await FirebaseFirestore.instance.collection("Livros").add(
          {
            'Titulo': booktitle,
            'Capa': urlImg,
            'Autor': authorname,
            'Resumo': resumobook.text,
            'datalancamento': databook.text,
            'numpaginas': npagbook.text,
            'Pdf': urlPdf,
            'Genero': generobook.text,
            'Downloads': downloadsbook.text,
            'Editor': editbook.text,
            'searchIndex': indexList,
          });
      formKeyBook.currentState.reset();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('O livro foi criado com sucesso')));
    }
  }

  Future<void> SelectImgBook() async{
    final imgBook = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],);
    if(imgBook == null) return;

    setState(() {
      pickedFileImgBook = imgBook.files.first;
    });
  }

  Future<void> SelectPdf() async{
    final pdfBook = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],);
    if(pdfBook == null) return;

    setState(() {
      pickedFilePdf = pdfBook.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: //Livros
      Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKeyBook,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 40)),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: booktitle,
                  decoration: InputDecoration(labelText: "Escreva o Titulo"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: authorname,
                  decoration: InputDecoration(labelText: "Escreva o Autor"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: resumobook,
                  decoration: InputDecoration(labelText: "Escreva o Resumo"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: databook,
                  decoration: InputDecoration(labelText: "Escreva o data de lançamento"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: generobook,
                  decoration: InputDecoration(labelText: "Escreva o Género"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: downloadsbook,
                  decoration: InputDecoration(labelText: "Escreva a quantidade de downloads"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: editbook,
                  decoration: InputDecoration(labelText: "Escreva o Editor"),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Campo vazio";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              //Botão Imagem
              if(pickedFileImgBook != null)
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                  child: Center(
                    child: Image.file(
                      File(pickedFileImgBook.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ElevatedButton(
                  onPressed: SelectImgBook,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                  ),
                  child: Text('Select Image')),

              //Botão Pdf
              if(pickedFilePdf != null)
                Container(
                  width: 300,
                  height: 100,
                  color: Colors.white,
                  child: Center(
                    child: Text(pickedFilePdf.name),
                  ),
                ),
              ElevatedButton(
                  onPressed: SelectPdf,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                  ),
                  child: Text('Select pdf')),
              ElevatedButton(
                  onPressed: () {
                    UploadBook(booktitle.text, authorname.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                  ),
                  child: Text('Adicionar à base de dados')),
            ],
          ),
        ),
      ),
    );
  }
}
