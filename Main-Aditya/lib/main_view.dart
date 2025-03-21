import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygiene_ui/views/installed_apps.dart';
import 'package:cygiene_ui/views/profile_pages/faqs_view.dart';
import 'package:flutter/material.dart';
import 'home_view.dart';
import 'models/User.dart';
import 'views/profile_pages/blogs_view.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeView(),
    const BlogsView(),
    const faqs_view(),
    const AppCheckExample()
  ];
  final List<void> methods = [];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeView();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserData?>(context);
    final Stream<DocumentSnapshot<Map>> userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .snapshots(includeMetadataChanges: true);

    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
    );
  }
}
