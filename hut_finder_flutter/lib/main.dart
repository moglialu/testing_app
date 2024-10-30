import 'package:flutter/material.dart';
import 'package:hut_finder_flutter/authAnyRequest.dart';
import 'package:hut_finder_flutter/authUserRequest.dart';
import 'package:hut_finder_flutter/customLogin.dart';
import 'package:hut_finder_flutter/loginOauth.dart';
import 'package:hut_finder_flutter/publicRequest.dart';
import 'package:hut_finder_flutter/tokenRequest.dart';


import 'authCallbackPage.dart';
import 'authDevRequest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Requests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FetchDataPage(),
        '/auth/callback': (context) => AuthCallbackPage(),
      },
    );
  }
}

class FetchDataPage extends StatefulWidget {
  @override
  _FetchDataPageState createState() => _FetchDataPageState();
}

class _FetchDataPageState extends State<FetchDataPage> {
  String responseText = "Press a button to make a request.";
  String accessToken = "";

  String username = "";
  String password = "";

  void updateLogin(String newUsername, String newPassword) {
    setState(() {
      username = newUsername;
      password = newPassword;
    });
  }

  void updateAccessToken(String token) {
    setState(() {
      accessToken = token;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trigger Requests'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginOAuth(),
              const PublicRequest(),
              CustomLogin(loginCallback: updateLogin),
              TokenRequest(
                onTokenFetched: updateAccessToken,
                username: username,
                password: password,
              ),
              AuthAnyRequest(accessToken: accessToken),
              AuthUserRequest(accessToken: accessToken),
              AuthDevRequest(accessToken: accessToken),
            ],
          ),
        ),
      ),
    );
  }
}
