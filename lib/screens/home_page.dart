// import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/api/post.dart';
// import 'package:real_chat/api/options.dart';
// import 'package:real_chat/api/post.dart';
import 'package:real_chat/chats/chats.dart';
import 'package:real_chat/utils/provider.dart';
// import 'package:real_chat/screens/options.dart';
import 'package:real_chat/utils/utils.dart'as model;


// import 'package:real_chat/chats/chat_messages.dart';
// import 'package:real_chat/chats/chat_messages.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
          CupertinoSliverNavigationBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => const AddPostScreen())));
              },
              icon: const Icon(CupertinoIcons.add),
            ),
            largeTitle: const  Text('Magenta'),
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
            )),
          ),
        ]),
      )),
    );
  }
}
