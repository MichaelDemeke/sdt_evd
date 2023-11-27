class history {
  int? count;
  int? totalCost;
  List<Data>? data;

  history({this.count, this.totalCost, this.data});

  history.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalCost = json['total_cost'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total_cost'] = this.totalCost;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? faceValue;
  int? quantity;
  int? cost;
  String? printedDate;
  List<Vouchers>? vouchers;

  Data(
      {this.id,
      this.faceValue,
      this.quantity,
      this.cost,
      this.printedDate,
      this.vouchers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    faceValue = json['face_value'];
    quantity = json['quantity'];
    cost = json['cost'];
    printedDate = json['printed_date'];
    if (json['vouchers'] != null) {
      vouchers = <Vouchers>[];
      json['vouchers'].forEach((v) {
        vouchers!.add(new Vouchers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['face_value'] = this.faceValue;
    data['quantity'] = this.quantity;
    data['cost'] = this.cost;
    data['printed_date'] = this.printedDate;
    if (this.vouchers != null) {
      data['vouchers'] = this.vouchers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vouchers {
  int? id;
  String? createdAt;
  String? serialNumber;
  String? rechargeNumber;
  String? stopDate;
  int? printSequenceNumber;

  Vouchers(
      {this.id,
      this.createdAt,
      this.serialNumber,
      this.rechargeNumber,
      this.stopDate,
      this.printSequenceNumber});

  Vouchers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    serialNumber = json['serial_number'];
    rechargeNumber = json['recharge_number'];
    stopDate = json['stop_date'];
    printSequenceNumber = json['print_sequence_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['serial_number'] = this.serialNumber;
    data['recharge_number'] = this.rechargeNumber;
    data['stop_date'] = this.stopDate;
    data['print_sequence_number'] = this.printSequenceNumber;
    return data;
  }
}
