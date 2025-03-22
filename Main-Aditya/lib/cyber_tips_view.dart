import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'views/widgets/chat_bot_page.dart';

class NewsApiService {
  static const _apiKey = 'YOUR_API_KEY';
  static const _baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> fetchCyberNews() async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/everything?q=cybersecurity OR digital forensics OR cyber fraud&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      throw Exception(
          'Failed to load news. Status Code: ${response.statusCode}');
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  late Future<List<dynamic>> _newsArticles;

  @override
  void initState() {
    super.initState();
    _newsArticles = _newsApiService.fetchCyberNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cyber News',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _newsArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found.'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return NewsTile(article: article);
              },
            );
          }
        },
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
}

class NewsTile extends StatelessWidget {
  final dynamic article;

  const NewsTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final imageUrl = article['urlToImage'];
    final title = article['title'] ?? 'No Title';
    final description = article['description'];
    final url = article['url'];

    return ListTile(
        leading: imageUrl != null
            ? Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image, size: 50),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          description ?? 'No description available',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          final title = article['title'] ?? 'No Title';
          final description =
              article['description'] ?? 'No description available.';
          final imageUrl = article['urlToImage'];
          final url = article['url'];

          if (url != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(
                  title: title,
                  description: description,
                  imageUrl: imageUrl,
                  url: url,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No URL available for this article.')),
            );
          }
        });
  }
}

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final String url;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Detail',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100),
                ),
              )
            else
              const Icon(Icons.image, size: 100),
            const SizedBox(height: 16),
            Text(
              description.isNotEmpty
                  ? description
                  : 'No description available for this article.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchURL(url);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Read Full Article',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
