import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdicionarAudiobooksAdmin extends StatefulWidget {
  const AdicionarAudiobooksAdmin({Key key}) : super(key: key);

  @override
  _AdicionarAudiobooksAdminState createState() => _AdicionarAudiobooksAdminState();
}

class _AdicionarAudiobooksAdminState extends State<AdicionarAudiobooksAdmin> {

  //Audiobook
  final formKeyAudio = GlobalKey<FormState>();
  TextEditingController audioname = TextEditingController();
  TextEditingController artistname = TextEditingController();
  TextEditingController downloadsaudio = TextEditingController();
  TextEditingController resumoaudio = TextEditingController();
  TextEditingController lengthaudio = TextEditingController();
  TextEditingController generoaudio = TextEditingController();
  PlatformFile pickedFileAudio;
  PlatformFile pickedFileImgAudio;
  UploadTask uploadTaskAudio;
  UploadTask uploadTaskImgAudio;

  Future<void> SelectAudio() async{
    final audio = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav']);
    if(audio == null) return;

    setState(() {
      pickedFileAudio = audio.files.first;
    });
  }

  Future<void> SelectImgAudio() async{
    final imgAudio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],);
    if(imgAudio == null) return;

    setState(() {
      pickedFileImgAudio = imgAudio.files.first;
    });
  }

  Future<void> UploadAudio(String audioname, String artistname) async {
    //Image
    final path = 'audiobooks/capas/${pickedFileImgAudio.name}';
    final file = File(pickedFileImgAudio.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTaskImgAudio = ref.putFile(file);
    print('Done');

    //Audio
    final pathaudio = 'audiobooks/audios/${pickedFileAudio.name}';
    final fileaudio = File(pickedFileAudio.path);
    final refaudio = FirebaseStorage.instance.ref().child(pathaudio);
    uploadTaskAudio = refaudio.putFile(fileaudio);
    print('Done');

    //Pesquisa searchIndex
    List<String> splitlistudio = audioname.split(" ");
    List<String> splitlistArtist = artistname.split(" ");

    List<String> indexList = [];

    //Percorre o titulo e faz uma lista de caracteres
    for(int i = 0; i < splitlistudio.length; i++){
      for(int j = 0; j < splitlistudio[i].length + 1; j++){
        indexList.add(splitlistudio[i].substring(0, j).toLowerCase());
      }
    }

    //Percorre o autor e faz uma lista de caracteres
    for(int i = 0; i < splitlistArtist.length; i++){
      for(int j = 0; j < splitlistArtist[i].length + 1; j++){
        indexList.add(splitlistArtist[i].substring(0, j).toLowerCase());
      }
    }

    if(formKeyAudio.currentState.validate()) {
      //Url da imagem selecionada
      final snapshot = await uploadTaskImgAudio.whenComplete(() {});
      final urlImg = await snapshot.ref.getDownloadURL();

      //Url do pdf selecionado
      final snapshotAudio = await uploadTaskAudio.whenComplete(() {});
      final urlAudio = await snapshotAudio.ref.getDownloadURL();

      //Upload tudo para a Firebase
      await FirebaseFirestore.instance.collection("Audiobooks").add(
          {
            'Titulo': audioname,
            'Capa': urlImg,
            'Autor': artistname,
            'Resumo': resumoaudio.text,
            'Tempo': lengthaudio.text,
            'Audio': urlAudio,
            'Genero': generoaudio.text,
            'Downloads': downloadsaudio.text,
            'searchIndex': indexList,
          });
      formKeyAudio.currentState.reset();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('O audiobook foi criado com sucesso')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKeyAudio,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 40)),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextFormField(
                  controller: audioname,
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
                  controller: artistname,
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
                  controller: resumoaudio,
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
                  controller: downloadsaudio,
                  decoration: InputDecoration(labelText: "Escreva a quantidade de donwloads"),
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
                  controller: generoaudio,
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
                  controller: lengthaudio,
                  decoration: InputDecoration(labelText: "Escreva a duração do audio"),
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
              if(pickedFileImgAudio != null)
                Container(
                  width: 300,
                  height: 100,
                  color: Colors.white,
                  child: Center(
                    child: Image.file(
                      File(pickedFileImgAudio.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ElevatedButton(
                  onPressed: SelectImgAudio,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                  ),
                  child: Text('Select Image')),
              //Botão Audio
              if(pickedFileAudio != null)
                Container(
                  width: 300,
                  height: 100,
                  color: Colors.white,
                  child: Center(
                    child: Text(pickedFileAudio.name),
                  ),
                ),
              ElevatedButton(
                  onPressed: SelectAudio,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                  ),
                  child: Text('Select Audio')),
              ElevatedButton(
                  onPressed: () {
                    UploadAudio(audioname.text, artistname.text);
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
