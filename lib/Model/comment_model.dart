import 'package:disan/Model/user_model.dart';

class Comment {
  String? comment;
  UserModel? user;
  String? date;

  Comment({this.comment, this.user, this.date});

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    user = json['user'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['user'] = this.user;
    data['date'] = this.date;
    return data;
  }
}
