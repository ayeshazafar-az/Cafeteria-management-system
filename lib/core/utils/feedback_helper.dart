import 'package:flutter/services.dart';

class FeedbackHelper {
  /// Triggers a double-pulse heavy haptic vibration pattern & system audio alert
  static Future<void> triggerOrderReadyFeedback() async {
    // Primary heavy haptic pulse
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 140));

    // Secondary echo haptic pulse
    await HapticFeedback.vibrate();

    // Play native system alert sound chime
    await SystemSound.play(SystemSoundType.click);
  }

  /// Light selection click for interactive buttons
  static Future<void> triggerSelectionClick() async {
    await HapticFeedback.selectionClick();
  }
}
