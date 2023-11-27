import 'package:flutter/material.dart';
import 'package:sdt_evd/Printed.dart';
import 'package:sdt_evd/Profile.dart';
import 'package:sdt_evd/Wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constants.dart';
import 'models/Fullaccess.dart';
import 'models/User.dart';
import 'models/history.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  int index = 0;
  late fullaccess listaccess;
  final screens = [
    Wallet(),
    Printed(),
    Profile(),
  ];

  @override
  void initState() {
    sendrequesttoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[index],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            selectedItemColor: Colors.blue,
            showSelectedLabels: true,
            backgroundColor: Colors.white,
            enableFeedback: true,
            unselectedItemColor: Colors.black,
            unselectedLabelStyle: TextStyle(color: Colors.black),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.print),
                label: 'Printed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]),
      ),
    );
  }

  Future<bool> sendrequesttoken() async {
    User lo = userget;
    print("the access token ${lo.accessToken}");

    try {
      var response = await http.get(
        Uri.parse("http://137.184.214.159:8000/api/v1/auth/users/me/"),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
      );

      print(response.statusCode);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        listaccess = fullaccess.fromJson(data) as fullaccess;
        setfullacc(listaccess);

        print(listaccess.printWalletBalance);
        print(listaccess.username);

        print("good to go");

        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(" Error ${e}");

      return false;
    }
  }
}
