import 'package:shared_preferences/shared_preferences.dart';

class MyUser {
  // date
  static const String collectionName="user";
  String? id;
  String? name;
  String? email;

  MyUser({required this.id, required this.name, required this.email});

  // json=> object
  MyUser.fromJson(Map<String, dynamic>? data)
      : this(
            id: data?["id"] as String,
            name: data?["name"] as String,
            email: data?["email"] as String);

// object=>  json
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email};
  }
  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id!);
    await prefs.setString('name', name!);
    await prefs.setString('email', email!);
}


}
