import 'package:cygiene_ui/views/widgets/animated_counter_widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_device/safe_device.dart';
import 'dart:async';
import 'package:screen_lock_check/screen_lock_check.dart';

var parameters_list = [];
var parameters_val = [];
var parameters_value = [];

class parameters_logic extends StatefulWidget {
  const parameters_logic({super.key});

  @override
  State<parameters_logic> createState() => _parameters_logicState();
}

class _parameters_logicState extends State<parameters_logic> {
  MethodChannel settingsChannel =
      const MethodChannel("samples.flutter.dev/settings");
  MethodChannel bluetoothChannel =
      const MethodChannel("samples.flutter.dev/bluetooth");
  MethodChannel gpsChannel = const MethodChannel("samples.flutter.dev/gps");
  MethodChannel nfcChannel = const MethodChannel("samples.flutter.dev/nfc");

  int score = 0;
  bool nfcStatus = false;
  bool gps_enabled = false;
  bool bluetoothStatus = false;
  bool _isJailBroken = false;
  bool isDevelopmentModeEnable = false;
  bool _isScreenLockEnabled = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    score_card();
    getBluetoothStatus();
    getGpsStatus();
    getNfcStatus();
  }

  Future<void> initPlatformState() async {
    bool isScreenLockEnabled = false;
    bool isJailBroken = false;

    if (!mounted) return;

    try {
      isJailBroken = await SafeDevice.isJailBroken;
      parameters_list.add('Rooted_device');
      parameters_val.add(isJailBroken ? 0 : 3);
      parameters_value.add(isJailBroken);

      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
      parameters_list.add('Developer_options');
      parameters_val.add(isDevelopmentModeEnable ? 0 : 2);
      parameters_value.add(isDevelopmentModeEnable);

      isScreenLockEnabled = await ScreenLockCheck().isScreenLockEnabled;
      parameters_list.add('Screen_lock');
      parameters_val.add(isScreenLockEnabled ? 2 : 0);
      parameters_value.add(isScreenLockEnabled);
    } catch (error) {
      print(error);
    }

    setState(() {
      _isJailBroken = isJailBroken;
      isDevelopmentModeEnable = isDevelopmentModeEnable;
      _isScreenLockEnabled = isScreenLockEnabled;
    });
  }

  Future<void> getBluetoothStatus() async {
    try {
      bluetoothStatus =
          await bluetoothChannel.invokeMethod("getBluetoothStatus");
      parameters_list.add('Bluetooth status');
      parameters_val.add(bluetoothStatus ? 0 : 1);
      parameters_value.add(bluetoothStatus);
      setState(() {});
    } catch (e) {
      print("Error getting Bluetooth status: $e");
    }
  }

  Future<void> getGpsStatus() async {
    try {
      gps_enabled = await gpsChannel.invokeMethod("getGpsStatus");
      parameters_list.add('Location');
      parameters_val.add(gps_enabled ? 0 : 1);
      parameters_value.add(gps_enabled);
      setState(() {});
    } catch (e) {
      print("Error getting GPS status: $e");
    }
  }

  Future<void> getNfcStatus() async {
    try {
      nfcStatus = await nfcChannel.invokeMethod("getNfcStatus");
      parameters_list.add('NFC status');
      parameters_val.add(nfcStatus ? 0 : 1);
      parameters_value.add(nfcStatus);
      setState(() {});
    } catch (e) {
      print("Error getting NFC status: $e");
    }
  }

  Future<void> score_card() async {
    setState(() {
      score = screen();
    });
  }

  int screen() {
    int totalScore = 0;

    for (int i = 0; i < parameters_val.length; i++) {
      totalScore += parameters_val[i] as int;
    }
    parameters_list = [];
    parameters_val = [];
    parameters_value = [];

    return totalScore;
  }

  Future<void> navigateToSettings(String setting) async {
    try {
      await settingsChannel
          .invokeMethod("navigateToSettings", {"setting": setting});
    } catch (e) {
      print("Error navigating to settings: $e");
    }
  }

  final Color enabledColor = const Color.fromARGB(255, 6, 192, 12);
  final Color disabledColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 111, 173),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        title: const Text(
          'Karna Score',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 1, 61, 84),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
              Lottie.asset(
                "assets/white.json",
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .20,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedCountingText(
                    targetScore: score,
                    duration: const Duration(
                      seconds: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          buildCard(
            icon: Icons.android,
            title: 'Rooted device',
            status: _isJailBroken ? "Yes" : "No",
            color: _isJailBroken ? disabledColor : enabledColor,
            description:
                'Rooting a smartphone gives you more control but increases security risks.',
            setting: null,
          ),
          buildCard(
            icon: Icons.lock,
            title: 'Screen Lock',
            status: _isScreenLockEnabled ? "Enabled" : "Disabled",
            color: _isScreenLockEnabled ? enabledColor : disabledColor,
            description:
                'Disabling screen lock increases the risk of unauthorized access to personal data.',
            setting: "screen_lock",
          ),
          buildCard(
            icon: Icons.developer_mode,
            title: 'Developer Options',
            status: isDevelopmentModeEnable ? "Enabled" : "Disabled",
            color: isDevelopmentModeEnable ? disabledColor : enabledColor,
            description:
                'Enabling Developer Options provides advanced features but comes with risks.',
            setting: "developer_options",
          ),
          buildCard(
            icon: Icons.nfc_outlined,
            title: 'NFC',
            status: nfcStatus ? "Enabled" : "Disabled",
            color: nfcStatus ? disabledColor : enabledColor,
            description:
                'NFC allows wireless communication but carries risks like unauthorized data access.',
            setting: "nfc",
          ),
          buildCard(
            icon: Icons.location_pin,
            title: 'Location',
            status: gps_enabled ? "Enabled" : "Disabled",
            color: gps_enabled ? disabledColor : enabledColor,
            description:
                'Using location services can compromise privacy and expose personal data.',
            setting: "location",
          ),
          buildCard(
            icon: Icons.bluetooth,
            title: 'Bluetooth Status',
            status: bluetoothStatus ? "Enabled" : "Disabled",
            color: bluetoothStatus ? disabledColor : enabledColor,
            description:
                'Bluetooth offers connectivity but carries risks like unauthorized access.',
            setting: "bluetooth",
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required IconData icon,
    required String title,
    required String status,
    required Color color,
    required String description,
    String? setting,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 44, 41, 41),
          size: 35,
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: '$title: ',
                style: const TextStyle(color: Colors.blue),
              ),
              TextSpan(
                text: status,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
        children: [
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 1, 61, 84),
                    fontSize: 15,
                  ),
                ),
                if (setting != null)
                  ElevatedButton(
                    onPressed: () => navigateToSettings(setting),
                    child: const Text("Go to Settings"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
