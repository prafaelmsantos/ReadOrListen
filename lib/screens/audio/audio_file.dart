import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  final String audiobookId;
  final String audiopath;
  const AudioFile({Key key, this.advancedPlayer, this.audiobookId, this.audiopath}) : super(key: key);

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = new Duration();
  Duration _position = new Duration();

  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  bool isPaused = false;
  bool isRepeat = false;
  bool isFastF = false;
  bool isFastF1x = false;
  bool isFastR = false;
  bool isFastR1x = false;
  List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  @override
  void initState(){
    super.initState();
    this.widget.advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    });});
    this.widget.advancedPlayer.onAudioPositionChanged.listen((p) {setState(() {
      _position = p;
    });});

    this.widget.advancedPlayer.setUrl(widget.audiopath);
    this.widget.advancedPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        if(isRepeat == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeat = false;
        }
      });
    });
  }

  Widget btnStart() {
    return IconButton(
         padding: const EdgeInsets.only(bottom: 10),
        icon: isPlaying == false? Icon(_icons[0], size: 50):Icon(_icons[1], size: 50),
      tooltip: isPlaying == false? 'Play': 'Pausa',
      onPressed: () {
           //Play
          if(isPlaying == false) {
            this.widget.advancedPlayer.play(widget.audiopath);
            setState(() {
              isPlaying = true;
            });
          }
          //Pausa
          else if(isPlaying == true){
            this.widget.advancedPlayer.pause();
            setState(() {
              isPlaying = false;
            });
          }
       },
    );
  }

  Widget btnForward() {
    return IconButton(
      icon: isFastF == false? Icon(Icons.fast_forward_rounded, size: 35, color: Colors.black):Icon(Icons.fast_forward_rounded, size: 35, color: Colors.red),
      tooltip:'Acelerar',
      onPressed: () {
        if(isPlaying == true) {
          if (isFastF == false) {
            this.widget.advancedPlayer.setPlaybackRate(2.0);
            setState(() {
              isFastF = true;
            });
          }
          else if (isFastF == true && isFastF1x == false) {
            this.widget.advancedPlayer.setPlaybackRate(5.0);
            setState(() {
              isFastF1x = true;
            });
          }
          else if (isFastF == true && isFastF1x == true) {
            this.widget.advancedPlayer.setPlaybackRate(1.0);
            setState(() {
              isFastF1x = false;
              isFastF = false;
            });
          }
        }
        else if(isPlaying == false) {
          widget.advancedPlayer.pause();
        }
      },
    );
  }

  Widget btnRewind() {
    return IconButton(
      icon: isFastR == false? Icon(Icons.fast_rewind_rounded, size: 35, color: Colors.black):Icon(Icons.fast_rewind_rounded, size: 35, color: Colors.red),
      tooltip: 'Voltar ao inicio',
      onPressed: () {
          if (isFastR == false) {
            this.widget.advancedPlayer.seek(Duration(milliseconds: 0));
            setState(() {
              isFastR = true;
              isFastR = false;
            });
          }
      },
    );
  }

  Widget btnRepeat() {
    return IconButton(
      icon: isRepeat == false? Icon(Icons.repeat_rounded, size: 35, color: Colors.black):Icon(Icons.repeat_rounded, size: 35, color: Colors.red),
      tooltip: isRepeat == false? 'Não Repete' : 'Repete',
      onPressed: () {
        //repete
        if(isRepeat == false) {
          this.widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP);
          setState(() {
            isRepeat = true;
          });
        }
        //Não repete
        else if(isRepeat == true){
          this.widget.advancedPlayer.setReleaseMode(ReleaseMode.RELEASE);
          setState(() {
            isRepeat = false;
          });
        }
      },
    );
  }


  Widget btnVolume() {
    return IconButton(
      icon: const Icon(Icons.volume_up_rounded, size: 35),
      tooltip: 'Volume',
      onPressed: () {
      },
    );
  }


  Widget slider() {
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          changeToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    this.widget.advancedPlayer.seek(newDuration);
  }

  Widget loadAsset() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          btnRepeat(),
          btnRewind(),
          btnStart(),
          btnForward(),
          btnVolume(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_position.toString().split(".")[0], style: TextStyle(fontSize:16),),
                //Slider da musica
                Container(
                  child: slider(),
                  width: 265,
                ),
                //Duração
                Text(_duration.toString().split(".")[0], style: TextStyle(fontSize:16),),
              ],
            ),
          ),
          loadAsset(),
        ],
      ),
    );
  }

}

