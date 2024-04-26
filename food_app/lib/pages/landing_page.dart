import 'package:flutter/material.dart';
import 'package:food_app/pages/login_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 212, 223, 173),
                  Color.fromARGB(255, 95, 153, 97),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.0),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.5),
                                spreadRadius: 10,
                                blurRadius: 20,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                          'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExeHZiem9yaHEyaTd6b2M3OG52cGhkOXBtMGwxZ3d2eG9sdngxbTdvayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/xUA7bbcVDWik6cPdmg/giphy.gif',
                          height: 380,
                          width: 380,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Eat Better, Feel Better!',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        minimumSize: Size(200, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 200.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: CustomPaint(
                painter: WavePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 245, 244, 203)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - 80)
      ..quadraticBezierTo(size.width * 0.25, size.height - 60, size.width * 0.5,
          size.height - 40)
      ..quadraticBezierTo(
          size.width * 0.75, size.height - 20, size.width, size.height - 40)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
