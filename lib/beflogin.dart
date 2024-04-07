import 'package:flutter/material.dart';
import 'package:medicproject/dlogin.dart';
import 'package:medicproject/guardianlogin.dart';
import 'plogin.dart';

class BefLogin extends StatefulWidget {
  @override
  _BefLoginState createState() => _BefLoginState();
}

class _BefLoginState extends State<BefLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pregwom.jpg', // Assuming 'pregwom.png' is in the assets folder
              width: 341,
              height: 368,
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Doctor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DloginScreen()),
                );
              },
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Guardian',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GLoginScreen()),
                );
              },
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Patient',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 234,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFFF973F46),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              width: 2,
              color: Color(0xFFFF973F46),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'patua_one',
            fontSize: 28,
            color: Color(0xFFFF973F46),
          ),
        ),
      ),
    );
  }
}
