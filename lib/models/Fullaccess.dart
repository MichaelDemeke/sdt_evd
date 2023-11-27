class fullaccess {
  int? id;
  String? username;
  String? role;
  int? printWalletBalance;

  fullaccess({this.id, this.username, this.role, this.printWalletBalance});

  fullaccess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    role = json['role'];
    printWalletBalance = json['print_wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['role'] = this.role;
    data['print_wallet_balance'] = this.printWalletBalance;
    return data;
  }
}
