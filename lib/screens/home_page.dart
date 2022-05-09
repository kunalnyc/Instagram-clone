import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // get data => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Magenta",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.00,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(color: Colors.blueAccent,iconSize: 30,
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {},
          ),
           IconButton(color: Colors.blueAccent,iconSize: 30,
            icon: const Icon(CupertinoIcons.add_circled),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
