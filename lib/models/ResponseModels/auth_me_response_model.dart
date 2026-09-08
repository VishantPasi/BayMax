class AuthMeResponseModel {
  String? id;
  String? email;
  String? name;
  String? authProvider;

  AuthMeResponseModel({this.id, this.email, this.name, this.authProvider});

  AuthMeResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    authProvider = json['auth_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['auth_provider'] = this.authProvider;
    return data;
  }
}
