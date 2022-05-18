// Copyright 2022 The Magenta team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Authentication/auth_service.dart';
import 'package:real_chat/screens/home.dart';
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
    return const  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Magenta',
      // theme: widgit.appTheme.lightTheme,
      // darkTheme: widgit.appTheme.darkTheme,
      home:  Welcome(),
    );
  }
}
