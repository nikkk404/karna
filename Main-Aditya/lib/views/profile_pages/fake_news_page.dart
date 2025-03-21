import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FakeNewsPage extends StatefulWidget {
  const FakeNewsPage({super.key});

  @override
  State<FakeNewsPage> createState() => _FakeNewsPageState();
}

class _FakeNewsPageState extends State<FakeNewsPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://karna.pythonanywhere.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fake News Detection',
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
