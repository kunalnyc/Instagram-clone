import 'dart:convert';
import 'dart:math';
// import 'dart:io';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text("Select Country"),
              previousPageTitle: "Edit Number",
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
                            title: Text(e['name']),
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
