import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/audioplayer.dart';

import 'dart:convert';

import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class AudioListPage extends StatefulWidget {
  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  List<Map<String, dynamic>> audioList = [];

  @override
  void initState() {
    super.initState();
    fetchAudioList();
  }

  Future<void> fetchAudioList() async {
    final response = await http.post(
      Uri.parse(audiolisturi),
    );

    if (response.statusCode == 200) {
      setState(() {
        audioList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print(audioList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio List'),
      ),
      body: ListView.builder(
        itemCount: audioList.length,
        itemBuilder: (context, index) {
          final audio = audioList[index];
          return ListTile(
            title: Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(audio['filename']),
                    ),
                    Container(
                      width: 22.5.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 248, 128, 136),
                            Color.fromARGB(255, 235, 211, 213),
                          ],
                          stops: [0, 1],
                          begin: AlignmentDirectional(1, 0),
                          end: AlignmentDirectional(-1, 0),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(190),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )),
            onTap: () async {
              final audioId = int.parse(audio['id']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerPage(
                    audioId: audioId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
