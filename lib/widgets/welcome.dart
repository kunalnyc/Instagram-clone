// import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Auth/auth.dart';
import 'package:real_chat/widgets/verification.dart';
// import 'package:real_chat/widgets/welcome_text.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1570872626485-d8ffea69f463?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Y2x1YnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.black.withOpacity(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // WelcomeText(),
                Column(
                  children: [
                    //  Text("Hello"),
                    const CircleAvatar(
                      radius: 80,
              
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1556035511-3168381ea4d4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2x1YnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
                    ),
                    const Text(
                      "Magenta",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "It's Start With Clubs",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15),
                      ),
                    ),
                    const Text(
                      "Create Clubs Join With Friends",
                      style:
                          TextStyle(color: CupertinoColors.white, fontSize: 15),
                    ),
                    const Text(
                      "Join Globally",
                      style:
                          TextStyle(color: CupertinoColors.white, fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: CupertinoButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Terms & Conditions",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        // const OneStepVerification();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => const Email())));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: const Icon(CupertinoIcons.right_chevron),
                            onPressed: () {
                              //  const OneStepVerification();
                            },
                          ),
                          const Text(
                            "Let\'s Talk",
                            style: TextStyle(
                                color: CupertinoColors.white, fontSize: 20),
                          )
                        ],
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
