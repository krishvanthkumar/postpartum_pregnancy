import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/widgets.dart';
import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class MoodTracker extends StatefulWidget {
  final String username;

  MoodTracker({required this.username});

  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  int touchedIndex = -1;
  List<int> totals = [];
  List<double> pieval = [0, 0, 0, 0, 0];
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
    String apiUrl = moodtrackuri;

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
    List<dynamic> jsonArray = jsonDecode(response);
    print(response);
    print(jsonArray);

    List<int> tempTotals = [];
    for (int i = 0; i < jsonArray.length; i++) {
      if (jsonArray[i] != null) {
        int? parsedInt = int.tryParse(jsonArray[i]);
        int k = parsedInt != null ? parsedInt : 0;
        print(k);
        tempTotals.add(k);
      }
    }

    print(tempTotals);
    setState(() {
      totals = tempTotals;
      for (int j in totals) {
        pieval[j] += 1;
      }
      double sum =
          pieval.fold(0, (previousValue, element) => previousValue + element);
      for (int i = 0; i < pieval.length; i++) {
        pieval[i] = (pieval[i] / sum) * 100;
      }
      print(pieval);
      print(totals);
    });
  }

  void handleError(int statusCode) {
    print('HTTP Error: $statusCode');
    print('boooooo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 40.h,
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
                          interval: 1,
                          getTitlesWidget: leftTitleWidgets,
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
                    maxY: 4,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          totals.length,
                          (index) => FlSpot(
                              index.toDouble(), totals[index].toDouble()),
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
            Text('Over All Mood Analytical Over View'),
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(pieval[0], pieval[1],
                              pieval[2], pieval[3], pieval[4], touchedIndex)),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                        color: Color.fromARGB(255, 240, 188, 188),
                        text: "😞 " + pieval[0].toStringAsFixed(2),
                        isSquare: true),
                    Indicator(
                        color: Color.fromARGB(255, 243, 104, 104),
                        text: "😠 " + pieval[1].toStringAsFixed(2),
                        isSquare: true),
                    Indicator(
                        color: Color.fromARGB(255, 230, 81, 81),
                        text: "😊 " + pieval[2].toStringAsFixed(2),
                        isSquare: true),
                    Indicator(
                        color: Color.fromARGB(255, 240, 35, 35),
                        text: "😤 " + pieval[3].toStringAsFixed(2),
                        isSquare: true),
                    Indicator(
                        color: Color.fromARGB(255, 250, 63, 63),
                        text: "😫 " + pieval[4].toStringAsFixed(2),
                        isSquare: true)
                  ],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Text('Over All Mood Analysis Percentage based Over View'),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(double first, double second,
      double third, double fourth, double fifth, touchedIndex) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color.fromARGB(255, 240, 188, 188),
            value: first,
            title: '😞',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color.fromARGB(255, 243, 104, 104),
            value: second,
            title: '😠',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color.fromARGB(255, 230, 81, 81),
            value: third,
            title: '😊',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );

        case 3:
          return PieChartSectionData(
            color: Color.fromARGB(255, 240, 35, 35),
            value: fourth,
            title: '😤',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );

        case 4:
          return PieChartSectionData(
            color: Color.fromARGB(255, 250, 63, 63),
            value: fifth,
            title: '😫',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '😞';
        break;
      case 1:
        text = '😠';
        break;
      case 2:
        text = '😊';
        break;
      case 3:
        text = '😤';
        break;
      case 4:
        text = '😫';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
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

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
