import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String id;
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  int price;
  String videoUrl;
  List reviews;
  String reportURL;
  int purchaseCount;
  String category;

  ItemModel(
      {this.id,
      this.title,
      this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      this.videoUrl,
      this.reviews,
      this.reportURL,
      this.purchaseCount,
      this.category});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    videoUrl = json['tutorial'];
    reviews = json['reviews'];
    reportURL = json['report'];
    purchaseCount = json['purchaseCount'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data['tutorial'] = this.videoUrl;
    data['reviews'] = this.reviews;
    data['report'] = this.reportURL;
    data['purchaseCount'] = this.purchaseCount;
    data['category'] = this.category;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
