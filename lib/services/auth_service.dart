import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//logic email dan password
  Future<UserCredential> loginWithRoleCheck({
    required String email,
    required String password,
    required bool isCompanyLogin,
  }) async {
    try {
      ///LOGIN FIREBASE AUTH
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      ///AMBIL ROLE DARI FIRESTORE
      final role = await getUserRole(uid);

      ///VALIDASI ROLE
      if (isCompanyLogin && role != 'company') {
        await _auth.signOut();
        throw Exception('Akun ini bukan COMPANY');
      }

      if (!isCompanyLogin && role != 'user') {
        await _auth.signOut();
        throw Exception('Akun ini bukan JOB SEEKER');
      }

      ///RETURN USER
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        throw Exception('Email atau password salah');
      } else if (e.code == 'user-not-found') {
        throw Exception('Akun tidak ditemukan');
      } else if (e.code == 'invalid-email') {
        throw Exception('Format email tidak valid');
      } else {
        throw Exception(e.message ?? 'Login gagal');
      }
    }
  }

//register
  Future<User?> register(
      String email,
      String username,
      String password,
      String role,
      ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'username': username,
        'role': role, // user
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Registrasi gagal';
    } catch (e) {
      throw Exception(e.toString());
    }

  }


  ///cek role
  Future<String> getUserRole(String uid) async {
    final doc =
    await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User data not found');
    }

    return doc['role'];
  }

//google login
  Future<User?> signInWithGoogle(String role) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      await _saveUserIfNew(userCredential.user!, role);
      return userCredential.user;
    } catch (e) {
      throw "Login Google gagal";
    }
  }

//facebook login
  Future<User?> signInWithFacebook(String role) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        throw "Login Facebook dibatalkan";
      }

      final OAuthCredential credential =
      FacebookAuthProvider.credential(result.accessToken!.token);

      final userCredential =
      await _auth.signInWithCredential(credential);

      await _saveUserIfNew(userCredential.user!, role);
      return userCredential.user;
    } catch (e) {
      throw "Login Facebook gagal";
    }
  }

//save user data
  Future<void> _saveUserIfNew(User user, String role) async {
    final doc =
    await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'role': role,
        'createdAt': Timestamp.now(),
      });
    }
  }

//logout
  Future<void> logout() async {
    await _auth.signOut();

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

}