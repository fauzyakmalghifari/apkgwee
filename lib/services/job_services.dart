import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addJob({
    required String title,
    required String description,
    required String salary,
    required String location,
    required String category,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    if (user.uid.isEmpty) {
      throw Exception('UID company tidak valid');
    }

    final userDoc =
    await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      throw Exception('Data company tidak ditemukan');
    }

    if (userDoc.data()?['role'] != 'company') {
      throw Exception('Akun ini bukan company');
    }

    final companyName = userDoc.data()?['companyName'];

    if (companyName == null || companyName.toString().isEmpty) {
      throw Exception('Nama company belum diisi');
    }

    await _firestore.collection('jobs').add({
      'title': title,
      'description': description,
      'salary': salary,
      'location': location,
      'category': category,
      'companyUid': user.uid,
      'companyName': companyName,

      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
