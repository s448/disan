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
  DanModel? order;

  NotificationModel({
    this.title,
    this.topic,
    required this.id,
    this.body,
    this.user,
    this.date,
    this.order,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    topic = json['topic'];
    id = json['id'];
    body = json['body'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    order = json['order'];
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
    data['order'] = this.order;
    return data;
  }
}
