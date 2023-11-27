class summery {
  int? count;
  int? faceValue;
  int? totalCost;

  summery({this.count, this.faceValue, this.totalCost});

  summery.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    faceValue = json['face_value'];
    totalCost = json['total_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['face_value'] = this.faceValue;
    data['total_cost'] = this.totalCost;
    return data;
  }
}
