import 'package:flutter/material.dart';
import 'package:sdt_evd/FrontPage.dart';
import 'package:sdt_evd/Rememberme.dart';
import 'package:sdt_evd/Wallet.dart';
import 'package:sdt_evd/constants.dart';
import 'package:sdt_evd/login.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/models/Fullaccess.dart';
import 'dart:convert';

import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/remember.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Future<rememberMe?> currentUser =
      SharedPreferencesHelper.getLoginCredentials();

  static var accesstokensaved;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: FutureBuilder<rememberMe?>(
          future: currentUser,
          builder: (context, AsyncSnapshot<rememberMe?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(), // Show circular progress indicator
              );
            } else if (snapshot.data == null) {
              print("snapshot return invalid");
              return Login();
            } else {
              print(snapshot.data!.tokenType);
              print("data found but not doing this");

              accesstokensaved = snapshot.data!.token;

              setuser(User(
                  accessToken: snapshot.data!.token,
                  tokenType: snapshot.data!.tokenType));

              Future<fullaccess?> validity = sendrequesttoken();
              return FutureBuilder<fullaccess?>(
                future: validity,
                builder: (context, AsyncSnapshot<fullaccess?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(), // Show circular progress indicator
                    );
                  } else if (snapshot.data == null) {
                    return Login();
                  } else {
                    return FrontPage();
                  }
                },
              );
            }
          },
        ));
  }

  static Future<fullaccess?> sendrequesttoken() async {
    late fullaccess listaccess;
    print("the access token ${accesstokensaved}");

    try {
      var response = await http.get(
        Uri.parse("http://137.184.214.159:8000/api/v1/auth/users/me/"),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${accesstokensaved}"
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

        return listaccess;
      } else {
        print(response.statusCode);

        return null;
      }
    } catch (e) {
      print(" Error ${e}");
      return null;
    }
  }
}
