import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JsonJi extends StatefulWidget {
  const JsonJi({Key? key}) : super(key: key);

  @override
  State<JsonJi> createState() => _JsonJiState();
}

var _searchController = TextEditingController();
var searchValue = "";

class _JsonJiState extends State<JsonJi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Select Country"),
          ),
          SliverToBoxAdapter(
            child: CupertinoSearchTextField(
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              controller: _searchController,
            ),
          ),
          FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/json/country.json'),
              builder: (context, snapshot) {
                var mydata = json.decode(snapshot.data.toString());
                return Center(
                  child: Text(mydata["name"]),
                );
              }),
        ]),
      ),
    );
  }
}
