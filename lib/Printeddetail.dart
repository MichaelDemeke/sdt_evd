import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sdt_evd/Printed.dart';
import 'package:sdt_evd/models/checked.dart';
import 'package:sdt_evd/models/history.dart' as history;
import 'package:sdt_evd/models/historydet.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';
import 'models/Fullaccess.dart';
import 'models/User.dart';
import 'models/checked.dart';

class Printeddetail extends StatefulWidget {
  final history.Data general;
  const Printeddetail(this.general, {super.key});

  @override
  State<Printeddetail> createState() => _PrinteddetailState();
}

class _PrinteddetailState extends State<Printeddetail> {
  List<int?> reprint = [];
  List<bool> checked = [];
  bool ischeched = false;
  bool clear = false;
  int _currentMax = 0;
  final _controller = ScrollController();

  late historydetail detailhistory;
  List<hischecked> historychecked = [];
  List<hischecked> afterhistorychecked = [];

  late Future<List<hischecked>?> fetchdeatailData;

  void change(int? x, bool isSelected) {
    if (isSelected) {
      reprint.add(x);
    } else {
      reprint.remove(x);
    }
  }

  bool areAllFalse(List<bool> boolList) {
    return boolList.every((element) => element == false);
  }

  bool round = false;

  @override
  void initState() {
    fetchdeatailData = _sendrequest();
    // _controller.addListener(_scrollListener);
    super.initState();
  }

