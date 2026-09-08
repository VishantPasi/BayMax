class SignUpRequestModel {
  String? email;
  String? password;
  String? phone;
  String? name;

  SignUpRequestModel({this.email, this.password, this.phone, this.name});

  SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['name'] = this.name;
    return data;
  }
}
