import 'package:flutter/material.dart';
import '../widgets/local_audio_player.dart';
import '../widgets/online_audio_player.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  int radioValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Local Audio"),
                  Radio(
                    groupValue: radioValue,
                    value: 1,
                    onChanged: _onChangedRadioValue,
                  ),

                  SizedBox(width: 30),

                  Text("Online Audio"),
                  Radio(
                    groupValue: radioValue,
                    value: 2,
                    onChanged: _onChangedRadioValue,
                  ),
                ],
              ),


              Visibility(
                visible: radioValue == 1 ? true : false,
                replacement: OnlineAudioPlayer(),
                child: LocalAudioPlayer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangedRadioValue(int? value) {
    setState(() {
      radioValue = value!;
    });
  }
}