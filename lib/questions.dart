import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medicproject/common.dart';
import 'package:medicproject/pmain.dart';
import 'package:sizer/sizer.dart';

class QuestionAns extends StatefulWidget {
  @override
  State<QuestionAns> createState() => _QuestionAnsState();
}

class _QuestionAnsState extends State<QuestionAns> {
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Take test',
            style: TextStyle(fontSize: 13.sp),
          ),
          backgroundColor: Color.fromARGB(48, 247, 31, 31),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5.0.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(_currentQuestionIndex + 1).toString().padLeft(2, '0')}/10', // Display current question number out of total questions
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Color.fromARGB(255, 248, 103, 103),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) /
                          10, // Change 10 to the total number of questions
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 248, 103, 103)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: QuestionariesPage(
          onQuestionChanged: (index) {
            setState(() {
              _currentQuestionIndex = index;
            });
          },
          onSubmit: (points, totalPoints) {
            _sendDataToBackend(points, totalPoints);
          },
        ),
      ),
    );
  }

  void _sendDataToBackend(List<int> points, int totalPoints) async {
    // Prepare the data to be sent
    Map<String, dynamic> data = {
      'username': userid, // Replace with actual username
      'tdate': DateTime.now().toString(), // Use the current date/time
      'q1': points[0].toString(),
      'q2': points[1].toString(),
      'q3': points[2].toString(),
      'q4': points[3].toString(),
      'q5': points[4].toString(),
      'q6': points[5].toString(),
      'q7': points[6].toString(),
      'q8': points[7].toString(),
      'q9': points[8].toString(),
      'q10': points[9].toString(),
      'tot': totalPoints.toString(),
    };

    // Convert data to JSON format
    String jsonData = jsonEncode(data);

    try {
      // Make the POST request to the backend API
      final response = await http.post(
        Uri.parse(questionuri),
        body: jsonData,
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Handle success
        print('Data sent successfully');
        print(response.body);
      } else {
        // Handle errors
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error sending data: $error');
    }
  }
}

class QuestionariesPage extends StatefulWidget {
  final ValueChanged<int> onQuestionChanged;
  final Function(List<int> points, int totalPoints) onSubmit;

  const QuestionariesPage({
    Key? key,
    required this.onQuestionChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<QuestionariesPage> createState() => _QuestionariesPageState();
}

class _QuestionariesPageState extends State<QuestionariesPage> {
  final List<String> questions = [
    'Question 1 \n\nI have been able to laugh and see the funny side of things',
    'Question 2 \n\nI have looked forward with enjoyment to things',
    'Question 3 \n\nI have blamed myself unnecessarily when things went wrong :',
    'Question 4 \n\nI have been anxious or worried for no good reason',
    'Question 5 \n\nI have felt scared or panicky for no good reason',
    'Question 6 \n\nThings have been getting to me :',
    'Question 7 \n\nI have been so unhappy  that I have had difficulty  sleeping :',
    'Question 8 \n\nI have been anxious or worried for no good  reason :',
    'Question 9 \n\nI have been so unhappy that I have been crying :',
    'Question 10 \n\nThe thought of harming myself has occurred to me :',
  ];

  final List<List<String>> choices = [
    [
      'Not at all',
      'Definitely not so much now',
      'Not quite so much now',
      'As much as I always could'
    ],
    [
      'Hardly at all',
      'Definitely less than I used to',
      'Rather less than I use to',
      'As much as I ever could'
    ],
    [
      'Yes, most of the time',
      'Yes, some of the time',
      'Not very often',
      'No never'
    ],
    ['Yes, very often', 'Yes, sometimes', 'Hardly ever', 'No, not at all'],
    ['Yes, quite a lot', 'Yes, sometimes', 'No, not much', 'No, not at all'],
    [
      'Yes, most of the time i haven\'t been able to copy at all',
      'Yes, sometimes I haven\'t  been copying as well as usual',
      'No, most of the time I have copied quite well',
      'No, I have been coping as  well as ever'
    ],
    [
      'Yes, most of the time',
      'Yes, sometimes',
      'No, not very often',
      'No, not at all'
    ],
    [
      'Yes, most of the time',
      'Yes, quite often',
      'Not very often',
      'No, not at all'
    ],
    [
      'Yes, most of the time',
      'Yes, quite often',
      'Only occasionally',
      'No, never'
    ],
    ['Yes, quite often', 'Sometimes', 'Hardly ever', 'never'],
  ];

  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: questions.length,
        options: CarouselOptions(
          height: 70.h,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            widget.onQuestionChanged(index);
          },
        ),
        itemBuilder: (BuildContext context, int index, _) {
          selectedIndices.add(-1); // Initialize with -1 (no option selected)
          return GestureDetector(
            onTap: () {
              // Handle tap event here
              print('Card tapped: ${questions[index]}');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index],
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: choices[index].map((choice) {
                              int choiceIndex = choices[index].indexOf(choice);
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      Radio<int>(
                                        value: choiceIndex,
                                        groupValue: selectedIndices[index],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedIndices[index] = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          choice,
                                          style: TextStyle(fontSize: 11.sp),
                                          maxLines: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (index < questions.length - 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Slide',
                        style: TextStyle(color: Colors.black, fontSize: 10.sp),
                      ),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                if (index == questions.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      // Calculate total points
                      int totalPoints = 0;

                      // Map the selected choices to their respective points
                      List<int> points = selectedIndices.map((index) {
                        switch (index) {
                          case 0:
                            return 3;
                          case 1:
                            return 2;
                          case 2:
                            return 1;
                          default:
                            return 0;
                        }
                      }).toList();
                      for (int i = 0; i < points.length; i++) {
                        totalPoints += points[i];
                      }
                      print(totalPoints);
                      // Call the onSubmit callback to send data to backend
                      widget.onSubmit(points, totalPoints);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Test Submission Status'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Your test has been submitted.'),
                                SizedBox(height: 10),
                                Text('Total Points: $totalPoints'),
                                SizedBox(height: 10),
                                totalPoints < 5
                                    ? Text('Your score is good.')
                                    : Text(
                                        'Your score is high. Please consult a doctor.'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigate back to the main page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                },
                                child: Text('Next'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Color.fromARGB(255, 245, 82, 82)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
