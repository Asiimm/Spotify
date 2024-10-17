import 'package:capstone2/SpotifyApi/Screen.dart';
import 'package:capstone2/SpotifyApi/spotify_auth.dart';
import 'package:flutter/material.dart';
import '../loginSignup/widget/button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart'; // New package to handle web authentication flow

class SpotifyPage extends StatefulWidget {
  const SpotifyPage({super.key});

  @override
  State<SpotifyPage> createState() => _SpotifyPageState();
}

class _SpotifyPageState extends State<SpotifyPage> {
  final SpotifyAuth _spotifyAuth = SpotifyAuth(); // Initialize the SpotifyAuth instance

  Future<void> _connectToSpotify() async {
    try {
      // Launch the Spotify authorization URL with show_dialog=true to force re-authentication
      final authUrl =
          'https://accounts.spotify.com/authorize?client_id=${_spotifyAuth.clientId}&response_type=code&redirect_uri=${_spotifyAuth.redirectUri}&scope=user-read-private%20user-read-email&show_dialog=true';

      // Open the authorization URL in a browser
      final result = await FlutterWebAuth.authenticate(
          url: authUrl, callbackUrlScheme: 'https');

      // Extract the authorization code from the result (redirect URL)
      final code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        // Use the code to request an access token
        await _spotifyAuth.getAccessToken(code);
        // You can now make API calls using the access token
        print('Spotify account connected!');
      } else {
        print('Authorization failed or was canceled');
      }
    } catch (e) {
      print('Error during Spotify authentication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF492A87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Spotify(),
              ),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Spotify',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Connect your Spotify account to share your music playlist',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Regbutton(
                text: 'Connect to Spotify',
                onTab: _connectToSpotify, // Trigger Spotify authentication flow
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'By connecting your Spotify account, you consent to the collection, use, and disclosure of your data in accordance with the Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
