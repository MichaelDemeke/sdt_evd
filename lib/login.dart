import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/FrontPage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sdt_evd/Rememberme.dart';
import 'package:sdt_evd/constants.dart';
import 'package:sdt_evd/models/Fullaccess.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/remember.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController controller;
  late TextEditingController controller1;

  String username = '';
  String password = '';

  late bool ok;
  late String token;

  bool ischecked = false;
  bool allgood = false;

  late User listuser;
  late bool see = false;

  late fullaccess listaccess;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assest/sdt.png"),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 45, 0, 30),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(border: Border.all(width: 0.9)),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(hintText: '  UserName'),
                        controller: controller,
                        onSubmitted: (value) {
                          setState(() {
                            username = controller.text;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(border: Border.all(width: 0.9)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              obscureText: see ? false : true,
                              decoration: InputDecoration(
                                  hintText: '  Password',
                                  alignLabelWithHint: true),
                              controller: controller1,
                              onSubmitted: (value) {
                                setState(() {
                                  password = controller1.text;
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (see) {
                                  see = false;
                                } else {
                                  see = true;
                                }
                              });
                            },
                            icon: see
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.no_accounts_sharp))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: ischecked,
                        activeColor: Colors.blue,
                        onChanged: (bool? value) {
                          setState(() {
                            ischecked = value!;
                          });
                        },
                      ),
                      Text("  Remember me")
                    ],
                  ),
                ),
                Center(
                    child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.79,
                    height: MediaQuery.of(context).size.height * 0.04,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        )),
                    child: const Center(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          //fontFamily: 'Dire_Dawa',
                        ),
                        textAlign: TextAlign.center,
                        child: Text('Login'),
                      ),
                    ),
                  ),
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            Center(child: CircularProgressIndicator()));

                    if (await sendrequest()) {
                      if (await sendrequesttoken(listuser.accessToken)) {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FrontPage(),
                        ));
                      }
                    }
                    //    Navigator.of(context).pop();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => FrontPage(),
                    // ));
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendrequest() async {
    int code = 0;
    try {
      print(controller.text);
      print(controller1.text);
      var response = await http.post(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/auth/login"), // http://137.184.214.159:8000/api/v1/auth/login
        body: {"username": controller.text, "password": controller1.text},
      );
      var data = jsonDecode(response.body);
      print('pp statuse is ${response.statusCode}');

      setState(() {
        code = response.statusCode;
      });

      if (response.statusCode == 200) {
        listuser = User.fromJson(data) as User;
        setuser(listuser);
        SharedPreferencesHelper.setRememberMe(ischecked);

        setRememberMe(rememberMe(
            username: controller.text,
            password: controller1.text,
            token: listuser.accessToken!,
            tokenType: listuser.tokenType!));

        if (ischecked) {
          print("it is checked");
          print(controller.text);
          print(controller1.text);
          print(listuser.accessToken);
          print(listuser.tokenType);

          SharedPreferencesHelper.setLoginCredentials(rememberMe(
              username: controller.text,
              password: controller1.text,
              token: listuser.accessToken!,
              tokenType: listuser.tokenType!));
        } else {
          SharedPreferencesHelper.clearLoginCredentials();
        }

        print("stage 3");

        setState(() {
          allgood = true;
        });

        return true;
      } else {
        _showMyDialog(
            "Invalid Username and Password \n statues code  ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _showMyDialog(
          "Unknown Error has occured plaease try again \n statues code ${code}");

      print("kkk Error ${e}");
      return false;
    }
  }

//#################################################################################################################

  Future<void> _showMyDialog(String x) async {
    String message = x;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Press ok to try again'),
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

  Future<bool> sendrequesttoken(var access) async {
    print("the access token ${access}");

    try {
      var response = await http.get(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/auth/users/me/"), //http://137.184.214.159:8000/api/v1/auth/users/me/
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${access}"
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

// class RememberMeController extends GetxController {
//   final GetStorage storage = GetStorage();

//   final RxBool rememberMe = false.obs;
//   @override
//   void onInit() {
//     rememberMe.value = storage.read('rememberMe') ?? false;
//     super.onInit;
//   }

//   void toggleRememberMe(bool value) {
//     rememberMe.value = value;
//     storage.write('rememberMe', value);
//   }
// }
//}