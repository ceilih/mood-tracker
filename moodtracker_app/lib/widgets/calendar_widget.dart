//table calendar package reference:
//https://pub.dev/packages/table_calendar

import 'package:flutter/material.dart';
import 'package:moodtracker_app/app_state.dart';
import 'package:moodtracker_app/models/mood_entry.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key, required this.appstate});

  final ApplicationState appstate;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  //first and last dates correspond to dates in mood entry

  final DateTime _firstDate = DateTime(2020);
  final DateTime _lastDate = DateTime(2100);

  final DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  DateTime? _selectedDay;

  List<MoodEntry> _moodList = [];

  late MoodEntry? _selectedEntry;

  late ValueNotifier<MoodEntry?> _selectedEntryNotifier;

  @override
  void initState() {
    super.initState();
    setState(() {
      _moodList = widget.appstate.moodList!;
      _selectedDay = _focusedDay;
      _selectedEntry = _getEntryForDate(DateTime.now());
      _selectedEntryNotifier = ValueNotifier<MoodEntry?>(_selectedEntry);
    });
  }

  @override
  void dispose() {
    _selectedEntryNotifier.dispose();
    super.dispose();
  }

  //GETTING ENTRY FOR EACH INDIVIDUAL DAY:

  MoodEntry? _getEntryForDate(DateTime dayTime) {
    //single entry for date
    var date = DateUtils.dateOnly(dayTime);
    //find entry for date specified
    for (var entry in _moodList) {
      var entryDate = DateUtils.dateOnly(entry.date);

      //compares only date, not datetime
      if (entryDate == date) {
        _selectedEntryNotifier = ValueNotifier<MoodEntry?>(entry);
        return entry;
      }
    }
    return null;
  }

  Widget _buildEntryMarker(MoodEntry entry) {
    late Color? colorValue;

    switch (entry.mood) {
      case ('Happy'):
        colorValue = Colors.orange[200];
        break;

      case ('Excited'):
        colorValue = Colors.yellow[200];
        break;

      case ('Calm'):
        colorValue = Colors.cyan[200];
        break;

      case ('Neutral'):
        colorValue = Colors.purple[300];
        break;

      case ('Sad'):
        colorValue = Colors.lightBlue[300];
        break;

      case ('Nervous'):
        colorValue = Colors.tealAccent;
        break;

      case ('Angry'):
        colorValue = Colors.redAccent[100];
        break;
    }

    return Container(
      decoration: BoxDecoration(shape: BoxShape.rectangle, color: colorValue),
      width: 19.0,
      height: 19.0,
      child: Center(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TableCalendar<MoodEntry>(
          focusedDay: _focusedDay,
          firstDay: _firstDate,
          lastDay: _lastDate,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _selectedEntry = _getEntryForDate(_selectedDay!);
              });
            }
          },

          eventLoader: (day) {
            List<MoodEntry> thisEntry = [];
            var date = DateUtils.dateOnly(day);
            //find entry for date specified
            for (var entry in _moodList) {
              var entryDate = DateUtils.dateOnly(entry.date);

              //compares only date, not datetime
              if (entryDate == date) {
                thisEntry.add(entry);
              }
            }

            return thisEntry;
          },

          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, entryList) {
              for (var entry in entryList) {
                return Positioned(child: _buildEntryMarker(entry));
              }
              return null;
            },
          ),
        ),

        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<MoodEntry?>(
            valueListenable: _selectedEntryNotifier,
            builder: (context, value, _) {
              if (value != null) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(value.mood),
                        subtitle: Text(value.notes ?? ''),
                      ),
                    );
                  },
                );
              }
              return Text('No Entry For This Date');
            },
          ),
        ),
      ],
    );
  }
}
