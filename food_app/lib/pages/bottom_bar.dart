import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;

  const BottomBar({
    Key? key,
    required this.onHomePressed,
    required this.onSearchPressed,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color.fromARGB(255, 28, 28, 28),
        //     const Color.fromARGB(255, 28, 28, 28),
        //   ],
        // ),
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0), // Top-left corner radius
          topRight: Radius.circular(0), // Top-right corner radius
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onHomePressed,
            ),
            // Text('Home'),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onSearchPressed,
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onProfilePressed,
            ),
          ],
        ),
      ),
    );
  }
}
