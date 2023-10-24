import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/user_model.dart';

class Comment {
  String? comment;
  UserModel? user;
  Timestamp? date;

  Comment({this.comment, this.user, this.date});

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['date'] = this.date;
    return data;
  }
}
