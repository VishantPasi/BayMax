class GetChatsWithIdResponseModel {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;
  List<Messages>? messages;

  GetChatsWithIdResponseModel(
      {this.id, this.title, this.createdAt, this.updatedAt, this.messages});

  GetChatsWithIdResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  String? role;
  String? content;
  String? createdAt;

  Messages({this.id, this.role, this.content, this.createdAt});

  Messages.fromJson(Map<String, dynamic> json) {
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
