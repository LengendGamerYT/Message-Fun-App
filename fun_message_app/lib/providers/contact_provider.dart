import 'package:flutter/material.dart';

class ContactProvider with ChangeNotifier {
  List<dynamic> _contacts = [];
  
  List<dynamic> get contacts => _contacts;
  
  Future<void> loadContacts() async {
    // Simulate loading contacts
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }
  
  Future<dynamic> getUserByUsername(String username) async {
    // Simulate user search
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }
  
  Future<bool> addContact(dynamic user) async {
    // Simulate adding contact
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}