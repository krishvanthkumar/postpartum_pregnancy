import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class MedPlayerPage extends StatefulWidget {
  final int videoId;

  MedPlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  _MedPlayerPageState createState() => _MedPlayerPageState();
}

class _MedPlayerPageState extends State<MedPlayerPage> {
  late VideoPlayerController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _fetchVideo() async {
    try {
      final response = await http.post(
        Uri.parse(medplayuri), // Replace with your PHP endpoint
        body: {'id': widget.videoId.toString()},
      );

      if (response.statusCode == 200) {
        final videoBytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final tempVideoFile =
            File('${tempDir.path}/video_${widget.videoId}.mp4');
        await tempVideoFile.writeAsBytes(videoBytes);

        _controller = VideoPlayerController.file(tempVideoFile);
        _controller?.addListener(() {
          setState(() {});
        });
        _controller?.setLooping(true);
        _controller?.initialize().then((_) => setState(() {}));
        _controller?.play();

        setState(() {
          _isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load video: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching video: $e');
    }
  }

  void _navigateToFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: _controller!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller!),
                    _ControlsOverlay(
                        controller: _controller!,
                        onFullScreenPressed: _navigateToFullScreen),
                    VideoProgressIndicator(_controller!, allowScrubbing: true),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay(
      {required this.controller, required this.onFullScreenPressed});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;
  final VoidCallback onFullScreenPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.fullscreen),
            onPressed: onFullScreenPressed,
          ),
        ),
      ],
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_fullScreenListener);
    super.dispose();
  }

  void _fullScreenListener() {
    if (!widget.controller.value.isPlaying) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: VideoPlayer(widget.controller),
        ),
      ),
    );
  }
}
