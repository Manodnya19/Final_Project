import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.black, Colors.black12],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ).createShader(bounds),
        blendMode: BlendMode.darken,
        child: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/images/leaf.jpeg'),
            //   fit: BoxFit.cover,
            // ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 212, 223, 173),
                Color.fromARGB(255, 95, 153, 97),
              ],
            ),
          ),
        ));
  }
}
