import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MaliciousUrlPage extends StatefulWidget {
  const MaliciousUrlPage({super.key});

  @override
  State<MaliciousUrlPage> createState() => _MaliciousUrlPageState();
}

class _MaliciousUrlPageState extends State<MaliciousUrlPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('MAL_URL'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Malicious URL Detection',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
