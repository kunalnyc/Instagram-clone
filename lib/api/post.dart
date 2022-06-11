import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/api/firestore.dart';
import 'package:real_chat/utils/provider.dart';
import 'package:real_chat/utils/utils.dart';

import '../utils/models.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    // final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              elevation: 0.00,
              backgroundColor: Colors.black,
              title: const Text(
                "Share Your Post",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: CupertinoPageScaffold(
              child: Center(
                child: IconButton(
                  onPressed: () => _selectImage(context),
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.pinkAccent,
                    size: 50,
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text("Share a New Post"),
              actions: [
                TextButton(
                    onPressed: () => postImage(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        ),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator(
                        color: Colors.pinkAccent,
                      )
                    : const Padding(padding: EdgeInsets.only(top: 1)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                ),
                SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Hey @${userProvider.getUser.username} 👻 This Post is Shared on your Magenta Feed After You Post',
                        style: const TextStyle(
                            color: CupertinoColors.white, fontSize: 35),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                // Expanded(
                //   child: SizedBox(
                //     child: Row(
                //       children: const [
                //         Padding(
                //           padding: EdgeInsets.all(8.0),
                //           child: Image(
                //             width: 200,
                //             height: 100,
                //             image: AssetImage(
                //               'assets/Splash2.png',
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100, bottom: 20),
                      child: Text(
                        'Powered By Magenta ',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.redressed(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.systemPink),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
