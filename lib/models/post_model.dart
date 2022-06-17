import 'package:flutter/cupertino.dart';

class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? Text;
  String? postImage;
  PostModel({
    this.name,
    this.uId,
    this.dateTime,
    this.Text,
    this.image,
    this.postImage,
  });
  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    Text = json['Text'];
    postImage = json['postImage'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "uId": uId,
      "image": image,
      "dateTime": dateTime,
      "Text": Text,
      "postImage": postImage,
    };
  }
}
