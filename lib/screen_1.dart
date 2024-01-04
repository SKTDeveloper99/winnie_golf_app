import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  int love = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Golfer_swing.jpg/1200px-Golfer_swing.jpg"),
            const Text(
              "Welcome to The Golf App by Winnie. Enjoy Golf with me and the AI coach",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            Text(
                "$love times",
              style: const TextStyle(color: Colors.red, fontSize: 40),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  love += 1;
                });
              },
              child: const Text("Winnie Likes You this much!"),
            )
          ] // Container
              ),
        ),
      ), // Scaffold
    ); // MaterialApp
  }
}
