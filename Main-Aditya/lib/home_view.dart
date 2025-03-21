import 'package:cygiene_ui/navigation/parameters_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cygiene_ui/screens/location_screen.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../services/vpn_engine.dart';
import 'views/widgets/count_down_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/profile_pages/profile_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cygiene_ui/views/widgets/custom_clipper.dart';
import '../views/widgets/chat_bot_page.dart';
import 'views/profile_pages/AboutUsView.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KARNA',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _vpnButton(context),
            const SizedBox(height: 20),
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    _controller.vpnState.value == VpnEngine.vpnDisconnected
                        ? 'Not Connected'
                        : _controller.vpnState
                            .replaceAll('_', ' ')
                            .toUpperCase(),
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )),
            const SizedBox(height: 20),
            Obx(() => CountDownTimer(
                startTimer:
                    _controller.vpnState.value == VpnEngine.vpnConnected)),
            const SizedBox(height: 20),
            _changeLocation(context),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const parameters_logic()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .04),
                minimumSize: const Size(double.infinity, 60),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    'Get Security Score',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.keyboard_arrow_right_rounded,
                        color: Colors.blue, size: 26),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _vpnButton(BuildContext context) => Obx(() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    width: MediaQuery.of(context).size.height * .14,
                    height: MediaQuery.of(context).size.height * .14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.power_settings_new,
                          size: 28,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _controller.getButtonText,
                          style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ));

  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          button: true,
          child: TextButton(
            onPressed: () => Get.to(() => LocationScreen()),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .04),
              minimumSize: const Size(double.infinity, 60),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.globe, color: Colors.white, size: 28),
                const SizedBox(width: 10),
                const Text(
                  'Change Location',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.keyboard_arrow_right_rounded,
                      color: Colors.blue, size: 26),
                )
              ],
            ),
          ),
        ),
      );

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user.displayName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email ?? 'example@gmail.com',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text(
              'About Us',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.blue),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Fluttertoast.showToast(msg: 'Logged out');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
