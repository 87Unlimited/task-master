import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime)? onTimeChanged;

  const CalendarPicker({
    Key? key,
    required this.initialDate,
    this.onTimeChanged,
  }) : super(key: key);

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  late DateTime _date;
  late DateTime date;

  @override
  Widget build(BuildContext context) {
    _date = widget.initialDate;
    return InkWell(
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat.yMMMMd('en_US').format(_date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    CupertinoIcons.calendar,
                    size: 24,
                    color: Colors.blue,
                  ),
                ),
              ]
          ),
        ),
      ),
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: CupertinoDatePicker(
              backgroundColor: Colors.white,
              initialDateTime: _date,
              onDateTimeChanged: (DateTime newTime) {
                DateFormat.yMMMMd('en_US').format(_date);
                setState(() {
                  _date = newTime;
                  if (widget.onTimeChanged != null) {
                    widget.onTimeChanged!(newTime);
                  }
                });
              },
              use24hFormat: true,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        );
      },
    );
  }
}