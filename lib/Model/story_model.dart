import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/user_model.dart';

class Story {
  String? id;
  UserModel? user;
  Timestamp? date;
  String? img;
  String? caption;
  // List<String>? mediaList;

  Story({this.user, this.date, this.img, this.id, this.caption});

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    img = json['img'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['date'] = this.date;
    data['img'] = this.img;
    data['caption'] = this.caption;
    return data;
  }
}
