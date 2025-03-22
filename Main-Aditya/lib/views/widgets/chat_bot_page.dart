import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Karna_ui/views/services/mistral_service.dart';
import 'package:flutter/services.dart'; // For copying text
import 'package:speech_to_text/speech_to_text.dart' as stt; // For voice input

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  late stt.SpeechToText _speech; // Speech-to-text instance
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void sendMessage() async {
    String userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": userMessage});
    });

    _controller.clear();
    String botResponse = await MistralService().getResponse(userMessage);

    setState(() {
      messages.add({"role": "bot", "content": botResponse});
    });
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      });
    }
  }

  void stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Karna Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isUser = message["role"] == "user";
                return GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(
                        ClipboardData(text: message["content"] ?? ""));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Message copied to clipboard")),
                    );
                  },
                  child: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message["content"] ?? "",
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black)),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? stopListening : startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
