// import 'dart:html';

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _searchController = TextEditingController();
  var searchValue = "";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chats").snapshots(),
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
               SliverToBoxAdapter(
              child: CupertinoSearchTextField(
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
                controller: _searchController,
              ),
            ),
              SliverList(
                  delegate: SliverChildListDelegate(
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic>? data =
                    document.data()! as Map<String, dynamic>?;
                return CupertinoListTile(
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(data!['url']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.checkmark_seal_fill,
                        color: Colors.blueAccent,
                        size: 18,
                      ),
                    ],
                  ),
                );
              }).toList())),
            ]));
          }
        });
  }
}
  
    // return (CustomScrollView(slivers: [
    //   const CupertinoSliverNavigationBar(
    //     largeTitle: Text("Messages"),
    //   ),
    //   SliverList(
    //       delegate: (SliverChildListDelegate(
    //     [
    //       CupertinoListTile(
    //         title: Row(
    //           children: const [
    //             CircleAvatar(
    //               radius: 25,
    //               backgroundImage: NetworkImage(
    //                   "https://images.unsplash.com/photo-1651233175313-3b04aaf1c638?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw3fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60"),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Herly Jamson",
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Icon(
    //               CupertinoIcons.checkmark_seal_fill,
    //               color: Colors.blueAccent,
    //               size: 20,
    //             )
    //           ],
    //         ),
    //       ),
    //        CupertinoListTile(
    //         title: Row(
    //           children: const [
    //             CircleAvatar(
    //               radius: 25,
    //               backgroundImage: NetworkImage(
    //                   "https://images.unsplash.com/photo-1651090866493-3712c7e177f7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60"),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Shivam",
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Icon(
    //               CupertinoIcons.checkmark_seal_fill,
    //               color: Colors.blueAccent,
    //               size: 20,
    //             )
    //           ],
    //         ),
    //       ),
    //        CupertinoListTile(
    //         title: Row(
    //           children: const [
    //             CircleAvatar(
    //               radius: 25,
    //               backgroundImage: NetworkImage(
    //                   "https://images.unsplash.com/photo-1651084296297-2c66780dc322?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0OHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60"),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Shimla",
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Icon(
    //               CupertinoIcons.checkmark_seal_fill,
    //               color: Colors.blueAccent,
    //               size: 20,
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   )))
    // ]));