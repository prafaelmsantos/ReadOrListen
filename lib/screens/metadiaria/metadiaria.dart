import 'dart:async';
import 'package:flutter/material.dart';
import 'button_meta_widget.dart';

class MetaDiaria extends StatefulWidget {
  @override
  _MetaDiariaState createState() => _MetaDiariaState();
}

class _MetaDiariaState extends State<MetaDiaria> {
  static const countdownDuration = Duration(minutes: 00);
  Duration duration = Duration();
  Timer timer;

  bool isCountdown = true;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    if(isCountdown) {
      setState(() => duration = countdownDuration);
    }
    setState(() => duration = Duration());
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer({bool resets = true}){
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if(resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Padding(padding: EdgeInsets.all(30),
                child: Text('Leitura de Hoje', style: TextStyle(fontSize: 30))),
            buildTime(),
            const SizedBox(height: 20),
            buildButtons(),
          ],
        ),
      ),
    );
  }
  Widget buildButtons() {
    final isRunning = timer == null ? false : timer.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning || !isCompleted
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
          text: isRunning ? 'STOP' : 'RESUME',
          onClicked: () {
            if(isRunning) {
              stopTimer(resets: false);
            } else{
              startTimer(resets: false);
            }
          },
        ),
        const SizedBox(width: 10),
        ButtonWidget(
          text: 'CANCEL',
          onClicked: stopTimer,
        ),
      ],
    )
        :ButtonWidget(
      text: 'START',
      onClicked: () {
        startTimer();
      },
    );
  }


  Widget buildTime() {
    String twoDigits (int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  Widget buildTimeCard({String time, String header}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(header),
      ],
    );
}