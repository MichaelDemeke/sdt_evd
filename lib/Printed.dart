import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sdt_evd/Bluetooth.dart';
import 'package:sdt_evd/Printeddetail.dart';
import 'package:sdt_evd/Voucher_Sale_Summary.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/models/history.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class Printed extends StatefulWidget {
  const Printed({super.key});

  @override
  State<Printed> createState() => _PrintedState();
}

class _PrintedState extends State<Printed> {
  bool ready = false;
  late history listhistory;
  late Future<history?> fetchData;
  late bool _connected;

  @override
  void initState() {
    fetchData = _sendrequest();
    // setState(() {
    //   listhistory = gethistory;
    // });

    checkifdeviceisconnected();

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

  void assign() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printed',
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
            icon: Icon(Icons.bluetooth, size: 27, color: getcolor),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => bluetooth(),
              ));
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showSearch(
      //       context: context,
      //       delegate: CustomSearchDelegate(),
      //     );
      //   },
      //   backgroundColor: Colors.purple,
      //   child: const Icon(Icons.search, color: Colors.white),
      // ),
      body: FutureBuilder<history?>(
          future: fetchData,
          builder: (BuildContext context, AsyncSnapshot<history?> snapshot) {
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
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: listhistory.data!.isNotEmpty
                      ? Flex(
                          direction: Axis.vertical,
                          children: [
                            Flexible(
                              child: ListView.builder(
                                itemCount: listhistory.data!.length,
                                itemBuilder: (context, index) {
                                  if (listhistory.data![index].quantity == 0) {
                                    return SizedBox.shrink();
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Printeddetail(listhistory
                                                          .data![index])));
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: 0.5)),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                          "EthioTele ${listhistory.data![index].faceValue}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                      // Text(
                                                      //     "${listhistory.data![index].printedDate!.substring(11, 16)} ",
                                                      //     style: TextStyle(
                                                      //         color:
                                                      //             Colors.blue,
                                                      //         fontSize: 15)),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              color:
                                                                  Colors.blue,
                                                              size: 18),
                                                          Text(
                                                              DateFormat.yMMMd()
                                                                  .add_jm()
                                                                  .format(DateTime.parse(listhistory
                                                                          .data![
                                                                              index]
                                                                          .printedDate!)
                                                                      .add(const Duration(
                                                                          hours:
                                                                              3))
                                                                      .toLocal()),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          "${listhistory.data![index].quantity}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                      Text("vouchers",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
                            child: Container(
                              child: const Column(
                                children: [
                                  Icon(Icons.print,
                                      size: 60, color: Colors.blue),
                                  Text(
                                    "No batch has been found",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
            }
          }),
    );
  }

  Future<history?> _sendrequest() async {
    User lo = userget;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.get(
        Uri.parse(
            "http://137.184.214.159:8000/api/v1/print_queues/?voucher_limit=0&skip=0"), //http://137.184.214.159:8000/
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
          listhistory = history.fromJson(data) as history;
        });

        print("good to go");
        print("total count is ${listhistory.totalCost}");
        // print(listhistory.count);
        print(listhistory.data![1].vouchers!.length);
        // print(listhistory.data![0].vouchers![0].printSequenceNumber);

        return listhistory;
      }
    } catch (e) {
      print(" Error ${e}");
      throw Exception('Failed to fetch data from the API');
    }
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   // List<String> searchItems = ['Item 1', 'Item 2', 'Item 3'];
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             query = '';
//           },
//           icon: Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in searchItems) {
//       if (item!.contains(query)) {
//         matchQuery.add(item as String);
//       }
//     }

//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in searchItems) {
//       if (item!.contains(query)) {
//         matchQuery.add(item);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
