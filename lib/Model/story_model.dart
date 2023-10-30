import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/user_model.dart';

class Story {
  UserModel? user;
  Timestamp? date;
  List<dynamic>? mediaList;

  Story({this.user, this.date});

  Story.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    mediaList = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['date'] = this.date;
    data['media'] = this.mediaList;
    return data;
  }
}
