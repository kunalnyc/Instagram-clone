// import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/post.dart';
// import 'package:real_chat/api/options.dart';
// import 'package:real_chat/api/post.dart';
import 'package:real_chat/chats/chats.dart';
import 'package:real_chat/screens/feed_screen.dart';
import 'package:real_chat/screens/search_screen.dart';
// import 'package:real_chat/screens/options.dart';

// import 'package:real_chat/chats/chat_messages.dart';
// import 'package:real_chat/chats/chat_messages.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // get color => null;

  // final Shader linearGradient = const LinearGradient(
  //   colors:[Color.fromARGB(255, 255, 0, 0),Colors.white,Colors.greenAccent,Colors.pinkAccent],
  // ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.00,
        backgroundColor: mobileBackgroundColor,
        // ignore: prefer_const_constructors
        title: Text("Magenta",
            style: GoogleFonts.redressed(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              // color: Colors.black,
              onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SearchScreen(),
                  )),
              icon: const Icon(CupertinoIcons.search),
            ),
          ),
          IconButton(
            // color: Colors.black,
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const AddPostScreen())),
            icon: const Icon(CupertinoIcons.add),
          ),
          IconButton(
            // color: Colors.black,
            onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: ((context) => const Chats()))),
            icon: const Icon(CupertinoIcons.bolt_horizontal_circle),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                animating: true,
                radius: 20,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) => FeedScreen(
                  snap: snapshot.data!.docs[index].data(),
                )),
          );
        },
      ),
    );
  }
}
