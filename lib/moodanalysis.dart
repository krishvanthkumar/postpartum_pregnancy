import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:medicproject/pmain.dart';
import 'package:sizer/sizer.dart';

class MoodAnalysis extends StatefulWidget {
  final String username;

  MoodAnalysis({required this.username});

  @override
  _MoodAnalysisState createState() => _MoodAnalysisState();
}

class _MoodAnalysisState extends State<MoodAnalysis> {
  late String mood = '';
  late String mDate;

  final String url = mooduri;
  late Color selectedButtonColor;
  late Color selectedTextColor;

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    mDate = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
  }

  void _sendLoginRequest() async {
    if (userid.isEmpty || mDate.isEmpty || mood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fields cannot be empty')),
      );
    } else {
      try {
        final response = await http.post(Uri.parse(url), body: {
          'username': userid,
          'mdate': mDate,
          'mood': mood,
        });
        if (response.body.toLowerCase().contains('success')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your response has been submitted')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit your response')),
          );
        }
      } catch (error) {
        print(error.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Analysis'),
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
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'How is your mood today?',
                      style: TextStyle(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 248, 128, 136),
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    buildMoodButton('Sad', 'assets/images/sad.png', '0'),
                    SizedBox(height: 1.0.h),
                    buildMoodButton('Angry', 'assets/images/angry.png', '1'),
                    SizedBox(height: 1.0.h),
                    buildMoodButton(
                        'Happy', 'assets/images/happiness.png', '2'),
                    SizedBox(height: 1.0.h),
                    buildMoodButton(
                        'Irritated', 'assets/images/irritated.png', '3'),
                    SizedBox(height: 1.0.h),
                    buildMoodButton('Tired', 'assets/images/tired.png', '4'),
                    SizedBox(height: 3.5.h),
                    ElevatedButton(
                      onPressed: () {
                        _sendLoginRequest();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMoodButton(String label, String imagePath, String moodValue) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          mood = moodValue;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: mood == moodValue
            ? Color.fromARGB(255, 248, 128, 136)
            : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: mood == moodValue
                  ? Colors.white
                  : Color.fromARGB(255, 248, 128, 136),
              fontSize: 3.0.w,
            ),
          ),
          Image.asset(
            imagePath,
            width: 8.0.w,
            height: 8.0.w,
          ),
        ],
      ),
    );
  }
}
