class GetChatsResponseModel {
  List<Items>? items;
  int? page;
  int? pageSize;
  int? total;
  bool? hasNext;

  GetChatsResponseModel(
      {this.items, this.page, this.pageSize, this.total, this.hasNext});

  GetChatsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    page = json['page'];
    pageSize = json['page_size'];
    total = json['total'];
    hasNext = json['has_next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['page_size'] = this.pageSize;
    data['total'] = this.total;
    data['has_next'] = this.hasNext;
    return data;
  }
}

class Items {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;

  Items({this.id, this.title, this.createdAt, this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
