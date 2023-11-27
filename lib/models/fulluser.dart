class fulluser {
  int? id;
  String? username;
  String? role;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? email;
  int? printWalletBalance;

  fulluser(
      {this.id,
      this.username,
      this.role,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.email,
      this.printWalletBalance});

  fulluser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    role = json['role'];
    phoneNumber = json['phone_number'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    printWalletBalance = json['print_wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['role'] = this.role;
    data['phone_number'] = this.phoneNumber;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['print_wallet_balance'] = this.printWalletBalance;
    return data;
  }
}
