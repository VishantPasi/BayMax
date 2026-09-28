class SendMessageResponseModel {
  int? id;
  String? role;
  String? content;
  String? createdAt;

  SendMessageResponseModel({this.id, this.role, this.content, this.createdAt});

  SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    content = json['content'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    return data;
  }
}
