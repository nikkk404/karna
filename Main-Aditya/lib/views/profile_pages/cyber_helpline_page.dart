import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline {
  final String name;
  final String number;

  Helpline({required this.name, required this.number});
}

class CyberHelplinePage extends StatefulWidget {
  const CyberHelplinePage({Key? key}) : super(key: key);

  @override
  _CyberHelplinePageState createState() => _CyberHelplinePageState();
}

class _CyberHelplinePageState extends State<CyberHelplinePage> {
  String _searchQuery = '';
  List<Helpline> _filteredHelplines = [];

  @override
  void initState() {
    super.initState();
    _filteredHelplines = _helplines;
  }

  final List<Helpline> _helplines = [
    Helpline(name: 'National Cyber Crime Reporting Portal', number: '1930'),
    Helpline(name: 'Cybercrime Helpline Number', number: '155260'),
    Helpline(name: 'National Emergency Number', number: '112'),
    Helpline(name: 'Police', number: '100'),
    Helpline(name: 'Women Helpline', number: '1091'),
    Helpline(name: 'Child Helpline', number: '1098'),
    Helpline(name: 'Senior Citizen Helpline', number: '14567'),
    Helpline(name: 'Ambulance', number: '108'),
    Helpline(name: 'Railway Helpline', number: '139'),
    Helpline(name: 'Mental Health Helpline - KIRAN', number: '1800-599-0019'),
  ];

  void _filterHelplines() {
    setState(() {
      _filteredHelplines = _helplines
          .where((helpline) =>
              helpline.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              helpline.number.contains(_searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cyber & Other Helplines',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterHelplines();
              },
              decoration: const InputDecoration(
                hintText: 'Search helpline...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredHelplines.length,
              itemBuilder: (context, index) {
                final helpline = _filteredHelplines[index];
                return ListTile(
                  title: Text(helpline.name),
                  subtitle: Text(helpline.number),
                  trailing: IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () async {
                      final url = Uri.parse('tel:${helpline.number}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Could not launch phone app")),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
