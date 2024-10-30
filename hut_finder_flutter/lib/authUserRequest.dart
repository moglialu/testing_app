import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthUserRequest extends StatefulWidget {
  final String accessToken;

  const AuthUserRequest({super.key, required this.accessToken});

  @override
  State<AuthUserRequest> createState() => _AuthUserRequestState();
}

class _AuthUserRequestState extends State<AuthUserRequest> {
  String responseText = "...";

  Future<void> fetchAuthData() async {
    final url = Uri.parse('http://localhost:8081/authuser');
    var headers = {
      'Authorization': 'Bearer ${widget.accessToken}',  // Use accessToken from parent widget
    };

    try {
      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        setState(() {
          responseText = responseBody;
        });
      } else {
        setState(() {
          responseText = "Failed to load data. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        responseText = "Error: $e";
      });
    }
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
              // Button on the left
              ElevatedButton(
                onPressed: fetchAuthData,
                child: const Text('Fetch Auth User'),
              ),
              const SizedBox(width: 20), // Space between button and response card

              // Card with response text on the right
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    responseText,
                    style: const TextStyle(fontSize: 10),
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
