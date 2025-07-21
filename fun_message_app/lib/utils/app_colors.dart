import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF4CAF50);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Message Colors
  static const Color sentMessageColor = Color(0xFF2196F3);
  static const Color receivedMessageColor = Color(0xFFE3F2FD);
  
  // Status Colors
  static const Color onlineColor = Color(0xFF4CAF50);
  static const Color offlineColor = Color(0xFF9E9E9E);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  
  // Call Colors
  static const Color callAcceptColor = Color(0xFF4CAF50);
  static const Color callDeclineColor = Color(0xFFF44336);
  static const Color callEndColor = Color(0xFFF44336);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}