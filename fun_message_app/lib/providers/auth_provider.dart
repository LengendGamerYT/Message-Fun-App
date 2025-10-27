import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = result.user;
      
      if (_user != null) {
        await _updateUserStatus(true);
        Get.offAllNamed('/home');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      Get.snackbar(
        'Login Error',
        _errorMessage!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    String username,
  ) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      
      // Check if username is already taken
      final usernameExists = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .get();
      
      if (usernameExists.docs.isNotEmpty) {
        _errorMessage = 'This username is already taken';
        Get.snackbar(
          'Registration Error',
          _errorMessage!,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = result.user;
      
      if (_user != null) {
        await _user!.updateDisplayName(displayName);
        await _createUserProfile(displayName, email, username);
        await _updateUserStatus(true);
        
        Get.offAllNamed('/home');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      Get.snackbar(
        'Registration Error',
        _errorMessage!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _createUserProfile(String displayName, String email, String username) async {
    await _firestore.collection('users').doc(_user!.uid).set({
      'uid': _user!.uid,
      'displayName': displayName,
      'email': email,
      'username': username.toLowerCase(),
      'photoURL': '',
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updateUserStatus(bool isOnline) async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    try {
      await _updateUserStatus(false);
      await _auth.signOut();
      _user = null;
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'username-already-exists':
        return 'This username is already taken';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}