import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/utils/models.dart';
import 'package:real_chat/utils/provider.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  const EditProfile({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final usersRef = FirebaseFirestore.instance.collection('users');

  bool isLoading = false;
  bool _usernameValid = true;
  bool _bioValid = true;

  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  var User;
//  var  User;
  @override
  void initState() {
    super.initState();
    getUser();
    isLoading = false;
  }

//  final UserProvider userProvider = Provider.of<UserProvider>(context);
  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =
        await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    // ignore: unused_local_variable
    var user = User.fromDocument(doc);
    usernameController.text = user.username;
    bioController.text = user.bio;
    setState(() {
      isLoading = true;
    });
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text('Bio'),
        ),
        CupertinoTextField(
          placeholder: 'Enter Your Bio',
          controller: bioController,
        )
      ],
    );
  }

  Column buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text('Username'),
        ),
        CupertinoTextField(
          placeholder: 'Enter Your Username',
          controller: usernameController,
        )
      ],
    );
  }

  updateProfile() {
    setState(() {
      usernameController.text.trim().length < 3 ||
              usernameController.text.isEmpty
          ? _usernameValid = false
          : _usernameValid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_usernameValid && _bioValid) {
      usersRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "username": usernameController.text,
        "bio": bioController.text,
      });
    }
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Log out'),
        content: const Text('Are You Proceed To Logout?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            color: CupertinoColors.systemPink,
            iconSize: 30,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                  // animating: true,
                  ),
            )
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 8,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(userProvider.getUser.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            buildUsernameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      CupertinoButton(
                          color: CupertinoColors.systemPink,
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: updateProfile),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: IconButton(
                          onPressed: () => _showAlertDialog(context),
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
