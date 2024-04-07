import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medicproject/common.dart';
import 'package:medicproject/interaction.dart';
import 'package:medicproject/mamame.dart';
import 'package:medicproject/moodanalysis.dart';
import 'package:medicproject/moodtrack.dart';
import 'package:medicproject/plogin.dart';
import 'package:medicproject/profile.dart';
import 'package:medicproject/questions.dart';
import 'package:medicproject/sleep.dart';
import 'package:medicproject/sleeptrack.dart';
import 'package:medicproject/testtrack.dart';
import 'package:sizer/sizer.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  late String username = userid;
  late String tdate = "";
  late String firstname = "";
  late String mdate = "", intera, mood, sleep, mama;
  @override
  void initState() {
    super.initState();

    fetchData(username);
    fetchData1(username);
    fetchData2(username);
  }

  void fetchData(String username) async {
    var response =
        await http.post(Uri.parse(profileuri), body: {'username': username});
    print("JSON Response: ${response.body}");

    List<String> values = response.body.split(", ");
    print("1 ${values[0]}");

    setState(() {
      firstname = values[0].substring(1, values[0].length);
      print(firstname);
    });
  }

  void fetchData1(String username) async {
    var response =
        await http.post(Uri.parse(testcheckuri), body: {'username': username});
    print("JSON Response: ${response.body}");

    List<String> values = response.body.split(", ");
    print("1 ${values[0]}");

    setState(() {
      tdate = values[0].substring(1, values[0].length);
      print(tdate);
    });
  }

  void fetchData2(String username) async {
    var response =
        await http.post(Uri.parse(checkuri), body: {'username': username});
    print("JSON Response: ${response.body}");

    List<String> values = response.body.split(", ");
    print("1 ${values[0]}");

    setState(() {
      mdate = values[0].substring(2, values[0].length);
      intera = values[3] + "1";
      mama = values[1] + "1";
      mood = values[2] + "1";
      sleep = values[4] + "1";
      print(mdate + "kk" + mama + "kk" + mood + "kk" + intera + "kk" + sleep);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
            );
          },
        ),
        title: Text(
          'Hello $firstname,',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 73,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'How can I best help you today ? Let me know by doing your daily check in.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Daily Check In',
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF973F46),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActivityCard(
                      'assets/images/hpstressmanag.png',
                      'How was your \nmood today ?',
                    ),
                    _buildActivityCard(
                      'assets/images/hpsleep.png',
                      'How was your sleep last night ?',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActivityCard1(
                      'assets/images/hpmother.png',
                      'Mama & Me',
                    ),
                    _buildActivityCard1(
                      'assets/images/hpcomm.png',
                      'how it went \ntoday ?',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Handle onTap
                },
                child: Container(
                  width: double.infinity,
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 250, 170, 170),
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tdate != "") {
                            print(tdate);
                            final formatter = DateFormat('yyyy-MM-dd');
                            final parsedDate = formatter.parse(tdate);

                            // Current date
                            final currentDate = DateTime.now();

                            // Calculating the difference in days
                            final daysDifference =
                                currentDate.difference(parsedDate).inDays;
                            fetchData1(username);
                            if (daysDifference >= 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionAns(),
                                ),
                              );
                            } else {
                              print(tdate);
                              print(daysDifference);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return customDialog1(daysDifference);
                                },
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120,
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
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'Take Test',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Image.asset(
                                'assets/images/question.png',
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyTest(username: userid),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "track",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 248, 247, 247),
                                ),
                              ),
                              SizedBox(width: 64.w),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 247, 246, 246),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildActivityCard(String imagePath, String text) {
    return Container(
      width: 40.w,
      height: 22.h,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 250, 170, 170),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              if (text == 'How was your \nmood today ?') {
                if (mdate != "") {
                  print(mdate);
                  final formatter = DateFormat('yyyy-MM-dd');
                  final parsedDate = formatter.parse(mdate);

                  // Current date
                  final currentDate = DateTime.now();

                  // Calculating the difference in days
                  final daysDifference =
                      currentDate.difference(parsedDate).inDays;
                  fetchData2(username);
                  if (daysDifference >= 1 || mood == "1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodAnalysis(username: username),
                      ),
                    );
                  } else {
                    print(mdate);
                    print(daysDifference);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return customDialog();
                      },
                    );
                  }
                }
              } else {
                if (mdate != "") {
                  print(mdate);
                  final formatter = DateFormat('yyyy-MM-dd');
                  final parsedDate = formatter.parse(mdate);

                  // Current date
                  final currentDate = DateTime.now();

                  // Calculating the difference in days
                  final daysDifference =
                      currentDate.difference(parsedDate).inDays;
                  fetchData2(username);
                  if (daysDifference >= 1 || sleep == "1") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SleepingPage(
                                  username: text,
                                )));
                  } else {
                    print(mdate);
                    print(daysDifference);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return customDialog();
                      },
                    );
                  }
                }
              }
            },
            child: Container(
              width: 40.w,
              height: 17.h,
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
                  Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: GestureDetector(
              onTap: () {
                if (text == 'How was your \nmood today ?') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoodTracker(
                        username: userid,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SleepTracker(
                        username: userid,
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "track",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 250, 249, 249),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 253, 253, 253),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard1(String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        if (text == 'Mama & Me') {
          if (mdate != "") {
            print(mdate);
            final formatter = DateFormat('yyyy-MM-dd');
            final parsedDate = formatter.parse(mdate);

            // Current date
            final currentDate = DateTime.now();

            // Calculating the difference in days
            final daysDifference = currentDate.difference(parsedDate).inDays;
            fetchData2(username);
            if (daysDifference >= 1 || mama == "1") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MamaAndMeScreen()));
            } else {
              print(mdate);
              print(daysDifference);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return customDialog();
                },
              );
            }
          }
        } else {
          if (mdate != "") {
            print(mdate);
            final formatter = DateFormat('yyyy-MM-dd');
            final parsedDate = formatter.parse(mdate);

            // Current date
            final currentDate = DateTime.now();

            // Calculating the difference in days
            final daysDifference = currentDate.difference(parsedDate).inDays;
            fetchData2(username);
            if (daysDifference >= 1 || intera == "1") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InteractionScreen()));
            } else {
              print(mdate);
              print(daysDifference);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return customDialog();
                },
              );
            }
          }
        }
      },
      child: Container(
        width: 40.w,
        height: 17.h,
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
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customDialog() {
    return Dialog(
      child: Container(
        width: 320,
        height: 15
            .h, // Assuming you're using flutter_screenutil for responsive design
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 253, 252, 252),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Sorry ,',
                style: TextStyle(
                  fontFamily: 'Poppins_Semibold',
                  color: Color(0xFF201F1F),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your response is already submitted for the day, let\'s meet tomorrow.',
                  style: TextStyle(
                    fontFamily: 'Poppins_Semibold',
                    color: Color(0xFF2E2E2E),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customDialog1(int imp) {
    int imp1 = 3 - imp;
    return Dialog(
      child: Container(
        width: 320,
        height: 15
            .h, // Assuming you're using flutter_screenutil for responsive design
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 253, 252, 252),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Sorry ,',
                style: TextStyle(
                  fontFamily: 'Poppins_Semibold',
                  color: Color(0xFF201F1F),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your response is already submitted for the day, check after $imp1 days.',
                  style: TextStyle(
                    fontFamily: 'Poppins_Semibold',
                    color: Color(0xFF2E2E2E),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
