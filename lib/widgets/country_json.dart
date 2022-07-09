import 'dart:convert';
import 'dart:math';
// import 'dart:io';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_chat/Themes/colors.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  List<dynamic>? dataRetrieved; // data decoded from the json file
  List<dynamic>? data; // data to display on the screen
  var _searchController = TextEditingController();
  var searchValue = "";
  @override
  // ignore: must_call_super
  void initState() {
    _getData();
    // getJson();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString('assets/json/country.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;

      // dataRetrieved = data;
    });
  }
//   Future<String> getJson() {
//   return rootBundle.loadString('CountryCodes.json');
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.black,
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text(
                "Select Country",
                style: TextStyle(color: Colors.white),
              ),
              previousPageTitle: "Edit Number",
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                   backgroundColor: Colors.white,
                  itemColor: CupertinoColors.systemPink,
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                    });
                  },
                  controller: _searchController,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate((data != null)
                  ? data!
                      .where((e) => e['name']
                          .toString()
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()))
                      .map((e) => CupertinoListTile(
                            onTap: () {
                              print(e['name']);
                              Navigator.pop(context,
                                  {"name": e['name'], "code": e['dial_code']});
                            },
                            title: Text(
                              e['name'],
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                            trailing: Text(e['dial_code']),
                          ))
                      .toList()
                  : [
                      const Center(
                        child: CupertinoActivityIndicator(
                          animating: true,
                          radius: 20,
                        ),
                      ),
                    ]),
            )
          ],
        ),
      ),
    );
  }
}
