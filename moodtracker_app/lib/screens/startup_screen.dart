import 'package:flutter/material.dart';
import 'package:moodtracker_app/app_state.dart';
import 'package:moodtracker_app/routes.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key, required this.appState});

  final ApplicationState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Mood Tracker'),
            ElevatedButton(onPressed: () {
              if(appState.isLoggedIn) {
                Navigator.of(context).pushNamed(homeScreen);
              } else {
                Navigator.of(context).pushNamed(loginScreen);
              }
            }, child: Text('Sign In'))
          ],
        ),
      ),
    );
  }
}