class quantity {
  int? count;
  int? faceValue;

  quantity({this.count, this.faceValue});

  quantity.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    faceValue = json['face_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['face_value'] = this.faceValue;
    return data;
  }
}
