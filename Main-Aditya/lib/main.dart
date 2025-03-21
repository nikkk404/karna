import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cygiene_ui/helpers/pref.dart';
import 'package:cygiene_ui/home_view.dart';
import 'package:cygiene_ui/views/bottom_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wireguard_vpn/wireguard_vpn.dart';
import 'package:provider/provider.dart';
import 'controllers/AuthRedirectController.dart';
import 'entities/ProfileImage.dart';
import 'models/User.dart';
import 'models/authentication/FirebaseAuthServiceModel.dart';
import 'providers/vpn_provider.dart';
import 'views/auth_pages/forgot_password_page_view.dart';
import 'views/auth_pages/login_page_view.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();
  await Pref.initializeHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthServiceModel>(
          create: (_) => FirebaseAuthServiceModel(),
        ),
        Provider<UserData?>(
          create: (_) => FirebaseAuthServiceModel().getUserDetails(),
        ),
        Provider<ProfileImage?>(
          create: (_) => ProfileImage(null),
        ),
        ChangeNotifierProvider<VpnState>(create: (context) => VpnState()),
      ],
      child: GetMaterialApp(
        title: 'KARNA',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => const AuthRedirectController(),
          "/login": (context) => const LoginPageView(),
          "/forgotPassword": (context) => const ForgotPasswordView(),
          "/home": (context) => const BottomNavBar(),
        },
      ),
    );
  }
}
