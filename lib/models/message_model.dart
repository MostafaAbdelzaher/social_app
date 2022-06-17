import 'package:flutter/cupertino.dart';

class MessageModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? dateTime;
  String? messageImage;

  MessageModel({
    this.senderId,
    this.messageImage,
    this.receiverId,
    this.dateTime,
    this.text,
  });
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    messageImage = json['messageImage'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }
  Map<String, dynamic>? toMap() {
    return {
      "senderId": senderId,
      "messageImage": messageImage,
      "receiverId": receiverId,
      "dateTime": dateTime,
      "text": text,
    };
  }
}
