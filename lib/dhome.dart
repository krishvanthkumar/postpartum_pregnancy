import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medicproject/common.dart';
import 'package:medicproject/daddpatient.dart';
import 'package:medicproject/daudioupload.dart';
import 'package:medicproject/dmedupload.dart';
import 'package:medicproject/docpatientlist.dart';
import 'package:medicproject/dvideoupload.dart';
import 'package:medicproject/dviewpatient.dart';
import 'package:sizer/sizer.dart';

class Patient {
  final String name;
  final String user;
  final String base64Image;

  Patient(this.name, this.user, this.base64Image);
}

class DHomePage extends StatefulWidget {
  @override
  State<DHomePage> createState() => _DHomePageState();
}

class _DHomePageState extends State<DHomePage> {
  List<Patient> patientList = [];

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  void makeRequest() async {
    try {
      print("hi");
      final response = await http.post(Uri.parse(dpatientlist));
      print("hi");
      if (response.statusCode == 200) {
        parseResponse(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data'),
        ),
      );
    }
  }

  void parseResponse(String response) {
    try {
      List<dynamic> jsonArray = json.decode(response);

      if (jsonArray.length > 0) {
        setState(() {
          patientList.clear();
          for (int i = 0; i < jsonArray.length; i++) {
            Map<String, dynamic> patientObject = jsonArray[i];
            String user = patientObject["username"];
            String name = patientObject["firstname"];
            String base64Image = patientObject["dp"];
            patientList.add(Patient(name, user, base64Image));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Empty response'),
          ),
        );
      }
    } catch (e) {
      print('Error parsing JSON: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error parsing JSON'),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {},
        ),
        title: Text(
          'Hello Doctor,',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                  'Welcome Doctor, I hope you had a nice day today ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActivityCard(
                      'assets/images/addpatient.png',
                      'Add Patient',
                    ),
                    _buildActivityCard(
                      'assets/images/vupload.png',
                      'Upload Videos',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActivityCard(
                      'assets/images/uploading.png',
                      'Upload Musics',
                    ),
                    _buildActivityCard(
                      'assets/images/meditation.png',
                      'Upload Meditation Videos',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'List of Patients',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF973F46),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                width: 90.w, // Set a fixed height for the CarouselSlider
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.5,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      // Do something
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  items: patientList.map((patient) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PatientDetail(username: patient.user)),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(patient.name),
                                    subtitle: Text(patient.user),
                                  ),
                                  // ignore: unnecessary_null_comparison
                                  patient.base64Image != ""
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage: MemoryImage(
                                              base64Decode(
                                                  patient.base64Image)),
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                              'assets/images/human.jpg'),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DoctorMain()),
                        );
                      },
                      child: Text('see more...')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        if (text == "Add Patient") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Register1()),
          );
        }
        if (text == "Upload Musics") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AudioUploadPage()),
          );
        }
        if (text == "Upload Videos") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoUploadPage()),
          );
        }
        if (text == "Upload Meditation Videos") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedUploadPage()),
          );
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
}
