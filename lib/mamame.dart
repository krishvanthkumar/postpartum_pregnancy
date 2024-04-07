import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:medicproject/pmain.dart';
import 'package:sizer/sizer.dart';

class MamaAndMeScreen extends StatefulWidget {
  @override
  _MamaAndMeScreenState createState() => _MamaAndMeScreenState();
}

class _MamaAndMeScreenState extends State<MamaAndMeScreen> {
  late String username;
  late String sdate;
  late String pick;
  late String rating;
  late String rating1;

  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    pick = '1.1';
    rating = '5';
    rating1 = '5';
    // Get current date
    DateTime currentDate = DateTime.now();
    sdate = '${currentDate.year}-${currentDate.month}-${currentDate.day}';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mama & Me'),
        backgroundColor: Color.fromARGB(48, 247, 31, 31),
      ),
      body: Container(
        color: Color.fromARGB(48, 247, 31, 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 50.0),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Record the amount of time spent with your child today',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                    SizedBox(height: 20.0),
                    Text(
                      'Rate your satisfaction with the feeding routine on a scale from 1 to 10?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                    Text(
                      'On a scale of 1-10, how enjoyable were the play activities with your child?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Slider(
                      activeColor: Color.fromARGB(255, 248, 128, 136),
                      value: double.parse(rating1),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() {
                          rating1 = value.toString();
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        submitData();
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

  void submitData() async {
    username = userid;
    // Set other values as needed

    final response = await http.post(
      Uri.parse(mamameuri),
      body: {
        'username': username,
        'mdate': sdate,
        'pick': pick,
        'rating': rating,
        'rating1': rating1,
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
      print('Failed to submit data: ${response.statusCode}');
    }
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

class SeekBar extends StatefulWidget {
  final int max;
  final Function(int) onChanged;

  const SeekBar({
    Key? key,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = (widget.max / 2).round();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value.toDouble(),
      min: 1.0,
      max: widget.max.toDouble(),
      onChanged: (newValue) {
        setState(() {
          _value = newValue.round();
        });
        widget.onChanged(_value);
      },
      divisions: widget.max,
      label: _value.toString(),
    );
  }
}
