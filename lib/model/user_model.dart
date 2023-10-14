class UserModel {
  String? uid;
  String? name;
  String? email;
  String? image;

  UserModel({this.uid, this.name, this.email, this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}
