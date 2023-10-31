import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/user_model.dart';

class NotificationModel {
  String? title;
  String? id;
  String? body;
  UserModel? user;
  Timestamp? date;
  String? topic;
  DanModel? dan;

  NotificationModel({
    this.title,
    this.topic,
    required this.id,
    this.body,
    this.user,
    this.date,
    this.dan,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    topic = json['topic'];
    id = json['id'];
    body = json['body'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    dan = json['dan'] != null ? DanModel.fromJson(json['dan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['topic'] = this.topic;
    data['id'] = this.id;
    data['body'] = this.body;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['date'] = this.date;
    if (user != null) {
      data['dan'] = dan!.toJson();
    }
    return data;
  }
}
