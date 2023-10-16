class UserModle {
  String? name;
  String? id;
  String? password;
  String? email;
  String? type;
  String? profile;
  String? background;

  UserModle(
      {this.name,
      this.id,
      this.password,
      this.email,
      this.type,
      this.profile,
      this.background});

  UserModle.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    password = json['password'];
    email = json['email'];
    type = json['type'];
    profile = json['profile'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['password'] = this.password;
    data['email'] = this.email;
    data['type'] = this.type;
    data['profile'] = this.profile;
    data['background'] = this.background;
    return data;
  }
}
