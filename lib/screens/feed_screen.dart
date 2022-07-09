import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/firestore.dart';
import 'package:real_chat/screens/comment.dart';
import 'package:real_chat/utils/utils.dart';
import 'package:real_chat/widgets/like.dart';

import '../utils/provider.dart';

class FeedScreen extends StatefulWidget {
  final snap;
  const FeedScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool ifLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ifLoading = true;
    getComments();
  }
 
  void getComments() async {
    ifLoading = true;
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      ifLoading = false;
    });
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
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
    return ifLoading
        ? const Center(
            child: CupertinoActivityIndicator(
              animating: true,
            ),
          )
        : Container(
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.snap['profImage']),
                        radius: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap['username'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                              onTap: () {
                                                deletePost(
                                                  widget.snap['postId']
                                                      .toString(),
                                                );
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(CupertinoIcons.ellipsis_vertical),
                      )
                    ],
                  ),
                ),
                // New Post CONTENT
                GestureDetector(
                    onDoubleTap: () async {
                      await FireStoreMethods().likePost(widget.snap['postId'],
                          userProvider.getUser.uid, widget.snap['likes']);
                      setState(() {
                        isLikeAnimating = true;
                      });
                    },
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(
                          milliseconds: 200,
                          // minutes: 1
                        ),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          child: const Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.white,
                            size: 100,
                          ),
                          isAnimating: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                        ),
                      ),
                    ])),

                //Like Comments & more
                Row(
                  children: <Widget>[
                    LikeAnimation(
                      isAnimating: widget.snap['likes']
                          .contains(userProvider.getUser.uid),
                      smallLike: true,
                      child: IconButton(
                          icon: widget.snap['likes']
                                  .contains(userProvider.getUser.uid)
                              ? const Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.pinkAccent,
                                )
                              : const Icon(CupertinoIcons.heart),
                          onPressed: () async {
                            await FireStoreMethods().likePost(
                              widget.snap['postId'].toString(),
                              userProvider.getUser.uid,
                              widget.snap['likes'],
                            );
                          }),
                    ),
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.bubble_left_bubble_right,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => CommentScreen(
                            postId: widget.snap['postId'].toString(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          CupertinoIcons.paperplane,
                        ),
                        onPressed: () {}),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: const Icon(CupertinoIcons.bookmark),
                          onPressed: () {}),
                    ))
                  ],
                ),
                //DESCRIPTION AND NUMBER OF COMMENTS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.w800),
                          child: Text(
                            '${widget.snap['likes'].length} likes',
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: widget.snap['username'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['description']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          child: Text(
                            'View all $commentLen comments',
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              postId: widget.snap['postId'].toString(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: const TextStyle(
                            color: secondaryColor,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
