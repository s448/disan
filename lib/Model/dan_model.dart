import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/user_model.dart';
import 'comment_model.dart';

class DanModel {
  String? id;
  UserModel? user;
  Timestamp? date;
  String? description;
  List<String>? imgs;
  int? likes;
  List<Comment>? comments;
  double? rating;
  bool? withRecord;
  bool? isReDaned;
  String? reDanner;
  List<dynamic>? likers = [];
  List<dynamic>? raters = [];

  DanModel({
    this.id,
    this.user,
    this.date,
    this.description,
    this.imgs,
    this.likes,
    this.comments,
    this.rating,
    this.withRecord,
    required this.likers,
    required this.raters,
    this.isReDaned,
    this.reDanner,
  });

  DanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    date = json['date'];
    description = json['description'];
    imgs = json['imgs'].cast<String>();
    likes = json['likes'];
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
    rating = json['rating'];
    withRecord = json['withrecord'];
    likers = json['likers'];
    raters = json['raters'];
    isReDaned = json['isredan'];
    reDanner = json['redanner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['date'] = this.date;
    data['description'] = this.description;
    data['imgs'] = this.imgs;
    data['likes'] = this.likes;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    data['withrecord'] = this.withRecord;
    data['likers'] = this.likers;
    data['raters'] = this.raters;
    data['isredan'] = this.isReDaned;
    data['redanner'] = this.reDanner;
    return data;
  }
}
