import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

class LoginOAuth extends StatefulWidget {
  const LoginOAuth({super.key});

  @override
  State<LoginOAuth> createState() => _LoginOAuthState();
}

class _LoginOAuthState extends State<LoginOAuth> {
  final authorizationEndpoint = Uri.parse('http://localhost:8080/realms/myrealm/protocol/openid-connect/auth');
  final tokenEndpoint = Uri.parse('http://localhost:8080/realms/myrealm/protocol/openid-connect/token');
  final identifier = 'myclient';
  final secret = 'notNecessaryForPublicClients?';
  final redirectUrl = Uri.parse('http://localhost:8000/auth/callback');

  oauth2.Client? client;

  Future<void> authenticate() async {
    var grant = oauth2.AuthorizationCodeGrant(
      identifier, authorizationEndpoint, tokenEndpoint,
      secret: secret,
    );

    // Step 1: Get the authorization URL to launch in the browser
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

    // Step 2: Set up a server to listen for the redirect with the authorization code
    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
    await launchUrl(authorizationUrl); // Opens the authorization URL in the browser

    // Step 3: Wait for the response from the browser redirect
    var request = await server.first;
    var responseUrl = request.uri;

    // Close the server once we have the response
    request.response
      ..statusCode = 200
      ..headers.set('Content-Type', 'text/html')
      ..write('<html><h1>You can now return to the app</h1></html>');
    await request.response.close();
    await server.close();

    // Step 4: Handle the authorization response
    client = await grant.handleAuthorizationResponse(responseUrl.queryParameters);
    setState(() {}); // Update the UI after authentication
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () => authenticate(),
                child: const Text('Login via Keycloak OAuth2'),
              ),
              if (client != null) ...[
                Text('Logged in successfully!'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
