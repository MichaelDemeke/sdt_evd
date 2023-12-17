import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:sdt_evd/models/history.dart';

import 'Bluetooth.dart';
import 'Printeddetail copy.dart';
import 'Voucher_Sale_Summary.dart';
import 'constants.dart';
import 'models/User.dart';

class Printed1 extends StatefulWidget {
  const Printed1({super.key});

  @override
  State<Printed1> createState() => _Printed1State();
}

class _Printed1State extends State<Printed1> {
  final _controller = ScrollController();
  List<history> _items = [];
  int _currentMax = 0;
  late history listhistory;
  late Future<history?> fetchData;
  bool round = false;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    fetchData = _fetchData();
  }

  _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _fetchData();
    }
  }

  Future<history?> _fetchData() async {
    print("inside fetch");
    User lo = userget;
    history temphis;
    var response = await http.get(
      Uri.parse(
          'http://137.184.214.159:8000/api/v1/print_queues/?skip=$_currentMax&limit=10'),
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
        temphis = history.fromJson(data) as history;
        print("assigns");
        if (round == false) {
          listhistory = history.fromJson(data) as history;
        } else {
          listhistory.data!.addAll(temphis.data!);
        }
        print("ADDs");
        _currentMax = listhistory.data!.length;
        print("currentmax");
        _isLastPage = temphis.count == listhistory.data!.length;
        print("lastpage");

        round = true;
      });

      print("good to go");
      print("total count is ${listhistory.totalCost}");
      // print(listhistory.count);
      print(listhistory.data![1].vouchers!.length);

      return listhistory;
    } else {
      throw Exception('Failed to load items');
    }
  }

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
            return ListView.builder(
              itemCount: listhistory.data!.length,
              controller: _controller,
              itemBuilder: (context, index) {
                if (listhistory.data![index].quantity == 0) {
                  return SizedBox.shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Printeddetail(listhistory.data![index])));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0.5)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                        "EthioTele ${listhistory.data![index].faceValue}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    // Text(
                                    //     "${listhistory.data![index].printedDate!.substring(11, 16)} ",
                                    //     style: TextStyle(
                                    //         color:
                                    //             Colors.blue,
                                    //         fontSize: 15)),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month,
                                            color: Colors.blue, size: 18),
                                        Text(
                                            DateFormat.yMMMd().add_jm().format(
                                                DateTime.parse(listhistory
                                                        .data![index]
                                                        .printedDate!)
                                                    .add(const Duration(
                                                        hours: 3))
                                                    .toLocal()),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${listhistory.data![index].quantity}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    Text("vouchers",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
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
            );
          }
        },
      ),
    );
  }
}
