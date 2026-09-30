class GoogleSignInResponseModel {
  String? accessToken;

  GoogleSignInResponseModel({this.accessToken});

  GoogleSignInResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    return data;
  }
}
