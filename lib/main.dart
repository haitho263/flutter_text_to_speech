import 'dart:convert';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPlay = false;
  String link ="";
  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration to;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.center,
        child: RaisedButton(child: Text("Get"), onPressed: () => _getSpeak()),
      ),
      Container(
        alignment: Alignment.center,
        child: RaisedButton(child: Text("Play"), onPressed: () => _play()),
      ),
      Container(
        alignment: Alignment.center,
        child: RaisedButton(child: Text("Stop"), onPressed: () => _stop()),
      ),
    ]);
  }

  Future _getSpeak() async {
    final String url = "https://api.fpt.ai/hmi/tts/v5";
    final _headers = {
      'api-key': 'Qo7PUncXm7GwTjkVg7LwtRCIvCwQCetc',
      'speed': '',
      'voice': 'linhsan'
    };
    final payload =
        "Nhiều người Hong Kong xuống đường phản đối Bắc Kinh ban hành luật an ninh và cảnh sát đã thực hiện những vụ bắt đầu tiên liên quan luật mới.";
    final response = await http.post(url, headers: _headers, body: payload);
    final _json = json.decode(response.body);
    link = _json["async"];

    await assetsAudioPlayer.open(
      Audio.network(link),
    );
    assetsAudioPlayer.stop();

  }

  Future _play() async {
    try {
      if (!isPlay){
        assetsAudioPlayer.play();
        isPlay= true;
      }
      else
        assetsAudioPlayer.playOrPause();

    } catch (t) {
      print("Can't play");
      isPlay = false;
    }
  }

  Future _stop() async {
    try {
      assetsAudioPlayer.playOrPause();
      //to = assetsAudioPlayer.currentPosition;
    } catch (t) {
      print("ko kn dc");
      isPlay = false;
    }
  }
}
