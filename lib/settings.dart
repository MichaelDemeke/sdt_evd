import 'package:flutter/material.dart';
import 'package:sdt_evd/changePassword.dart';
import 'Rememberme.dart';
import 'constants.dart';
import 'login.dart';
import 'models/Fullaccess.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  fullaccess l = getfullacc;

  List<String> title = [
    "Language",
    "Update Password",
    "Printing Profile",
    "About",
    "Logout"
  ];
  List<String> subtitle = [
    "English",
    "Update your password",
    "${getfullacc.username}",
    "About svd",
    "Logout from this device"
  ];
  List<Icon> iconsl = [
    Icon(Icons.language, color: Colors.blue, size: 23),
    Icon(Icons.key, color: Colors.blue, size: 23),
    Icon(Icons.print, color: Colors.blue, size: 23),
    Icon(Icons.info, color: Colors.blue, size: 23),
    Icon(Icons.exit_to_app, color: Colors.blue, size: 23)
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
                fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: title.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(width: 0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: iconsl[index]),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title[index],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              Text(subtitle[index],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              onTap: () async {
                if (index == 4) {
                  await SharedPreferencesHelper.clearLoginCredentials();
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Login()));
                } else if (index == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => changePassword(),
                  ));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
