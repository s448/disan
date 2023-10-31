import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/user_model.dart';

class OrderModel {
  String? id;
  UserModel? user;
  Timestamp? date;
  String? topic;
  DanModel? dan;

  OrderModel({
    this.topic,
    required this.id,
    this.user,
    this.date,
    this.dan,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    dan = json['dan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['id'] = this.id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['date'] = this.date;
    data['dan'] = this.dan;
    return data;
  }
}
