import 'package:flutter/material.dart';

//adding import statements for firebase connection
import 'package:firebase_core/firebase_core.dart';
import 'package:moodtracker_app/app_state.dart';
import 'package:moodtracker_app/screens/home_screen.dart';
import 'package:moodtracker_app/screens/login_screen.dart';
import 'package:moodtracker_app/screens/startup_screen.dart';
import 'firebase_options.dart';

//import local files
import 'package:moodtracker_app/routes.dart' as routes;

//firebase initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appState = ApplicationState();

  runApp(MainApp(appState: appState));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appState});

  final ApplicationState appState;

  @override
  Widget build(BuildContext context) {
    //upon app entry -> sign in button
    //if signed in, route to home
    //if not, login screen
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case routes.startupScreen:
            page = StartupScreen(appState: appState);
            break;

          case routes.loginScreen:
            page = LoginScreen();
            break;

          case routes.homeScreen:
            page = HomeScreen(appState: appState);
            break;

          default:
            page = StartupScreen(appState: appState);
        }
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}
