import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../widgets/display_section.dart';
import '../widgets/keypad_section.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  bool _isScientific = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (val) {
        debugPrint('Speech error: ${val.errorMsg}');
        if (mounted) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          _showSnackBar("Voice error: ${val.errorMsg}");
        }
      },
      onStatus: (status) {
        debugPrint('Speech status: $status');
        // When the speech recognizer stops (e.g. timeout), update state
        if (status == 'notListening' || status == 'done') {
          if (mounted && _isListening) {
            setState(() => _isListening = false);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }
      },
    );
  }

  void _listen() async {
    if (!_isListening) {
      // Request permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _showSnackBar("Microphone permission denied.");
        return;
      }

      // Re-initialize if needed
      if (!_speechAvailable) {
        _speechAvailable = await _speech.initialize();
      }

      if (_speechAvailable) {
        setState(() => _isListening = true);
        HapticFeedback.heavyImpact();
        _showSnackBar("LISTENING...", isPersistent: true);

        _speech.listen(
          onResult: (val) {
            // Only process the final result to avoid partial triggers
            if (val.finalResult && val.recognizedWords.isNotEmpty) {
              _processSpeechInput(val.recognizedWords);
            }
          },
          listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.confirmation,
            cancelOnError: true,
            partialResults: true,
          ),
        );
      } else {
        _showSnackBar("Speech recognition not available.");
      }
    } else {
      // Stop listening
      setState(() => _isListening = false);
      _speech.stop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _processSpeechInput(String input) {
    if (input.isEmpty) return;

    final calc = context.read<CalculatorProvider>();
    final theme = context.read<ThemeProvider>();
    
    // Advanced parsing: convert spoken words to math operators
    String expression = input.toLowerCase()
        .replaceAll('plus', '+')
        .replaceAll('add', '+')
        .replaceAll('minus', '-')
        .replaceAll('subtract', '-')
        .replaceAll('times', '*')
        .replaceAll('multiplied by', '*')
        .replaceAll('into', '*')
        .replaceAll('x', '*')
        .replaceAll('divided by', '/')
        .replaceAll('over', '/')
        .replaceAll('by', '/')
        .replaceAll('point', '.')
        .replaceAll('dot', '.')
        .replaceAll('open bracket', '(')
        .replaceAll('close bracket', ')')
        .replaceAll('open parenthesis', '(')
        .replaceAll('close parenthesis', ')')
        .replaceAll('percent', '%')
        .replaceAll(RegExp(r'[^0-9+\-*/(). %]'), '') // Only keep valid chars
        .replaceAll(' ', '');

    if (expression.isNotEmpty) {
      calc.setExpression(expression);
      calc.calculate(theme.decimalPrecision);
      HapticFeedback.lightImpact();
      _showSnackBar("HEARD: $expression");
    } else {
      _showSnackBar("Couldn't parse: \"$input\"");
    }

    // Stop listening after processing
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _showSnackBar(String text, {bool isPersistent = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (isPersistent) ...[
              Icon(Icons.graphic_eq, color: primary, size: 18),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(text, style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, 
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              )),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: isPersistent ? const Duration(seconds: 15) : const Duration(seconds: 2),
        backgroundColor: isDark 
            ? Theme.of(context).colorScheme.surfaceContainerHigh 
            : Colors.white,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        action: isPersistent ? SnackBarAction(
          label: 'STOP',
          textColor: Colors.redAccent,
          onPressed: () {
            setState(() => _isListening = false);
            _speech.stop();
          },
        ) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 20,
        title: Text(_isScientific ? 'SCIENTIFIC' : 'INFICALC'),
        actions: [
          IconButton(
            icon: Icon(_isScientific ? Icons.calculate : Icons.science),
            onPressed: () => setState(() => _isScientific = !_isScientific),
            tooltip: 'Toggle Scientific Mode',
          ),
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none, 
              color: _isListening ? Colors.redAccent : null,
            ),
            onPressed: _listen,
            tooltip: 'Voice Command',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const DisplaySection(),
          KeypadSection(isScientific: _isScientific),
        ],
      ),
    );
  }
}
