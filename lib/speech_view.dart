import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:simple_permissions/simple_permissions.dart';

class SpeechView extends StatefulWidget {
  @override
  _SpeechViewState createState() => _SpeechViewState();
}

class _SpeechViewState extends State<SpeechView> {
  SpeechRecognition _speech;

  bool _speechRecognitionAvail = false;
  bool _isListening = false;

  String _text = '';
  String _locale = '';

  @override void initState() {
      super.initState();
      activateSpeechRecognizer();
    }

  void activateSpeechRecognizer() {
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler((avail) { _speechRecognitionAvail = avail; });
    _speech.setCurrentLocaleHandler((locale) { _locale = locale; });
    _speech.setRecognitionStartedHandler(() { setState(() { _isListening = true; }); });
    _speech.setRecognitionResultHandler((res) { setState(() { _text = res; }); });
    _speech.setRecognitionCompleteHandler(() { setState(() { _isListening = false; }); });

    _speech.activate().then((res) => setState(() { _speechRecognitionAvail = res; }));
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            new Container(
              child: new Text(_text),
            ),
            _buildButton(
              label: _isListening ? 'Cancel' : 'Start',
              callback: () { _isListening ? cancel() : start(); },
              enabled: _speechRecognitionAvail,
            ) ,
            _buildButton(
              label: 'Stop',
              callback: stop,
              enabled: _isListening
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton({String label, bool enabled, callback}) {
    return new Padding(
      padding: EdgeInsets.all(16.0),
      child: RaisedButton(
        child: new Text(label),
        onPressed: enabled ? callback : null,
      )
    );
  }

  void start() async {
    if (!_speechRecognitionAvail) {
      var permstat = await SimplePermissions.requestPermission(Permission.RecordAudio);
      if (permstat == PermissionStatus.denied || permstat == PermissionStatus.deniedNeverAsk) {
        setState(() { _text = "Audio Recording not allowed"; });
      } else if (permstat == PermissionStatus.authorized) {
        setState(() { _speechRecognitionAvail = true; });
      }
    }
    _speech.listen(locale: _locale)
      .then((result) => print('$result'));
  }

  void cancel() {
    _speech.cancel()
    .then((result) => print('$result'));
  }

  void stop() {
    _speech.stop()
    .then((result) => print('$result'));
  }
}