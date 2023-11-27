import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:sdt_evd/Bluetooth.dart';
import 'package:sdt_evd/Printed.dart';
import 'package:sdt_evd/models/Fullaccess.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/history.dart';
import 'package:sdt_evd/models/quantity.dart';

import 'models/historydet.dart';

bool aut = true;

BluetoothDevice? _Bluetoothdevice;
BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
bool stillthere = false;

Future<bool> checkifdeviceisconnected() async {
  bool isConnected = await bluetoothPrint.isConnected ?? false;

  if (isConnected) {
    stillthere = true;
    return true;
  } else {
    stillthere = false;
    return false;
  }
}

int Airtime = 0;

void setdevices(var event) {
  _Bluetoothdevice = event;
}

get getdevice {
  checkifdeviceisconnected();
  if (stillthere)
    return _Bluetoothdevice;
  else
    return null;
}

//##########################################################
Color currentcolor = Colors.blue;

void color(Color c) {
  currentcolor = c;
}

get getcolor {
  checkifdeviceisconnected();
  if (stillthere)
    return currentcolor;
  else
    return Colors.blue;
}

//#######################################################
late User tempo;
void setuser(User x) {
  tempo = x;
}

get userget {
  return tempo;
}
//##########################################################

late fullaccess temp;
void setfullacc(fullaccess x) {
  temp = x;
}

get getfullacc {
  return temp;
}

//###############################################################
late history hist;
void sethistory(history x) {
  hist = x;
}

get gethistory {
  return hist;
}

//##################################################################
late List<quantity> dethis;
void setdetailhistory(List<quantity> x) {
  dethis = x;
}

get getdetailhistory {
  return dethis;
}
