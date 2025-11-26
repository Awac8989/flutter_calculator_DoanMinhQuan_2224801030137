// utils/haptic_feedback_helper.dart
import 'package:flutter/services.dart';

class HapticFeedbackHelper {
  static bool _isEnabled = true;

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  static void lightImpact() {
    if (_isEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  static void mediumImpact() {
    if (_isEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  static void heavyImpact() {
    if (_isEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  static void selectionClick() {
    if (_isEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  // Custom feedback patterns for calculator operations
  static void numberInput() {
    lightImpact();
  }

  static void operationInput() {
    mediumImpact();
  }

  static void calculate() {
    heavyImpact();
  }

  static void clear() {
    selectionClick();
  }

  static void error() {
    // Double tap for error indication
    Future.delayed(Duration.zero, () {
      mediumImpact();
      Future.delayed(const Duration(milliseconds: 100), () {
        mediumImpact();
      });
    });
  }
}