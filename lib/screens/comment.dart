import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/firestore.dart';
import 'package:real_chat/utils/provider.dart';
import 'package:real_chat/utils/utils.dart';
import 'package:real_chat/widgets/comment+resource.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style:
              TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.w300),
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userProvider.getUser.photoUrl),
                radius: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 16),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${userProvider.getUser.username}',
                        border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  userProvider.getUser.uid,
                  userProvider.getUser.username,
                  userProvider.getUser.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
