class SignUpResponseModel {
  String? accessToken;
  String? tokenType;

  SignUpResponseModel({this.accessToken, this.tokenType});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}
