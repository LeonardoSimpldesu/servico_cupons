import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trying_flutter/src/shared/models/user_model.dart';

class UserRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(UserModel user) async {
    await _collection.doc(user.id).set(user.toMap());
  }
  
  Future<UserModel?> getUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}