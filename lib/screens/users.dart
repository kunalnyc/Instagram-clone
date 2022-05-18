// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:real_chat/api/api.dart';
import 'package:real_chat/api/chat_api.dart';
import 'package:real_chat/chats/lib.dart';
// import 'package:real_chat/chats/lib.dart';

// ignore: must_be_immutable
class Users extends StatefulWidget {
  Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

    // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   chatState.refreshChatsForCurrentUser();
  // }
  //    @override
  // void initState() {
  //   super.initState();
  //   chatState.refreshChatsForCurrentUser();
  // }

  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  // get child => null;
  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: uid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: currentUser)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something Went Wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator(
              animating: true,
              radius: 20,
            );
          }
          if (snapshot.hasData) {}
          {
            return (CustomScrollView(slivers: [
              const CupertinoSliverNavigationBar(
                leading: Icon(CupertinoIcons.person_add),
                largeTitle: Text("Messages"),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>;
                document.data()! as Map<String, dynamic>?;
                return CupertinoListTile(
                 trailing: const  Icon(CupertinoIcons.camera,color: Colors.blueAccent,),
                  onTap: () =>
                      callChatDetailScreen(context, data['name'], data['uid']),
                  title: Column(
                    children: [
                      Center(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(data['url']),
                            ),
                            Row(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              color: Colors.blueAccent,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      data['status'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                );
              }).toList())),
            ]));
          }
        });
  }
}
