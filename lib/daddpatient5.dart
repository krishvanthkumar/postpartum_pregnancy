import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:medicproject/dhome.dart';

class Register5 extends StatefulWidget {
  final String username;

  Register5({required this.username});

  @override
  _Register5State createState() => _Register5State();
}

class _Register5State extends State<Register5> {
  TextEditingController epohController = TextEditingController();
  TextEditingController egaController = TextEditingController();
  TextEditingController epoadController = TextEditingController();
  TextEditingController edoadController = TextEditingController();
  TextEditingController ecomController = TextEditingController();
  TextEditingController ebwController = TextEditingController();

  String? oc;
  String? dd;
  String? bd;

  void sendLoginRequest(String username) async {
    String poh = epohController.text.trim();
    String poad = epoadController.text.trim();
    String doad = edoadController.text.trim();
    String bw = ebwController.text.trim();
    String ga = egaController.text.trim();
    String com = ecomController.text.trim();

    if (poh.isEmpty ||
        poad.isEmpty ||
        ga.isEmpty ||
        doad.isEmpty ||
        bw.isEmpty ||
        com.isEmpty) {
      showToast("Fields cannot be empty");
    } else {
      String url = addpatient5uri;
      Map<String, String> body = {
        "poh": poh,
        "poad": poad,
        "ga": ga,
        "doad": doad,
        "bw": bw,
        "com": com,
        "oc": oc!,
        "dd": dd!,
        "bd": bd!,
        "username": username,
      };

      try {
        http.Response response = await http.post(Uri.parse(url), body: body);
        if (response.statusCode == 200) {
          handleResponse(response.body, username);
        } else {
          handleError("HTTP Error: ${response.statusCode}");
        }
      } catch (e) {
        handleError("Error: $e");
      }
    }
  }

  void handleResponse(String response, String username) {
    print("Response: $response");
    if (response.toLowerCase().contains("success")) {
      showToast("Sign Up successful");
    } else {
      showToast("Sign Up failed");
    }
  }

  void handleError(String error) {
    showToast("Error: $error");
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Step 5"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: epohController,
                  decoration:
                      InputDecoration(labelText: 'Past Obstetric History'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Outcome',
                  style: TextStyle(
                    fontFamily: 'poppins_semibold',
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile(
                      title: Text('Delivery'),
                      value: 'Delivery',
                      groupValue: oc,
                      onChanged: (value) {
                        setState(() {
                          oc = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Abortion'),
                      value: 'Abortion',
                      groupValue: oc,
                      onChanged: (value) {
                        setState(() {
                          oc = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Ectopic Pregnancy'),
                      value: 'Ectopic Pregnancy',
                      groupValue: oc,
                      onChanged: (value) {
                        setState(() {
                          oc = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Molar Pregnancy'),
                      value: 'Molar Pregnancy',
                      groupValue: oc,
                      onChanged: (value) {
                        setState(() {
                          oc = value as String?;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: egaController,
                  decoration: InputDecoration(labelText: 'Gestational Age'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: epoadController,
                  decoration:
                      InputDecoration(labelText: 'Place Of Abortion/Delivery'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: edoadController,
                  decoration:
                      InputDecoration(labelText: 'Detail Of Abortion/Delivery'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Delivery Details(Modes Of Delivery)',
                  style: TextStyle(
                    fontFamily: 'poppins_semibold',
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile(
                      title: Text('Vaginal with episiotomy'),
                      value: 'Vaginal with episiotomy',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Vaginal with intact pernium'),
                      value: 'Vaginal with intact pernium',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Vaginal with perineal tear'),
                      value: 'Vaginal with perineal tear',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Vacuum assisted vaginal'),
                      value: 'Vacuum assisted vaginal',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Forceps assisted vaginal'),
                      value: 'Forceps assisted vaginal',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Elective ceserean section with ST'),
                      value: 'Elective ceserean section with ST',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Elective ceserean section without ST'),
                      value: 'Elective ceserean section without ST',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Emerge ceserean section with ST'),
                      value: 'Emerge ceserean section with ST',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Emerge'),
                      value: 'Emerge',
                      groupValue: dd,
                      onChanged: (value) {
                        setState(() {
                          dd = value as String?;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: ecomController,
                  decoration: InputDecoration(labelText: 'Complication'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Baby Details',
                  style: TextStyle(
                    fontFamily: 'poppins_semibold',
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile(
                      title: Text('AGA'),
                      value: 'AGA',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('SGA'),
                      value: 'SGA',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('LGA'),
                      value: 'LGA',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('TERM'),
                      value: 'TERM',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('PRETERM'),
                      value: 'PRETERM',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('anomalies present'),
                      value: 'anomalies present',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('NICU admission'),
                      value: 'NICU admission',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Breastfeeding Normal'),
                      value: 'Breastfeeding Normal',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Breastfeeding abnormal'),
                      value: 'Breastfeeding abnormal',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Milesstones normal'),
                      value: 'Milesstones normal',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Milesstones Abnormal'),
                      value: 'Milesstones Abnormal',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Alive'),
                      value: 'Alive',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Dead'),
                      value: 'Dead',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Healthy'),
                      value: 'Healthy',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Others'),
                      value: 'Others',
                      groupValue: bd,
                      onChanged: (value) {
                        setState(() {
                          bd = value as String?;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: ebwController,
                  decoration: InputDecoration(labelText: 'Baby Weight'),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        sendLoginRequest(widget.username);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DHomePage(),
                          ),
                        );
                      },
                      child: Text('Submit'),
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
}
