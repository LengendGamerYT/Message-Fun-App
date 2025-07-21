import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<dynamic> _users = [];
  bool _isLoading = false;
  
  List<dynamic> get users => _users;
  bool get isLoading => _isLoading;
  
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    _users = [
      {'displayName': 'Sample User', 'isOnline': true, 'statusText': 'Online'},
    ];
    
    _isLoading = false;
    notifyListeners();
  }
}