import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyJobService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> applyJob({
    required String jobId,
    required String jobTitle,
    required String companyUid,
    required String companyName,
    required String username,
    required String email,
    required String phone,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }

    final exist = await _firestore
        .collection('applications')
        .where('userUid', isEqualTo: user.uid)
        .where('jobId', isEqualTo: jobId)
        .get();

    if (exist.docs.isNotEmpty) {
      throw Exception("Kamu sudah melamar pekerjaan ini");
    }

    await _firestore.collection('applications').add({
      'userUid': user.uid,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'companyUid': companyUid,
      'companyName': companyName,
      'username': username,
      'email': email,
      'phone': phone,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
