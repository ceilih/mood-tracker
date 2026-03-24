import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodtracker_app/routes.dart' as routes;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction((context, authState) {
          //switch statement for assigning user variable
          final user = switch (authState) {
            SignedIn state => state.user,
            UserCreated state => state.credential.user,
            _ => null,
          };

          if (user == null) {
            return;
          }

          if (authState is UserCreated) {
            user.updateDisplayName(user.email!.split('@').first);
          }

          //remove sign in from stack
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(routes.homeScreen);
        }),
      ],
    );
  }
}
