import 'package:capstone2/SpotifyApi/Screen.dart';
import 'package:capstone2/SpotifyApi/spotify_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capstone2/logs/logs.dart';
import 'package:capstone2/permission/permission.dart';
import 'package:capstone2/sync/sync.dart';
import 'package:capstone2/loginSignup/screen/account.dart';
import 'package:capstone2/loginSignup/screen/login.dart';
import 'package:capstone2/loginSignup/screen/forget.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:capstone2/loginSignup/screen/email_verification.dart';
import 'package:capstone2/Services/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks(); // Initialize dynamic links
  }

  // Initialize dynamic links
  Future<void> initDynamicLinks() async {
    // Handle initial link
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDynamicLink(initialLink);

    // Handle incoming links while the app is in the foreground
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print('Error processing dynamic link: $error');
    });
  }

  // Handle deep links
  void _handleDynamicLink(PendingDynamicLinkData? dynamicLinkData) async {
    final Uri? deepLink = dynamicLinkData?.link;

    if (deepLink != null) {
      // Log the deep link for debugging
      print('Deep Link: $deepLink');

      final code = deepLink.queryParameters['code'];
      if (code != null) {
        print('Authorization Code: $code');
        // Call SpotifyAuthService to exchange the code for an access token
        await SpotifyAuth().getAccessToken(code);
      } else {
        print('No authorization code found in the dynamic link.');
      }
    } else {
      print('No deep link found.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: {
        'account': (context) => Account(),
        'forget': (context) => ForgetPassword(),
        'home_screen': (context) => const HomeScreen(),
        'login': (context) => const Login(),
        'email_verification': (context) => EmailVerification(),
        'sync': (context) => Sync(),
        'logs': (context) => Logs(),
        'permission': (context) => Permission(),
        //   'screen': (context) => Spotify(),
      },
    );
  }
}
