import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user;
    } catch (e) {
      throw Exception('Sign-in failed: ${e.toString()}');
    }
  }

  // Sign up and create user document
  Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Create Firestore user document
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return cred.user;
    } catch (e) {
      throw Exception('Sign-up failed: ${e.toString()}');
    }
  }

  // Add habit with optional deadline
  Future<void> addHabit(String title, String description, [DateTime? deadline]) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.collection('habits').add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      if (deadline != null) 'deadline': deadline,
    });
  }

  // Fetch habits with ID and optional deadline
  Future<List<Map<String, dynamic>>> fetchUserHabits() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final habitsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .get();

    return habitsSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'] ?? '',
        'description': data['description'] ?? '',
        'deadline': data['deadline'],
        'createdAt': data['createdAt'],
      };
    }).toList();
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Add inside the FirebaseService class

  Future<void> updateHabitStatus(String habitId, bool isCompleted) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .doc(habitId)
        .update({'isCompleted': isCompleted});
  }

  Future<void> deleteHabit(String habitId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }



  // Get current user
  User? get currentUser => _auth.currentUser;
}
