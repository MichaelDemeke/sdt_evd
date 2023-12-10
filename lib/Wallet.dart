import 'dart:ffi';
import 'dart:convert';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sdt_evd/Bluetooth copy.dart';
import 'package:sdt_evd/Order.dart';
import 'package:sdt_evd/Voucher_Sale_Summary.dart';
import 'package:sdt_evd/constants.dart';
import 'package:sdt_evd/models/Fullaccess.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/models/historydet.dart';
import 'package:sdt_evd/models/quantity.dart';

import 'models/history.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  List<int> ListItems = [5, 10, 15, 25, 50, 100];
  List<quantity> ll = [];
  late quantity listquantity;
  fullaccess tokens = getfullacc;
  late bool _connected;

  @override
  void initState() {
    checkifdeviceisconnected();
    sendrequestquantity();
    super.initState();
  }

  void checkifdeviceisconnected() {
    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            color(Colors.green);
            print('connect success');
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            color(Colors.blue);
            print('disconnect success');
          });
          break;
        default:
          break;
      }
    });
  }

  // void logic() {
  //   for (int i = 0; i < quantitylist.length; i++) {
  //     if (quantitylist[i].faceValue == ListItems[i]) {
  //       setState(() {
  //         count[i] = quantitylist[i].count!;
  //       });

  //       print(count[i]);
  //     }
  //   }
  // }

// int quantitycheck () {
//   listquantity.count!;

// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet',
            style: TextStyle(
                fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.info, size: 27, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VoucherSaleSummary(),
            ));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.bluetooth,
              size: 27,
              color: getcolor,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => bluetooth(),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      )),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 33,
                      ),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${tokens.printWalletBalance}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Airtime',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4),
                        Container(
                          width: 70,
                          height: 70,
                          child: Image.asset(
                            "assest/money-bag.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                ListItems.isNotEmpty
                    ? Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: ListItems.length,
                          itemBuilder: (context, index) {
                            var result = ListItems[index];
                            return GestureDetector(
                              onTap: () {
                                List<quantity> mm = getdetailhistory;
                                int count = 0;
                                bool c = false;
                                print(mm[0].faceValue);
                                print(ListItems[index]);
                                print(count);
                                for (int i = 0; i < mm!.length; i++) {
                                  print("in the for loop");
                                  if (ListItems[index] == mm[i].faceValue) {
                                    print('in if');
                                    setState(() {
                                      print("in setstate");
                                      count = mm[i].count!;
                                      c = true;
                                    });
                                  }
                                }
                                if (c == false) {
                                  setState(() {
                                    count = 0;
                                  });
                                }

                                print("the count before ${count}");

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Order(ListItems[index], count, index),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  foregroundDecoration: BoxDecoration(
                                      border: Border.all(width: 1)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.wrap_text_rounded,
                                        color: Colors.blue,
                                        size: 27,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 90, 0),
                                        child: Center(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${ListItems[index]}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 26),
                                                    ),
                                                    Text(
                                                      ' birr',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "EthioTele",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 0, 0, 0),
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                          child: Container(
                            child: const Column(
                              children: [
                                Icon(Icons.list_alt,
                                    size: 60, color: Colors.blue),
                                Text(
                                  "No Donominastion yet",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendrequestquantity() async {
    User lo = userget;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.get(
        Uri.parse(
            "https://evdc-api.onrender.com/api/v1/vouchers/summary/?status=wallet"), //https://evdc-api.onrender.com/api/v1/vouchers/summary/?status=wallet
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
      );
      print(response.statusCode);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("data length ${data.length}");

        data.forEach((qq) {
          setState(() {
            listquantity = quantity.fromJson(qq) as quantity;
            print(listquantity.count);
            print(listquantity.faceValue);
            ll.add(listquantity);
            //  count.add(listquantity.count);
          });
        });

        setState(() {
          setdetailhistory(ll);
        });

        print("inside ll ${ll.length}");
        // logic();
        print("hello world ");
        // print("total count is${quantitylist[0].count}");
        print(listquantity.faceValue);

        return true;
      } else {
        print(response.statusCode);
        print("XXXXXXXXXXX ELSE");
        return false;
      }
    } catch (e) {
      print(" Error ${e}");
      print("vvvvvvvvvvv catch");
      return false;
    }
  }
}
