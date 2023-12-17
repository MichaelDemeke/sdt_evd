import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sdt_evd/changePassword.dart';
import 'package:sdt_evd/login.dart';
import 'package:sdt_evd/models/Fullaccess.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/fulluser.dart';
import 'constants.dart';
import 'Rememberme.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  fullaccess userprofile = getfullacc;

  late fulluser listfulluser;
  late Future<fulluser?> fetchData;
  String selectedText = "Change password";
  @override
  void initState() {
    fetchData = _sendrequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
                fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.info, size: 27, color: Colors.blue),
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => VoucherSaleSummary(),
        //     ));
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 27,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => settings(),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder<fulluser?>(
        future: fetchData,
        builder: (BuildContext context, AsyncSnapshot<fulluser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(), // Show circular progress indicator
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: GestureDetector(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    semanticLabel: "Logout",
                                  ),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              await SharedPreferencesHelper
                                  .clearLoginCredentials();
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Login()));
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 120,
                        ),
                      ),
                      Text(
                        "${userprofile.username}",
                        style: TextStyle(color: Colors.black, fontSize: 23),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.alternate_email_rounded,
                            ),
                            Text(
                              ' _____',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.call,
                            ),
                            Text(
                              ' _______________',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Icon(Icons.location_on_sharp,
                                  size: 45, color: Colors.blue),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(left: BorderSide(width: 1.0))),
                              child: const Column(
                                children: [
                                  Text(
                                    '    Tele Region \n    Addis Ababa - Piyasa \n    Ethiopia  ',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Icon(Icons.edit,
                                  size: 30, color: Colors.blue),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Text(
                                  "     ${userprofile.printWalletBalance} \n Wallet ",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                'Wallet',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assest/download.jpg"),
                          fit: BoxFit.fill)),
                  child: Column(
                    children: [
                      // await SharedPreferencesHelper
                      //                 .clearLoginCredentials();
                      //             Navigator.of(context).pop();
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //                 builder: (context) => Login()));

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 120,
                        ),
                      ),
                      Text(
                        "${listfulluser.firstName} ${listfulluser.lastName}",
                        style: TextStyle(color: Colors.black, fontSize: 23),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.alternate_email_rounded,
                            ),
                            Text(
                              '${listfulluser.email}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.call,
                            ),
                            Text(
                              '${listfulluser.phoneNumber}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Icon(Icons.location_on_sharp,
                                  size: 45, color: Colors.blue),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(left: BorderSide(width: 1.0))),
                              child: const Column(
                                children: [
                                  Text(
                                    '    Tele Region \n    Addis Ababa - Piyasa \n    Ethiopia  ',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Icon(Icons.edit,
                                  size: 30, color: Colors.blue),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${listfulluser.printWalletBalance}",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Wallet",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Wallet',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<fulluser?> _sendrequest() async {
    User lo = userget;
    fullaccess l = getfullacc;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.get(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/users/${l.username}"), //http://137.184.214.159:8000/api/v1/users/
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
      );
      print(response.statusCode);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        listfulluser = fulluser.fromJson(data) as fulluser;

        print("good to go");
        print("total count is ${listfulluser.firstName}");
        print(listfulluser.phoneNumber);
        print(listfulluser.printWalletBalance);

        setfulluser(listfulluser);

        return listfulluser;
      }
    } catch (e) {
      print(" Error ${e}");
      throw Exception('Failed to fetch data from the API');
    }
  }

  Future<void> _showMyDialog(String x, String status) async {
    String message = x;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(status),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Press ok to continue'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
