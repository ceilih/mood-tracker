import 'package:flutter/material.dart';
import 'package:moodtracker_app/app_state.dart';
import 'package:moodtracker_app/models/mood_entry.dart';

class MoodEntryWidget extends StatefulWidget {
  const MoodEntryWidget({super.key, required this.appState});

  final ApplicationState appState;

  @override
  State<MoodEntryWidget> createState() => _MoodEntryWidgetState();
}

class _MoodEntryWidgetState extends State<MoodEntryWidget> {
  final _formkey = GlobalKey<FormState>();

  final _moodController = TextEditingController();
  //does this need to be some sort of DatePickerController(); ?
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();



  //resource for dropdownbuttonformfield
  //https://medium.com/@punithsuppar7795/understanding-dropdownbuttonformfield-flutter-98d46469e2cb

  //selection options for mood
  final List<DropdownMenuItem<String>> moodOptions =
      [
            'Select mood...',
            'Happy',
            'Excited',
            'Calm',
            'Neutral',
            'Sad',
            'Nervous',
            'Angry',
          ]
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList();

  //selected mood
  final String _initialMood = 'Select mood...';
  late String _moodSelect;

  //first and last dates for calendar
  final DateTime _firstDate = DateTime(2020);
  final DateTime _lastDate = DateTime(2100);

  void _dateSelector() {
    showDatePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _moodController.dispose();
    _notesController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: Column(
            //adjusts spacing between form items
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mood Entry'),

              //mood entry field
              DropdownButtonFormField<String>(
                initialValue: _initialMood,
                items: moodOptions,
                onChanged: (value) {
                  setState(() {
                    _moodSelect = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value == _initialMood) {
                    return 'Must select mood';
                  }
                  return null;
                },
              ),
              
              GestureDetector(
                child: TextFormField(
                  controller: _dateController,
                  onTap: () {
                    _dateSelector();
                  },
                  decoration: InputDecoration(label: Text('Select Date')),
                ),
              ),

              TextFormField(
                decoration: InputDecoration(label: Text('Notes...')),
                controller: _notesController,
              ),

              //submit button
              TextButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    DateTime entryDate = DateTime.parse(_dateController.text);
                    //map to moodentry
                    MoodEntry newEntry = MoodEntry(
                      mood: _moodSelect,
                      date: entryDate,
                      notes: _notesController.text,
                    );

                    widget.appState.createMoodEntry(newEntry);

                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Entry Saved!',
                      ),
                    ),
                  );

                    _formkey.currentState!.reset();
                  }
                },
                child: Text('Save Entry'),
              ),
            ],
          ),
        ),
      );
  }
}
