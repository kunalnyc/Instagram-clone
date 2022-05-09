import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OneStepVerification extends StatefulWidget {
  const OneStepVerification({Key? key}) : super(key: key);

  @override
  State<OneStepVerification> createState() => _OneStepVerificationState();
}

class _OneStepVerificationState extends State<OneStepVerification> {
  final _enterPhoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text(
          "Edit Number",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 35)),
                Text(
                  "One | Step | Verification",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Enter Your Phone Number",
                style: TextStyle(
                    color: Color.fromARGB(141, 0, 0, 0), fontSize: 25),
              ),
            ),
            CupertinoListTile(
              onTap: () {},
              title: const Text(
                "United States",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    "+12",
                    style: TextStyle(
                        fontSize: 25, color: CupertinoColors.inactiveGray),
                  ),
                  Expanded(
                      child: CupertinoTextField(
                    placeholder: "Enter Your Number",
                    controller: _enterPhoneNumber,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: CupertinoColors.inactiveGray, fontSize: 20),
                  )),
                ],
              ),
            ),
            const Text(
              "We Will Send You an OTP Message",
              style: TextStyle(
                  color: CupertinoColors.systemPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CupertinoButton(color: CupertinoColors.systemPink, 
                  child: const Text("Request Code"), onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
