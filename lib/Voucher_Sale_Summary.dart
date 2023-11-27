import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sdt_evd/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/summery.dart';

class VoucherSaleSummary extends StatefulWidget {
  const VoucherSaleSummary({super.key});

  @override
  State<VoucherSaleSummary> createState() => _VoucherSaleSummaryState();
}

class _VoucherSaleSummaryState extends State<VoucherSaleSummary> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  bool aut = false;
  List<summery> listsummery = [];
  List<String> numbers = [
    '5 Birr',
    '10 Birr',
    '15 Birr',
    '25 Birr',
    '50 Birr',
    '100 Birr',
  ];
  List<int> count = [];
  @override
  void initState() {
    sendrequest();
    for (int i = 0; i < listsummery.length; i++) {
      if (listsummery[i].faceValue == 5) {
        setState(() {
          count[0] = listsummery[i].count!;
        });
      } else if (listsummery[i].faceValue == 10) {
        setState(() {
          count[1] = listsummery[i].count!;
        });
      } else if (listsummery[i].faceValue == 15) {
        setState(() {
          count[2] = listsummery[i].count!;
        });
      } else if (listsummery[i].faceValue == 25) {
        setState(() {
          count[3] = listsummery[i].count!;
        });
      } else if (listsummery[i].faceValue == 50) {
        setState(() {
          count[4] = listsummery[i].count!;
        });
      } else {
        setState(() {
          count[5] = listsummery[i].count!;
        });
      }
    }
    super.initState();
  }

  void figureout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher Sale Summary',
            style: TextStyle(
                fontSize: 21, color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.apps_outlined,
                size: 85,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text('From',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.normal)),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.1)),
                            child: Center(
                              child: Text(
                                  "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}"),
                            ),
                          ),
                          onTap: () async {
                            final DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(
                                  3000,
                                ));
                            if (dateTime != null) {
                              setState(() {
                                selectedDate = dateTime;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text('To',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.normal)),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.1)),
                            child: Center(
                              child: Text(
                                  "${selectedDate1.day} - ${selectedDate1.month} - ${selectedDate1.year}"),
                            ),
                          ),
                          onTap: () async {
                            final DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: selectedDate1,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(
                                  3000,
                                ));
                            if (dateTime != null) {
                              setState(() {
                                selectedDate1 = dateTime;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${getfullacc.printWalletBalance}',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                Text('Airtime',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal))
              ],
            ),
            aut
                ? Expanded(
                    child: GridView.builder(
                      itemCount: numbers.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 10 / 7),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.blue),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 0, 0),
                                    child: Text(numbers[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Text('--------------------------',
                                      style: TextStyle(
                                          fontSize: 23, color: Colors.white)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Icon(Icons.print,
                                                color: Colors.white, size: 25),
                                          ),
                                          Text(
                                            "${listsummery[index].count}",
                                            // count.length <= index
                                            //     ? "0"
                                            //     : count[index].toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 23),
                                          )
                                        ],
                                      ),
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
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.list_alt,
                                      size: 60, color: Colors.blue),
                                  Text(
                                    "Not authenticated yet",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<bool> sendrequest() async {
    // String url =
    //     "https://bored-calf-leotard.cyclic.app/api/v1/print_queues/summary/?printed_date_from=2023-11-05T08%3A01%3A52.393791&printed_date_to=2023-11-06T08%3A01%3A52.393863";
    String url1 = "http://137.184.214.159:8000/api/v1/print_queues/summary/";
    User lo = userget;
    print("the access token ${lo.accessToken}");
    try {
      var response = await http.get(
        Uri.parse(url1),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${lo.accessToken}"
        },
      );
      print(response.statusCode);
      var data = jsonDecode(response.body);
      // print(data.face_Value);
      // print(data.count);
      if (response.statusCode == 200) {
        print(data.length);
        data.forEach((listStat) {
          summery itemsummery = summery.fromJson(listStat) as summery;
          print(itemsummery.faceValue);
          print(itemsummery.count);
          setState(() {
            listsummery.add(itemsummery);
          });
        });

        setState(() {
          aut = true;
        });
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
