import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IncidentPortal extends StatefulWidget {
  const IncidentPortal({Key? key}) : super(key: key);

  @override
  _IncidentPortalState createState() => _IncidentPortalState();
}

class _IncidentPortalState extends State<IncidentPortal> {
  @override
  void initState() {
    super.initState();
    _launchCybercrimePortal();
  }

  Future<void> _launchCybercrimePortal() async {
    final Uri url = Uri.parse('https://cybercrime.gov.in/');
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Cybercrime portal")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Incident Portal',
          style: TextStyle(color: Colors.blue), // Text color changed to blue
        ),
        backgroundColor: Colors.white, // Background color changed to white
        iconTheme: const IconThemeData(
            color: Colors.blue), // Icon color changed to blue
      ),
      body: const Center(
        child: Text(
            'Loading Cybercrime Portal...'), // Optional: Display a loading message
      ),
    );
  }
}
