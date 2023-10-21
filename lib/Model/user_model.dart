class UserModel {
  String? name;
  String? id;
  String? whatsappNumber;
  String? token;
  String? bio;
  String? email;
  String? type;
  String? profile;
  String? background;
  double? lat;
  double? long;

  UserModel(
      {this.name,
      this.id,
      this.token,
      this.bio,
      this.email,
      this.type,
      this.profile,
      this.background,
      this.whatsappNumber,
      this.lat,
      this.long});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    whatsappNumber = json['whatsapp'];
    token = json['token'];
    bio = json['bio'];
    email = json['email'];
    type = json['type'];
    profile = json['profile'];
    background = json['background'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['whatsapp'] = this.whatsappNumber;
    data['token'] = this.token;
    data['bio'] = this.bio;
    data['email'] = this.email;
    data['type'] = this.type;
    data['profile'] = this.profile;
    data['background'] = this.background;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
