// spotify_auth.dart

// Here you will implement the logic to handle the Spotify OAuth authentication.
// This may include methods to request an access token using the authorization code,
// storing the access token, and making API calls to get user data.

import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyAuth {
  final String clientId = 'b54219d1e27c409782f2d68118690250';
  final String clientSecret = 'ae2ef45cd190407a8de23d42118b60d2';
  final String redirectUri = 'https://firebasefitbitlink.page.link/Spotify';

  // Method to get access token from authorization code
  Future<void> getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      // Parse the access token and store it
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      // Use the access token to make API calls
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }
}
