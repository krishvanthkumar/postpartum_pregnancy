import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';

class DoctorMain extends StatefulWidget {
  @override
  _DoctorMainState createState() => _DoctorMainState();
}

class _DoctorMainState extends State<DoctorMain> {
  List<Patient> patientList = [];
  List<Patient> filteredPatientList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  void makeRequest() async {
    try {
      final response = await http.post(Uri.parse(dpatientlist));
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
          // Initially set filtered list to the full patient list
          filteredPatientList = List.from(patientList);
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

  void filterPatients(String query) {
    setState(() {
      filteredPatientList = patientList
          .where((patient) =>
              patient.name.toLowerCase().contains(query.toLowerCase()) ||
              patient.user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterPatients(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search by name or username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatientList.length,
              itemBuilder: (context, index) {
                final patient = filteredPatientList[index];
                return Container(
                  decoration: BoxDecoration(
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
                  child: ListTile(
                    leading: patient.base64Image.isNotEmpty
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: MemoryImage(
                              base64Decode(patient.base64Image),
                            ),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/human.jpg'),
                          ),
                    title: Text(patient.name),
                    subtitle: Text(patient.user),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Patient {
  final String name;
  final String user;
  final String base64Image;

  Patient(this.name, this.user, this.base64Image);
}
