import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportController extends GetxController {
  final feedbackText = ''.obs;
  final feedbackType = 'suggestion'.obs; // 'suggestion' or 'issue'
  
  final email = 'yasinkhan2856@gmail.com';
  
  void setFeedbackType(String type) {
    feedbackType.value = type;
  }
  
  void updateFeedbackText(String text) {
    feedbackText.value = text;
  }
  
  void submitFeedback() {
    if (feedbackText.value.isNotEmpty) {
      // In a real app, this would send to backend
      Get.snackbar(
        'Thank You!',
        'Your feedback has been submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      feedbackText.value = '';
    } else {
      Get.snackbar(
        'Error',
        'Please enter your feedback before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
