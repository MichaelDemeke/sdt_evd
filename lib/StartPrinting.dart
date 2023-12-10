import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/Bluetooth.dart';
import 'package:sdt_evd/constants.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/voucher.dart';

import 'models/Fullaccess.dart';

class startPrint {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  BluetoothDevice device = getdevice;
  var context;

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
                "Recharge: *805*${listVouchers.vouchers![i].rechargeNumber.toString()}#",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));
        print(listVouchers.vouchers![i].rechargeNumber);

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "Serial Number: ${listVouchers.vouchers![i].serialNumber.toString()}",
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
        _showMyDialog("Print in progress", "Success");
      }
    }
  }

  Future<bool> sendrequest(int x, int quantity, var contex) async {
    context = contex;
    String faceValue = x.toString();
    late voucher listVouchers;
    User lo = userget;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.post(
        Uri.parse("https://evdc-api.onrender.com/api/v1/print_queues/"),
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
        start(listVouchers);
        _showMyDialog(
            "Data has been fetched successfully Print in progress", "Success");
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
