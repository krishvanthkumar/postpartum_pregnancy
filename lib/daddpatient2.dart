import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:medicproject/daddpatient3.dart';

class Register2 extends StatefulWidget {
  final String username;

  Register2({required this.username});
  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  String lmp = '';
  String edd = '';
  String ga = '';
  String noc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Register your Details',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(labelText: 'LMP'),
                onChanged: (value) {
                  setState(() {
                    lmp = value;
                    calculateEDD();
                  });
                },
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EDD\n$edd', // Display the calculated EDD
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'GA'),
                onChanged: (value) {
                  setState(() {
                    ga = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'No Of Children'),
                onChanged: (value) {
                  setState(() {
                    noc = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  sendRequest();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Register3(username: widget.username),
                    ),
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateEDD() {
    if (lmp.isNotEmpty) {
      DateTime lmpDate = DateTime.parse(lmp);
      DateTime eddDate =
          lmpDate.add(Duration(days: 280)); // Add 280 days to LMP
      setState(() {
        edd = eddDate.toString().substring(0, 10); // Update EDD value
      });
    } else {
      setState(() {
        edd = ''; // Reset EDD value if LMP is empty
      });
    }
  }

  void sendRequest() async {
    var url = Uri.parse(addpatient2uri);
    var response = await http.post(url, body: {
      'lmp': lmp,
      'edd': edd,
      'ga': ga,
      'noc': noc,
      'username':
          widget.username, // Assuming you will retrieve this from somewhere
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    try {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration successful'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration failed'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error parsing JSON'),
      ));
    }
  }
}
