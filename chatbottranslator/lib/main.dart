import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const ChatBotApp());
}

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatBotPage(),
    );
  }
}

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final _translator = GoogleTranslator();
  final _speech = stt.SpeechToText();
  final _tts = FlutterTts();

  final _inputTextNotifier = ValueNotifier<String>('');

  String _selectedLanguage = 'en-GB';


  String _outputText = '';
  bool _isTranslating = false;
  bool _isListening = false;

  void _translate() async {
    setState(() {
      _isTranslating = true;
    });
    Translation translation =
    await _translator.translate(_inputTextNotifier.value, to: _selectedLanguage.substring(0,2));
    setState(() {
      _outputText = translation.text;
      _isTranslating = false;
    });
    _speakTranslation();
  }

  void _speakTranslation() async {
    await _tts.setLanguage(_selectedLanguage);
    await _tts.speak(_outputText);
  }

  void _startRecording() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _inputTextNotifier.value = result.recognizedWords;
          _translate();
        });
      });
    }
  }

  void _stopRecording() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot Translator'),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: const [
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/usa.png'), height: 20),
                value: 'en-US',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/uk.png'), height: 20),
                value: 'en-GB',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/spain.png'), height: 20),
                value: 'es',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/france.png'), height: 20),
                value: 'fr',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/brazil.png'), height: 20),
                value: 'pt-BR',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/germany.png'), height: 20),
                value: 'de',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/italy.png'), height: 20),
                value: 'it',
              ),
              DropdownMenuItem(
                child: Image(
                    image: AssetImage('assets/flags/japan.png'), height: 20),
                value: 'ja',
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _outputText,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Digite seu texto aqui',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputTextNotifier.value = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isListening = true;
                      });
                      _startRecording();
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isListening = false;
                      });
                      _stopRecording();
                    },
                    onTapCancel: () {
                      setState(() {
                        _isListening = false;
                      });
                      _stopRecording();
                    },
                    child: Center(
                      child: _isListening
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: _isTranslating
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.translate),
                  onPressed: _translate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}