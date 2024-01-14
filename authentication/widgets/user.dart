import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//
// class UserModel {
//   final String name;
//   final String email;
//   final String password;
//
//   const UserModel({
//     required this.name,
//     required this.email,
//     required this.password,
//   });
//
//   toJson() {
//     return {
//       'name': name,
//       'email': email,
//       'password': password,
//     };
//   }
//
//   factory UserModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     final data = document.data()!;
//
//     return UserModel(
//         name: data['name'], email: data['email'], password: data['password']);
//   }
// }

class User {
  final String name;
  final String email;
  final String password;

  const User({
    required this.name,
    required this.email,
    required this.password,
  });

  static User fromJson(Map<String, dynamic> json) => User(
      name: json['name'], email: json['email'], password: json['password']);
}

Future createUser(
    {required String username,
    required String useremail,
    required String password}) async {
  final docUsers =
      FirebaseFirestore.instance.collection('users').doc(useremail);

  final json = {
    'name': username,
    'email': useremail,
    'password': password,
  };

  await docUsers.set(json);
}

Future readUser({required String useremail}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(useremail);
  final snapshot = await docUser.get();

  if (snapshot.exists) {
    return User.fromJson(snapshot.data()!);
  }
}
