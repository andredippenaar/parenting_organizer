import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parenting Organizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Map to hold events for each day
  Map<DateTime, List<String>> selectedEvents = {};

  // Date selected on the calendar
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            eventLoader: (day) {
              return selectedEvents[day] ?? [];
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay)
                  .map((event) => ListTile(
                        title: Text(event),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addEventDialog(context),
      ),
    );
  }

  // Get events for the selected day
  List<String> _getEventsForDay(DateTime day) {
    return selectedEvents[day] ?? [];
  }

  // Show a dialog to add events
  void _addEventDialog(BuildContext context) {
    TextEditingController eventController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Event"),
          content: TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: "Enter event details"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  if (eventController.text.isNotEmpty) {
                    if (selectedEvents[_selectedDay] != null) {
                      selectedEvents[_selectedDay]!.add(eventController.text);
                    } else {
                      selectedEvents[_selectedDay] = [eventController.text];
                    }
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
