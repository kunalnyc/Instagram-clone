import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:real_chat/Themes/colors.dart';
// import 'package:real_chat/screens/fprofile_screen.dart';
import 'package:real_chat/screens/profile_screen.dart';
// import 'package:real_chat/screens/profile.dart';
// import 'package:real_chat/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;
  bool _issLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
    // _issLoading = true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: CupertinoSearchTextField(
          controller: _searchController,
          onSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
              _issLoading = true;
            });
            print(_);
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: _searchController.text,
                    // isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                      animating: true,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                      animating: true,
                    ),
                  );
                }
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ));
                // return StaggeredGridView.countBuilder(
                //   crossAxisCount: 3,
                //   itemCount: (snapshot.data! as dynamic).docs.length,
                //   itemBuilder: (context, index) => Image.network(
                //     (snapshot.data! as dynamic).docs[index]['postUrl'],
                //     fit: BoxFit.cover,
                //   ),
                //   staggeredTileBuilder: (index) => MediaQuery.of(context)
                //               .size
                //               .width >
                //           webScreenSize
                //       ? StaggeredTile.count(
                //           (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                //       : StaggeredTile.count(
                //           (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                //   mainAxisSpacing: 8.0,
                //   crossAxisSpacing: 8.0,
                // );
              },
            ),
    );
  }
}
