import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medicproject/common.dart';
import 'package:medicproject/pmain.dart';
import 'package:sizer/sizer.dart';

class SleepingPage extends StatefulWidget {
  final String username;

  SleepingPage({required this.username});

  @override
  _SleepingPageState createState() => _SleepingPageState();
}

class _SleepingPageState extends State<SleepingPage> {
  late String pick;
  late String rating;
  late String sdate;

  @override
  void initState() {
    super.initState();
    pick = '1.1';
    rating = '5';

    // Get current date
    DateTime currentDate = DateTime.now();
    sdate = '${currentDate.year}-${currentDate.month}-${currentDate.day}';
  }

  Future<void> sendLoginRequest(String username) async {
    String url = sleepuri;
    try {
      final response = await http.post(Uri.parse(url), body: {
        'username': username,
        'mdate': sdate,
        'pick': pick,
        'rate': rating,
      });
      print(username + " " + sdate);
      if (response.statusCode == 200) {
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
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleeping'),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 50.0, top: 50.0),
                child: Column(
                  children: [
                    Text(
                      'How many hours of sleep did you get last night ?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NumberPicker(
                          value: 1,
                          minValue: 1,
                          maxValue: 15,
                          onChanged: (value) {
                            setState(() {
                              pick = '$value.${int.parse(pick.split('.')[1])}';
                            });
                          },
                        ),
                        Text(':'),
                        NumberPicker(
                          value: 1,
                          minValue: 1,
                          maxValue: 59,
                          onChanged: (value) {
                            setState(() {
                              pick = '${int.parse(pick.split('.')[0])}.$value';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'How would you rate its quality on a scale of 10 ?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    SizedBox(height: 3.h),
                    Slider(
                      activeColor: Color.fromARGB(255, 248, 128, 136),
                      value: double.parse(rating),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() {
                          rating = value.toString();
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          sendLoginRequest(userid);
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
}

class NumberPicker extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int>? onChanged;

  const NumberPicker({
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.onChanged,
  });

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
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
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: DropdownButton<int>(
        value: _selectedValue,
        items: List.generate(widget.maxValue - widget.minValue + 1, (index) {
          return DropdownMenuItem<int>(
            value: widget.minValue + index,
            child: Text((widget.minValue + index).toString()),
          );
        }),
        onChanged: (newValue) {
          setState(() {
            _selectedValue = newValue!;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(_selectedValue);
          }
        },
      ),
    );
  }
}
