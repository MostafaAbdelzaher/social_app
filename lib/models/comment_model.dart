import 'package:flutter/cupertino.dart';

class CommentModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? commentText;
  String? commentImage;
  String? postId;
  CommentModel({
    this.name,
    this.uId,
    this.dateTime,
    this.commentText,
    this.image,
    this.commentImage,
    this.postId
  });
  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    postId = json['postId'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    commentText = json['commentText'];
    commentImage = json['commentImage'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "postId": postId,
      "uId": uId,
      "image": image,
      "dateTime": dateTime,
      "commentText": commentText,
      "commentImage": commentImage,
    };
  }
}
