import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:medicproject/dhome.dart';
import 'package:sizer/sizer.dart';

class DloginScreen extends StatefulWidget {
  @override
  _DloginScreenState createState() => _DloginScreenState();
}

class _DloginScreenState extends State<DloginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        String response = await _sendLoginRequest(username, password);
        _handleResponse(response);
      } catch (e) {
        _handleError(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fields cannot be empty'),
      ));
    }
  }

  Future<String> _sendLoginRequest(String username, String password) async {
    String url = dloginUri;
    Map<String, String> data = {'username': username, 'password': password};

    var response = await http.post(Uri.parse(url), body: data);

    if (response.statusCode == 200) {
      setState(() {
        userid = username;
      });
      print(userid);
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _handleResponse(String response) {
    print('JSON Response: $response');

    try {
      if (response.toLowerCase().contains('success')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successful'),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error parsing JSON'),
      ));
    }
  }

  void _handleError(dynamic error) {
    if (error is TimeoutException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request timed out. Check your internet connection.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: true,
            bottom: true,
            child: SingleChildScrollView(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  SizedBox(
                    height: 33.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 190),
                    child: SizedBox(
                        width: 80.w,
                        height: 10.h,
                        child: Image.asset("assets/images/babygirl.jpg")),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: AlignmentDirectional(0, 1),
                    child: Container(
                        width: 100,
                        height: 500,
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 248, 128, 136),
                              Color.fromARGB(255, 235, 211, 213),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Sign in to your \naccount!',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF973F46),
                                ),
                              ),
                              SizedBox(height: 30),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'User ID',
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF973F46),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF973F46),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF973F46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/previous.png',
                                  width: 30,
                                  height: 30,
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ]))));

    // return Scaffold(
    //   resizeToAvoidBottomInset: true,
    //   body: SafeArea(
    //     child: ListView(
    //       reverse: true,
    //       children: [
    //         Container(
    //           height: MediaQuery.of(context).size.height,
    //           child: Stack(
    //             children: [
    //               Positioned(
    //                 top: 204,
    //                 left: 250,
    //                 child: Image.asset(
    //                   'assets/images/babygirl.jpg',
    //                   width: 80,
    //                   height: 80,
    //                 ),
    //               ),
    //               Container(
    //                 width: double.infinity,
    //                 alignment: AlignmentDirectional(0, 1),
    //                 child: Container(
    //                   width: 100,
    //                   height: 500,
    //                   constraints: BoxConstraints(
    //                     minWidth: double.infinity,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     gradient: LinearGradient(
    //                       begin: Alignment.topCenter,
    //                       end: Alignment.bottomCenter,
    //                       colors: [
    //                         Color.fromARGB(255, 248, 128, 136),
    //                         Color.fromARGB(255, 235, 211, 213),
    //                       ],
    //                     ),
    //                     borderRadius: BorderRadius.only(
    //                       bottomLeft: Radius.circular(0),
    //                       bottomRight: Radius.circular(0),
    //                       topLeft: Radius.circular(40),
    //                       topRight: Radius.circular(40),
    //                     ),
    //                   ),
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(20),
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       crossAxisAlignment: CrossAxisAlignment.stretch,
    //                       children: [
    //                         Text(
    //                           'Sign in to your \naccount!',
    //                           textAlign: TextAlign.left,
    //                           style: TextStyle(
    //                             fontSize: 34,
    //                             fontWeight: FontWeight.bold,
    //                             color: Color(0xFF973F46),
    //                           ),
    //                         ),
    //                         SizedBox(height: 30),
    //                         TextField(
    //                           controller: _usernameController,
    //                           decoration: InputDecoration(
    //                             labelText: 'User ID',
    //                             labelStyle: TextStyle(
    //                               fontSize: 16,
    //                               color: Color(0xFF973F46),
    //                             ),
    //                             filled: true,
    //                             fillColor: Colors.white,
    //                             border: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(10),
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(height: 20),
    //                         TextField(
    //                           controller: _passwordController,
    //                           obscureText: true,
    //                           decoration: InputDecoration(
    //                             labelText: 'Password',
    //                             labelStyle: TextStyle(
    //                               fontSize: 16,
    //                               color: Color(0xFF973F46),
    //                             ),
    //                             filled: true,
    //                             fillColor: Colors.white,
    //                             border: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(10),
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(height: 30),
    //                         ElevatedButton(
    //                           onPressed: _login,
    //                           style: ElevatedButton.styleFrom(
    //                             backgroundColor: Color(0xFF973F46),
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(10),
    //                             ),
    //                             padding: EdgeInsets.symmetric(vertical: 15),
    //                           ),
    //                           child: Text(
    //                             'Sign In',
    //                             style: TextStyle(
    //                               fontSize: 18,
    //                               fontWeight: FontWeight.bold,
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(height: 20),
    //                         GestureDetector(
    //                           onTap: () {},
    //                           child: Image.asset(
    //                             'assets/images/previous.png',
    //                             width: 30,
    //                             height: 30,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
