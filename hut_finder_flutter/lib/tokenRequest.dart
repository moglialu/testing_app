import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TokenRequest extends StatefulWidget {
  final Function(String) onTokenFetched; // Callback for passing token to parent
  final String username;
  final String password;

  const TokenRequest({super.key, required this.onTokenFetched, required this.username, required this.password});

  @override
  State<TokenRequest> createState() => _TokenRequestState();
}

class _TokenRequestState extends State<TokenRequest> {
  String accessToken = "";


  Future<void> fetchToken() async {
    print('Fetching token...');
    print(widget.username);
    final url = Uri.parse(
        'http://localhost:8080/realms/myrealm/protocol/openid-connect/token');

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var bodyFields = {
      'grant_type': 'password',
      'client_id': 'myclient',
      'client_secret': '9rA7bf5BceeafC8Hdi7NIBJCg8J1nF82',
      'username': widget.username,
      'password': widget.password,
    };

    try {
      var request = http.Request('POST', url)
        ..bodyFields = bodyFields
        ..headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        setState(() {
          accessToken = jsonResponse['access_token'] ?? "";
        });

        // Pass token back to parent widget
        widget.onTokenFetched(accessToken);
      } else {
        setState(() {
          accessToken = "";
        });
        widget.onTokenFetched(""); // Clear token in parent if request fails
      }
    } catch (e) {
      setState(() {
        accessToken = "";
      });
      widget.onTokenFetched(""); // Clear token in parent if there's an error
    }
  }

  void _clearAccessToken() {
    setState(() {
      accessToken = "";
    });
    widget.onTokenFetched(""); // Also clear token in the parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column of Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: fetchToken,
                    child: const Text('Fetch User Token'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _clearAccessToken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(width: 20),

              // Card to Display Access Token
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    accessToken.isNotEmpty
                        ? 'Access Token:\n$accessToken'
                        : 'Wrong Credentials',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
