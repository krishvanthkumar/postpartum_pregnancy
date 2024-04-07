import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medicproject/audiolist.dart';
import 'package:medicproject/mediclist.dart';
import 'package:medicproject/videolist.dart';
import 'package:sizer/sizer.dart';

class StressPage extends StatefulWidget {
  @override
  _StressPage createState() => _StressPage();
}

class _StressPage extends State<StressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stress Relief'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 35.0, right: 35.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/stressrelief.png',
                width: 80.w,
                height: 30.h,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioListPage(),
                          ),
                        );
                      },
                      child: _buildFeatureBox(
                        title: 'Soothing Music',
                        icon: 'assets/images/music1.png',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoListPage(),
                          ),
                        );
                      },
                      child: _buildFeatureBox(
                        title: 'Relaxing Videos',
                        icon: 'assets/images/video.png',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedListPage(),
                          ),
                        );
                      },
                      child: _buildFeatureBox(
                        title: 'Meditation',
                        icon: 'assets/images/yoga.png',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBox({required String title, required String icon}) {
    return Container(
      width: 85.w,
      height: 12.5.h,
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
          Row(children: [
            SizedBox(width: 20.0),
            Image.asset(
              icon,
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'poppins_semibold',
                fontSize: 13.sp,
                color: Colors.black,
              ),
            ),
          ]),
          Container(
            width: 22.5.w,
            height: 20.h,
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
          ),
        ],
      ),
    );
  }
}
