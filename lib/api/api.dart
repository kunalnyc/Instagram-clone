import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:real_chat/Themes/colors.dart';

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;

  ChatDetail({Key? key, this.friendUid, this.friendName}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendUid, friendName);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final friendUid;
  final friendName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocId;
  var _textController = new TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName);
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats.add({
                'users': {currentUserId: null, friendUid: null},
                'names': {
                  currentUserId: FirebaseAuth.instance.currentUser?.displayName,
                  friendUid: friendName
                }
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator(
            animating: true,
            radius: 20,
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: mobileBackgroundColor,
                middle: Text(
                  friendName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                previousPageTitle: "Back",
                trailing: CupertinoButton(
                    child: const Icon(CupertinoIcons.phone), onPressed: () {}),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            data = document.data()!;
                            print(document.toString());
                            print(data['msg']);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ChatBubble(
                                clipper: ChatBubbleClipper8(
                                  // nipSize: 0,
                                  // nipSize: 50,
                                  radius: 20,
                                  type: isSender(data['uid'].toString())
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble,
                                  // SizedBox(height: 30)
                                ),
                                alignment: getAlignment(data['uid'].toString()),
                                // alignment: WrapAlignment.start,
                                // alignment: WrapAlignment.spaceAround
                                // alignment: WrapAlignment.end,
                                margin: const EdgeInsets.only(top: 20),
                                backGroundColor:
                                    isSender(data['uid'].toString())
                                        ? Color.fromARGB(255, 255, 0, 85)
                                        : Color(0xffE7E7ED),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                    // minHeight: 10,m
                                    maxHeight: 30,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(data['msg'],
                                              style: TextStyle(
                                                  color: isSender(data['uid']
                                                          .toString())
                                                      ? Colors.white
                                                      : Colors.black),
                                              maxLines: 100,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            data['createdOn'] == null
                                                ? DateTime.now().toString()
                                                : data['createdOn']
                                                    .toDate()
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: isSender(
                                                        data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black),
                                            maxLines: 100,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            color: CupertinoColors.systemPink,
                            iconSize: 40,
                            onPressed: () {},
                            icon:
                                const Icon(CupertinoIcons.camera_circle_fill)),
                        IconButton(
                            color: CupertinoColors.systemPink,
                            iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.link)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: CupertinoTextField(
                              cursorColor: CupertinoColors.activeGreen,
                              placeholder: " Message...",
                              controller: _textController,
                            ),
                          ),
                        ),
                        CupertinoButton(
                            child: const Icon(
                              CupertinoIcons.paperplane_fill,
                              color: CupertinoColors.activeGreen,
                            ),
                            onPressed: () => sendMessage(_textController.text))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