  // _scrollListener() {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     print("it is scrolling ");
  //     _sendrequest();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batches Detail',
            style: TextStyle(
                fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.general.faceValue} ",
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
        Text(
          "EthioTele",
          style: TextStyle(
              color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
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
              if (ischeched) {
                // setState(() {
                //   detailhistory.vouchers!.forEach((element) {
                //     reprint.add(element.id);
                //   });
                // });

                setState(() {
                  historychecked.forEach((element) {
                    element.datachecked = true;
                  });
                });
              }

              if (areAllFalse(checked))
                _showMyDialog(
                    "you should select an item to be printed", "Error");

              if (getdevice == null) {
                _showMyDialog("Try to connect to your printer first", "Error");
              } else {
                afterhistorychecked.clear();
                for (int i = 0; i < historychecked!.length; i++) {
                  if (historychecked[i].datachecked) {
                    setState(() {
                      afterhistorychecked.add(historychecked[i]);
                    });
                  }
                }

                showDialog(
                    context: context,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()));
                startreprint();
              }
            },
          )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.04,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: ischeched,
                        onChanged: (value) {
                          setState(() {
                            ischeched = value!;
                            if (ischeched) {
                              // historychecked.forEach((element) {
                              //   element.datachecked = true;
                              // });
                              checked = List<bool>.generate(
                                  historychecked.length, (_) => true);
                              clear = false;
                            } else
                              // historychecked.forEach((element) {
                              //   element.datachecked = false;
                              // });
                              checked = List<bool>.generate(
                                  historychecked.length, (_) => false);
                          });

                          //  change(widget.rolehistory.vouchers![index].id,
                          //      ischeched);
                        },
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          //fontFamily: 'Dire_Dawa',
                        ),
                        textAlign: TextAlign.center,
                        child: Text('Select all'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.04,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: clear,
                        onChanged: (value) {
                          setState(() {
                            clear = value!;
                            if (clear)
                              checked = List<bool>.generate(
                                  detailhistory.vouchers!.length, (_) => false);
                            historychecked.forEach((element) {
                              element.datachecked = false;
                            });

                            ischeched = false;
                          });

                          // change(widget.rolehistory.vouchers![index].id,
                          //     ischeched);
                        },
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          //fontFamily: 'Dire_Dawa',
                        ),
                        textAlign: TextAlign.center,
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<hischecked>?>(
            future: fetchdeatailData,
            builder: (BuildContext context,
                AsyncSnapshot<List<hischecked>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child:
                      CircularProgressIndicator(), // Show circular progress indicator
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
                    child: Container(
                      child: const Column(
                        children: [
                          Icon(Icons.print, size: 60, color: Colors.blue),
                          Text(
                            "No print history yet",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: historychecked.length,
                    // controller: _controller,
                    itemBuilder: (context, index) {
                      return Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: MediaQuery.of(context).size.height * 0.09,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0.1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                    "# ${historychecked[index].data.printSequenceNumber}",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18)),
                              ),
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Column(
                                    children: [
                                      Text("${detailhistory.printedDate}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
                                      Text(
                                          "${historychecked[index].data.serialNumber}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                                child: Checkbox(
                                  value: checked[index],
                                  onChanged: (value) {
                                    setState(() {
                                      checked[index] = value ?? false;

                                      historychecked[index].datachecked =
                                          checked[index];

                                      // change(detailhistory.vouchers![index].id, checked[index]);

                                      if (checked[index]) {
                                        clear = false;
                                      } else {
                                        ischeched = false;
                                      }
                                    });
                                  },
                                ),
                              )
                            ],
                          ));
                    },
                  ),
                );
              }
              ;
            }),
      ]),
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

  Future<void> startreprint() async {
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
    BluetoothDevice device = getdevice;
    fullaccess l = getfullacc;
    if (device != null && device.address != null) {
      print(device.name);

//###########################################################################

      ByteData data1 = await rootBundle.load("assest/logo.png");
      List<int> imageBytes1 =
          data1.buffer.asUint8List(data1.offsetInBytes, data1.lengthInBytes);
      String base64Image1 = base64Encode(imageBytes1);

//#############################################################################

      for (var i = 0; i < afterhistorychecked.length; i++) {
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
            content: "${detailhistory.faceValue} birr",
            weight: 2,
            width: 2,
            height: 2,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: afterhistorychecked[i]
                .data
                .rechargeNumber
                .toString()
                .replaceAllMapped(
                    RegExp(r"(.{5})(.{4})(.*)"),
                    (match) =>
                        "${match.group(1)} ${match.group(2)} ${match.group(3)}"),
            weight: 2,
            width: 2,
            height: 2,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));
        print(afterhistorychecked[i].data.rechargeNumber);

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
                "Recharge: *805*${afterhistorychecked[i].data.rechargeNumber}#",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "Serial Number: ${afterhistorychecked[i].data.serialNumber}",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "TD: ${afterhistorychecked[i].data.createdAt?.substring(0, 10)} - ED: ${afterhistorychecked[i].data.stopDate?.substring(0, 10)}",
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
                "--------------------------#${afterhistorychecked[i].data.printSequenceNumber.toString()}",
            weight: 0,
            width: 0,
            height: 0,
            align: LineText.ALIGN_CENTER,
            linefeed: 0));

        await bluetoothPrint.printReceipt(config, list);
      }
    }
  }

  Future<List<hischecked>?> _sendrequest() async {
    User lo = userget;
    historydetail extracthistory;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.get(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/print_queues/${widget.general.id}?voucher_skip=0&voucher_limit=${widget.general.quantity}"), //http://137.184.214.159:8000/
        // http://137.184.214.159:8000/api/v1/print_queues/${widget.general.id}?voucher_skip=${_currentMax}&voucher_limit=10
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
      );
      print(response.statusCode);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          // if (round) {
          //   extracthistory = historydetail.fromJson(data) as historydetail;
          //   print(
          //       "The detail history length before  ${detailhistory.vouchers!.length}");

          //   print(
          //       "The extract history length ${extracthistory.vouchers!.length}"); //extracthistory.vouchers![extracthistory.vouchers!.length - 1].id
          //   detailhistory.vouchers!
          //       .addAll(extracthistory.vouchers as Iterable<Vouchers>);
          //   print(
          //       "The detail history length after  ${detailhistory.vouchers!.length}"); //detailhistory.vouchers![detailhistory.vouchers!.length - 1].id
          // } else {
          detailhistory = historydetail.fromJson(data) as historydetail;
          //}
          // _currentMax = detailhistory.vouchers!.length;
        });

        // setState(() {
        //   round = true;
        // });

        print("good to go");
        print("total count is ${widget.general.quantity}");

        setState(() {
          detailhistory.vouchers!.sort((a, b) =>
              a.printSequenceNumber!.compareTo(b.printSequenceNumber as num));

          checked =
              List<bool>.generate(detailhistory.vouchers!.length, (_) => false);

          for (int i = 0; i < detailhistory.vouchers!.length; i++) {
            historychecked.add(hischecked(
                data: detailhistory.vouchers![i], datachecked: false));
          }
        });

        return historychecked;
      }
    } catch (e) {
      print(" Error ${e}");
      throw Exception('Failed to fetch data from the API');
    }
  }
}
