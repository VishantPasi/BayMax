class GoogleSignInRequestModel {
  String? idToken;

  GoogleSignInRequestModel({this.idToken});

  GoogleSignInRequestModel.fromJson(Map<String, dynamic> json) {
    idToken = json['id_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_token'] = this.idToken;
    return data;
  }
}
