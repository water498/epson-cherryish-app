class UserModel {

  String name;
  String? birth;
  String? phone;
  String email;
  int? created_time;
  int? updated_time;

  UserModel({
    required this.name,
    this.birth,
    this.phone,
    required this.email,
    this.created_time,
    this.updated_time,
  });

  // fromJson method to parse JSON into UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      birth: json['birth'],
      phone: json['phone'],
      email: json['email'],
      created_time: json['created_time'],
      updated_time: json['updated_time'],
    );
  }

  // toJson method to convert UserModel into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birth': birth,
      'phone': phone,
      'email': email,
      'created_time': created_time,
      'updated_time': updated_time,
    };
  }

}



