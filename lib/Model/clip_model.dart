import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:disan/Model/user_model.dart';

class ClipModel {
  String? id;
  UserModel? user;
  Timestamp? date;
  String? media;
  String? caption;
  List<Comment>? comments;
  List<dynamic>? likers = [];

  ClipModel({
    this.user,
    this.date,
    this.media,
    this.id,
    this.caption,
    this.comments,
  });

  ClipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    media = json['media'];
    caption = json['caption'];
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
    likers = json['likers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['media'] = this.media;
    data['date'] = this.date;
    data['caption'] = this.caption;
    data['likers'] = this.likers;
    return data;
  }
}
