import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:medicproject/common.dart';
import 'package:medicproject/medicplayer.dart';

import 'package:sizer/sizer.dart';

class MedListPage extends StatefulWidget {
  @override
  _MedListPageState createState() => _MedListPageState();
}

class _MedListPageState extends State<MedListPage> {
  List<Map<String, dynamic>> videoList = [];

  @override
  void initState() {
    super.initState();
    fetchVideoList();
  }

  Future<void> fetchVideoList() async {
    final response = await http.post(
      Uri.parse(medlisturi),
    );

    if (response.statusCode == 200) {
      setState(() {
        videoList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print(videoList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          final video = videoList[index];
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
                      child: Text(video['video_title']),
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
              final videoId = int.parse(video['vid']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedPlayerPage(
                    videoId: videoId,
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
