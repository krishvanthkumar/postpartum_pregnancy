import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class MyTest extends StatefulWidget {
  final String username;

  MyTest({required this.username});

  @override
  _MyTestState createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> {
  List<int> totals = [];
  List<Color> gradientColors = [
    Color.fromARGB(255, 248, 128, 136),
    Color.fromARGB(255, 235, 211, 213),
  ];
  @override
  void initState() {
    super.initState();
    fetchData(widget.username);
  }

  Future<void> fetchData(String username) async {
    String apiUrl = testtrackuri;

    try {
      var response =
          await http.post(Uri.parse(apiUrl), body: {'username': username});
      if (response.statusCode == 200) {
        handleResponse(response.body);
      } else {
        handleError(response.statusCode);
      }
    } catch (error) {
      print('Error: $error');
      handleError(0); // Handle error if request fails
    }
  }

  void handleResponse(String response) {
    try {
      print(response);
      List<dynamic> jsonArray = jsonDecode(response);
      print(jsonArray);
      List<int> tempTotals = [];
      for (int i = 0; i < jsonArray.length; i++) {
        int? parsedInt = int.tryParse(jsonArray[i]);
        int k = parsedInt != null ? parsedInt : 0;
        print(k);
        tempTotals.add(k);
      }
      setState(() {
        totals = tempTotals;
      });
    } catch (error) {
      print('JSON parsing error: $error');
    }
  }

  void handleError(int statusCode) {
    print('HTTP Error: $statusCode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Test'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 253, 253, 253),
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
              padding: const EdgeInsets.all(20.0),
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(
                      border: Border.all(color: Colors.white, width: 0.5)),
                  gridData: FlGridData(
                    drawHorizontalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 42,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: calculateXInterval(List.generate(
                              totals.length,
                              (index) => FlSpot(index.toDouble(),
                                  totals[index].toDouble())))),
                    ),
                  ),
                  minX: 0,
                  maxX: totals.length.toDouble() - 1,
                  minY: 0,
                  maxY: 30,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        totals.length,
                        (index) =>
                            FlSpot(index.toDouble(), totals[index].toDouble()),
                      ),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.3))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text('Over view of your Test Analysis'),
        ],
      )),
    );
  }

  double calculateXInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1.0; // Handle empty data cases
    double minX = spots.first.x;
    double maxX = spots.last.x;
    double range = maxX - minX;
    int numLabels = range ~/ 10; // Aim for around 10 labels
    return (range / (numLabels.toDouble() + 1)); // Add 1 to avoid zero interval
  }
}
