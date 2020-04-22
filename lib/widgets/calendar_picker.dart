import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String _displayedDate (DateTime date) {
  if (date == null) return "";
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final todayDate = DateTime(date.year, date.month, date.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  if (today == todayDate)
    return "Today";
  else if (todayDate == tomorrow)
    return "Tomorrow";
  else if (date.year == now.year)
    return DateFormat.MMMd().format(date);
  return DateFormat.yMMMd().format(date);
}

String _displayedTime (TimeOfDay time) {
  if (time == null) return "";
  final now = DateTime.now();
  final DateTime exampleDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.Hm().format(exampleDate);
}

class CalendarPicker extends StatelessWidget {
  final TimeOfDay currentTime;
  final DateTime currentDate;
  final Function onSelectDate;
  final Function onSelectTime;


  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  CalendarPicker({
    Key key,
    this.onSelectDate,
    this.onSelectTime,
    this.currentTime,
    this.currentDate,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    _dateController.text = _displayedDate(currentDate);
    _timeController.text = _displayedTime(currentTime);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Day",
              hintText: "Choose date",
            ),
            readOnly: true,
            onTap: onSelectDate,
            controller: _dateController,
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Time",
              hintText: "Today"
            ),
            readOnly: true,
            onTap: onSelectTime,
            controller: _timeController,
          ),
        ),
      ],
    );
  }
}
