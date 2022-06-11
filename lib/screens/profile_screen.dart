import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Auth/auth.dart';
import 'package:real_chat/Logic/auth_logic.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/screens/edit_profile.dart';
import 'package:real_chat/utils/provider.dart';
import 'package:real_chat/utils/utils.dart';
import 'package:real_chat/widgets/button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final followersRef = FirebaseFirestore.instance.collection('Followers');
  final followingRef = FirebaseFirestore.instance.collection('Following');
  final usersRef = FirebaseFirestore.instance.collection('users');
  final Feedref = FirebaseFirestore.instance.collection('posts');
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  // bool isUnfollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
    getFollowers();
    getFollowing();
    checkifFollowing();
    //  checkifunFollowing();
  }

  checkifFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.uid)
        .collection('userFollowers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      isFollowing = doc.exists;
      // isUnfollowing = true;
    });
  }
  // checkifunFollowing() async {
  //   DocumentSnapshot snap = await followersRef
  //       .doc(widget.uid)
  //       .collection('userFollowing')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     isUnfollowing = false;
  //     // followers --;
  //     // following --;
  //   });
  // }

  getFollowers() async {
    QuerySnapshot snapshot =
        await followersRef.doc(widget.uid).collection('userFollowers').get();
    setState(() {
      followers = snapshot.docs.length;
      // isFollowing = false;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot =
        await followingRef.doc(widget.uid).collection('userFollowing').get();
    setState(() {
      following = snapshot.docs.length;
      // isFollowing = true;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          )
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      // isFollowing = userSnap
      //     .data()!['followers']
      //     .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  handelUnfollowUser() {
    setState(() {
      isFollowing = false;
      // isUnfollowing = true;
      // followers--;
    });
    followersRef
        .doc(widget.uid)
        .collection('userFollowers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    //Following Collection of Current Profile
    //update following Collection on Current profile
    followingRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userFollowing')
        .doc(widget.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //push Feed Notify To the Followers
    Feedref.doc(widget.uid)
        .collection('posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handelfollowUser() {
    setState(() {
      isFollowing = true;
      // isUnfollowing = false;
      // followers++;
    });
    followersRef
        .doc(widget.uid)
        .collection('userFollowers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
    //Following Collection of Current Profile
    //update following Collection on Current profile
    followingRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userFollowing')
        .doc(widget.uid)
        .set({});
    //push Feed Notify To the Followers
    Feedref.doc(widget.uid)
        .collection('posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
  }

//    EDITING PROFILE FOR THERE CURRENT USERS  TO EDIT THERE PREFERENCES
  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => EditProfile(
                currentUserId: FirebaseAuth.instance.currentUser!.uid))));
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return isLoading
        ? const Center(
            child: CupertinoActivityIndicator(
              animating: true,
              radius: 17,
            ),
          )
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  // previousPageTitle: 'Back',
                  trailing: IconButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            title: const Text('My Profile'),
                            message: const Text('Made With Cupertino'),
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                /// This parameter indicates the action would be a default
                                /// defualt behavior, turns the action's text to bold text.
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Edit Profile'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Share Post'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Share Svds'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Settings'),
                              ),
                              CupertinoActionSheetAction(
                                /// This parameter indicates the action would perform
                                /// a destructive action such as delete or exit and turns
                                /// the action's text color to red.
                                isDestructiveAction: true,
                                onPressed: () async {
                                  await AuthLogics().signOut();
                                  Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(
                                      builder: (context) => const Email(),
                                    ),
                                  );
                                },
                                // Navigator.pop(context);

                                child: const Text('Log Out'),
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                          CupertinoIcons.line_horizontal_3_decrease)),
                  leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.person_2)),
                  backgroundColor: mobileBackgroundColor,
                  border: const Border(
                    bottom: BorderSide(
                        width: 1,
                        color: CupertinoColors.systemPink,
                        style: BorderStyle.solid),
                  ),
                ),
                SliverFillRemaining(
                  child: ListView(
                    children: [
                      // MainAxisAlignment.center
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(
                                    userData['photoUrl'],
                                  ),
                                  radius: 50,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userData['username'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userProvider.getUser.bio,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: MagentaCustomColumn(
                                              postLen, "post"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: MagentaCustomColumn(
                                              followers, "Followers"),
                                        ),
                                        MagentaCustomColumn(
                                            following, "Following"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: Colors.grey,
                                        text: 'Edit Profile',
                                        textColor: primaryColor,
                                        function: editProfile,
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            backgroundColor:
                                                CupertinoColors.black,
                                            borderColor: CupertinoColors.white,
                                            text: 'Unfollow',
                                            textColor: CupertinoColors.white,
                                            function: handelUnfollowUser,
                                          )
                                        : FollowButton(
                                            backgroundColor:
                                                CupertinoColors.systemPink,
                                            borderColor:
                                                CupertinoColors.systemPink,
                                            text: 'Follow',
                                            textColor: Colors.white,
                                            function: handelfollowUser,
                                          )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) => Image.network(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['postUrl'],
                                    fit: BoxFit.cover,
                                  ));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  // ignore: non_constant_identifier_names
  Column MagentaCustomColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
