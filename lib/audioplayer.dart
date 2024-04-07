import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class AudioPlayerPage extends StatefulWidget {
  final int audioId;

  const AudioPlayerPage({Key? key, required this.audioId}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();
  double _sliderValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _sliderValue = _position.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
          _position = Duration(seconds: 0);
          _sliderValue = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _playPause() async {
    if (isPlaying) {
      // Pause the audio and store the current position
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      if (_position < _duration) {
        // Resume playback from the stored position if it's within the duration
        await audioPlayer.resume();
      } else {
        // Play the audio from the beginning if it's already completed
        final response = await fetchAudioFile(widget.audioId);
        if (response.statusCode == 200) {
          Uint8List audioData = response.bodyBytes;
          BytesSource source = BytesSource(audioData);
          await audioPlayer.play(source);
          _startTimer();
        } else {
          print('Failed to fetch audio file');
          return;
        }
      }
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _sliderValue = _position.inMilliseconds.toDouble();
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _seekTo(double value) {
    audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inMinutes)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Container(
          width: 80.w,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/wmusic.jpeg',
                  width: 80.w, height: 40.h),
              SizedBox(
                height: 4.h,
              ),
              Slider(
                activeColor: Color.fromARGB(255, 248, 128, 136),
                thumbColor: Color.fromARGB(255, 248, 128, 136),
                min: 0.0,
                max: _duration.inMilliseconds.toDouble(),
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                onChangeEnd: _seekTo,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${_formatDuration(_position)}'),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _playPause,
                  ),
                  Text(
                    '${_formatDuration(_duration)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<http.Response> fetchAudioFile(int audioId) async {
  var url = Uri.parse(audioplayuri);
  var response = await http.post(url, body: {'id': audioId.toString()});

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to retrieve audio file');
  }
}
