// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiUser {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;

  ApiUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
  });

  factory ApiUser.fromMap(Map<String, dynamic> map) {
    return ApiUser(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      website: map['website'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }

  String toJson() => json.encode(toMap());

  factory ApiUser.fromJson(String source) =>
      ApiUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
