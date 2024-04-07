import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late String nextCheckInTime;
  late String nextTestSessionTime;
  int? adaysDifference;
  int? tdaysDifference;
  late DateTime _nextDay;
  late Duration _timeLeft;
  late Timer _timer;
  late String intera, mood, sleep, mama;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNextCheckInTime();
    fetchNextTestSessionTime();
    _calculateNextDay();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    // Cancel the timer in the dispose method
    super.dispose();
  }

  void _calculateNextDay() {
    DateTime now = DateTime.now();
    _nextDay = DateTime(now.year, now.month, now.day + 1);
    _timeLeft = _nextDay.difference(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - Duration(seconds: 1);
          } else {
            _calculateNextDay();
          }
        });
      }
    });
  }

  void _startTestSessionTimer() {
    DateTime now = DateTime.now();
    DateTime testSessionDate =
        DateTime(now.year, now.month, now.day + tdaysDifference!);
    Duration timeUntilTestSession = testSessionDate.difference(now);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timeUntilTestSession.inSeconds > 0) {
            timeUntilTestSession -= Duration(seconds: 1);
          } else {
            // Handle what happens when the test session timer expires
          }
        });
      }
    });
  }

  Future<void> fetchNextCheckInTime() async {
    try {
      var response =
          await http.post(Uri.parse(checkuri), body: {'username': userid});
      List<String> values = response.body.split(", ");
      setState(() {
        intera = values[3] + "1";
        mama = values[1] + "1";
        mood = values[2] + "1";
        sleep = values[4] + "1";
        nextCheckInTime = values[0].substring(2, values[0].length);
        print(nextCheckInTime);
        final formatter = DateFormat('yyyy-MM-dd');
        final parsedDate = formatter.parse(nextCheckInTime);
        final currentDate = DateTime.now();
        adaysDifference = currentDate.difference(parsedDate).inDays;
        print(adaysDifference! + 11);
        isLoading = false; // Data loaded, set isLoading to false
      });
    } catch (e) {
      print('Error fetching next check-in time: $e');
    }
  }

  Future<void> fetchNextTestSessionTime() async {
    try {
      var response =
          await http.post(Uri.parse(testcheckuri), body: {'username': userid});
      List<String> values = response.body.split(", ");
      setState(() {
        nextTestSessionTime = values[0].substring(1, values[0].length);
        print(nextTestSessionTime);
        final formatter = DateFormat('yyyy-MM-dd');
        final parsedDate = formatter.parse(nextTestSessionTime);
        final currentDate = DateTime.now();
        tdaysDifference = currentDate.difference(parsedDate).inDays;
        print(tdaysDifference! + 12);
        isLoading = false; // Data loaded, set isLoading to false
      });
    } catch (e) {
      print('Error fetching next test session time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget nextCheckInWidget = SizedBox();
    String formattedTime =
        '${_timeLeft.inHours}:${(_timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}';

    // Check if isLoading is true, display CircularProgressIndicator
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Check if adaysDifference is null or less than or equal to 1
    if (adaysDifference == null || adaysDifference! < 1) {
      String pending = "";
      if (mood == "1") {
        pending = pending + "mood monitoring ,";
      }
      if (sleep == "1") {
        pending = pending + "sleep monitoring ,";
      }
      if (mama == "1") {
        pending = pending + "mama & me monitoring ,";
      }
      if (intera == "1") {
        pending = pending + "interation monitoring ,";
      }
      if (pending == "") {
        pending = pending + "no task pending ,";
      }
      nextCheckInWidget = Container(
        width: 90.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Next Check-In:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time left until next check in: $formattedTime',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Still pending Check In\'s : $pending',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else if (adaysDifference! > 1) {
      nextCheckInWidget = Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Your streak has broken before $adaysDifference',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "please be regular to application",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/images/baby.png',
              height: 70,
              width: 70,
            ),
          ],
        ),
      );
    } else {
      nextCheckInWidget = Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time to Complete today Check In',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    // Widget for displaying time left until next test session
    Widget nextTestSessionWidget = SizedBox();
    if (tdaysDifference != null && tdaysDifference! < 3) {
      int a = _timeLeft.inHours + ((2 - tdaysDifference!) * 24);

      String formattedTime1 =
          '${a}:${(_timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}';
      nextTestSessionWidget = Container(
        width: 90.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Next Test Session:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time left until next test session: $formattedTime1',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else {
      nextTestSessionWidget = Container(
        width: 90.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time to take your test',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'The last time you took the test was $tdaysDifference days ago. ',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nextCheckInWidget,
            SizedBox(
              height: 10,
            ),
            nextTestSessionWidget,
          ],
        ),
      ),
    );
  }
}
