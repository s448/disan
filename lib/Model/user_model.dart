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
  List<dynamic>? categories = [];
  double? rating;
  List<dynamic>? raters = [];
  List<dynamic>? followers = [];
  List<dynamic>? following = [];
  List<dynamic>? muted = [];
  List<dynamic>? blocked = [];
  bool? waHiden;
  List<dynamic>? waAllowed = [];

  UserModel({
    this.name,
    this.id,
    this.token,
    this.bio,
    this.email,
    this.type,
    this.profile,
    this.background,
    this.whatsappNumber,
    this.lat,
    this.long,
    this.categories,
    this.rating,
    this.raters,
    this.followers,
    this.following,
    this.muted,
    this.blocked,
    this.waAllowed,
    this.waHiden,
  });

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
    categories = json['categories'];
    rating = json['rating'];
    raters = json['raters'];
    following = json['following'];
    followers = json['followers'];
    muted = json['muted'];
    blocked = json['blocked'];
    waAllowed = json['waallowed'];
    waHiden = json['wahiden'];
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
    data['categories'] = this.categories;
    data['rating'] = this.rating;
    data['raters'] = this.raters;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['muted'] = this.muted;
    data['blocked'] = this.blocked;
    data['waallowed'] = this.waAllowed;
    data['wahiden'] = this.waHiden;
    return data;
  }
}
