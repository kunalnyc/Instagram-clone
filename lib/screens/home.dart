import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:real_chat/chats/lib.dart';
// import 'package:real_chat/chats/chat_messages.dart';
import 'package:real_chat/screens/chat.dart';
import 'package:real_chat/screens/home_page.dart';
import 'package:real_chat/screens/users.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState() {
    super.initState();
    chatState.refreshChatsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          onTap: (index) {
            // ignore: avoid_print
            print("Clicked Tab $index");
          },
          items: const [
            BottomNavigationBarItem(
                label: 'Home', icon: Icon(CupertinoIcons.home)),
            BottomNavigationBarItem(
                label: 'Chat', icon: Icon(CupertinoIcons.chat_bubble_2)),
            BottomNavigationBarItem(
                label: 'Svds', icon: Icon(CupertinoIcons.play_circle)),
            BottomNavigationBarItem(
                label: 'Notify', icon: Icon(CupertinoIcons.bell)),
            BottomNavigationBarItem(
                label: 'Profile', icon: Icon(CupertinoIcons.person)),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const MyHomePage();
            case 1:
              return Users();
            case 2:
              return const Text("Hello ji");
            case 3:
              return const Text("Hello ji");
            case 4:
            default:
              return const Text("Hello jjjji");
          }
        },
      );
}
