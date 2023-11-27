import 'package:flutter/material.dart';
import 'package:sdt_evd/Bluetooth.dart';
import 'package:sdt_evd/Voucher_Sale_Summary.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  List<String> searchItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer',
            style: TextStyle(
                fontSize: 23,
                color: Colors.purple,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.info, size: 27, color: Colors.purple),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VoucherSaleSummary(),
            ));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth, size: 27, color: Colors.purple),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => bluetooth(),
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.search, color: Colors.white),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
                child: searchItems.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchItems.length,
                        itemBuilder: (context, index) {
                          var result = searchItems[index];
                          return ListTile(
                            title: Text(result),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
                          child: Container(
                            child: const Column(
                              children: [
                                Icon(Icons.currency_exchange,
                                    size: 60, color: Colors.purple),
                                Text(
                                  "No Transfers Yet",
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
          )),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchItems = ['Item 1', 'Item 2', 'Item 3'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchItems) {
      if (item.contains(query)) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchItems) {
      if (item.contains(query)) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
