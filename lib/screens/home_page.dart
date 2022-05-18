import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_chat/chats/chats.dart';
// import 'package:real_chat/chats/chat_messages.dart';
// import 'package:real_chat/chats/chat_messages.dart';

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
        body: (CupertinoPageScaffold(
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1616190419596-e2839e7380d7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8a2FzaG1pcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
            ),
            largeTitle: const Text("Magenta"),
            trailing: (CupertinoButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: ((context) => const Chats())));            
              },
              child: Badge(
                badgeContent: const Text("1"),
                badgeColor: const Color.fromARGB(255, 255, 0, 0),
                child: (const Icon(
                  CupertinoIcons.bolt_horizontal_circle,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 35,
                )),
              ),
            ))),
      ]),
    )));
  }
}
