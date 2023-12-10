import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart' as bluetooth_print;
import 'package:get/utils.dart';
import 'constants.dart';
//import 'package:beacon_flutter/beacon_flutter.dart';

class bluetooth extends StatefulWidget {
  const bluetooth({super.key});

  @override
  State<bluetooth> createState() => _bluetoothState();
}

class _bluetoothState extends State<bluetooth> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  late Future<bool> isConnected;
  late bool _connected;
  //final _beaconPlugin = Beacon();
  static const bluetoothscanner = MethodChannel('michael.com/bluetooth');

  late bluetooth_print.BluetoothDevice _currentdevice;
  List<bluetooth_print.BluetoothDevice> _device = [];
  String _deviceMsg = "";

  Future<void> _scanBluetoothDevices() async {
    try {
      final List<BluetoothDevice> devices =
          await bluetoothscanner.invokeMethod('scanBluetoothDevices');
      setState(() {
        _device = devices.cast<bluetooth_print.BluetoothDevice>();
      });
    } catch (e) {
      print('Error scanning Bluetooth devices: $e');
    }
  }

  @override
  void initState() {
    _scanBluetoothDevices();

    print("print copy");
    //  checkifdeviceisconnected();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initPrinter();
      },
    );

    // var _flutterBlue = BluetoothPrint.instance;
    // _flutterBlue.isConnected.then((value) {
    //   //Do your processing
    // });

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
    super.initState();
  }

  Future<bool> checkifdeviceisconnected() async {
    print("in the function");
    //  bool isnotConnected = await getdevice.isConnected ?? false;
    Future<bool?> isConnected = bluetoothPrint.isConnected;
    if (isConnected == true) {
      print("in the if");
      return true;
    } else
      setState(() {
        setdevices(null);
        color(Colors.blue);
      });
    print("in the else");
    return false;
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    if (!mounted) return;
    var subscription = bluetoothPrint.scanResults.listen((event) {
      if (!mounted) return;
      setState(() {
        _device = event;
        // setdevices(event);
      });
      if (_device.isEmpty)
        setState(() {
          _deviceMsg = 'No Device';
        });
      switch (event) {
        case BluetoothPrint.CONNECTED:
          setState(() {});
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            setdevices(null);
            color(Colors.blue);
          });
          break;
        default:
          break;
      }
    });
  }

//   void startscan2(){
//     print('list of paired devices');
// flutterBlue.connectedDevices.asStream().listen((paired) {
//   print('paired device: $paired');
// });
// setState(() {
//   _isScanning = true;
// });
// scanSubscription =
//     flutterBlue.scan(timeout: Duration(seconds: 20)).listen((scanResult) {
//   var device = scanResult.device;
//   print('${device.name} found! rssi: ${scanResult.rssi}');
// }, onDone: _stopScan);
// scanSubscription.cancel();

// }

  void startscan() async {
    print("inside the start scan ");
    try {
      // listen to scan results
// Note: `onScanResults` only returns live scan results, i.e. during scanning
// Use: `scanResults` if you want live scan results *or* the previous results
      var subscription = FlutterBluePlus.onScanResults.listen(
        (results) {
          if (results.isNotEmpty) {
            print("inside the results");
            ScanResult r = results.last;
            // the most recently found device

            print(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
          } else {
            print("results is empty");
          }
        },
      );

// Wait for Bluetooth enabled & permission granted
// In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
      await FlutterBluePlus.adapterState
          .where((val) => val == BluetoothAdapterState.on)
          .first;

// Start scanning
      await FlutterBluePlus.startScan();

// Stop scanning
      await FlutterBluePlus.stopScan();

// cancel to prevent duplicate listeners
      subscription.cancel();
    } catch (e) {
      print("The error is ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth',
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("1. Make sure Bluetooth is turned on",
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("2. Make sure Location is turned on",
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("3. Make sure Bluetooth device is turned on",
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
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
                      child: Text('Scan Bluetooth'),
                    ),
                  ),
                ),
                onTap: () async {
                  startscan();
                  // initPrinter();
                },
              )),
            ),
            getdevice != null
                ? ListTile(
                    leading: Icon(Icons.print),
                    title: Text(getdevice.name!),
                    trailing: Text("Conected "),
                    subtitle: Text(getdevice.address!),
                  )
                : _device.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.bluetooth, size: 90, color: Colors.blue),
                            Text(_deviceMsg ?? '',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 18)),
                          ],
                        ),
                      )
                    // : StreamBuilder<List<BluetoothDevice>>(
                    //   stream: bluetoothPrint.scanResults,
                    //   initialData: [],
                    //   builder: (context, snapshot) =>
                    //     Column(
                    //       children: snapshot.data!.map((e) =>ListTile(
                    //           leading: Icon(Icons.print),
                    //           title: Text(e.name!),
                    //           subtitle: Text(e.address!),
                    //           onTap: () async {
                    //             if (e.name != null &&
                    //                 e.address != null) {
                    //               await bluetoothPrint.connect(e);
                    //               _currentdevice = e;

                    //               _showMyDialog(
                    //                   "Device has been connected successfully",
                    //                   "Success");
                    //               setState(() {
                    //                 setdevices(e);
                    //                 color(Colors.green);
                    //               });
                    //               Navigator.pop(context);
                    //             } else {
                    //               color(Colors.blue);
                    //             }
                    //           },
                    //         )).toList(),
                    //     )

                    // )

                    : Expanded(
                        child: ListView.builder(
                          itemCount: _device.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.print),
                              title: Text(_device[index].name!),
                              subtitle: Text(_device[index].address!),
                              onTap: () async {
                                if (_device[index] != null &&
                                    _device[index].address != null) {
                                  await bluetoothPrint.connect(_device[index]);
                                  _currentdevice = _device[index];

                                  _showMyDialog(
                                      "Device has been connected successfully",
                                      "Success");
                                  setState(() {
                                    setdevices(_device[index]);
                                    color(Colors.green);
                                  });
                                  Navigator.pop(context);
                                } else {
                                  color(Colors.blue);
                                }
                              },
                            );
                          },
                        ),
                      ),
          ],
        ));
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
