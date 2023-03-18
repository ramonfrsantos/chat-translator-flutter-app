import 'package:flutter/foundation.dart';
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

  final TextEditingController _inputTextController = TextEditingController();
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
          _inputTextController.text = result.recognizedWords;
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
        title: const Text(
          'ChatBot Translator',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline (
              child: DropdownButton<String>(
                value: _selectedLanguage,
                borderRadius: BorderRadius.circular(20),
                icon: null,
                autofocus: false,
                focusColor: const Color.fromRGBO(0, 0, 0, 0.0),
                underline: null,
                elevation: 4,
                items: [
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/usa.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'English (US)',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'en-US',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/uk.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'English (UK)',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'en-GB',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/spain.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'Español',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'es',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/france.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'Français',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'fr',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/brazil.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'Português (BR)',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'pt-BR',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/germany.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'Deutsch',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'de',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/italy.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'Italiano',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'it',
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: const [
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/flags/japan.png'),
                          height: 30,
                        ),
                        SizedBox(width: 25),
                        Text(
                          '日本語',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    value: 'ja',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
            ),
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
                    controller: _inputTextController,
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