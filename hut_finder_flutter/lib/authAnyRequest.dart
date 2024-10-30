import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthAnyRequest extends StatefulWidget {
  final String accessToken;

  const AuthAnyRequest({super.key, required this.accessToken});

  @override
  State<AuthAnyRequest> createState() => _AuthAnyRequestState();
}

class _AuthAnyRequestState extends State<AuthAnyRequest> {
  String responseText = "...";

  Future<void> fetchAuthData() async {
    final url = Uri.parse('http://localhost:8081/auth');
    var headers = {
      'Authorization': 'Bearer ${widget.accessToken}',  // Use accessToken from parent widget
    };

    try {
      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          responseText = response.body;
        });
      } else {
        setState(() {
          responseText = "Failed to load data. Status: ${response.statusCode} - ${response.reasonPhrase ?? 'unknown Error'}";
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
                child: const Text('Fetch Auth'),
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
