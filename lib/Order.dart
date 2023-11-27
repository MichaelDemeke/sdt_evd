import 'dart:ffi';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:sdt_evd/Bluetooth.dart';
import 'package:sdt_evd/StartPrinting.dart';
import 'package:sdt_evd/Voucher_Sale_Summary.dart';
import 'package:sdt_evd/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sdt_evd/models/Fullaccess.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/models/quantity.dart';

import 'models/User.dart';
import 'models/voucher.dart';

class Order extends StatefulWidget {
  final int index;
  final int i;
  final int count;
  const Order(this.index, this.count, this.i, {super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late TextEditingController controller;
  int amount = 0;
  late bool printed;
  fullaccess useracess = getfullacc;
  int limit = 500;
  late Future<bool> valid;
  late bool _connected;
  late String temp;
  List<quantity> ll = [];
  late quantity listquantity;

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  late BluetoothDevice device;
  @override
  void initState() {
    checkifdeviceisconnected();
    controller = TextEditingController();
    super.initState();
  }

  // bool logic(int x) {
  //   print(x);
  //   print(widget.count[widget.i]);
  //   if (limit <= x) {
  //     print("inside logic");
  //     return false;
  //   } else if (limit >= widget.count[widget.i]! &&
  //       x >= widget.count[widget.i]!) {
  //     print("object");
  //     return false;
  //   } else {
  //     print("else");
  //     return true;
  //   }
  // }

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Print',
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
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
              icon: Icon(Icons.bluetooth, size: 27, color: getcolor),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => bluetooth(),
                ));
              },
            ),
          ],
        ),
        body: Container(
          child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.index} ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Birr",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "EthioTele",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Balance ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "${useracess.printWalletBalance}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 45, 0, 30),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: TextField(
                        decoration: InputDecoration(hintText: '  amount'),
                        controller: controller,
                        onSubmitted: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Center(
                      child: GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.39,
                      height: MediaQuery.of(context).size.height * 0.04,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          )),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.print, color: Colors.white, size: 20),
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                //fontFamily: 'Dire_Dawa',
                              ),
                              textAlign: TextAlign.center,
                              child: Text('Print'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (int.tryParse(controller.text) != null) {
                        temp = controller.text;
                        amount = int.parse(temp);
                      } else {
                        _showMyDialog(
                            "Please enter the correct amount you want to print out",
                            "Error");
                      }
                      print("in on tap");

                      // if (logic(amount)) {
                      //   print("inside ok");
                      //   _showMyDialog(
                      //       "You can't print this amount you have reached your limit",
                      //       "Error");
                      // }
                      print(amount);
                      checkifdeviceisconnected();
                      if (limit <= amount) {
                        print("inside logic");
                        _showMyDialog(
                            "You can't print ${amount}. You have reached ur limit",
                            "Error");
                      } else if (limit >= widget.count &&
                          amount >= widget.count) {
                        print("object");
                        _showMyDialog(
                            "You can't print ${amount}. You have reached ur limit",
                            "Error");
                      } else {
                        if (getdevice == null) {
                          print("inside connected");
                          _showMyDialog(
                              "Try to connect to your printer first", "Error");
                        } else {
                          print("inside else");
                          setState(() {
                            device = getdevice;
                          });

                          showDialog(
                              context: context,
                              builder: (context) =>
                                  Center(child: CircularProgressIndicator()));

                          sendrequest(widget.index, int.parse(controller.text));
                        }
                      }
                    },
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${int.tryParse(controller.text) != null ? int.parse(controller.text) * widget.index : "0"} Vouchers are going to be printed ",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ? Text("Printer not Connected",
                          //     style: TextStyle(
                          //         color: Colors.purple,
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.normal))
                          Text(
                            "Printer  ${getdevice == null ? "null" : getdevice.name}",
                            style: TextStyle(
                                color: getcolor,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            Icons.bluetooth,
                            color: getcolor,
                            size: 29,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
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

  Future<void> start(voucher listVouchers) async {
    if (device != null && device.address != null) {
      print(device.name);
      fullaccess l = getfullacc;
      print('${listVouchers.faceValue} birr');

//############################################################################

      ByteData data1 = await rootBundle.load("assest/logo.png");
      List<int> imageBytes1 =
          data1.buffer.asUint8List(data1.offsetInBytes, data1.lengthInBytes);
      String base64Image1 = base64Encode(imageBytes1);

      _showMyDialog("Print in progress", "Success");

      for (var i = 0; i < listVouchers.vouchers!.length; i++) {
        Map<String, dynamic> config = Map();
        List<LineText> list = [];

        list.add(LineText(
          type: LineText.TYPE_IMAGE,
          content: base64Image1,
          height: 200,
          width: 350,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "${listVouchers.faceValue} birr",
            weight: 2,
            width: 2,
            height: 1,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: listVouchers.vouchers![i].rechargeNumber
                .toString()
                .replaceAllMapped(
                    RegExp(r"(.{5})(.{4})(.*)"),
                    (match) =>
                        "${match.group(1)} ${match.group(2)} ${match.group(3)}"),
            weight: 2,
            width: 2,
            height: 1,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));
        print(listVouchers.vouchers![i].rechargeNumber);

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: ("--------------------------------"),
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "Recharge: *805*${listVouchers.vouchers![i].rechargeNumber}#",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));
        print(listVouchers.vouchers![i].rechargeNumber);

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "Serial Number: ${listVouchers.vouchers![i].serialNumber}",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "TD: ${listVouchers.vouchers![i].createdAt?.substring(0, 10)} - ED: ${listVouchers.vouchers![i].stopDate?.substring(0, 10)} ",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "Retailer: ${l.username}",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "SDT - AA, Bole Int, Airport",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "--------------------------#${listVouchers.vouchers![i].printSequenceNumber.toString()}",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 0));

        await bluetoothPrint.printReceipt(config, list);
      }
    }
  }

  Future<bool> sendrequest(int x, int quantity) async {
    String faceValue = x.toString();
    late voucher listVouchers;
    User lo = userget;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.post(
        Uri.parse(
            "https://evdc-api.onrender.com/api/v1/print_queues/"), // http://137.184.214.159:8000/
        body: json.encode({"face_value": faceValue, "quantity": quantity}),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
      );
      print(response.statusCode);
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        listVouchers = voucher.fromJson(data) as voucher;
        print("good to go");
        print(listVouchers.vouchers!.length);

        if (listVouchers.vouchers!.length == 0) {
          _showMyDialog('Check if you have enough vouchers', 'Error');
        } else {
          start(listVouchers);
          sendrequesttoken();
        }
        sendrequestquantity();
        return true;
      } else {
        _showMyDialog(
            "There seems to be an error in data fetching check if you have enough balance",
            "Error code ${response.statusCode}");
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      _showMyDialog(
          "There seems to be an unknown error check if you are connected to the internet",
          "Error");
      print(" mmmmmm   Error ${e}");
      return false;
    }
  }

  Future<bool> sendrequesttoken() async {
    User lo = userget;
    late fullaccess listaccess;
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

  Future<bool> sendrequestquantity() async {
    User lo = userget;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.get(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/vouchers/summary/?status=wallet"),
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

        print("inside ll${ll[0].faceValue}");
        // logic();
        print("hello world ");
        // print("total count is${quantitylist[0].count}");
        print(listquantity.faceValue);

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
