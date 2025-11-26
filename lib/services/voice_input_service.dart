// services/voice_input_service.dart
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceInputService {
  static final SpeechToText _speechToText = SpeechToText();
  static bool _isListening = false;
  static bool _isAvailable = false;

  static bool get isListening => _isListening;
  static bool get isAvailable => _isAvailable;

  static Future<bool> initialize() async {
    try {
      // Request microphone permission
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        return false;
      }

      // Initialize speech to text
      _isAvailable = await _speechToText.initialize(
        onStatus: (status) {
          _isListening = status == 'listening';
        },
        onError: (error) {
          print('Voice input error: $error');
          _isListening = false;
        },
      );

      return _isAvailable;
    } catch (e) {
      print('Failed to initialize voice input: $e');
      return false;
    }
  }

  static Future<void> startListening({
    required Function(String) onResult,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!_isAvailable) {
      await initialize();
    }

    if (_isAvailable && !_isListening) {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            final recognizedText = result.recognizedWords;
            final processedInput = _processVoiceInput(recognizedText);
            onResult(processedInput);
          }
        },
        listenFor: timeout,
        pauseFor: const Duration(seconds: 2),
        partialResults: false,
        localeId: 'en_US',
        listenMode: ListenMode.confirmation,
      );
    }
  }

  static Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
    }
  }

  static String _processVoiceInput(String input) {
    String processed = input.toLowerCase().trim();

    // Replace spoken words with calculator operations
    final replacements = {
      // Numbers
      'zero': '0', 'one': '1', 'two': '2', 'three': '3', 'four': '4',
      'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9',
      
      // Operations
      'plus': '+', 'add': '+', 'sum': '+',
      'minus': '-', 'subtract': '-', 'take away': '-',
      'times': '*', 'multiply': '*', 'multiplied by': '*',
      'divide': '/', 'divided by': '/', 'over': '/',
      
      // Functions
      'sine': 'sin', 'cosine': 'cos', 'tangent': 'tan',
      'natural log': 'ln', 'square root': 'sqrt',
      'factorial': '!', 'pi': 'pi', 'pie': 'pi',
      
      // Operations
      'equals': '=', 'equal': '=', 'calculate': '=',
      'clear': 'clear',
    };

    // Apply replacements
    for (final entry in replacements.entries) {
      processed = processed.replaceAll(entry.key, entry.value);
    }

    // Clean up extra spaces
    processed = processed.replaceAll(RegExp(r'\s+'), ' ').trim();
    return processed;
  }

  static Future<void> dispose() async {
    if (_isListening) {
      await stopListening();
    }
  }
}