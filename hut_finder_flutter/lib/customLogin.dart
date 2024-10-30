import 'package:flutter/material.dart';

class CustomLogin extends StatefulWidget {
  final Function(String username, String password) loginCallback;

  const CustomLogin({super.key, required this.loginCallback});

  @override
  State<CustomLogin> createState() => _CustomLoginState();
}

class _CustomLoginState extends State<CustomLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _submittedUsername = "";
  String _submittedPassword = "";

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Update state to show username and password in the card
    setState(() {
      _submittedUsername = username;
      _submittedPassword = password;
    });

    // Call the parent callback with username and password
    widget.loginCallback(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true, // Hide password input
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitLogin, // Call login function on press
                      child: const Text('Create Credentials'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // Space between the form and the card
        
            // Right side: Card to display username and password
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submitted Credentials',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Username: $_submittedUsername',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Password: $_submittedPassword',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
