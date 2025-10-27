import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallProvider with ChangeNotifier {
  bool _isInCall = false;
  
  bool get isInCall => _isInCall;
  
  void initiateCall({
    required String receiverId,
    required String receiverName,
    required bool isVideoCall,
  }) {
    Get.snackbar(
      'Call Feature',
      'Video/Voice calling will be available with full Agora setup',
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }
}