import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class faqs_view extends StatelessWidget {
  const faqs_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        backgroundColor: primaryColor,
        title: const Text(
          'FAQs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
          ),
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const ExpansionTile(
              title: Text(
                '1.  What is Karna?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    """Karna is a phone security app that helps protect your device by monitoring app permissions, detecting threats, and enhancing cybersecurity. Inspired by the resilient warrior Karna, it ensures your digital safety.""",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const ExpansionTile(
              title: Text(
                '2.  Why Karna?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    """Karna protects your phone like the legendary warrior, safeguarding your privacy and security by monitoring app permissions and detecting threats.""",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const ExpansionTile(
              title: Text(
                '3.  What is Mobile Security?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    """Mobile security protects your phone from threats like malware and data breaches. Key steps include strong passwords, regular updates, avoiding public Wi-Fi, and using antivirus software.""",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const ExpansionTile(
              title: Text(
                '4.  Why Security is important?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    """Our smartphones have become indispensable parts of our lives. They hold a treasure trove of personal information: contacts, photos, financial data, work documents, and even health records. This makes mobile security more critical than ever.""",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const ExpansionTile(
              title: Text(
                '5.  Tips to secure your mobile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    """Our smartphones are essential tools in today's digital world, but they also carry a lot of sensitive information. Here are 5 simple tips to keep your mobile phone secure.""",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
