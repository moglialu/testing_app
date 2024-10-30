import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PublicRequest extends StatefulWidget {
  const PublicRequest({super.key});

  @override
  State<PublicRequest> createState() => _PublicRequestState();
}

class _PublicRequestState extends State<PublicRequest> {
  String responseText = "Press the button to make a request.";

  // Function for the GET request
  Future<void> fetchPublicData() async {
    final url = Uri.parse('http://localhost:8081/public');

    try {
      final response = await http.get(url);

      setState(() {
        responseText = response.statusCode == 200
            ? response.body
            : "Failed to load data. Status: ${response.statusCode} - ${response.reasonPhrase}";
      });
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
            crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
            children: [
              // Button on the left
              ElevatedButton(
                onPressed: fetchPublicData,
                child: const Text('Fetch Public Data'),
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
