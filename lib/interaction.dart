import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:medicproject/pmain.dart';
import 'package:sizer/sizer.dart';

class InteractionScreen extends StatefulWidget {
  @override
  _InteractionScreenState createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  late String username;
  late String mdate;
  String feel = "";
  String cmt = "";

  @override
  void initState() {
    super.initState();
    // Initialize any variables or controllers here
    username = userid; // Initialize username
    DateTime currentDate = DateTime.now();
    mdate =
        '${currentDate.year}-${currentDate.month}-${currentDate.day}'; // Initialize mdate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interaction'),
        backgroundColor: Color.fromARGB(48, 247, 31, 31),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(48, 247, 31, 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
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
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How was your interactions with others today?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'How satisfied are you with your social interactions today ?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: feel == 'good'
                                ? Color.fromARGB(255, 248, 128, 136)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/happiness.png',
                              width: 8.0.w,
                              height: 8.0.w,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              feel = 'good';
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: feel == 'bad'
                                ? Color.fromARGB(255, 248, 128, 136)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/sad.png',
                              width: 8.0.w,
                              height: 8.0.w,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              feel = 'bad';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Did you spend quality time on activities you enjoy or find fulfilling?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cmt == 'yes'
                                ? Color.fromARGB(255, 248, 128, 136)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onPressed: () {
                            setState(() {
                              cmt = 'yes';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: cmt == 'yes'
                                    ? Colors.white
                                    : Color.fromARGB(255, 248, 128, 136),
                                fontSize: 3.0.w,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cmt == 'no'
                                ? Color.fromARGB(255, 248, 128, 136)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onPressed: () {
                            setState(() {
                              cmt = 'no';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: cmt == 'no'
                                    ? Colors.white
                                    : Color.fromARGB(255, 248, 128, 136),
                                fontSize: 3.0.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          submitData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 248, 128, 136),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0.h, horizontal: 1.0.w),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitData() async {
    // Perform data submission
    final response = await http.post(
      Uri.parse(interactionuri),
      body: {
        'username': username,
        'mdate': mdate,
        'feel': feel,
        'cmt': cmt,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your response has been submitted")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit your response")),
        );
      }
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit data: ${response.statusCode}')));
    }
  }
}
