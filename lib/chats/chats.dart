import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cupertino_chat_app/screens/chat_detail.dart';
// import 'package:cupertino_chat_app/states/lib.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/api.dart';
import 'package:real_chat/chats/lib.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  // @override
  // void initState() {
  //   super.initState();
  //   chatState.refreshChatsForCurrentUser();
  // }

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: uid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
          builder: (BuildContext context) => CustomScrollView(
                slivers: [
                  const CupertinoSliverNavigationBar(
                    backgroundColor: mobileBackgroundColor,
                    largeTitle: Text("Chats",style: TextStyle(color: CupertinoColors.white),),
                    previousPageTitle: 'Home',
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          chatState.messages.values.toList().map((data) {
                    return CupertinoListTile(
                        //  leading: CircleAvatar(
                        //         radius: 25,
                        //         backgroundImage:
                        //             NetworkImage(data['photoUrl'])),
                      title: Text(data['friendName'],style: const TextStyle(color: Colors.white),),
                      subtitle: Text(data['msg'],style: const TextStyle(color: Colors.pinkAccent),),
                      onTap: () => callChatDetailScreen(
                          context, data['friendName'], data['friendUid']),
                    );
                  }).toList()))
                ],
              )),
    );
  }
}