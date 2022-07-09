// import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class chatDetails extends StatefulWidget {
  final FriendUid;
  final FriendName;
  const chatDetails({Key? key, this.FriendName, this.FriendUid, required String friendName})
      : super(key: key);

  @override
  State<chatDetails> createState() => __chatDetailsState(FriendUid, FriendName);
}

class __chatDetailsState extends State<chatDetails> {
  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');
  final FriendUid;
  final FriendName;
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
  var ChatDocID;
  var _textController = new TextEditingController();

  // var data = document.data()!;
  __chatDetailsState(this.FriendUid, this.FriendName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chats
        .where('users', isEqualTo: {FriendUid: null, currentUserID: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              ChatDocID = querySnapshot.docs.single.id;
            } else {
              chats.add({
                'users': {currentUserID: null, FriendUid: null}
              }).then((value) => {ChatDocID = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(ChatDocID).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserID,
      'friendName': FriendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserID;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserID) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .doc(ChatDocID)
            .collection('Messages')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        // .where('uid', isNotEqualTo: currentUser)
        // .snapshots(),
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
          if (snapshot.hasData) {
            // ignore: unused_local_variable
            var data;
            return Scaffold(
              body: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  previousPageTitle: "back",
                  middle: Text(FriendName),
                  trailing: CupertinoButton(
                      child: Icon(CupertinoIcons.phone), onPressed: () {}),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          data = document.data()!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                radius: 0,nipSize: 0,
                                type: isSender(data['uid'].toString())
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: isSender(data['uid'].toString())
                                   ? const Color(0xFF08C187)
                                  : const Color(0xffE7E7ED),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(data['msg'],
                                            style: TextStyle(
                                                color: isSender(
                                                        data['uid'].toString())
                                                   ? Colors.white
                                                    : Colors.black),
                                            maxLines: 100,
                                            overflow: TextOverflow.ellipsis)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : data['createdOn']
                                                  .toDate()
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  isSender(data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                         Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: CupertinoTextField(
                            controller: _textController,
                          ),
                        ),
                      ),
                      CupertinoButton(
                          child: const Icon(Icons.send_sharp),
                          onPressed: () => sendMessage(_textController.text))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
