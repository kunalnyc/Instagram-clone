import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Authentication/auth_service.dart';
import 'package:real_chat/Themes/colors.dart';
import 'package:real_chat/widgets/country_json.dart';

class OneStepVerification extends StatefulWidget {
  const OneStepVerification({Key? key}) : super(key: key);

  @override
  State<OneStepVerification> createState() => _OneStepVerificationState();
}

class _OneStepVerificationState extends State<OneStepVerification> {
  final _enterPhoneNumber = TextEditingController();
  Map<String, dynamic> data = {"name": "United States", "code": "+1"};
  late Map<String, dynamic> dataResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          backgroundColor: mobileBackgroundColor,
          middle: Text(
            "Edit Number",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          previousPageTitle: 'Signup',
        ),
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
                    color: Colors.white,
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
                style:
                    TextStyle(color: CupertinoColors.systemPink, fontSize: 25),
              ),
            ),
            CupertinoListTile(
              onTap: () async {
                dataResults = await Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SelectCountry()));
                setState(() {
                  if (dataResults != null) data = dataResults;
                });
              },
              title: Text(
                data['name'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    data['code'],
                    style: const TextStyle(
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
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CupertinoButton(
                  color: CupertinoColors.systemPink,
                  child: const Text("Request Code"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => VerifyNumber(
                                  number:
                                      data['code']! + _enterPhoneNumber.text,
                                )));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
