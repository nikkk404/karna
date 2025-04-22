import 'dart:async';
import 'package:Karna_ui/navigation/parameters_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/profile_pages/profile_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Karna_ui/views/widgets/custom_clipper.dart';
import '../views/widgets/chat_bot_page.dart';
import 'views/profile_pages/AboutUsView.dart';
import 'package:flutter_wireguard_vpn/wireguard_vpn.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = Get.put(HomeController());
  final _wireguardFlutterPlugin = WireguardVpn();
  bool vpnActivate = false;
  Stats stats = Stats(totalDownload: 0, totalUpload: 0);
  final String initName = 'sakec-wire4';
  final String initAddress = "192.168.69.4/24";
  final String initPort = "51820";
  final String initDnsServer = "101.53.147.30";
  final String initPrivateKey = "CDi9IdHiYJmw9mCzgBb3EIoUR8JNINnbdsMz0gYz1lE=";
  final String initAllowedIp = "0.0.0.0/0, ::/0";
  final String initPublicKey = "FytzEla1nQkpfGAouJaM1eFKR1e5N9vbt24of2+iIHg=";
  final String initEndpoint = "115.113.39.74:51820";
  final String presharedKey = "iP4F07mNzTur0nJc71T/rDxaJpIOk+Ntg8xyJafW1AY=";

  late Timer _timer;
  int _vpnDurationInSeconds = 0;
  bool isVpnButtonClicked = false;

  @override
  void initState() {
    super.initState();
    vpnActivate ? _obtainStats() : null;
    _startVpnTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startVpnTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _vpnDurationInSeconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vpnState = Provider.of<VpnState>(context, listen: true);
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 350,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Color.fromARGB(255, 2, 85, 154)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Tap to connect",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(size.height),
                  onTap: () {
                    setState(() {
                      isVpnButtonClicked = !isVpnButtonClicked;
                      if (isVpnButtonClicked) {
                        vpnState.toggleConnection();
                        if (vpnState.isConnected) {
                          vpnState.startTimer();
                          _activateVpn(vpnState.isConnected, vpnState);
                        }
                      } else {
                        vpnState.stopTimer();
                        _activateVpn(vpnState.isConnected, vpnState);
                      }
                    });
                  },
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/vpn_button.jpg',
                        width: 80.0,
                        height: 80.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      size: 12,
                      color: vpnState.isConnected
                          ? Color.fromARGB(255, 6, 192, 12)
                          : Colors.redAccent,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      vpnState.isConnected ? 'Connected' : 'Disconnected',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: Material(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "KARNA Secure DNS",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 27,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Duration',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Download',
                            style: TextStyle(
                              color: Color(0xFF0299FB),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${stats.totalDownload}',
                            style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Mbps',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 3,
                        height: 70,
                        color: Color(0xFF666666),
                      ),
                      Column(
                        children: [
                          const Text(
                            'Upload',
                            style: TextStyle(
                              color: Color(0xFF0299FB),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${stats.totalUpload}',
                            style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Mbps',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      _formatDuration(_vpnDurationInSeconds),
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const parameters_logic(),
                  ),
                );
              },
              label: const Text(
                "Get Security Score",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              backgroundColor: Colors.blue,
              icon: const Icon(
                Icons.security,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: FloatingActionButton(
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
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _obtainStats() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final results = await _wireguardFlutterPlugin.tunnelGetStats(initName);
      setState(() {
        stats = results ?? Stats(totalDownload: 0, totalUpload: 0);
      });
    });
  }

  void _activateVpn(bool value, VpnState vpnState) async {
    final toastMsg = value
        ? 'You are now connected to KARNA Secure DNS'
        : 'You are now disconnected from KARNA Secure DNS';
    final toastColor = value ? Colors.greenAccent : Colors.redAccent.shade100;

    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    print(toastMsg); // Print message in console

    setState(() {
      vpnActivate = value;
      if (vpnActivate) {
        _obtainStats();
        if (vpnState.isConnected) {
          vpnState.startTimer();
        }
      } else {
        vpnState.stopTimer();
      }
    });

    if (vpnActivate) {
      _activateVpnBackground(vpnState);
    } else {
      // Disconnect VPN directly
      await _disconnectVpn();
      vpnState.disconnect(); // Update state
      print("VPN disconnected");
    }

    // Print connection status in console
    print("VPN is ${vpnActivate ? 'connected' : 'disconnected'}");
  }

  Future<void> _disconnectVpn() async {
    await _wireguardFlutterPlugin.changeStateParams(SetStateParams(
      state: false, // Disconnect
      tunnel: Tunnel(
        name: initName,
        address: initAddress,
        dnsServer: initDnsServer,
        listenPort: initPort,
        peerAllowedIp: initAllowedIp,
        peerEndpoint: initEndpoint,
        peerPublicKey: initPublicKey,
        privateKey: initPrivateKey,
        peerPresharedKey: presharedKey,
      ),
    ));
  }

  void _activateVpnBackground(VpnState vpnState) async {
    final results =
        await _wireguardFlutterPlugin.changeStateParams(SetStateParams(
      state: vpnActivate,
      tunnel: Tunnel(
        name: initName,
        address: initAddress,
        dnsServer: initDnsServer,
        listenPort: initPort,
        peerAllowedIp: initAllowedIp,
        peerEndpoint: initEndpoint,
        peerPublicKey: initPublicKey,
        privateKey: initPrivateKey,
        peerPresharedKey: presharedKey,
      ),
    ));

    setState(() {
      if (results ?? false) {
        if (vpnActivate) {
          vpnState.connect();
        } else {
          vpnState.disconnect();
        }
      } else {
        vpnState.disconnect();
      }
    });
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

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
