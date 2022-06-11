import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cupertino_chat_app/screens/chat_detail.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/api.dart';
import 'package:real_chat/chats/lib.dart';
// import 'package:real_chat/screens/discover_people.dart';
// import 'package:real_chat/utils/provider.dart';

// ignore: must_be_immutable
class Peopless extends StatelessWidget {
  Peopless({Key? key}) : super(key: key);
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
                  const CupertinoSliverNavigationBar(
                    // leading: Text('') ,
                    // trailing: GestureDetector(
                    //   onTap: () => Navigator.push(context, CupertinoPageRoute(builder: ((context) => Peoples()))),

                    //   child: const Icon(CupertinoIcons.person_3_fill)),
                    largeTitle: Text(
                      "Discover People",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: mobileBackgroundColor,
                    previousPageTitle: 'Messaging',
                  ),
                  SliverToBoxAdapter(
                    key: UniqueKey(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        onSubmitted: (value) => usersState.setSearchTerm(value),
                        onChanged: (value) => usersState.setSearchTerm(value),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return CupertinoListTile(
                            // onTap: () => callChatDetailScreen(
                            //   context,
                            //   data['username'],
                            //   data['uid'],
                            // ),
                            leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(data['photoUrl'])),
                            title: Text(
                              data['username'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              "People you know",
                              style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 12),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: TextButton(
                                // style: CupertinoColors.systemPink,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    CupertinoColors.systemPink,
                                  ),
                                ),

                                onPressed: () {},
                                child: const Text(
                                  "Follow",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
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
