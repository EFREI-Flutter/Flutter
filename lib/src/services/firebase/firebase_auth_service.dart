import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../interfaces/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _ensureUserDocument(User? user, {String? fallbackEmail}) async {
    if (user == null) return;
    final email = user.email ?? fallbackEmail ?? '';
    final doc = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot<Map<String, dynamic>>? snapshot;
    try {
      snapshot = await doc.get();
    } on FirebaseException {
      snapshot = null;
    }
    final payload = <String, dynamic>{
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (snapshot == null || !snapshot.exists) {
      payload['createdAt'] = FieldValue.serverTimestamp();
    }
    await doc.set(payload, SetOptions(merge: true));
  }

  @override
  Future<void> ensureTestUser({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _ensureUserDocument(credential.user, fallbackEmail: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await _ensureUserDocument(credential.user, fallbackEmail: email);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<String?> currentUserId() async {
    return _auth.currentUser?.uid;
  }

  @override
  Future<String?> currentUserEmail() async {
    return _auth.currentUser?.email;
  }

  @override
  Future<void> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _ensureUserDocument(credential.user, fallbackEmail: email);
  }

  @override
  Future<void> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _ensureUserDocument(credential.user, fallbackEmail: email);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
