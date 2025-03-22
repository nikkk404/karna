import 'package:flutter/material.dart';
import 'package:Karna_ui/views/profile_pages/cyber_helpline_page.dart';
import 'package:Karna_ui/views/profile_pages/fake_news_page.dart';
import 'package:Karna_ui/views/profile_pages/malicious_url_page.dart';
import 'package:Karna_ui/views/profile_pages/password_strength_page.dart';
import 'package:Karna_ui/views/profile_pages/incident_portal.dart';
import 'package:Karna_ui/views/widgets/chat_bot_page.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Features',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeatureCard(context, 'Malicious URL Detection', Icons.link,
              const MaliciousUrlPage()),
          _buildFeatureCard(context, 'Fake News Detection', Icons.article,
              const FakeNewsPage()),
          _buildFeatureCard(context, 'Cyber Helpline', Icons.phone,
              const CyberHelplinePage()),
          _buildFeatureCard(context, 'Password Strength', Icons.password,
              const PasswordStrengthPage()),
          _buildFeatureCard(context, 'Incident Reporting Portal',
              Icons.access_time, const IncidentPortal()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
