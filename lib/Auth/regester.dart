import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_chat/Logic/auth_logic.dart';
import 'package:real_chat/screens/home.dart';
import 'package:real_chat/utils/utils.dart';
import 'package:real_chat/widgets/text_field.dart';
import 'package:real_chat/widgets/verification.dart';

class EmailS extends StatefulWidget {
  const EmailS({Key? key}) : super(key: key);

  @override
  State<EmailS> createState() => _EmailState();
}

class _EmailState extends State<EmailS> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthLogics().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res == 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const Homepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: CupertinoPageScaffold(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(100),
                //   child: Image.asset(
                //     'assets/logo.png',
                //     height: 50,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Stack(children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage('assets/avtar.png')),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo_rounded)))
                ]),
                const SizedBox(
                  height: 30,
                ),
                TextFieldInput(
                  hintText: 'Enter Your Username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hintText: 'Enter Your Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  // isPass: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hintText: 'Enter Your Password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              radius: 20,
                            ),
                          )
                        : const Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: CupertinoColors.systemPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    // color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Container(),
                  flex: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'Want To Signing With Phone Number?',
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) =>
                                  const OneStepVerification())),
                      child: Container(
                        child: const Text(
                          ' Phone.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
