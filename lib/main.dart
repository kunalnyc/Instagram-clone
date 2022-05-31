// Copyright 2022 The Magenta team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Auth/auth.dart';
import 'package:real_chat/Auth/regester.dart';
import 'package:real_chat/Authentication/auth_service.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/screens/home.dart';
import 'package:real_chat/utils/provider.dart';
import 'package:real_chat/widgets/country_json.dart';
// import 'package:real_chat/widgets/json.dart';
import 'package:real_chat/widgets/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Magenta',
        // theme: widgit.appTheme.lightTheme,
        // darkTheme: widgit.appTheme.darkTheme,
        // theme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: mobileBackgroundColor,
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges() ,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const  Homepage();
    
              }else if( snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
              child:  CupertinoActivityIndicator(
                  animating: true,
                  radius: 20,
                )
              );
            }
            return const Email();
          }
        ),
      ),
    );
  }
}
