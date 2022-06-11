import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Themes/colors.dart';

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              leading: IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.pen)),
              trailing: IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.app_badge)),
              largeTitle: const Text(
                'Notification Center',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: mobileBackgroundColor,
            ),
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No Notifications Yet',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
