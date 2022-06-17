import 'package:flutter/cupertino.dart';

class SocialUserModel {
  String? email;
  String? name;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;
  SocialUserModel({
    this.name,
    this.uId,
    this.phone,
    this.email,
    this.image,
    this.cover,
    this.bio,
    this.isEmailVerified,
  });
  SocialUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    uId = json['uId'];
    phone = json['phone'];
    email = json['email'];
    isEmailVerified = json["isEmailVerified"];
  }
  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "email": email,
      "image": image,
      "cover": cover,
      "bio": bio,
      "phone": phone,
      "uId": uId,
      "isEmailVerified": isEmailVerified,
    };
  }
}
