//contains: bottom navigation and display of either calendar, mood entry, or profile widget

import 'package:flutter/material.dart';
import 'package:moodtracker_app/app_state.dart';
import 'package:moodtracker_app/widgets/mood_entry_widget.dart';
import 'package:moodtracker_app/widgets/calendar_widget.dart';
import 'package:moodtracker_app/widgets/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.appState});

  final ApplicationState appState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final ApplicationState state = widget.appState;

  late final List<Widget> _displayWidgets = <Widget>[
    MoodEntryWidget(appState: state),
    CalendarWidget(appstate: state),
    ProfileWidget(),
  ];

  int _selectedIndex = 1;

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //body contains widget to display - mood entry, calendar, or profile info
      body: Center(child: _displayWidgets.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_present_rounded),
            label: 'Entry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[300],
        onTap: _itemTapped,
      ),
    );
  }
}
