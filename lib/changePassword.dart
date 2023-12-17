import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/constants.dart';
import 'package:sdt_evd/models/fulluser.dart';
import 'package:sdt_evd/models/remember.dart';

import 'models/User.dart';

class changePassword extends StatefulWidget {
  const changePassword({super.key});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  late TextEditingController controller;
  late TextEditingController controller1;
  late TextEditingController controller2;

  bool see = false;
  bool see1 = false;
  bool see2 = false;

  late String oldPassword;
  late String newPassword;
  late String repeatNewPassword;

  late fulluser updateduser;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password',
            style: TextStyle(
                fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
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
                                hintText: ' Enter old password',
                                alignLabelWithHint: true),
                            controller: controller,
                            onSubmitted: (value) {
                              setState(() {
                                oldPassword = controller.text;
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
            ),
            //#############################################################################

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
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
                            obscureText: see1 ? false : true,
                            decoration: InputDecoration(
                                hintText: ' Enter new password',
                                alignLabelWithHint: true),
                            controller: controller1,
                            onSubmitted: (value) {
                              setState(() {
                                newPassword = controller1.text;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (see1) {
                                see1 = false;
                              } else {
                                see1 = true;
                              }
                            });
                          },
                          icon: see1
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.no_accounts_sharp))
                    ],
                  ),
                ),
              ),
            ),

            //#############################################################################

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
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
                            obscureText: see2 ? false : true,
                            decoration: InputDecoration(
                                hintText: ' Repeat new password',
                                alignLabelWithHint: true),
                            controller: controller2,
                            onSubmitted: (value) {
                              setState(() {
                                repeatNewPassword = controller2.text;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (see2) {
                                see2 = false;
                              } else {
                                see2 = true;
                              }
                            });
                          },
                          icon: see2
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.no_accounts_sharp))
                    ],
                  ),
                ),
              ),
            ),

            //#######################################################################################

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
                    child: Text('Change Password'),
                  ),
                ),
              ),
              onTap: () {
                rememberMe rm = getremmberme;
                showDialog(
                    context: context,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()));
                if (controller.text != rm.password) {
                  _showMyDialog("The password you entered is wrong", "Error");
                } else {
                  if (controller1.text != controller2.text) {
                    _showMyDialog(
                        "Make sure you have repeated your new password properly",
                        "Error");
                  } else {
                    sendrequest();
                    Navigator.of(context).pop();
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
    );
  }

  Future<bool> sendrequest() async {
    int code = 0;
    User lo = userget;
    fulluser fu = getfulluser;
    try {
      print(controller.text);
      print(controller1.text);
      var response = await http.patch(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/users/api/v1/users/"), // http://137.184.214.159:8000/api/v1/users/
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
        body: jsonEncode({
          "username": fu.username,
          "password": controller1.text,
          "role": fu.role,
          "phone_number": fu.phoneNumber,
          "first_name": fu.firstName,
          "last_name": fu.lastName,
          "email": fu.email,
        }),
      );
      var data = jsonDecode(response.body);
      print(data);
      print('pp statuse is ${response.statusCode}');

      setState(() {
        code = response.statusCode;
      });

      if (response.statusCode == 200) {
        updateduser = fulluser.fromJson(data) as fulluser;
        setfulluser(updateduser);
        _showMyDialog(
            "You have successfully changed your password \n statues code  ${response.statusCode}",
            "Success");
        setRememberMe(rememberMe(
            username: fu.username!,
            password: controller1.text,
            token: lo.accessToken!,
            tokenType: lo.tokenType!));
        return true;
      } else if (response.statusCode == 422) {
        _showMyDialog(
            "Password can't be more than 8 characters and less than 4 characters",
            "Error");
        return false;
      } else {
        _showMyDialog(
            "Unknown Error has occurred please try again \n statues code ${response.statusCode}",
            "Error");
        return false;
      }
    } catch (e) {
      _showMyDialog("Unknown Error has occurred please try again", "Error");

      print("kkk Error ${e}");
      return false;
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
