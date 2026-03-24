import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodtracker_app/routes.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      actions: [
        SignedOutAction((context) {
          //remove home screen from stack
          Navigator.of(context).pop();

          //navigate back to signin screen
          Navigator.of(context).pushNamed(startupScreen);
        }),
      ],
    );
  }
}
