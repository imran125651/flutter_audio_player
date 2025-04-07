import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../main.dart';


class OnlineAudioPlayer extends StatefulWidget {
  const OnlineAudioPlayer({super.key});

  @override
  State<OnlineAudioPlayer> createState() => _OnlineAudioPlayerState();
}

class _OnlineAudioPlayerState extends State<OnlineAudioPlayer> {
  late AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;


  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      _player = globalAudioPlayer;
      await globalAudioPlayer.stop();

      await _player.setAudioSource(
        AudioSource.uri(
         Uri.parse("https://webaudioapi.com/samples/audio-tag/chrono.mp3"),
          tag: MediaItem(
            id: '2',
            album: 'My Online Album',
            title: 'My Online Audio',
            artist: 'My Online Artist',
            //artUri: Uri.parse('https://example.com/cover.jpg'),
          ),
        ),
      );
    }
    catch (e) {
      //print("Error loading audio: $e");
    }


    _player.positionStream.listen((d) {
      if(!mounted) return;
      setState(() {
        _position = d;

        if(_position.inSeconds.toDouble() == _player.duration?.inSeconds.toDouble()){
          _player.seek(Duration.zero);
          _position = Duration.zero;
          _player.pause();
        }
      });
    });


    _player.durationStream.listen((d) {
      if(!mounted) return;
      setState(() {
        _duration = d ?? Duration.zero;
      });
    });
  }

  String formatDuration(Duration d){
      final minutes = d.inMinutes.remainder(60);
      final seconds = d.inSeconds.remainder(60);
      return '${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}';
  }

  void handlePlayPause(){
    if(_player.playing){
      _player.pause();    }
    else{
      _player.play();
    }
  }

  void handleSeek(double value){
    _player.seek(Duration(seconds: value.toInt()));
  }

  @override
  void dispose() {
    _player.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Online Audio', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatDuration(_position)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    min: 0.0,
                    max: _player.duration?.inSeconds.toDouble() ?? 1,
                    onChanged: handleSeek,
                  ),
                ),
                Text(formatDuration(_duration)),
                IconButton(
                  icon: Icon(_player.playing ? Icons.pause : Icons.play_arrow),
                  iconSize: 35,
                  onPressed: handlePlayPause,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
