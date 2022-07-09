import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cupertino_chat_app/screens/chat_detail.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/api.dart';
import 'package:real_chat/chats/lib.dart';
import 'package:real_chat/screens/discover_people.dart';
import 'package:real_chat/utils/provider.dart';

// ignore: must_be_immutable
class People extends StatelessWidget {
  People({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: uid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isNotEqualTo: currentUser)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 20,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(userProvider.getUser.photoUrl),
                    ),
                    trailing: GestureDetector(
                      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: ((context) => Peopless()))),
                      
                      child: const Icon(CupertinoIcons.person_3_fill)),
                    largeTitle: const Text(
                      "Messages",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: mobileBackgroundColor,
                  ),
                  // SliverToBoxAdapter(
                  //   key: UniqueKey(),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: CupertinoSearchTextField(
                  //       onSubmitted: (value) => usersState.setSearchTerm(value),
                  //       onChanged: (value) => usersState.setSearchTerm(value),
                  //     ),
                  //   ),
                  // ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return CupertinoListTile(
                            onTap: () => callChatDetailScreen(
                              context,
                              data['username'],
                              data['uid'],
                            ),
                            leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(data['photoUrl'])),
                            title: Text(
                              data['username'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              "Available",
                              style: TextStyle(
                                  color: CupertinoColors.activeGreen,
                                  fontSize: 12),
                            ),
                            trailing: IconButton(iconSize: 25,
                              color: CupertinoColors.systemPink,
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.camera),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }
}
